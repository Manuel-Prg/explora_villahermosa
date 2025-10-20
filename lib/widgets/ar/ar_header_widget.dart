import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../utils/responsive_utils.dart';

class ARHeaderWidget extends StatelessWidget {
  const ARHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final deviceType = ResponsiveUtils.getDeviceType(screenWidth);
    final titleSize = ResponsiveUtils.getFontSize(deviceType, FontSize.title);
    final bodySize = ResponsiveUtils.getFontSize(deviceType, FontSize.body);
    final iconSize =
        ResponsiveUtils.getIconSize(deviceType, IconSizeType.medium);

    return Container(
      padding: EdgeInsets.all(
        ResponsiveUtils.getCardPadding(deviceType),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purple.shade700,
            Colors.deepPurple.shade600,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.view_in_ar,
                  color: Colors.white,
                  size: iconSize,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Vista AR',
                style: TextStyle(
                  fontSize: titleSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: deviceType == DeviceType.mobile ? 12 : 16,
              vertical: deviceType == DeviceType.mobile ? 8 : 10,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFD54F), Color(0xFFFFB74D)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.amber.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.stars,
                  size: iconSize * 0.9,
                  color: Colors.white,
                ),
                const SizedBox(width: 6),
                Text(
                  '${provider.points}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: bodySize,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
