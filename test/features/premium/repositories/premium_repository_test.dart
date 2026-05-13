import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_days/core/constants/storage_keys.dart';
import 'package:money_days/features/premium/models/premium_entitlement.dart';
import 'package:money_days/features/premium/repositories/premium_repository.dart';

void main() {
  late Directory tempDir;
  late Box<dynamic> box;
  const boxName = 'money_days_premium_test_box';

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('money_days_premium_');
    Hive.init(tempDir.path);
    box = await Hive.openBox<dynamic>(boxName);
  });

  tearDown(() async {
    await box.close();
    await Hive.deleteBoxFromDisk(boxName);
    await Hive.close();

    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('LocalPremiumRepository reloads saved entitlement after reopening Hive', () async {
    final repository = LocalPremiumRepository(box);
    final entitlement = PremiumEntitlement(
      isActive: true,
      productId: 'money_days_premium',
      source: PremiumPurchaseSource.purchase,
      updatedAt: DateTime(2026, 5, 1, 10, 30),
    );

    await repository.saveEntitlement(entitlement);

    await box.close();
    box = await Hive.openBox<dynamic>(boxName);

    final reloadedRepository = LocalPremiumRepository(box);
    final loadedEntitlement = reloadedRepository.loadEntitlement();

    expect(loadedEntitlement.toMap(), entitlement.toMap());
  });

  test('LocalPremiumRepository falls back to inactive entitlement without saved data', () {
    final repository = LocalPremiumRepository(box);

    expect(
      repository.loadEntitlement().toMap(),
      PremiumEntitlement.inactive.toMap(),
    );
  });

  test('premium entitlement is stored under the premium key', () async {
    final repository = LocalPremiumRepository(box);

    await repository.saveEntitlement(
      const PremiumEntitlement(isActive: true),
    );

    expect(box.containsKey(StorageKeys.premiumEntitlement), isTrue);
  });
}
