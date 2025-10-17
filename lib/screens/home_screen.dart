import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _shimmerController;
  late AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _floatController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    final isSmallScreen = screenHeight < 700;
    final isMediumScreen = screenWidth < 380;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFFFF8E1),
              const Color(0xFFFFE0B2).withOpacity(0.3),
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                isMediumScreen ? 16 : 20,
                isMediumScreen ? 16 : 20,
                isMediumScreen ? 16 : 20,
                isSmallScreen ? 12 : 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, isMediumScreen),
                  SizedBox(height: isSmallScreen ? 20 : 25),
                  _buildWelcomeCard(context, isMediumScreen, isSmallScreen),
                  SizedBox(height: isSmallScreen ? 20 : 25),
                  _buildQuickStats(context, isMediumScreen, isSmallScreen),
                  SizedBox(height: isSmallScreen ? 20 : 25),
                  _buildSectionTitle('Lugares Turísticos', Icons.place,
                      const Color(0xFF4CAF50)),
                  SizedBox(height: isSmallScreen ? 12 : 15),
                  _buildTouristPlaces(context, isMediumScreen, isSmallScreen),
                  SizedBox(height: isSmallScreen ? 20 : 25),
                  _buildSectionTitle('Actividades', Icons.local_activity,
                      const Color(0xFF9C27B0)),
                  SizedBox(height: isSmallScreen ? 12 : 15),
                  _buildActivitiesGrid(context, isMediumScreen, isSmallScreen),
                  // Espaciado para botón de accesibilidad
                  SizedBox(height: bottomPadding > 0 ? bottomPadding + 16 : 80),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isMediumScreen) {
    final appProvider = Provider.of<AppProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '👋',
                    style: TextStyle(fontSize: isMediumScreen ? 24 : 28),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      '¡Bienvenido!',
                      style: TextStyle(
                        fontSize: isMediumScreen ? 22 : 26,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF5D4037),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Explora Villahermosa',
                style: TextStyle(
                  fontSize: isMediumScreen ? 13 : 15,
                  color: const Color(0xFF8D6E63),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        AnimatedBuilder(
          animation: _shimmerController,
          builder: (context, child) {
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMediumScreen ? 14 : 16,
                vertical: isMediumScreen ? 10 : 12,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: const [
                    Color(0xFFFFD54F),
                    Color(0xFFFFB74D),
                    Color(0xFFFF9800)
                  ],
                  stops: [
                    _shimmerController.value - 0.3,
                    _shimmerController.value,
                    _shimmerController.value + 0.3,
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
                  const Icon(Icons.stars, color: Colors.white, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    '${appProvider.points}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: isMediumScreen ? 16 : 18,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildWelcomeCard(
      BuildContext context, bool isMediumScreen, bool isSmallScreen) {
    final appProvider = Provider.of<AppProvider>(context);
    final progressValue = (appProvider.points % 100) / 100;

    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, math.sin(_floatController.value * math.pi * 2) * 3),
          child: Container(
            padding: EdgeInsets.all(isMediumScreen ? 18 : 22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFF6F00),
                  Color(0xFFFF9800),
                  Color(0xFFFFB74D)
                ],
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(isMediumScreen ? 10 : 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.emoji_events,
                        color: const Color(0xFFFF9800),
                        size: isMediumScreen ? 28 : 35,
                      ),
                    ),
                    SizedBox(width: isMediumScreen ? 12 : 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Nivel ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isMediumScreen ? 18 : 22,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${appProvider.level}',
                                  style: TextStyle(
                                    color: const Color(0xFFFF9800),
                                    fontSize: isMediumScreen ? 18 : 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${appProvider.visitedPlaces.length} lugares visitados 📍',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: isMediumScreen ? 12 : 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isMediumScreen ? 14 : 18),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progreso al siguiente nivel',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: isMediumScreen ? 11 : 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${(progressValue * 100).toInt()}%',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isMediumScreen ? 11 : 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Stack(
                        children: [
                          Container(
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: progressValue,
                            child: Container(
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.5),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${appProvider.getPointsForNextLevel()} puntos restantes',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: isMediumScreen ? 10 : 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickStats(
      BuildContext context, bool isMediumScreen, bool isSmallScreen) {
    final appProvider = Provider.of<AppProvider>(context);

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            '🎯',
            'Logros',
            '${appProvider.achievements.where((a) => a['unlocked'] == true).length}/${appProvider.achievements.length}',
            const Color(0xFF9C27B0),
            isMediumScreen,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            '🏆',
            'Racha',
            '${appProvider.level} días',
            const Color(0xFFFF9800),
            isMediumScreen,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String emoji, String label, String value, Color color, bool isSmall) {
    return Container(
      padding: EdgeInsets.all(isSmall ? 14 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: TextStyle(fontSize: isSmall ? 24 : 28)),
          SizedBox(height: isSmall ? 6 : 8),
          Text(
            label,
            style: TextStyle(
              fontSize: isSmall ? 11 : 12,
              color: const Color(0xFF8D6E63),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: isSmall ? 16 : 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF5D4037),
          ),
        ),
      ],
    );
  }

  Widget _buildTouristPlaces(
      BuildContext context, bool isMediumScreen, bool isSmallScreen) {
    final places = [
      {
        'name': 'Parque La Venta',
        'icon': Icons.park,
        'color': const Color(0xFF4CAF50),
        'id': 'parque_venta',
        'emoji': '🌳',
      },
      {
        'name': 'Yumká',
        'icon': Icons.nature,
        'color': const Color(0xFF8BC34A),
        'id': 'yumka',
        'emoji': '🦁',
      },
      {
        'name': 'Casa Universitaria del Agua',
        'icon': Icons.water_drop,
        'color': const Color(0xFF03A9F4),
        'id': 'casa_agua',
        'emoji': '💧',
      },
      {
        'name': 'Museo La Venta',
        'icon': Icons.museum,
        'color': const Color(0xFF009688),
        'id': 'museo_venta',
        'emoji': '🗿',
      },
      {
        'name': 'Laguna Ilusiones',
        'icon': Icons.water,
        'color': const Color(0xFF00BCD4),
        'id': 'laguna_ilusiones',
        'emoji': '💧',
      },
    ];

    final cardWidth = isMediumScreen ? 130.0 : 145.0;

    return SizedBox(
      height: isSmallScreen ? 160 : 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: places.length,
        itemBuilder: (context, index) {
          final place = places[index];
          return _buildPlaceCard(
            context,
            place['name'] as String,
            place['icon'] as IconData,
            place['color'] as Color,
            place['id'] as String,
            place['emoji'] as String,
            cardWidth,
            isMediumScreen,
          );
        },
      ),
    );
  }

  Widget _buildPlaceCard(
    BuildContext context,
    String name,
    IconData icon,
    Color color,
    String placeId,
    String emoji,
    double cardWidth,
    bool isSmall,
  ) {
    final appProvider = Provider.of<AppProvider>(context);
    final isVisited = appProvider.visitedPlaces.contains(placeId);

    return Container(
      width: cardWidth,
      margin: const EdgeInsets.only(right: 12),
      child: InkWell(
        onTap: () {
          if (!isVisited) {
            appProvider.visitPlace(placeId);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Text('¡Visitado! '),
                    Text(name,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const Text(' +10 puntos'),
                  ],
                ),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            gradient: isVisited
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
                  )
                : const LinearGradient(
                    colors: [Colors.white, Colors.white],
                  ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isVisited ? color : Colors.grey.shade200,
              width: isVisited ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isVisited
                    ? color.withOpacity(0.3)
                    : Colors.black.withOpacity(0.08),
                blurRadius: isVisited ? 15 : 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      emoji,
                      style: TextStyle(fontSize: isSmall ? 40 : 45),
                    ),
                    SizedBox(height: isSmall ? 8 : 12),
                    Text(
                      name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isSmall ? 12 : 13,
                        fontWeight: FontWeight.bold,
                        color: isVisited ? color : const Color(0xFF5D4037),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (isVisited) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          '✓ Visitado',
                          style: TextStyle(
                            fontSize: 9,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isVisited)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.5),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivitiesGrid(
      BuildContext context, bool isMediumScreen, bool isSmallScreen) {
    final activities = [
      {
        'name': 'Trivia',
        'icon': Icons.quiz,
        'color': const Color(0xFFE91E63),
        'description': 'Responde preguntas',
        'emoji': '🤔',
      },
      {
        'name': 'Realidad Aumentada',
        'icon': Icons.view_in_ar,
        'color': const Color(0xFF9C27B0),
        'description': 'Escanea monumentos',
        'emoji': '📱',
      },
      {
        'name': 'Mascotas',
        'icon': Icons.pets,
        'color': const Color(0xFF3F51B5),
        'description': 'Colecciona mascotas',
        'emoji': '🐾',
      },
      {
        'name': 'Logros',
        'icon': Icons.emoji_events,
        'color': const Color(0xFFFF9800),
        'description': 'Desbloquea logros',
        'emoji': '🏅',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: isSmallScreen ? 12 : 15,
        mainAxisSpacing: isSmallScreen ? 12 : 15,
        childAspectRatio: isMediumScreen ? 1.1 : 1.15,
      ),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        return _buildActivityCard(
          activity['name'] as String,
          activity['icon'] as IconData,
          activity['color'] as Color,
          activity['description'] as String,
          activity['emoji'] as String,
          isMediumScreen,
        );
      },
    );
  }

  Widget _buildActivityCard(
    String name,
    IconData icon,
    Color color,
    String description,
    String emoji,
    bool isSmall,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(isSmall ? 12 : 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emoji,
              style: TextStyle(fontSize: isSmall ? 32 : 36),
            ),
            SizedBox(height: isSmall ? 8 : 10),
            Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isSmall ? 13 : 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF5D4037),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: isSmall ? 3 : 4),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isSmall ? 10 : 11,
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
