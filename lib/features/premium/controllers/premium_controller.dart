import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/app_clock.dart';
import '../../../core/constants/app_constants.dart';
import '../models/premium_entitlement.dart';
import '../models/premium_state.dart';
import '../repositories/premium_repository.dart';
import '../services/premium_store_service.dart';

enum PremiumActionResult {
  started,
  alreadyActive,
  storeUnavailable,
  productUnavailable,
  failed,
}

final premiumControllerProvider =
    NotifierProvider<PremiumController, PremiumState>(PremiumController.new);

class PremiumController extends Notifier<PremiumState> {
  StreamSubscription<List<PremiumPurchaseUpdate>>? _purchaseSubscription;

  PremiumRepository get _repository => ref.read(premiumRepositoryProvider);
  PremiumStoreService get _storeService => ref.read(premiumStoreServiceProvider);

  @override
  PremiumState build() {
    final entitlement = _repository.loadEntitlement();

    _purchaseSubscription = _storeService.purchaseUpdates.listen((updates) {
      unawaited(_handlePurchaseUpdates(updates));
    });
    ref.onDispose(() => _purchaseSubscription?.cancel());

    Future<void>.microtask(refreshStore);

    return PremiumState(entitlement: entitlement);
  }

  Future<void> refreshStore() async {
    state = state.copyWith(isLoading: true);

    try {
      final result = await _storeService.loadPremiumProduct();
      state = state.copyWith(
        product: result.product,
        clearProduct: result.product == null,
        isStoreAvailable: result.isStoreAvailable,
        isLoading: false,
      );
    } catch (_) {
      state = state.copyWith(
        clearProduct: true,
        isStoreAvailable: false,
        isLoading: false,
      );
    }
  }

  Future<PremiumActionResult> buyPremium() async {
    if (state.isPremium) {
      return PremiumActionResult.alreadyActive;
    }

    if (!state.isStoreAvailable || state.product == null) {
      await refreshStore();
    }

    if (!state.isStoreAvailable) {
      return PremiumActionResult.storeUnavailable;
    }
    if (state.product == null) {
      return PremiumActionResult.productUnavailable;
    }

    state = state.copyWith(isPurchasePending: true);

    try {
      await _storeService.buyPremium();
      return PremiumActionResult.started;
    } catch (_) {
      state = state.copyWith(isPurchasePending: false);
      return PremiumActionResult.failed;
    }
  }

  Future<PremiumActionResult> restorePurchases() async {
    if (!state.isStoreAvailable) {
      await refreshStore();
    }

    if (!state.isStoreAvailable) {
      return PremiumActionResult.storeUnavailable;
    }

    state = state.copyWith(isRestoring: true);

    try {
      await _storeService.restorePurchases();
      return PremiumActionResult.started;
    } catch (_) {
      state = state.copyWith(isRestoring: false);
      return PremiumActionResult.failed;
    } finally {
      if (!state.isPremium) {
        state = state.copyWith(isRestoring: false);
      }
    }
  }

  Future<void> _handlePurchaseUpdates(List<PremiumPurchaseUpdate> updates) async {
    for (final update in updates) {
      if (update.productId != AppConstants.premiumProductId) {
        continue;
      }

      switch (update.status) {
        case PremiumPurchaseStatus.pending:
          state = state.copyWith(isPurchasePending: true);
          continue;
        case PremiumPurchaseStatus.purchased:
        case PremiumPurchaseStatus.restored:
          final entitlement = PremiumEntitlement(
            isActive: true,
            productId: update.productId,
            source:
                update.status == PremiumPurchaseStatus.restored
                    ? PremiumPurchaseSource.restore
                    : PremiumPurchaseSource.purchase,
            updatedAt: AppClock.now(),
          );

          await _repository.saveEntitlement(entitlement);
          state = state.copyWith(
            entitlement: entitlement,
            isPurchasePending: false,
            isRestoring: false,
          );
          break;
        case PremiumPurchaseStatus.canceled:
        case PremiumPurchaseStatus.error:
          state = state.copyWith(
            isPurchasePending: false,
            isRestoring: false,
          );
          break;
      }

      if (update.needsCompletion) {
        await _storeService.completePurchase(update);
      }
    }
  }
}
