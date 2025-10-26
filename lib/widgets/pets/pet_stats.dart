// lib/widgets/pets/pet_stats.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/pet_provider.dart';
import '../../providers/inventory_provider.dart';
import '../../models/shop_item_model.dart';
import '../../utils/responsive_utils.dart';
import 'pet_shop_dialog.dart';

class PetStatsWidget extends StatelessWidget {
  final PetProvider provider;
  final DeviceType deviceType;
  final VoidCallback onFeedPet;
  final VoidCallback onPlayWithPet;

  const PetStatsWidget({
    super.key,
    required this.provider,
    required this.deviceType,
    required this.onFeedPet,
    required this.onPlayWithPet,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = ResponsiveUtils.getBorderRadius(deviceType);
    final cardPadding = ResponsiveUtils.getCardPadding(deviceType);
    final spacing = ResponsiveUtils.getSpacing(deviceType);

    return Container(
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: Colors.purple.shade200, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildStatBar(
            label: 'Hambre',
            value: provider.petHunger,
            color: const Color(0xFFFFB74D),
            icon: Icons.restaurant,
            spacing: spacing,
          ),
          SizedBox(height: spacing.subsection),
          _buildStatBar(
            label: 'Felicidad',
            value: provider.petHappiness,
            color: const Color(0xFFE91E63),
            icon: Icons.favorite,
            spacing: spacing,
          ),
          SizedBox(height: spacing.subsection),
          _buildStatBar(
            label: 'Experiencia',
            value: provider.petExperience,
            color: const Color(0xFF66BB6A),
            icon: Icons.star,
            spacing: spacing,
          ),
          SizedBox(height: spacing.subsection + 5),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildStatBar({
    required String label,
    required int value,
    required Color color,
    required IconData icon,
    required ResponsiveSpacing spacing,
  }) {
    final bodySize = ResponsiveUtils.getFontSize(deviceType, FontSize.body);
    final captionSize =
        ResponsiveUtils.getFontSize(deviceType, FontSize.caption);
    final iconSize =
        ResponsiveUtils.getIconSize(deviceType, IconSizeType.small);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: iconSize),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: bodySize,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF5D4037),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: deviceType == DeviceType.mobile ? 10 : 12,
                vertical: deviceType == DeviceType.mobile ? 4 : 6,
              ),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$value%',
                style: TextStyle(
                  fontSize: captionSize,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Stack(
          children: [
            Container(
              height: deviceType == DeviceType.mobile ? 10 : 12,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            FractionallySizedBox(
              widthFactor: value / 100,
              child: Container(
                height: deviceType == DeviceType.mobile ? 10 : 12,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.7)],
                  ),
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final bodySize = ResponsiveUtils.getFontSize(deviceType, FontSize.body);
    final iconSize =
        ResponsiveUtils.getIconSize(deviceType, IconSizeType.small);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showFeedMenu(context),
                icon: Icon(Icons.restaurant_menu, size: iconSize),
                label: Text(
                  'Alimentar',
                  style: TextStyle(fontSize: bodySize),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFB74D),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    vertical: deviceType == DeviceType.mobile ? 12 : 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showPlayMenu(context),
                icon: Icon(Icons.sports_esports, size: iconSize),
                label: Text(
                  'Jugar',
                  style: TextStyle(fontSize: bodySize),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF66BB6A),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    vertical: deviceType == DeviceType.mobile ? 12 : 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Botón de tienda
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => showPetShop(context),
            icon: Icon(Icons.store, size: iconSize),
            label: Text(
              'Tienda',
              style: TextStyle(fontSize: bodySize),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9C27B0),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                vertical: deviceType == DeviceType.mobile ? 12 : 15,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
            ),
          ),
        ),
      ],
    );
  }

  void _showFeedMenu(BuildContext context) {
    final inventoryProvider =
        Provider.of<InventoryProvider>(context, listen: false);
    final foodItems = ShopData.getItemsByCategory(ItemCategory.food);
    final availableFood =
        foodItems.where((item) => inventoryProvider.hasItem(item.id)).toList();

    if (availableFood.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No tienes comida. ¡Visita la tienda!'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Selecciona la comida',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5D4037),
              ),
            ),
            const SizedBox(height: 20),
            ...availableFood.map((item) {
              final count = inventoryProvider.getItemCount(item.id);
              return ListTile(
                leading: Text(item.emoji, style: const TextStyle(fontSize: 40)),
                title: Text(item.name),
                subtitle: Text(item.description),
                trailing: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: item.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'x$count',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: item.color,
                    ),
                  ),
                ),
                onTap: () {
                  inventoryProvider.useItem(item.id);
                  provider.feedPet(item.id);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          '¡Has alimentado a tu mascota con ${item.name}!'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showPlayMenu(BuildContext context) {
    final inventoryProvider =
        Provider.of<InventoryProvider>(context, listen: false);
    final toyItems = ShopData.getItemsByCategory(ItemCategory.toy);
    final availableToys =
        toyItems.where((item) => inventoryProvider.hasItem(item.id)).toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Selecciona cómo jugar',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5D4037),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.pan_tool,
                  size: 40, color: Color(0xFF66BB6A)),
              title: const Text('Jugar sin juguete'),
              subtitle: const Text('+10 exp, +10 felicidad'),
              onTap: () {
                provider.playWithPet();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('¡Jugaste con tu mascota!'),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            const Divider(),
            if (availableToys.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'No tienes juguetes. ¡Cómpralos en la tienda!',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              )
            else
              ...availableToys.map((item) {
                final count = inventoryProvider.getItemCount(item.id);
                return ListTile(
                  leading:
                      Text(item.emoji, style: const TextStyle(fontSize: 40)),
                  title: Text(item.name),
                  subtitle: Text(item.description),
                  trailing: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: item.color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'x$count',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: item.color,
                      ),
                    ),
                  ),
                  onTap: () {
                    inventoryProvider.useItem(item.id);
                    provider.playWithPet(toyType: item.id);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('¡Jugaste con ${item.name}!'),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                );
              }),
          ],
        ),
      ),
    );
  }
}
