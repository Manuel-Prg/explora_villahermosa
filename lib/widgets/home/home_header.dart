// lib/widgets/home/home_header.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../screens/profile_screen.dart';
import '../../utils/responsive_utils.dart';

class HomeHeader extends StatelessWidget {
  final DeviceType deviceType;
  final AnimationController shimmerController;

  const HomeHeader({
    super.key,
    required this.deviceType,
    required this.shimmerController,
  });

  @override
  Widget build(BuildContext context) {
    // Saludo dinámico según la hora
    final hour = DateTime.now().hour;
    String greeting = '¡Buenos días!';
    String emoji = '🌅';

    if (hour >= 12 && hour < 18) {
      greeting = '¡Buenas tardes!';
      emoji = '☀️';
    } else if (hour >= 18) {
      greeting = '¡Buenas noches!';
      emoji = '🌙';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: _buildWelcomeText(greeting, emoji),
        ),
        const SizedBox(width: 12),
        Column(
          children: [
            _buildProfileButton(context), // 🆕 Botón de perfil
            const SizedBox(height: 8),
            _buildPointsBadge(context),
          ],
        ),
      ],
    );
  }

  Widget _buildWelcomeText(String greeting, String emoji) {
    final titleSize = ResponsiveUtils.getFontSize(deviceType, FontSize.title);
    final subtitleSize =
        ResponsiveUtils.getFontSize(deviceType, FontSize.subtitle);
    final emojiSize = deviceType == DeviceType.desktop
        ? 32.0
        : (deviceType == DeviceType.tablet ? 30.0 : 28.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(emoji, style: TextStyle(fontSize: emojiSize)),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                greeting,
                style: TextStyle(
                  fontSize: titleSize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF4A2C2A),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Descubre Villahermosa hoy',
          style: TextStyle(
            fontSize: subtitleSize,
            color: const Color(0xFF8D6E63).withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // 🆕 Botón de perfil
  Widget _buildProfileButton(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final iconSize = deviceType == DeviceType.desktop
        ? 28.0
        : (deviceType == DeviceType.tablet ? 26.0 : 24.0);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfileScreen(),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(deviceType == DeviceType.mobile ? 8 : 10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF9C27B0),
              Color(0xFFBA68C8),
            ],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              Icons.person,
              color: Colors.white,
              size: iconSize,
            ),
            // Badge de nivel
            if (appProvider.level > 1)
              Positioned(
                right: -4,
                top: -4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9800),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.5),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Center(
                    child: Text(
                      '${appProvider.level}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPointsBadge(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final badgePadding = deviceType == DeviceType.desktop
        ? 20.0
        : (deviceType == DeviceType.tablet ? 18.0 : 16.0);
    final fontSize = deviceType == DeviceType.desktop
        ? 22.0
        : (deviceType == DeviceType.tablet ? 20.0 : 18.0);
    final iconSize = deviceType == DeviceType.desktop
        ? 24.0
        : (deviceType == DeviceType.tablet ? 22.0 : 20.0);

    return AnimatedBuilder(
      animation: shimmerController,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: badgePadding,
            vertical: badgePadding * 0.75,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: const [
                Color(0xFFFFD54F),
                Color(0xFFFFB74D),
                Color(0xFFFF9800)
              ],
              stops: [
                shimmerController.value - 0.3,
                shimmerController.value,
                shimmerController.value + 0.3,
              ].map((e) => e.clamp(0.0, 1.0)).toList(),
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.stars, color: Colors.white, size: iconSize),
              const SizedBox(width: 6),
              Text(
                '${appProvider.points}',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
