import 'package:flutter/material.dart';

class HalfColorIcon extends StatelessWidget {
  final Color color1;
  final Color color2;
  final double size;
  final IconData icon = Icons.circle;

  const HalfColorIcon({
    super.key,
    required this.color1,
    required this.color2,
    this.size = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Metade esquerda do círculo
        ClipRect(
          child: Align(
            alignment: Alignment.centerLeft,
            widthFactor: 0.5,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color1,
              ),
            ),
          ),
        ),
        // Metade direita do círculo
        ClipRect(
          child: Align(
            alignment: Alignment.centerRight,
            widthFactor: 0.5,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
