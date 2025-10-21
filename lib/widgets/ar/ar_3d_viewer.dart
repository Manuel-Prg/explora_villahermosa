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
        ],
      ),
    );
  }
}
