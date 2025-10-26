// lib/widgets/profile/profile_header_widget.dart
import 'package:flutter/material.dart';
import '../../utils/responsive_utils.dart';
import '../../models/user_profile_model.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final UserProfile profile;
  final DeviceType deviceType;
  final VoidCallback onEditName;

  const ProfileHeaderWidget({
    super.key,
    required this.profile,
    required this.deviceType,
    required this.onEditName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purple.shade600,
            Colors.deepPurple.shade600,
            Colors.blue.shade600,
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: kToolbarHeight,
            bottom: 16,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildAvatar(context),
              const SizedBox(height: 12),
              _buildNameSection(),
              const SizedBox(height: 8),
              _buildLevelBadge(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Personalización de avatar próximamente! 🎨'),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        width: deviceType == DeviceType.mobile ? 64 : 80,
        height: deviceType == DeviceType.mobile ? 64 : 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(
            color: Colors.white,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(
          Icons.person,
          size: deviceType == DeviceType.mobile ? 32 : 40,
          color: Colors.purple.shade600,
        ),
      ),
    );
  }

  Widget _buildNameSection() {
    return GestureDetector(
      onTap: onEditName,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                profile.name,
                style: TextStyle(
                  fontSize: deviceType == DeviceType.mobile ? 20 : 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.edit,
              size: 16,
              color: Colors.white.withOpacity(0.8),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.stars,
            color: Colors.amber.shade300,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            'Nivel ${profile.level} • ${profile.totalPoints} pts',
            style: TextStyle(
              fontSize: deviceType == DeviceType.mobile ? 12 : 14,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
