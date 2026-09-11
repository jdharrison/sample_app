import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// A stationary paper impression above even opaque descendants. Only the
/// decoration ignores input; the content keeps its hit testing and semantics.
class ParchmentSurface extends StatelessWidget {
  const ParchmentSurface({super.key, required this.child, this.frame = true});

  final Widget child;
  final bool frame;

  static const brass = Color(0xFF96743B);

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.passthrough,
    children: [
      child,
      Positioned.fill(
        child: IgnorePointer(
          child: ExcludeSemantics(
            child: RepaintBoundary(
              child: CustomPaint(
                foregroundPainter: _PaperPainter(frame: frame),
                isComplex: true,
                child: const SizedBox.expand(),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

class _PaperPainter extends CustomPainter {
  const _PaperPainter({required this.frame});
  final bool frame;

  // A small fixed tile avoids generating thousands of random fibres on every
  // scroll. The seed, density and physical mark sizes never depend on time.
  static final ui.Picture _grain = _recordGrain();
  static const _tileSize = 192.0;

  static ui.Picture _recordGrain() {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final random = math.Random(1873);
    final ink = Paint()..color = const Color(0x09634B2C);
    final light = Paint()..color = const Color(0x12FFF4D6);
    final fibre = Paint()
      ..color = const Color(0x08634B2C)
      ..strokeWidth = .45
      ..style = PaintingStyle.stroke;
    for (var i = 0; i < 260; i++) {
      final point = Offset(
        random.nextDouble() * _tileSize,
        random.nextDouble() * _tileSize,
      );
      canvas.drawCircle(
        point,
        .2 + random.nextDouble() * .45,
        i.isEven ? ink : light,
      );
      if (i % 5 == 0) {
        final length = 1.5 + random.nextDouble() * 4;
        canvas.drawLine(point, point + Offset(length, length * .25), fibre);
      }
    }
    return recorder.endRecording();
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    canvas.save();
    canvas.clipRect(Offset.zero & size);
    for (var y = 0.0; y < size.height; y += _tileSize) {
      for (var x = 0.0; x < size.width; x += _tileSize) {
        canvas.save();
        canvas.translate(x, y);
        canvas.drawPicture(_grain);
        canvas.restore();
      }
    }
    final chart = Paint()
      ..color = const Color(0x07634B2C)
      ..strokeWidth = .6
      ..style = PaintingStyle.stroke;
    final origin = Offset(size.width * .94, size.height * .22);
    for (final radius in [110.0, 164.0, 224.0, 296.0]) {
      canvas.drawArc(
        Rect.fromCircle(center: origin, radius: radius),
        math.pi * .35,
        math.pi * 1.25,
        false,
        chart,
      );
    }
    if (frame && size.shortestSide > 24) {
      final rule = Paint()
        ..color = ParchmentSurface.brass.withValues(alpha: .28)
        ..strokeWidth = .6
        ..style = PaintingStyle.stroke;
      canvas.drawRect((Offset.zero & size).deflate(3.5), rule);
      // Small engraved corner leaves stay within the narrow outer margin.
      for (final corner in [
        Offset.zero,
        Offset(size.width, 0),
        Offset(0, size.height),
        Offset(size.width, size.height),
      ]) {
        canvas.save();
        canvas.translate(corner.dx, corner.dy);
        canvas.scale(corner.dx == 0 ? 1 : -1, corner.dy == 0 ? 1 : -1);
        canvas.drawPath(
          Path()
            ..moveTo(4, 19)
            ..quadraticBezierTo(12, 12, 6, 6)
            ..quadraticBezierTo(12, 12, 19, 4)
            ..moveTo(7, 17)
            ..lineTo(7, 7)
            ..lineTo(17, 7),
          rule,
        );
        canvas.restore();
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_PaperPainter oldDelegate) => frame != oldDelegate.frame;
}
