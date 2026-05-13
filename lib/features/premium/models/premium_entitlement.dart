import '../../../core/constants/app_constants.dart';

enum PremiumPurchaseSource { none, purchase, restore }

class PremiumEntitlement {
  const PremiumEntitlement({
    this.isActive = false,
    this.productId = AppConstants.premiumProductId,
    this.source = PremiumPurchaseSource.none,
    this.updatedAt,
  });

  factory PremiumEntitlement.fromMap(Map<String, dynamic> map) {
    final rawSource = map['source'] as String?;

    return PremiumEntitlement(
      isActive: map['isActive'] == true,
      productId:
          map['productId'] as String? ?? AppConstants.premiumProductId,
      source: PremiumPurchaseSource.values.firstWhere(
        (value) => value.name == rawSource,
        orElse: () => PremiumPurchaseSource.none,
      ),
      updatedAt: DateTime.tryParse(map['updatedAt'] as String? ?? ''),
    );
  }

  static const inactive = PremiumEntitlement();

  final bool isActive;
  final String productId;
  final PremiumPurchaseSource source;
  final DateTime? updatedAt;

  PremiumEntitlement copyWith({
    bool? isActive,
    String? productId,
    PremiumPurchaseSource? source,
    DateTime? updatedAt,
  }) {
    return PremiumEntitlement(
      isActive: isActive ?? this.isActive,
      productId: productId ?? this.productId,
      source: source ?? this.source,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isActive': isActive,
      'productId': productId,
      'source': source.name,
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
