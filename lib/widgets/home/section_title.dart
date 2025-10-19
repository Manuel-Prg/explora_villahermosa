// lib/widgets/home/section_title.dart
import 'package:flutter/material.dart';
import '../../utils/responsive_utils.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final DeviceType deviceType;

  const SectionTitle({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.deviceType,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize =
        ResponsiveUtils.getIconSize(deviceType, IconSizeType.medium);
    final titleSize = ResponsiveUtils.getFontSize(deviceType, FontSize.heading);
    final containerPadding = deviceType == DeviceType.desktop
        ? 10.0
        : (deviceType == DeviceType.tablet ? 9.0 : 8.0);

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(containerPadding),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.7)],
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.35),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: iconSize),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: titleSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF4A2C2A),
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}
