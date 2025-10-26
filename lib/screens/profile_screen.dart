// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/pet_provider.dart';
import '../providers/game_progress_provider.dart';
import '../utils/responsive_utils.dart';
import '../widgets/profile/profile_header.dart';
import '../widgets/profile/level_progress.dart';
import '../widgets/profile/stats_grid.dart';
import '../widgets/profile/category_progress.dart';
import '../widgets/profile/archievements_preview.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    Provider.of<PetProvider>(context);
    Provider.of<GameProgressProvider>(context);

    final profile = userProvider.userProfile;
    final screenWidth = MediaQuery.of(context).size.width;
    final deviceType = ResponsiveUtils.getDeviceType(screenWidth);
    final padding = ResponsiveUtils.getScreenPadding(deviceType);
    final spacing = ResponsiveUtils.getSpacing(deviceType);

    if (profile == null || !userProvider.isLoaded) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header con avatar y nombre
          _buildAppBar(context, profile, deviceType, userProvider),

          // Contenido
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(padding.left),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Barra de progreso de nivel
                  LevelProgressWidget(
                    profile: profile,
                    deviceType: deviceType,
                    spacing: spacing,
                  ),

                  SizedBox(height: spacing.section),

                  // Grid de estadísticas
                  StatsGridWidget(
                    profile: profile,
                    deviceType: deviceType,
                    spacing: spacing,
                  ),

                  SizedBox(height: spacing.section),

                  // Progreso por categorías
                  CategoryProgressWidget(
                    profile: profile,
                    deviceType: deviceType,
                    spacing: spacing,
                  ),

                  SizedBox(height: spacing.section),

                  // Sección de logros
                  AchievementsPreviewWidget(
                    deviceType: deviceType,
                    spacing: spacing,
                  ),

                  SizedBox(height: spacing.section + 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(
    BuildContext context,
    dynamic profile,
    DeviceType deviceType,
    UserProvider userProvider,
  ) {
    return SliverAppBar(
      expandedHeight: deviceType == DeviceType.mobile ? 220 : 260,
      pinned: true,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          return FlexibleSpaceBar(
            background: ProfileHeaderWidget(
              profile: profile,
              deviceType: deviceType,
              onEditName: () => _showEditNameDialog(context, userProvider),
            ),
          );
        },
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SettingsScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  void _showEditNameDialog(BuildContext context, UserProvider userProvider) {
    final controller =
        TextEditingController(text: userProvider.userProfile?.name ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.edit, color: Colors.purple.shade600),
            const SizedBox(width: 8),
            const Text('Editar Nombre'),
          ],
        ),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Ingresa tu nombre',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.purple.shade600, width: 2),
            ),
            prefixIcon: const Icon(Icons.person),
          ),
          maxLength: 20,
          textCapitalization: TextCapitalization.words,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final newName = controller.text.trim();
              if (newName.isNotEmpty) {
                userProvider.updateProfileName(newName);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('¡Nombre actualizado a "$newName"! ✨'),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}
