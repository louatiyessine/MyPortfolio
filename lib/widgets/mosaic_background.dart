import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Motif décoratif d'étoiles à huit branches, inspiré des zelliges et des
/// portes de la médina. Il s'estompe vers le bas.
///
/// Dessiné avec un [CustomPainter] : pas d'image à charger, net sur tous les
/// écrans, et la couleur suit l'accent de l'étudiant.
class MosaicBackground extends StatelessWidget {
  const MosaicBackground({
    super.key,
    required this.color,
    this.opacity = 0.10,
    this.tileSize = 64,
  });

  final Color color;
  final double opacity;
  final double tileSize;

  @override
  Widget build(BuildContext context) {
    // IgnorePointer : le décor ne doit jamais intercepter les clics.
    return IgnorePointer(
      child: CustomPaint(
        size: Size.infinite,
        painter: _MosaicPainter(
          color: color,
          opacity: opacity,
          tileSize: tileSize,
        ),
      ),
    );
  }
}

class _MosaicPainter extends CustomPainter {
  _MosaicPainter({
    required this.color,
    required this.opacity,
    required this.tileSize,
  });

  final Color color;
  final double opacity;
  final double tileSize;

  @override
  void paint(Canvas canvas, Size size) {
    final rows = (size.height / tileSize).ceil() + 1;
    final cols = (size.width / tileSize).ceil() + 1;

    for (var row = 0; row < rows; row++) {
      final y = row * tileSize;
      // Plus on descend, plus le motif devient transparent.
      final fade = (1 - y / size.height).clamp(0.0, 1.0);
      final stroke = Paint()
        ..color = color.withValues(alpha: opacity * fade)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      final dot = Paint()..color = color.withValues(alpha: opacity * fade * 1.6);

      for (var col = 0; col < cols; col++) {
        final center = Offset(col * tileSize, y);
        canvas.drawPath(_star(center, tileSize * 0.34), stroke);
        // Petit point au centre de chaque case, entre quatre étoiles.
        canvas.drawCircle(
          center + Offset(tileSize / 2, tileSize / 2),
          1.6,
          dot,
        );
      }
    }
  }

  /// Étoile à 8 branches (deux carrés superposés) : 16 sommets qui alternent
  /// entre le rayon extérieur [r] et un rayon intérieur.
  static Path _star(Offset center, double r) {
    const innerRatio = 0.7654; // = cos(45°) / cos(22,5°)
    final path = Path();
    for (var i = 0; i < 16; i++) {
      final angle = i * math.pi / 8; // pas de 22,5°
      final radius = i.isEven ? r : r * innerRatio;
      final point = center +
          Offset(math.cos(angle) * radius, math.sin(angle) * radius);
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    return path..close();
  }

  /// On ne redessine que si un paramètre visuel a changé.
  @override
  bool shouldRepaint(_MosaicPainter old) =>
      old.color != color || old.opacity != opacity || old.tileSize != tileSize;
}
