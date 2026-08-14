import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class VehicleContainer extends StatelessWidget {
  final Widget child;
  final double? height;

  VehicleContainer({required this.child, this.height = 60});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      child: child,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: LelloTheme.palleteOf(theme).textOpaque(),
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}
