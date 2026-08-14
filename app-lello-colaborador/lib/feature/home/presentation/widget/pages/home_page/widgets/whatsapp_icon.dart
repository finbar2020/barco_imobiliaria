import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:essentials/essentials.dart';

class WhatsappIcon extends StatefulWidget {
  const WhatsappIcon({
    Key? key,
  }) : super(key: key);

  @override
  _WhatsappIconState createState() => _WhatsappIconState();
}

class _WhatsappIconState extends State<WhatsappIcon> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 50.0,
        height: 30.0,
        decoration: BoxDecoration(
          color: LelloTheme.palleteOf(Theme.of(context)).primary(),
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Center(
          child: SvgPicture.asset(
            'assets/ic_whatsapp_white.svg',
            height: 20.0,
            width: 20.0,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
