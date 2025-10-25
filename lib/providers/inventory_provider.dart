// lib/providers/inventory_provider.dart
import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class InventoryProvider extends ChangeNotifier {
  final Map<String, int> _inventory = {
    'comida_basica': 3,
    'comida_premium': 1,
    'juguete_pelota': 2,
  };
  Map<String, int> get inventory => _inventory;

  void addItemToInventory(String itemId, int quantity) {
    _inventory[itemId] = (_inventory[itemId] ?? 0) + quantity;
    debugPrint('🎒 Item agregado: $itemId x$quantity');
    notifyListeners();
    _saveData();
  }

  void useItem(String itemId) {
    if (_inventory[itemId] != null && _inventory[itemId]! > 0) {
      _inventory[itemId] = _inventory[itemId]! - 1;
      if (_inventory[itemId] == 0) {
        _inventory.remove(itemId);
      }
      debugPrint('🎒 Item usado: $itemId');
      notifyListeners();
      _saveData();
    }
  }

  bool hasItem(String itemId) => (_inventory[itemId] ?? 0) > 0;

  int getItemCount(String itemId) => _inventory[itemId] ?? 0;

  Future<void> loadData() async {
    debugPrint('🔄 InventoryProvider: Cargando datos...');
    try {
      final inventoryData = await StorageService.loadInventoryData();

      _inventory.clear();
      _inventory.addAll(inventoryData);

      if (_inventory.isEmpty) {
        _inventory['comida_basica'] = 3;
        _inventory['comida_premium'] = 1;
        _inventory['juguete_pelota'] = 2;
        debugPrint('🎁 Inventario inicial agregado');
      }

      debugPrint(
          '✅ InventoryProvider: Datos cargados - ${_inventory.length} items');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ InventoryProvider: Error: $e');
    }
  }

  Future<void> _saveData() async {
    await StorageService.saveInventoryData(_inventory);
  }
}
