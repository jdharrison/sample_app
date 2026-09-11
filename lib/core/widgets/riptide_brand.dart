import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../config/riptide.dart';
import 'parchment.dart';

/// Original compass and botanical trident engraving, drawn without image assets.
/// The shell supplies the single accessible home-link label.
class RiptideBrand extends StatelessWidget {
  const RiptideBrand({super.key});

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontFamily: 'serif',
      fontSize: 23,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.2,
      color: Theme.of(context).colorScheme.onSurface,
    );
    return ExcludeSemantics(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final measure = TextPainter(
            text: TextSpan(text: RiptideConfig.name, style: style),
            textDirection: Directionality.of(context),
            textScaler: MediaQuery.textScalerOf(context),
          )..layout();
          final showName = constraints.maxWidth >= measure.width + 52;
          measure.dispose();
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 40,
                height: 48,
                child: CustomPaint(
                  painter: _MaritimeMark(
                    Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              if (showName) ...[
                const SizedBox(width: 12),
                Text(RiptideConfig.name, style: style),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _MaritimeMark extends CustomPainter {
  const _MaritimeMark(this.ink);
  final Color ink;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    final gold = Paint()
      ..color = ParchmentSurface.brass
      ..strokeWidth = .7
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(Offset.zero, 15, gold);
    canvas.drawCircle(Offset.zero, 17, gold);
    for (var i = 0; i < 8; i++) {
      final angle = i * math.pi / 4;
      canvas.drawLine(
        Offset(math.cos(angle) * 17, math.sin(angle) * 17),
        Offset(math.cos(angle) * 20, math.sin(angle) * 20),
        gold,
      );
    }
    final pen = Paint()
      ..color = ink
      ..strokeWidth = 1.25
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    canvas.drawPath(
      Path()
        ..moveTo(0, 14)
        ..lineTo(0, -15)
        ..moveTo(-3, -10)
        ..lineTo(0, -15)
        ..lineTo(3, -10)
        ..moveTo(0, 5)
        ..cubicTo(-9, 3, -9, -2, -8, -8)
        ..moveTo(-11, -5)
        ..lineTo(-8, -8)
        ..lineTo(-5, -5)
        ..moveTo(0, 5)
        ..cubicTo(9, 3, 9, -2, 8, -8)
        ..moveTo(5, -5)
        ..lineTo(8, -8)
        ..lineTo(11, -5)
        ..moveTo(-4, 11)
        ..quadraticBezierTo(0, 8, 4, 11),
      pen,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_MaritimeMark oldDelegate) => ink != oldDelegate.ink;
}
