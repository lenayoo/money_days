import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/constants/storage_keys.dart';
import '../models/premium_entitlement.dart';

abstract class PremiumRepository {
  PremiumEntitlement loadEntitlement();

  Future<void> saveEntitlement(PremiumEntitlement entitlement);
}

final premiumRepositoryProvider = Provider<PremiumRepository>(
  (ref) => InMemoryPremiumRepository(),
);

class InMemoryPremiumRepository implements PremiumRepository {
  PremiumEntitlement _entitlement = PremiumEntitlement.inactive;

  @override
  PremiumEntitlement loadEntitlement() => _entitlement;

  @override
  Future<void> saveEntitlement(PremiumEntitlement entitlement) async {
    _entitlement = entitlement;
  }
}

class LocalPremiumRepository implements PremiumRepository {
  LocalPremiumRepository(this._box);

  final Box<dynamic> _box;

  @override
  PremiumEntitlement loadEntitlement() {
    final rawEntitlement = _box.get(StorageKeys.premiumEntitlement);
    if (rawEntitlement is! Map) {
      return PremiumEntitlement.inactive;
    }

    final entitlementMap = rawEntitlement.map(
      (key, value) => MapEntry(key.toString(), value),
    );

    return PremiumEntitlement.fromMap(entitlementMap);
  }

  @override
  Future<void> saveEntitlement(PremiumEntitlement entitlement) {
    return _box.put(StorageKeys.premiumEntitlement, entitlement.toMap());
  }
}
