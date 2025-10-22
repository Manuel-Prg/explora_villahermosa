import 'package:flutter/material.dart';

// Transición de Fade
class FadePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final Duration duration;

  FadePageRoute({
    required this.page,
    this.duration = const Duration(milliseconds: 400),
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: duration,
        );
}

// Transición de Slide desde la derecha
class SlideRightPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final Duration duration;

  SlideRightPageRoute({
    required this.page,
    this.duration = const Duration(milliseconds: 350),
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOutCubic;

            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: duration,
        );
}

// Transición de Slide desde abajo
class SlideUpPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final Duration duration;

  SlideUpPageRoute({
    required this.page,
    this.duration = const Duration(milliseconds: 350),
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeInOutCubic;

            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: duration,
        );
}

// Transición de Scale (zoom)
class ScalePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final Duration duration;

  ScalePageRoute({
    required this.page,
    this.duration = const Duration(milliseconds: 400),
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const curve = Curves.easeInOutCubic;

            var scaleTween = Tween<double>(begin: 0.8, end: 1.0).chain(
              CurveTween(curve: curve),
            );

            var fadeTween = Tween<double>(begin: 0.0, end: 1.0).chain(
              CurveTween(curve: curve),
            );

            return ScaleTransition(
              scale: animation.drive(scaleTween),
              child: FadeTransition(
                opacity: animation.drive(fadeTween),
                child: child,
              ),
            );
          },
          transitionDuration: duration,
        );
}

// Transición de Rotation + Scale
class RotationScalePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final Duration duration;

  RotationScalePageRoute({
    required this.page,
    this.duration = const Duration(milliseconds: 500),
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const curve = Curves.easeInOutBack;

            var scaleTween = Tween<double>(begin: 0.0, end: 1.0).chain(
              CurveTween(curve: curve),
            );

            var rotationTween = Tween<double>(begin: -0.2, end: 0.0).chain(
              CurveTween(curve: curve),
            );

            return ScaleTransition(
              scale: animation.drive(scaleTween),
              child: RotationTransition(
                turns: animation.drive(rotationTween),
                child: child,
              ),
            );
          },
          transitionDuration: duration,
        );
}

// Transición combinada Slide + Fade
class SlideFadePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final Duration duration;
  final Offset beginOffset;

  SlideFadePageRoute({
    required this.page,
    this.duration = const Duration(milliseconds: 400),
    this.beginOffset = const Offset(0.3, 0.0),
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const curve = Curves.easeInOutCubic;

            var slideTween = Tween<Offset>(
              begin: beginOffset,
              end: Offset.zero,
            ).chain(CurveTween(curve: curve));

            var fadeTween = Tween<double>(begin: 0.0, end: 1.0).chain(
              CurveTween(curve: curve),
            );

            return SlideTransition(
              position: animation.drive(slideTween),
              child: FadeTransition(
                opacity: animation.drive(fadeTween),
                child: child,
              ),
            );
          },
          transitionDuration: duration,
        );
}

// Extensión para facilitar el uso
extension NavigatorExtensions on BuildContext {
  // Navegación con fade
  Future<T?> pushFade<T>(Widget page) {
    return Navigator.push<T>(
      this,
      FadePageRoute<T>(page: page),
    );
  }

  // Navegación con slide desde la derecha
  Future<T?> pushSlideRight<T>(Widget page) {
    return Navigator.push<T>(
      this,
      SlideRightPageRoute<T>(page: page),
    );
  }

  // Navegación con slide desde abajo
  Future<T?> pushSlideUp<T>(Widget page) {
    return Navigator.push<T>(
      this,
      SlideUpPageRoute<T>(page: page),
    );
  }

  // Navegación con scale
  Future<T?> pushScale<T>(Widget page) {
    return Navigator.push<T>(
      this,
      ScalePageRoute<T>(page: page),
    );
  }

  // Navegación con slide + fade
  Future<T?> pushSlideFade<T>(Widget page) {
    return Navigator.push<T>(
      this,
      SlideFadePageRoute<T>(page: page),
    );
  }

  // Reemplazar con fade
  Future<T?> replaceFade<T>(Widget page) {
    return Navigator.pushReplacement<T, void>(
      this,
      FadePageRoute<T>(page: page),
    );
  }
}
