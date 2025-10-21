import 'package:flutter/material.dart';

enum ItemCategory {
  food,
  toy,
  medicine,
  accessory,
}

class ShopItem {
  final String id;
  final String name;
  final String description;
  final int price;
  final IconData icon;
  final Color color;
  final ItemCategory category;
  final String emoji;

  const ShopItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.icon,
    required this.color,
    required this.category,
    required this.emoji,
  });
}

class ShopData {
  static final List<ShopItem> items = [
    // 🍖 COMIDA
    const ShopItem(
      id: 'comida_basica',
      name: 'Comida Básica',
      description: 'Restaura 20 de hambre',
      price: 10,
      icon: Icons.lunch_dining,
      color: Color(0xFFFFB74D),
      category: ItemCategory.food,
      emoji: '🥗',
    ),
    const ShopItem(
      id: 'comida_premium',
      name: 'Comida Premium',
      description: 'Restaura 40 de hambre y +15 felicidad',
      price: 25,
      icon: Icons.restaurant_menu,
      color: Color(0xFFFF9800),
      category: ItemCategory.food,
      emoji: '🍖',
    ),
    const ShopItem(
      id: 'comida_deluxe',
      name: 'Comida Deluxe',
      description: 'Restaura 60 de hambre y +25 felicidad',
      price: 50,
      icon: Icons.restaurant,
      color: Color(0xFFFF6F00),
      category: ItemCategory.food,
      emoji: '🍗',
    ),

    // 🎾 JUGUETES
    const ShopItem(
      id: 'juguete_pelota',
      name: 'Pelota',
      description: '+15 exp, +20 felicidad al jugar',
      price: 15,
      icon: Icons.sports_soccer,
      color: Color(0xFF66BB6A),
      category: ItemCategory.toy,
      emoji: '⚽',
    ),
    const ShopItem(
      id: 'juguete_cuerda',
      name: 'Cuerda',
      description: '+20 exp, +25 felicidad al jugar',
      price: 30,
      icon: Icons.looks_two,
      color: Color(0xFF4CAF50),
      category: ItemCategory.toy,
      emoji: '🪢',
    ),
    const ShopItem(
      id: 'juguete_premium',
      name: 'Juguete Premium',
      description: '+30 exp, +35 felicidad al jugar',
      price: 60,
      icon: Icons.star,
      color: Color(0xFF2E7D32),
      category: ItemCategory.toy,
      emoji: '🎾',
    ),

    // 💊 MEDICINA
    const ShopItem(
      id: 'medicina_basica',
      name: 'Medicina Básica',
      description: '+10 felicidad',
      price: 20,
      icon: Icons.medical_services,
      color: Color(0xFF42A5F5),
      category: ItemCategory.medicine,
      emoji: '💊',
    ),
    const ShopItem(
      id: 'vitamina',
      name: 'Vitamina',
      description: '+20 experiencia',
      price: 35,
      icon: Icons.local_pharmacy,
      color: Color(0xFF1E88E5),
      category: ItemCategory.medicine,
      emoji: '💉',
    ),
    const ShopItem(
      id: 'pocion_energia',
      name: 'Poción de Energía',
      description: 'Restaura hambre y felicidad al 100%',
      price: 80,
      icon: Icons.science,
      color: Color(0xFF9C27B0),
      category: ItemCategory.medicine,
      emoji: '🧪',
    ),

    // 🎀 ACCESORIOS
    const ShopItem(
      id: 'collar',
      name: 'Collar',
      description: 'Decoración para tu mascota',
      price: 40,
      icon: Icons.circle,
      color: Color(0xFFE91E63),
      category: ItemCategory.accessory,
      emoji: '🎀',
    ),
    const ShopItem(
      id: 'sombrero',
      name: 'Sombrero',
      description: 'Dale estilo a tu mascota',
      price: 55,
      icon: Icons.store,
      color: Color(0xFFF06292),
      category: ItemCategory.accessory,
      emoji: '🎩',
    ),
  ];

  static List<ShopItem> getItemsByCategory(ItemCategory category) {
    return items.where((item) => item.category == category).toList();
  }

  static ShopItem? getItemById(String id) {
    try {
      return items.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }
}
