// lib/widgets/home/activities_grid.dart
import 'package:flutter/material.dart';
import '../../models/activity_model.dart';
import '../../utils/responsive_utils.dart';
import 'activity_card.dart';

class ActivitiesGrid extends StatelessWidget {
  final DeviceType deviceType;

  const ActivitiesGrid({
    super.key,
    required this.deviceType,
  });

  @override
  Widget build(BuildContext context) {
    final activities = ActivityModel.getActivities();
    final crossAxisCount = ResponsiveUtils.getGridColumns(deviceType);
    final spacing = ResponsiveUtils.getSpacing(deviceType);
    final aspectRatio = deviceType == DeviceType.desktop
        ? 1.2
        : (deviceType == DeviceType.tablet ? 1.15 : 1.15);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing.subsection,
        mainAxisSpacing: spacing.subsection,
        childAspectRatio: aspectRatio,
      ),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        return ActivityCard(
          activity: activities[index],
          deviceType: deviceType,
        );
      },
    );
  }
}
