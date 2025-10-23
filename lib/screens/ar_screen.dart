import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/ar/ar_header.dart';
import '../widgets/ar/ar_3d_viewer.dart';
import '../widgets/ar/ar_instructions.dart';
import '../widgets/ar/ar_monuments_list.dart';
import '../widgets/ar/ar_close_button.dart';
import '../widgets/ar/monument_info_dialog.dart';
import '../models/monument_model.dart';
import '../utils/responsive_utils.dart';

class ARScreen extends StatefulWidget {
  const ARScreen({super.key});

  @override
  State<ARScreen> createState() => _ARScreenState();
}

class _ARScreenState extends State<ARScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  int selectedModelIndex = 0;
  bool showViewer = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _handleMonumentTap(int index) {
    setState(() => selectedModelIndex = index);
  }

  void _handleView3D(int index) {
    setState(() {
      selectedModelIndex = index;
      showViewer = true;
    });
  }

  void _handleCloseViewer() {
    setState(() => showViewer = false);
  }

  void _handleShowInfo(BuildContext context, MonumentModel monument) {
    showMonumentInfoDialog(
      context: context,
      monument: monument,
      onClaim: () {
        final provider = Provider.of<AppProvider>(context, listen: false);
        provider.addPoints(monument.points);
        provider.visitPlace(monument.id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    final deviceType = ResponsiveUtils.getDeviceType(screenWidth);
    final selectedMonument = MonumentsData.monuments[selectedModelIndex];

    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Stack(
        children: [
          // Fondo 3D o cámara
          if (showViewer && selectedMonument.hasModel)
            AR3DViewerWidget(monument: selectedMonument)
          else
            _buildCameraBackground(),

          // Contenido principal
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                const ARHeaderWidget(),
                Expanded(
                  child: !showViewer
                      ? Center(
                          child: ARInstructionsWidget(
                            monument: selectedMonument,
                            pulseController: _pulseController,
                            deviceType: deviceType,
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                ARMonumentsListWidget(
                  deviceType: deviceType,
                  selectedIndex: selectedModelIndex,
                  onMonumentTap: _handleMonumentTap,
                  onView3D: _handleView3D,
                  onShowInfo: (monument) => _handleShowInfo(context, monument),
                ),
                SizedBox(height: bottomPadding > 0 ? bottomPadding + 12 : 70),
              ],
            ),
          ),

          // Botón flotante de cerrar
          if (showViewer)
            Positioned(
              right: 16,
              bottom: _calculateCloseButtonPosition(
                screenHeight,
                bottomPadding,
                deviceType,
              ),
              child: ARCloseButtonWidget(onClose: _handleCloseViewer),
            ),
        ],
      ),
    );
  }

  double _calculateCloseButtonPosition(
      double screenHeight, double bottomPadding, DeviceType deviceType) {
    return (screenHeight * 0.18) + bottomPadding + 70;
  }

  Widget _buildCameraBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.grey[900]!,
            Colors.grey[800]!,
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.camera_alt,
          size: 80,
          color: Colors.white.withOpacity(0.1),
        ),
      ),
    );
  }
}
