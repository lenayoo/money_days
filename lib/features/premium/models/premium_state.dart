import '../../../core/constants/app_constants.dart';
import 'premium_entitlement.dart';
import 'premium_product.dart';

class PremiumState {
  const PremiumState({
    this.entitlement = PremiumEntitlement.inactive,
    this.product,
    this.isStoreAvailable = false,
    this.isLoading = false,
    this.isPurchasePending = false,
    this.isRestoring = false,
  });

  final PremiumEntitlement entitlement;
  final PremiumProduct? product;
  final bool isStoreAvailable;
  final bool isLoading;
  final bool isPurchasePending;
  final bool isRestoring;

  bool get isPremium => entitlement.isActive;
  String get priceLabel =>
      product?.priceLabel ?? AppConstants.premiumFallbackPriceLabel;

  PremiumState copyWith({
    PremiumEntitlement? entitlement,
    PremiumProduct? product,
    bool clearProduct = false,
    bool? isStoreAvailable,
    bool? isLoading,
    bool? isPurchasePending,
    bool? isRestoring,
  }) {
    return PremiumState(
      entitlement: entitlement ?? this.entitlement,
      product: clearProduct ? null : product ?? this.product,
      isStoreAvailable: isStoreAvailable ?? this.isStoreAvailable,
      isLoading: isLoading ?? this.isLoading,
      isPurchasePending: isPurchasePending ?? this.isPurchasePending,
      isRestoring: isRestoring ?? this.isRestoring,
    );
  }
}
