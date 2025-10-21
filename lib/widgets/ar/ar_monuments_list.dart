import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../models/monument_model.dart';
import '../../utils/responsive_utils.dart';

class ARMonumentsListWidget extends StatelessWidget {
  final DeviceType deviceType;
  final int selectedIndex;
  final Function(int) onMonumentTap;
  final Function(int) onView3D;
  final Function(MonumentModel) onShowInfo;

  const ARMonumentsListWidget({
    super.key,
    required this.deviceType,
    required this.selectedIndex,
    required this.onMonumentTap,
    required this.onView3D,
    required this.onShowInfo,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cardHeight = _getCardHeight(size.height);
    final cardWidth = _getCardWidth(size.width);
    final cardPadding = ResponsiveUtils.getCardPadding(deviceType);

    return Container(
      height: cardHeight,
      padding: EdgeInsets.symmetric(horizontal: cardPadding),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: MonumentsData.monuments.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return _MonumentCard(
            monument: MonumentsData.monuments[index],
            isSelected: selectedIndex == index,
            cardWidth: cardWidth,
            cardHeight: cardHeight,
            deviceType: deviceType,
            onTap: () => onMonumentTap(index),
            onView3D: () => onView3D(index),
            onShowInfo: () => onShowInfo(MonumentsData.monuments[index]),
          );
        },
      ),
    );
  }

  double _getCardHeight(double screenHeight) {
    switch (deviceType) {
      case DeviceType.mobile:
        return screenHeight * 0.18;
      case DeviceType.tablet:
        return screenHeight * 0.20;
      case DeviceType.desktop:
        return screenHeight * 0.22;
    }
  }

  double _getCardWidth(double screenWidth) {
    switch (deviceType) {
      case DeviceType.mobile:
        return screenWidth / 4.5;
      case DeviceType.tablet:
        return screenWidth / 5.5;
      case DeviceType.desktop:
        return screenWidth / 7;
    }
  }
}

class _MonumentCard extends StatelessWidget {
  final MonumentModel monument;
  final bool isSelected;
  final double cardWidth;
  final double cardHeight;
  final DeviceType deviceType;
  final VoidCallback onTap;
  final VoidCallback onView3D;
  final VoidCallback onShowInfo;

  const _MonumentCard({
    required this.monument,
    required this.isSelected,
    required this.cardWidth,
    required this.cardHeight,
    required this.deviceType,
    required this.onTap,
    required this.onView3D,
    required this.onShowInfo,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final isVisited = provider.visitedPlaces.contains(monument.id);
    final borderRadius = ResponsiveUtils.getBorderRadius(deviceType);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: cardWidth,
        margin: const EdgeInsets.only(right: 12.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(borderRadius * 0.8),
          border: Border.all(
            color: isSelected
                ? monument.color
                : (isVisited ? Colors.green : Colors.grey[300]!),
            width: isSelected ? 3 : (isVisited ? 2 : 1),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: monument.color.withOpacity(0.4),
                    blurRadius: 15,
                    spreadRadius: 3,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildIcon(isSelected, isVisited),
            _buildTitle(isSelected, isVisited),
            _buildActionButton(isSelected),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(bool isSelected, bool isVisited) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected || isVisited
                ? monument.color.withOpacity(0.1)
                : Colors.grey.shade100,
            shape: BoxShape.circle,
          ),
          child: Icon(
            monument.icon,
            size: cardHeight * 0.22,
            color: isSelected || isVisited ? monument.color : Colors.grey,
          ),
        ),
        if (isVisited)
          Positioned(
            right: -4,
            top: -4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: const Icon(
                Icons.check,
                size: 12,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTitle(bool isSelected, bool isVisited) {
    final fontSize = ResponsiveUtils.getFontSize(deviceType, FontSize.caption);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Text(
        monument.name,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
          color: isSelected || isVisited
              ? const Color(0xFF5D4037)
              : Colors.grey.shade600,
        ),
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildActionButton(bool isSelected) {
    if (monument.hasModel) {
      return _ActionButton(
        onTap: onView3D,
        color: monument.color,
        icon: Icons.view_in_ar,
        label: 'Ver 3D',
        isPrimary: true,
        cardWidth: cardWidth,
        isSelected: isSelected,
      );
    } else {
      return _ActionButton(
        onTap: onShowInfo,
        color: Colors.grey.shade400,
        icon: Icons.info_outline,
        label: 'Info',
        isPrimary: false,
        cardWidth: cardWidth,
        isSelected: isSelected,
      );
    }
  }
}

class _ActionButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color color;
  final IconData icon;
  final String label;
  final bool isPrimary;
  final double cardWidth;
  final bool isSelected;

  const _ActionButton({
    required this.onTap,
    required this.color,
    required this.icon,
    required this.label,
    required this.isPrimary,
    required this.cardWidth,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = cardWidth * 0.12;
    final verticalPadding = cardWidth * 0.06;
    final fontSize = cardWidth * 0.09;
    final iconSize = cardWidth * 0.13;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        decoration: BoxDecoration(
          gradient: isPrimary
              ? LinearGradient(
                  colors: [
                    color,
                    color.withOpacity(0.8),
                  ],
                )
              : null,
          color: !isPrimary ? color : null,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isPrimary && isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: isPrimary ? Colors.white : Colors.grey.shade700,
            ),
            SizedBox(width: cardWidth * 0.04),
            Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: isPrimary ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
