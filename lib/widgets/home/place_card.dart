// lib/widgets/home/place_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/game_progress_provider.dart';
import '../../models/place_model.dart';
import '../../utils/responsive_utils.dart';

class PlaceCard extends StatelessWidget {
  final PlaceModel place;
  final DeviceType deviceType;

  const PlaceCard({
    super.key,
    required this.place,
    required this.deviceType,
  });

  @override
  Widget build(BuildContext context) {
    final progressProvider = Provider.of<GameProgressProvider>(context);
    final isVisited = progressProvider.visitedPlaces.contains(place.id);

    final cardWidth = deviceType == DeviceType.desktop
        ? 180.0
        : (deviceType == DeviceType.tablet ? 165.0 : 160.0);
    final spacing = ResponsiveUtils.getSpacing(deviceType);

    return Container(
      width: cardWidth,
      margin: EdgeInsets.only(right: spacing.card),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleTap(context, isVisited),
          borderRadius: BorderRadius.circular(24),
          child: Ink(
            decoration: _buildDecoration(isVisited),
            child: Stack(
              children: [
                _buildContent(isVisited),
                if (isVisited) _buildCheckmark(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleTap(BuildContext context, bool isVisited) {
    if (!isVisited) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final progressProvider =
          Provider.of<GameProgressProvider>(context, listen: false);

      userProvider.addPoints(10);
      progressProvider.visitPlace(place.id);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '¡${place.name} visitado! +10 pts',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: place.color,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  BoxDecoration _buildDecoration(bool isVisited) {
    return BoxDecoration(
      gradient: isVisited
          ? LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                place.color.withOpacity(0.25),
                place.color.withOpacity(0.15)
              ],
            )
          : const LinearGradient(colors: [Colors.white, Color(0xFFFFFBF5)]),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(
        color: isVisited ? place.color : Colors.grey.shade200,
        width: isVisited ? 2.5 : 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: isVisited
              ? place.color.withOpacity(0.35)
              : Colors.black.withOpacity(0.08),
          blurRadius: isVisited ? 18 : 12,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }

  Widget _buildContent(bool isVisited) {
    final emojiSize = deviceType == DeviceType.desktop
        ? 55.0
        : (deviceType == DeviceType.tablet ? 50.0 : 52.0);
    final nameSize = ResponsiveUtils.getFontSize(deviceType, FontSize.body);
    final padding = deviceType == DeviceType.desktop
        ? 20.0
        : (deviceType == DeviceType.tablet ? 18.0 : 18.0);

    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(place.emoji, style: TextStyle(fontSize: emojiSize)),
          SizedBox(
              height: deviceType == DeviceType.desktop
                  ? 14
                  : (deviceType == DeviceType.tablet ? 12 : 14)),
          Text(
            place.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: nameSize,
              fontWeight: FontWeight.bold,
              color: isVisited ? place.color : const Color(0xFF4A2C2A),
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildCheckmark() {
    final size = deviceType == DeviceType.desktop
        ? 18.0
        : (deviceType == DeviceType.tablet ? 16.0 : 16.0);
    final padding = deviceType == DeviceType.desktop
        ? 8.0
        : (deviceType == DeviceType.tablet ? 7.0 : 8.0);

    return Positioned(
      top: 10,
      right: 10,
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [place.color, place.color.withOpacity(0.8)],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: place.color.withOpacity(0.6),
              blurRadius: 10,
            ),
          ],
        ),
        child: Icon(Icons.check_rounded, color: Colors.white, size: size),
      ),
    );
  }
}
