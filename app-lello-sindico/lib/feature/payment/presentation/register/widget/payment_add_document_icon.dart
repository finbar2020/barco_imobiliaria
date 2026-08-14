import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaymentAddDocumentIcon extends StatelessWidget {
  final String svgString;
  final double width;
  final double height;

  const PaymentAddDocumentIcon({
    super.key,
    required this.svgString,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      svgString,
      width: width,
      height: height,
    );
  }
}
