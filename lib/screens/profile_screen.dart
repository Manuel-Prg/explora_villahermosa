import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../utils/responsive_utils.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final profile = provider.userProfile;
    final screenWidth = MediaQuery.of(context).size.width;
    final deviceType = ResponsiveUtils.getDeviceType(screenWidth);
    final padding = ResponsiveUtils.getScreenPadding(deviceType);
    final spacing = ResponsiveUtils.getSpacing(deviceType);

    if (profile == null) {
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
          _buildHeader(context, profile, deviceType),

          // Contenido
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(padding.left),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Barra de progreso de nivel
                  _buildLevelProgress(profile, deviceType, spacing),

                  SizedBox(height: spacing.section),

                  // Grid de estadísticas
                  _buildStatsGrid(profile, deviceType, spacing),

                  SizedBox(height: spacing.section),

                  // Progreso por categorías
                  _buildCategoryProgress(profile, deviceType, spacing),

                  SizedBox(height: spacing.section),

                  // Sección de logros (próximamente)
                  _buildAchievementsPreview(deviceType, spacing),

                  SizedBox(height: spacing.section + 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, dynamic profile, DeviceType deviceType) {
    ResponsiveUtils.getFontSize(deviceType, FontSize.body);

    return SliverAppBar(
      expandedHeight: deviceType == DeviceType.mobile ? 220 : 260,
      pinned: true,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          // Calcular el progreso del collapse
          final settings = context
              .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
          final deltaExtent = settings?.maxExtent ?? 200;
          final minExtent = settings?.minExtent ?? 56;
          final currentExtent = settings?.currentExtent ?? 200;

          (1.0 - ((currentExtent - minExtent) / (deltaExtent - minExtent)))
              .clamp(0.0, 1.0);

          return FlexibleSpaceBar(
            background: Container(
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
              child: Padding(
                padding: const EdgeInsets.only(
                  top: kToolbarHeight + 16,
                  bottom: 12,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Avatar
                    Container(
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
                    const SizedBox(height: 8),
                    // Nombre
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    const SizedBox(height: 6),
                    // Nivel y puntos
                    Container(
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
                              fontSize:
                                  deviceType == DeviceType.mobile ? 12 : 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
            // TODO: Ir a settings
          },
        ),
      ],
    );
  }

  Widget _buildLevelProgress(
      dynamic profile, DeviceType deviceType, ResponsiveSpacing spacing) {
    final bodySize = ResponsiveUtils.getFontSize(deviceType, FontSize.body);
    final captionSize =
        ResponsiveUtils.getFontSize(deviceType, FontSize.caption);
    final progress = profile.levelProgress;

    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.getCardPadding(deviceType)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(ResponsiveUtils.getBorderRadius(deviceType)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progreso al Nivel ${profile.level + 1}',
                style: TextStyle(
                  fontSize: bodySize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF5D4037),
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: captionSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Stack(
            children: [
              Container(
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: 12,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.purple.shade600,
                        Colors.deepPurple.shade600,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${profile.currentXP} / ${profile.xpForNextLevel} XP',
            style: TextStyle(
              fontSize: captionSize,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(
      dynamic profile, DeviceType deviceType, ResponsiveSpacing spacing) {
    final stats = profile.stats;
    final columns = deviceType == DeviceType.mobile ? 2 : 4;

    return GridView.count(
      crossAxisCount: columns,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: spacing.card,
      mainAxisSpacing: spacing.card,
      childAspectRatio: 1.2,
      children: [
        _buildStatCard(
          icon: Icons.place,
          value: stats.placesVisited.toString(),
          label: 'Lugares',
          color: Colors.blue,
          deviceType: deviceType,
        ),
        _buildStatCard(
          icon: Icons.quiz,
          value: stats.triviasCompleted.toString(),
          label: 'Trivias',
          color: Colors.orange,
          deviceType: deviceType,
        ),
        _buildStatCard(
          icon: Icons.local_fire_department,
          value: stats.daysStreak.toString(),
          label: 'Días Racha',
          color: Colors.red,
          deviceType: deviceType,
        ),
        _buildStatCard(
          icon: Icons.pets,
          value: stats.petsOwned.toString(),
          label: 'Mascotas',
          color: Colors.green,
          deviceType: deviceType,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    required DeviceType deviceType,
  }) {
    final bodySize = ResponsiveUtils.getFontSize(deviceType, FontSize.body);
    final captionSize =
        ResponsiveUtils.getFontSize(deviceType, FontSize.caption);

    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.getCardPadding(deviceType)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
            ResponsiveUtils.getBorderRadius(deviceType) * 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: deviceType == DeviceType.mobile ? 24 : 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: bodySize * 1.5,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: captionSize,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryProgress(
      dynamic profile, DeviceType deviceType, ResponsiveSpacing spacing) {
    final stats = profile.stats;
    final bodySize = ResponsiveUtils.getFontSize(deviceType, FontSize.body);
    final captionSize =
        ResponsiveUtils.getFontSize(deviceType, FontSize.caption);

    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.getCardPadding(deviceType)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(ResponsiveUtils.getBorderRadius(deviceType)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Progreso por Categoría',
            style: TextStyle(
              fontSize: bodySize,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF5D4037),
            ),
          ),
          const SizedBox(height: 16),
          _buildProgressBar(
            label: 'Exploración',
            progress: stats.explorationProgress,
            color: Colors.blue,
            captionSize: captionSize,
          ),
          const SizedBox(height: 12),
          _buildProgressBar(
            label: 'Conocimiento',
            progress: stats.knowledgeProgress,
            color: Colors.orange,
            captionSize: captionSize,
          ),
          const SizedBox(height: 12),
          _buildProgressBar(
            label: 'Mascotas',
            progress: stats.petsProgress,
            color: Colors.green,
            captionSize: captionSize,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar({
    required String label,
    required double progress,
    required Color color,
    required double captionSize,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: captionSize,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(
                fontSize: captionSize,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Stack(
          children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            FractionallySizedBox(
              widthFactor: progress.clamp(0.0, 1.0),
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAchievementsPreview(
      DeviceType deviceType, ResponsiveSpacing spacing) {
    final bodySize = ResponsiveUtils.getFontSize(deviceType, FontSize.body);

    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.getCardPadding(deviceType)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(ResponsiveUtils.getBorderRadius(deviceType)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Logros Recientes',
                style: TextStyle(
                  fontSize: bodySize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF5D4037),
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Ir a pantalla de logros
                },
                child: const Text('Ver todos'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBadgePreview(
                icon: Icons.explore,
                color: Colors.blue,
                isLocked: false,
              ),
              _buildBadgePreview(
                icon: Icons.quiz,
                color: Colors.orange,
                isLocked: false,
              ),
              _buildBadgePreview(
                icon: Icons.star,
                color: Colors.amber,
                isLocked: true,
              ),
              _buildBadgePreview(
                icon: Icons.pets,
                color: Colors.green,
                isLocked: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadgePreview({
    required IconData icon,
    required Color color,
    required bool isLocked,
  }) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: isLocked ? Colors.grey.shade200 : color.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: isLocked ? Colors.grey.shade400 : color,
          width: 2,
        ),
      ),
      child: Icon(
        isLocked ? Icons.lock : icon,
        color: isLocked ? Colors.grey.shade400 : color,
        size: 30,
      ),
    );
  }
}
