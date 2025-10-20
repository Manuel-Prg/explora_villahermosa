import 'package:flutter/material.dart';
import '../../providers/app_provider.dart';
import '../../utils/responsive_utils.dart';

class PetsHeaderWidget extends StatelessWidget {
  final AppProvider provider;

  const PetsHeaderWidget({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final deviceType = ResponsiveUtils.getDeviceType(screenWidth);
    final titleSize = ResponsiveUtils.getFontSize(deviceType, FontSize.title);
    final subtitleSize =
        ResponsiveUtils.getFontSize(deviceType, FontSize.subtitle);
    final iconSize =
        ResponsiveUtils.getIconSize(deviceType, IconSizeType.medium);
    final borderRadius = ResponsiveUtils.getBorderRadius(deviceType);
    final cardPadding = ResponsiveUtils.getCardPadding(deviceType);

    return Container(
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purple.shade400,
            Colors.deepPurple.shade400,
            Colors.blue.shade400,
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tu Mascota',
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  if (deviceType != DeviceType.mobile) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Cuida y alimenta a tu compañero',
                      style: TextStyle(
                        fontSize: subtitleSize,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: deviceType == DeviceType.mobile ? 12 : 16,
                vertical: deviceType == DeviceType.mobile ? 6 : 8,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.stars,
                    color: Colors.amber.shade300,
                    size: iconSize,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${provider.points}',
                    style: TextStyle(
                      fontSize: titleSize * 0.75,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
