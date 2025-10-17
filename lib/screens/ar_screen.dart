import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ARScreen extends StatefulWidget {
  const ARScreen({super.key});

  @override
  State<ARScreen> createState() => _ARScreenState();
}

class _ARScreenState extends State<ARScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  int selectedModelIndex = 0;
  bool showViewer = false;

  final List<Map<String, dynamic>> monuments = [
    {
      'id': 'cafe',
      'name': 'Café el Portal',
      'model': 'assets/models/cafe.glb',
      'icon': Icons.local_cafe,
      'color': const Color(0xFF8D6E63),
      'points': 50,
      'description':
          'Edificio histórico con arquitectura colonial de principios del siglo XX.',
    },
    {
      'id': 'Palacio',
      'name': 'Palacio Municipal',
      'model': 'assets/models/Edificio.glb',
      'icon': Icons.apartment,
      'color': const Color(0xFF4CAF50),
      'points': 40,
      'description': 'Edificio emblemático del centro de Villahermosa.',
    },
    {
      'id': 'catedral',
      'name': 'Catedral del Señor',
      'model': 'assets/models/catedral.glb',
      'icon': Icons.church,
      'color': const Color(0xFF2196F3),
      'points': 30,
      'description': 'Hermosa catedral en el centro de Villahermosa.',
    },
    {
      'id': 'malecon',
      'name': 'Malecón',
      'model': 'assets/models/malecon.glb',
      'icon': Icons.water,
      'color': const Color(0xFF00BCD4),
      'points': 25,
      'description': 'Paseo a orillas del río Grijalva.',
    },
  ];

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

  void _showMonumentInfo(Map<String, dynamic> monument) {
    final provider = Provider.of<AppProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(25),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: monument['color'].withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                monument['icon'],
                size: 60,
                color: monument['color'],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              monument['name'],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5D4037),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              monument['description'],
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF8D6E63),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFD54F), Color(0xFFFFB74D)],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.stars, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    '+${monument['points']} puntos',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      side: BorderSide(color: monument['color']),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Cerrar',
                      style: TextStyle(
                        color: monument['color'],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      provider.addPoints(monument['points']);
                      provider.visitPlace(monument['id']);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('¡Has ganado ${monument['points']} puntos!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: monument['color'],
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Reclamar',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Obtener padding del sistema (incluye áreas de accesibilidad)
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calcular altura dinámica para las tarjetas según el tamaño de pantalla
    final cardHeight = screenHeight < 700 ? 110.0 : 120.0;

    return Scaffold(
      body: Stack(
        children: [
          // Fondo o visor 3D
          if (showViewer && monuments[selectedModelIndex]['model'] != null)
            _build3DViewer()
          else
            _buildCameraBackground(),

          // UI Principal
          SafeArea(
            bottom: false, // Desactivamos SafeArea en la parte inferior
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: !showViewer
                      ? Center(child: _buildInstructions())
                      : const SizedBox.shrink(),
                ),
                // Lista de monumentos al final con padding dinámico
                _buildMonumentsList(cardHeight),
                // Espaciado adicional para el botón de accesibilidad
                SizedBox(height: bottomPadding > 0 ? bottomPadding + 16 : 80),
              ],
            ),
          ),

          // Botón flotante cuando está en modo visor
          if (showViewer)
            Positioned(
              right: 20,
              bottom: cardHeight + bottomPadding + 80, // Posición dinámica
              child: _buildFloatingCloseButton(),
            ),
        ],
      ),
    );
  }

  Widget _build3DViewer() {
    final monument = monuments[selectedModelIndex];

    return ModelViewer(
      backgroundColor: Colors.grey[900]!,
      key: Key(monument['id']),
      src: monument['model'],
      alt: monument['name'],
      ar: true,
      autoRotate: true,
      cameraControls: true,
    );
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
          size: 100,
          color: Colors.white.withOpacity(0.1),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final provider = Provider.of<AppProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Vista AR',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD54F),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                const Icon(Icons.stars, size: 18, color: Colors.white),
                const SizedBox(width: 5),
                Text(
                  '${provider.points}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 + (_pulseController.value * 0.1),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9C27B0).withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.view_in_ar,
                    size: 40,
                    color: Color(0xFF9C27B0),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 15),
          Text(
            monuments[selectedModelIndex]['name'],
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF5D4037),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Toca el botón "Ver 3D" en las tarjetas para visualizar el monumento',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF8D6E63),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingCloseButton() {
    return GestureDetector(
      onTap: () {
        setState(() => showViewer = false);
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red.shade600,
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.5),
              blurRadius: 15,
              spreadRadius: 3,
            ),
          ],
        ),
        child: const Icon(
          Icons.close,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildMonumentsList(double cardHeight) {
    final provider = Provider.of<AppProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    // Ajustar ancho de tarjetas según pantalla
    final cardWidth = screenWidth < 360 ? 90.0 : 100.0;

    return Container(
      height: cardHeight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: monuments.length,
        itemBuilder: (context, index) {
          final monument = monuments[index];
          final isVisited = provider.visitedPlaces.contains(monument['id']);
          final isSelected = selectedModelIndex == index;
          final hasModel = monument['model'] != null;

          return GestureDetector(
            onTap: () => setState(() => selectedModelIndex = index),
            child: Container(
              width: cardWidth,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? monument['color']
                      : (isVisited ? Colors.green : Colors.grey[300]!),
                  width: isSelected ? 3 : (isVisited ? 2 : 1),
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: monument['color'].withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icono principal del monumento
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(
                        monument['icon'],
                        size: 30,
                        color: isSelected || isVisited
                            ? monument['color']
                            : Colors.grey,
                      ),
                      if (isVisited)
                        Positioned(
                          right: -4,
                          top: -4,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              size: 10,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Nombre del monumento
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Text(
                      monument['name'],
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: isSelected || isVisited
                            ? const Color(0xFF5D4037)
                            : Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Botón de Ver en 3D o Info
                  if (hasModel)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedModelIndex = index;
                          showViewer = true;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              monument['color'],
                              monument['color'].withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: monument['color'].withOpacity(0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.view_in_ar,
                              size: 11,
                              color: Colors.white,
                            ),
                            SizedBox(width: 3),
                            Text(
                              'Ver 3D',
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    GestureDetector(
                      onTap: () {
                        setState(() => selectedModelIndex = index);
                        _showMonumentInfo(monument);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 11,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 3),
                            Text(
                              'Info',
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
