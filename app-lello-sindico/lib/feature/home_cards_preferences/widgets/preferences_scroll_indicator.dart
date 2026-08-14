import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PreferencesScrollIndicator extends StatefulWidget {
  const PreferencesScrollIndicator({super.key});

  @override
  State<PreferencesScrollIndicator> createState() =>
      _PreferencesScrollIndicatorState();
}

class _PreferencesScrollIndicatorState extends State<PreferencesScrollIndicator>
    with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  final Tween<double> _rotationTween = Tween(begin: 0, end: 2);

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    animation = _rotationTween.animate(controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.repeat();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'assets/an_scroll_tutorial.json',
      height: 100,
      width: 100,
      animate: true,
      repeat: true,
    );
  }
}

class ArrowPainter extends CustomPainter {
  final int value;
  ArrowPainter({required this.value});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    var halfWidth = size.width / 2;
    var halfHeight = size.height / 2;

    var path = Path();
    path.moveTo(halfWidth - 5, halfHeight - 12);
    path.lineTo(halfWidth, halfHeight - 7);
    path.lineTo(halfWidth + 5, halfHeight - 12);
    canvas.drawPath(
        path,
        paint
          ..color =
              (value < 33 ? const Color(0xFFC20332) : Colors.red.shade400));

    path = Path();
    path.moveTo(halfWidth - 7, halfHeight - 7);
    path.lineTo(halfWidth, halfHeight);
    path.lineTo(halfWidth + 7, halfHeight - 7);
    canvas.drawPath(
        path,
        paint
          ..color = (value > 33 && value < 66
              ? const Color(0xFFC20332)
              : Colors.red.shade400));

    path = Path();
    path.moveTo(halfWidth - 9, halfHeight - 2);
    path.lineTo(halfWidth, halfHeight + 7);
    path.lineTo(halfWidth + 9, halfHeight - 2);
    canvas.drawPath(
        path,
        paint
          ..color =
              (value > 66 ? const Color(0xFFC20332) : Colors.red.shade400));
  }

  @override
  bool shouldRepaint(ArrowPainter oldDelegate) => oldDelegate.value != value;
}
