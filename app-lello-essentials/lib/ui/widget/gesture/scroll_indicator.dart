import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ScrollIndicator extends StatefulWidget {
  final double height;
  final double width;
  const ScrollIndicator({super.key, this.height = 100, this.width = 100});

  @override
  State<ScrollIndicator> createState() => _ScrollIndicatorState();
}

/// O Lottie anima sozinho (`animate`/`repeat`), então não há controller
/// próprio nem `setState` a cada frame.
class _ScrollIndicatorState extends State<ScrollIndicator> {
  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'assets/an_scroll_tutorial.json',
      height: widget.height,
      width: widget.width,
      animate: true,
      repeat: true,
      // O asset é declarado pelo app hospedeiro; sem ele não renderiza nada.
      errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
    );
  }
}
