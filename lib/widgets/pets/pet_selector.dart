// lib/widgets/pets/pet_selector.dart
import 'package:flutter/material.dart';
import '../../providers/pet_provider.dart';
import '../../models/pet_model.dart';
import '../../utils/responsive_utils.dart';

class PetSelectorWidget extends StatelessWidget {
  final PetProvider provider;
  final DeviceType deviceType;
  final Function(String petId, String petName, Color petColor, bool hasModel)
      onPetSelected;

  const PetSelectorWidget({
    super.key,
    required this.provider,
    required this.deviceType,
    required this.onPetSelected,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = ResponsiveUtils.getBorderRadius(deviceType);
    final cardPadding = ResponsiveUtils.getCardPadding(deviceType);
    final titleSize = ResponsiveUtils.getFontSize(deviceType, FontSize.heading);
    final gridColumns = ResponsiveUtils.getGridColumns(deviceType);

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selecciona tu mascota',
            style: TextStyle(
              fontSize: titleSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF5D4037),
            ),
          ),
          SizedBox(height: deviceType == DeviceType.mobile ? 12 : 15),
          _buildPetGrid(gridColumns),
        ],
      ),
    );
  }

  Widget _buildPetGrid(int columns) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = deviceType == DeviceType.mobile ? 12.0 : 16.0;
        final cardSize =
            (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: PetsData.pets.map((pet) {
            final isSelected = provider.selectedPet == pet.id;
            return _buildPetCard(pet, isSelected, cardSize);
          }).toList(),
        );
      },
    );
  }

  Widget _buildPetCard(PetModel pet, bool isSelected, double cardSize) {
    final captionSize =
        ResponsiveUtils.getFontSize(deviceType, FontSize.caption);
    final emojiSize = _getEmojiSize();

    return GestureDetector(
      onTap: () => onPetSelected(pet.id, pet.name, pet.color, pet.hasModel),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: cardSize,
        height: cardSize,
        decoration: BoxDecoration(
          color: isSelected ? pet.color.withOpacity(0.15) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.getBorderRadius(deviceType) * 0.7,
          ),
          border: Border.all(
            color: isSelected ? pet.color : Colors.grey.shade300,
            width: isSelected ? 3 : 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: pet.color.withOpacity(0.3),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  pet.emoji,
                  style: TextStyle(fontSize: emojiSize),
                ),
                const SizedBox(height: 5),
                Text(
                  pet.name,
                  style: TextStyle(
                    fontSize: captionSize,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? pet.color : Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            if (pet.hasModel)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: pet.color,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: pet.color.withOpacity(0.5),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.view_in_ar,
                    size: deviceType == DeviceType.mobile ? 12 : 14,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  double _getEmojiSize() {
    switch (deviceType) {
      case DeviceType.mobile:
        return 32.0;
      case DeviceType.tablet:
        return 38.0;
      case DeviceType.desktop:
        return 42.0;
    }
  }
}
