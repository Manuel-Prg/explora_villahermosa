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

  // Se eliminó la clase ResponsiveValues para usar cálculos dinámicos.

  void _showMonumentInfo(BuildContext context, Map<String, dynamic> monument) {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final screenWidth = MediaQuery.of(context).size.width;

    // Tamaños de fuente dinámicos para el BottomSheet
    final titleFontSize = screenWidth * 0.06;
    final bodyFontSize = screenWidth * 0.04;
    final buttonFontSize = screenWidth * 0.04;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: SingleChildScrollView(
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
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: monument['color'].withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  monument['icon'],
                  size: screenWidth * 0.15,
                  color: monument['color'],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                monument['name'],
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF5D4037),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  monument['description'],
                  style: TextStyle(
                    fontSize: bodyFontSize,
                    color: const Color(0xFF8D6E63),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                      style: TextStyle(
                        fontSize: bodyFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
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
                            fontSize: buttonFontSize,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          provider.addPoints(monument['points']);
                          provider.visitPlace(monument['id']);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '¡Has ganado ${monument['points']} puntos!',
                                style: TextStyle(fontSize: bodyFontSize),
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: monument['color'],
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Reclamar',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: buttonFontSize,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 10),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          if (showViewer && monuments[selectedModelIndex]['model'] != null)
            _build3DViewer()
          else
            _buildCameraBackground(),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                _buildHeader(screenWidth),
                Expanded(
                  child: !showViewer
                      ? Center(child: _buildInstructions(screenWidth))
                      : const SizedBox.shrink(),
                ),
                _buildMonumentsList(),
                SizedBox(
                  height: bottomPadding > 0 ? bottomPadding + 12 : 70,
                ),
              ],
            ),
          ),
          if (showViewer)
            Positioned(
              right: 16,
              bottom: (MediaQuery.of(context).size.height * 0.18) +
                  bottomPadding +
                  70,
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
          size: 60,
          color: Colors.white.withOpacity(0.1),
        ),
      ),
    );
  }

  Widget _buildHeader(double screenWidth) {
    final provider = Provider.of<AppProvider>(context);

    // Tamaños de fuente dinámicos
    final titleFontSize = screenWidth * 0.055;
    final pointsFontSize = screenWidth * 0.04;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Vista AR',
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD54F),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                const Icon(Icons.stars, size: 18, color: Colors.white),
                const SizedBox(width: 6),
                Text(
                  '${provider.points}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: pointsFontSize,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructions(double screenWidth) {
    // Tamaños dinámicos para las instrucciones
    final titleFontSize = screenWidth * 0.05;
    final bodyFontSize = screenWidth * 0.038;

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
                  padding: const EdgeInsets.all(16),
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
          const SizedBox(height: 16),
          Text(
            monuments[selectedModelIndex]['name'],
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF5D4037),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Toca el botón "Ver 3D" en las tarjetas para visualizar el monumento',
            style: TextStyle(
              fontSize: bodyFontSize,
              color: const Color(0xFF8D6E63),
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

  Widget _buildMonumentsList() {
    final provider = Provider.of<AppProvider>(context);
    final size = MediaQuery.of(context).size;

    // --- MEJORA RESPONSIVE ---
    // Calculamos el tamaño de las tarjetas dinámicamente
    final double cardHeight = size.height * 0.18; // 18% de la altura
    final double cardWidth =
        size.width / 4.5; // Mostrar ~4.5 tarjetas en pantalla

    return Container(
      height: cardHeight,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
              margin: const EdgeInsets.only(right: 12.0),
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(
                        monument['icon'],
                        size: cardHeight *
                            0.25, // Icono proporcional a la tarjeta
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      monument['name'],
                      style: TextStyle(
                        fontSize: cardWidth * 0.1, // Fuente proporcional
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
                  if (hasModel)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedModelIndex = index;
                          showViewer = true;
                        });
                      },
                      child: _buildActionButton(
                        monument['color'],
                        Icons.view_in_ar,
                        'Ver 3D',
                        true,
                        cardWidth, // Pasar el ancho para el tamaño del botón
                      ),
                    )
                  else
                    GestureDetector(
                      onTap: () {
                        setState(() => selectedModelIndex = index);
                        _showMonumentInfo(context, monument);
                      },
                      child: _buildActionButton(
                        Colors.grey.shade300,
                        Icons.info_outline,
                        'Info',
                        false,
                        cardWidth, // Pasar el ancho para el tamaño del botón
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

  Widget _buildActionButton(
    Color bgColor,
    IconData icon,
    String label,
    bool isPrimary,
    double cardWidth, // Recibe el ancho de la tarjeta
  ) {
    // El padding y el tamaño de la fuente ahora son proporcionales
    final double horizontalPadding = cardWidth * 0.1;
    final double verticalPadding = cardWidth * 0.05;
    final double fontSize = cardWidth * 0.09;
    final double iconSize = cardWidth * 0.12;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        gradient: isPrimary
            ? LinearGradient(
                colors: [
                  bgColor,
                  bgColor.withOpacity(0.8),
                ],
              )
            : null,
        color: !isPrimary ? bgColor : null,
        borderRadius: BorderRadius.circular(10),
        boxShadow: isPrimary
            ? [
                BoxShadow(
                  color: bgColor.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: iconSize,
            color: isPrimary ? Colors.white : Colors.grey,
          ),
          SizedBox(width: cardWidth * 0.04),
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: isPrimary ? Colors.white : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
