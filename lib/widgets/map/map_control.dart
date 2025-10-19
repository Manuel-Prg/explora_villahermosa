import 'package:flutter/material.dart';
import '../../utils/responsive_utils.dart';

class MapControls extends StatelessWidget {
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onCenterUser;
  final VoidCallback onShowAll;

  const MapControls({
    super.key,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onCenterUser,
    required this.onShowAll,
  });

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveUtils.fromContext(context);
    final spacing = ResponsiveUtils.getSpacing(deviceType);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Zoom In
        _buildControlButton(
          icon: Icons.add,
          onTap: onZoomIn,
          deviceType: deviceType,
        ),

        SizedBox(height: spacing.card * 0.5),

        // Zoom Out
        _buildControlButton(
          icon: Icons.remove,
          onTap: onZoomOut,
          deviceType: deviceType,
        ),

        SizedBox(height: spacing.subsection),

        // Mi ubicación
        _buildControlButton(
          icon: Icons.my_location,
          onTap: onCenterUser,
          deviceType: deviceType,
          color: Colors.blue.shade600,
        ),

        SizedBox(height: spacing.card * 0.5),

        // Ver todos
        _buildControlButton(
          icon: Icons.center_focus_strong,
          onTap: onShowAll,
          deviceType: deviceType,
          color: Colors.orange.shade600,
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onTap,
    required DeviceType deviceType,
    Color? color,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 4,
      shadowColor: Colors.black26,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: color ?? Colors.black87,
            size: ResponsiveUtils.getIconSize(
              deviceType,
              IconSizeType.medium,
            ),
          ),
        ),
      ),
    );
  }
}
