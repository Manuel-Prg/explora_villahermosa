// lib/widgets/home/activity_card.dart
import 'package:flutter/material.dart';
import '../../models/activity_model.dart';
import '../../utils/responsive_utils.dart';

class ActivityCard extends StatelessWidget {
  final ActivityModel activity;
  final DeviceType deviceType;

  const ActivityCard({
    super.key,
    required this.activity,
    required this.deviceType,
  });

  @override
  Widget build(BuildContext context) {
    final cardPadding = ResponsiveUtils.getCardPadding(deviceType);
    final emojiSize = deviceType == DeviceType.desktop
        ? 44.0
        : (deviceType == DeviceType.tablet ? 40.0 : 36.0);
    final nameSize = ResponsiveUtils.getFontSize(deviceType, FontSize.body);
    final descSize = ResponsiveUtils.getFontSize(deviceType, FontSize.caption);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: activity.color.withOpacity(0.2), width: 2),
        boxShadow: [
          BoxShadow(
            color: activity.color.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(cardPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(activity.emoji, style: TextStyle(fontSize: emojiSize)),
            SizedBox(
                height: deviceType == DeviceType.desktop
                    ? 12
                    : (deviceType == DeviceType.tablet ? 10 : 10)),
            Text(
              activity.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: nameSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF5D4037),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
                height: deviceType == DeviceType.desktop
                    ? 5
                    : (deviceType == DeviceType.tablet ? 4 : 4)),
            Text(
              activity.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: descSize,
                color: const Color(0xFF8D6E63),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
