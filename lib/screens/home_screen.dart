// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../widgets/home/home_header.dart';
import '../widgets/home/welcome_card.dart';
import '../widgets/home/quick_stats.dart';
import '../widgets/home/section_title.dart';
import '../widgets/home/tourist_places_list.dart';
import '../widgets/home/activities_grid.dart';
import '../utils/responsive_utils.dart';

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
    _initAnimations();
  }

  void _initAnimations() {
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
    final screenSize = MediaQuery.of(context).size;
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    final deviceType = ResponsiveUtils.getDeviceType(screenSize.width);
    final spacing = ResponsiveUtils.getSpacing(deviceType);

    return Scaffold(
      body: Container(
        decoration: _buildGradientBackground(),
        child: SafeArea(
          bottom: false,
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: ResponsiveUtils.getMaxContentWidth(deviceType),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: ResponsiveUtils.getScreenPadding(deviceType),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HomeHeader(
                        deviceType: deviceType,
                        shimmerController: _shimmerController,
                      ),
                      SizedBox(height: spacing.section),
                      WelcomeCard(
                        deviceType: deviceType,
                        floatController: _floatController,
                      ),
                      SizedBox(height: spacing.section),
                      QuickStats(deviceType: deviceType),
                      SizedBox(height: spacing.section),
                      SectionTitle(
                        title: 'Lugares Turísticos',
                        icon: Icons.place,
                        color: const Color(0xFF4CAF50),
                        deviceType: deviceType,
                      ),
                      SizedBox(height: spacing.subsection),
                      TouristPlacesList(deviceType: deviceType),
                      SizedBox(height: spacing.section),
                      SectionTitle(
                        title: 'Actividades',
                        icon: Icons.local_activity,
                        color: const Color(0xFF9C27B0),
                        deviceType: deviceType,
                      ),
                      SizedBox(height: spacing.subsection),
                      ActivitiesGrid(deviceType: deviceType),
                      SizedBox(
                          height: bottomPadding > 0 ? bottomPadding + 16 : 80),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildGradientBackground() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFFFF8E1),
          const Color(0xFFFFE0B2).withOpacity(0.3),
        ],
      ),
    );
  }
}
