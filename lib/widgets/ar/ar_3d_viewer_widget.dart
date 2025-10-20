import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../../models/monument_model.dart';

class AR3DViewerWidget extends StatelessWidget {
  final MonumentModel monument;

  const AR3DViewerWidget({
    super.key,
    required this.monument,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.grey[900]!,
            Colors.black,
          ],
        ),
      ),
      child: Stack(
        children: [
          ModelViewer(
            key: Key(monument.id),
            src: monument.model!,
            alt: monument.name,
            backgroundColor: Colors.transparent,

            // AR Configuration
            ar: true,
            arModes: const ['scene-viewer', 'webxr', 'quick-look'],

            // Animation
            autoPlay: true,
            animationName: null,

            // Camera
            autoRotate: true,
            autoRotateDelay: 0,
            rotationPerSecond: '30deg',
            cameraControls: true,
            cameraOrbit: 'auto auto auto',
            minCameraOrbit: 'auto auto 5%',
            maxCameraOrbit: 'auto auto 100%',

            // Lighting
            shadowIntensity: 1.0,
            shadowSoftness: 1.0,
            exposure: 1.0,

            // Interaction
            interactionPrompt: InteractionPrompt.auto,
            interactionPromptThreshold: 2000,

            // Loading
            loading: Loading.eager,
            reveal: Reveal.auto,
          ),

          // Loading indicator
          Center(
            child: CircularProgressIndicator(
              color: monument.color,
              strokeWidth: 3,
            ),
          ),

          // Monument name overlay
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: monument.color.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: monument.color.withOpacity(0.4),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      monument.icon,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      monument.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
