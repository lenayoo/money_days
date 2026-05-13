import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../core/constants/app_constants.dart';
import '../models/premium_product.dart';

enum PremiumPurchaseStatus { pending, purchased, restored, canceled, error }

class PremiumProductLoadResult {
  const PremiumProductLoadResult({
    required this.isStoreAvailable,
    this.product,
  });

  final bool isStoreAvailable;
  final PremiumProduct? product;
}

class PremiumPurchaseUpdate {
  const PremiumPurchaseUpdate({
    required this.productId,
    required this.status,
    required this.needsCompletion,
    this.nativePurchase,
  });

  final String productId;
  final PremiumPurchaseStatus status;
  final bool needsCompletion;
  final Object? nativePurchase;
}

abstract class PremiumStoreService {
  Stream<List<PremiumPurchaseUpdate>> get purchaseUpdates;

  Future<PremiumProductLoadResult> loadPremiumProduct();

  Future<void> buyPremium();

  Future<void> restorePurchases();

  Future<void> completePurchase(PremiumPurchaseUpdate purchase);
}

final premiumStoreServiceProvider = Provider<PremiumStoreService>(
  (ref) => UnsupportedPremiumStoreService(),
);

class UnsupportedPremiumStoreService implements PremiumStoreService {
  @override
  Stream<List<PremiumPurchaseUpdate>> get purchaseUpdates =>
      const Stream.empty();

  @override
  Future<void> buyPremium() async {}

  @override
  Future<void> completePurchase(PremiumPurchaseUpdate purchase) async {}

  @override
  Future<PremiumProductLoadResult> loadPremiumProduct() async {
    return const PremiumProductLoadResult(isStoreAvailable: false);
  }

  @override
  Future<void> restorePurchases() async {}
}

class InAppPremiumStoreService implements PremiumStoreService {
  InAppPremiumStoreService({
    InAppPurchase? inAppPurchase,
    String productId = AppConstants.premiumProductId,
  }) : _inAppPurchase = inAppPurchase ?? InAppPurchase.instance,
       _productId = productId;

  final InAppPurchase _inAppPurchase;
  final String _productId;
  Map<String, ProductDetails> _productsById = const {};

  @override
  Stream<List<PremiumPurchaseUpdate>> get purchaseUpdates =>
      _inAppPurchase.purchaseStream.map(
        (purchases) =>
            purchases
                .where((purchase) => purchase.productID == _productId)
                .map(_mapPurchase)
                .toList(growable: false),
      );

  @override
  Future<PremiumProductLoadResult> loadPremiumProduct() async {
    final isStoreAvailable = await _inAppPurchase.isAvailable();
    if (!isStoreAvailable) {
      _productsById = const {};
      return const PremiumProductLoadResult(isStoreAvailable: false);
    }

    final response = await _inAppPurchase.queryProductDetails({_productId});
    _productsById = {
      for (final product in response.productDetails) product.id: product,
    };

    final product = _productsById[_productId];
    if (product == null) {
      return const PremiumProductLoadResult(isStoreAvailable: true);
    }

    return PremiumProductLoadResult(
      isStoreAvailable: true,
      product: PremiumProduct(
        id: product.id,
        title: product.title,
        description: product.description,
        priceLabel: product.price,
      ),
    );
  }

  @override
  Future<void> buyPremium() async {
    final product = _productsById[_productId];
    if (product == null) {
      throw StateError('Premium product is not available.');
    }

    final didStart = await _inAppPurchase.buyNonConsumable(
      purchaseParam: PurchaseParam(productDetails: product),
    );

    if (!didStart) {
      throw StateError('Premium purchase flow did not start.');
    }
  }

  @override
  Future<void> restorePurchases() {
    return _inAppPurchase.restorePurchases();
  }

  @override
  Future<void> completePurchase(PremiumPurchaseUpdate purchase) async {
    final nativePurchase = purchase.nativePurchase;
    if (nativePurchase is PurchaseDetails) {
      await _inAppPurchase.completePurchase(nativePurchase);
    }
  }

  PremiumPurchaseUpdate _mapPurchase(PurchaseDetails purchase) {
    final statusName = purchase.status.name;

    return PremiumPurchaseUpdate(
      productId: purchase.productID,
      status: switch (statusName) {
        'pending' => PremiumPurchaseStatus.pending,
        'purchased' => PremiumPurchaseStatus.purchased,
        'restored' => PremiumPurchaseStatus.restored,
        'canceled' => PremiumPurchaseStatus.canceled,
        _ => PremiumPurchaseStatus.error,
      },
      needsCompletion: purchase.pendingCompletePurchase,
      nativePurchase: purchase,
    );
  }
}
