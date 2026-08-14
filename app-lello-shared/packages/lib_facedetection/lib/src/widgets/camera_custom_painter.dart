import 'dart:math' show pi, sin;
import 'dart:ui';
import 'package:flutter/material.dart';

enum FaceFrameState { waiting, detected, validating, error }

class RPSCustomPainter extends CustomPainter {
  final Color color;
  final FaceFrameState state;
  final Animation<double>? animation;

  // Cache for the face path
  static Path? _cachedPath;
  static Size? _cachedSize;

  RPSCustomPainter({
    this.color = Colors.grey,
    this.state = FaceFrameState.waiting,
    this.animation,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final Path path = _getFacePath(size);
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = color;

    if (state == FaceFrameState.waiting && animation != null) {
      paint.strokeWidth = 2.0 + (animation!.value * 2.0);
    }

    if (state == FaceFrameState.validating) {
      paint.strokeWidth = 3.0;
      final Path dashPath = _createDashPath(path);
      canvas.drawPath(dashPath, paint);
      return;
    }

    if (state == FaceFrameState.detected) {
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 3.0;
      paint.maskFilter = const MaskFilter.blur(BlurStyle.outer, 3.0);
    }

    if (state == FaceFrameState.error && animation != null) {
      canvas.translate(sin(animation!.value * pi * 8) * 3, 0);
    }

    canvas.drawPath(path, paint);

    if (state == FaceFrameState.detected) {
      final fillPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = color.withOpacity(0.1);
      canvas.drawPath(path, fillPaint);
    }
  }

  Path _getFacePath(Size size) {
    if (_cachedPath != null && _cachedSize == size) {
      return _cachedPath!;
    }
    _cachedSize = size;
    _cachedPath = _createFacePath(size);
    return _cachedPath!;
  }

  Path _createDashPath(Path sourcePath) {
    final Path dashPath = Path();
    const double dashWidth = 10.0;
    const double dashSpace = 5.0;
    final PathMetric metric = sourcePath.computeMetrics().first;
    double distance = 0.0;
    while (distance < metric.length) {
      dashPath.addPath(
        metric.extractPath(distance, distance + dashWidth),
        Offset.zero,
      );
      distance += dashWidth + dashSpace;
    }
    return dashPath;
  }

  Path _createFacePath(Size size) {
    final Path path = Path();
    path.moveTo(size.width * 0.4999938, size.height * 0.03866327);
    path.cubicTo(
        size.width * 0.1749529,
        size.height * 0.03866327,
        size.width * 0.07399138,
        size.height * 0.2888980,
        size.width * 0.07399138,
        size.height * 0.3800510);
    path.cubicTo(
        size.width * 0.07582704,
        size.height * 0.4798571,
        size.width * 0.08952392,
        size.height * 0.5792857,
        size.width * 0.1149023,
        size.height * 0.6770408);
    path.lineTo(size.width * 0.1185608, size.height * 0.6897347);
    path.cubicTo(
        size.width * 0.1282526,
        size.height * 0.7256735,
        size.width * 0.1432588,
        size.height * 0.7605714,
        size.width * 0.1632586,
        size.height * 0.7937041);
    path.cubicTo(
        size.width * 0.1852737,
        size.height * 0.8316224,
        size.width * 0.2236172,
        size.height * 0.8620510,
        size.width * 0.2713573,
        size.height * 0.8794898);
    path.cubicTo(
        size.width * 0.3055931,
        size.height * 0.8927449,
        size.width * 0.3387121,
        size.height * 0.9077245,
        size.width * 0.3705345,
        size.height * 0.9243571);
    path.lineTo(size.width * 0.3731918, size.height * 0.9258469);
    path.cubicTo(
        size.width * 0.4096098,
        size.height * 0.9481327,
        size.width * 0.4540380,
        size.height * 0.9605816,
        size.width * 0.4999938,
        size.height * 0.9613469);
    path.cubicTo(
        size.width * 0.5459367,
        size.height * 0.9605714,
        size.width * 0.5903649,
        size.height * 0.9481429,
        size.width * 0.6267701,
        size.height * 0.9258571);
    path.lineTo(size.width * 0.6294530, size.height * 0.9243571);
    path.cubicTo(
        size.width * 0.6612626,
        size.height * 0.9077245,
        size.width * 0.6943944,
        size.height * 0.8927449,
        size.width * 0.7286174,
        size.height * 0.8794898);
    path.cubicTo(
        size.width * 0.7763061,
        size.height * 0.8620918,
        size.width * 0.8146112,
        size.height * 0.8317245,
        size.width * 0.8366263,
        size.height * 0.7938571);
    path.cubicTo(
        size.width * 0.8566646,
        size.height * 0.7606735,
        size.width * 0.8716836,
        size.height * 0.7257245,
        size.width * 0.8814011,
        size.height * 0.6897347);
    path.lineTo(size.width * 0.8850596, size.height * 0.6770408);
    path.cubicTo(
        size.width * 0.9104508,
        size.height * 0.5792857,
        size.width * 0.9241477,
        size.height * 0.4798571,
        size.width * 0.9259962,
        size.height * 0.3800510);
    path.cubicTo(
        size.width * 0.9259962,
        size.height * 0.2888980,
        size.width * 0.8250218,
        size.height * 0.03866327,
        size.width * 0.4999938,
        size.height * 0.03866327);
    path.close();
    path.moveTo(size.width * 0.8650727, size.height * 0.6897347);
    path.cubicTo(
        size.width * 0.8557018,
        size.height * 0.7237449,
        size.width * 0.8413631,
        size.height * 0.7567755,
        size.width * 0.8223646,
        size.height * 0.7881531);
    path.cubicTo(
        size.width * 0.8018257,
        size.height * 0.8232245,
        size.width * 0.7664218,
        size.height * 0.8514286,
        size.width * 0.7223273,
        size.height * 0.8678265);
    path.cubicTo(
        size.width * 0.6871160,
        size.height * 0.8814388,
        size.width * 0.6530342,
        size.height * 0.8968469,
        size.width * 0.6203004,
        size.height * 0.9139490);
    path.lineTo(size.width * 0.6175533, size.height * 0.9154898);
    path.cubicTo(
        size.width * 0.5838952,
        size.height * 0.9363469,
        size.width * 0.5426505,
        size.height * 0.9479796,
        size.width * 0.4999938,
        size.height * 0.9486531);
    path.cubicTo(
        size.width * 0.4573242,
        size.height * 0.9479796,
        size.width * 0.4160795,
        size.height * 0.9363367,
        size.width * 0.3824214,
        size.height * 0.9154796);
    path.lineTo(size.width * 0.3796872, size.height * 0.9139490);
    path.cubicTo(
        size.width * 0.3469533,
        size.height * 0.8968571,
        size.width * 0.3128716,
        size.height * 0.8814490,
        size.width * 0.2776602,
        size.height * 0.8678265);
    path.cubicTo(
        size.width * 0.2335144,
        size.height * 0.8513878,
        size.width * 0.1980592,
        size.height * 0.8231327,
        size.width * 0.1775203,
        size.height * 0.7879898);
    path.cubicTo(
        size.width * 0.1585603,
        size.height * 0.7566633,
        size.width * 0.1442472,
        size.height * 0.7236939,
        size.width * 0.1348764,
        size.height * 0.6897347);
    path.lineTo(size.width * 0.1311537, size.height * 0.6770408);
    path.cubicTo(
        size.width * 0.1055314,
        size.height * 0.5793163,
        size.width * 0.09173185,
        size.height * 0.4798673,
        size.width * 0.08996037,
        size.height * 0.3800510);
    path.cubicTo(
        size.width * 0.08996037,
        size.height * 0.2922857,
        size.width * 0.1871350,
        size.height * 0.05135714,
        size.width * 0.4999938,
        size.height * 0.05135714);
    path.cubicTo(
        size.width * 0.8128397,
        size.height * 0.05135714,
        size.width * 0.9100143,
        size.height * 0.2922857,
        size.width * 0.9100143,
        size.height * 0.3800510);
    path.cubicTo(
        size.width * 0.9082429,
        size.height * 0.4798673,
        size.width * 0.8944433,
        size.height * 0.5793163,
        size.width * 0.8688082,
        size.height * 0.6770408);
    path.lineTo(size.width * 0.8650727, size.height * 0.6897347);
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant RPSCustomPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.state != state ||
        oldDelegate.animation?.value != animation?.value;
  }
}
