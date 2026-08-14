import 'package:flutter/material.dart';

import 'color_pallete.dart';

class LightPallete implements ColorPallete {
  static final LightPallete _instance = LightPallete._internal();

  Color _primary = Color(0xFFC20332);
  Color _secondary = Color(0xFF5C0521);

  factory LightPallete({Color? primary, Color? secondary}) {
    _instance._primary = primary ?? _instance._primary;
    _instance._secondary = secondary ?? _instance._secondary;
    return _instance;
  }

  LightPallete._internal();

  @override
  Color primary() => _primary;
  @override
  Color secondary() => _secondary;
  @override
  Color accent() => secondary();
  @override
  Color background() => Color(0xFFFFFFFF);
  @override
  Color backgroundDark() => Color(0xFFF7F7F9);
  @override
  Color contrastBackground() => Color(0xFF822730);
  @override
  Color error() => Color(0xFFFF0000);
  @override
  Color negative() => Color(0xFFF22200);
  @override
  Color overlay() => Color(0x89000000);
  @override
  Color separator() => Color(0xFFE0E0E0);
  @override
  Color raffle() => Color(0xFF4D86F4);
  @override
  Color routineBlue() => Color(0xFF0058A0);
  @override
  Color warning() => Color(0XFFFF8A00);
  @override
  Color success() => Color(0xFF42B883);
  @override
  Color secondGradient() => Color(0xFF8F0F23);
  @override
  Color customColor() => Color(0xFFFFFFFF);
  @override
  Color crimsonRed() => Color(0xFFE5073E);
  @override
  Color hubertSindico() => Color(0xFF0C3959);
  @override
  Color hubertMorador() => Color(0xFF36ACE2);

  //text
  @override
  Color text() => Color(0xFF000000);
  @override
  Color textLight() => Color(0x89000000);
  @override
  Color textLightest() => Color(0x44000000);
  @override
  Color hubText() => Color(0xFF494949);
  @override
  Color textAccent() => Color(0xFF2F80ED);
  @override
  Color grey() => Color(0xFF606062);
  @override
  Color greyDarker() => Color(0xFF2D2D2D);
  @override
  Color textOpaque() => Color(0xFF828282);
  @override
  Color purpleText() => Color(0xFF922885);

  //button
  @override
  Color button() => Color(0xFFCB2640);
  @override
  Color buttonText() => Color(0xFFFFFFFF);
  @override
  Color buttonLink() => primary();
  @override
  Color buttonSystem() => Color(0xFF2F80ED);
  @override
  Color secondaryButtonBorder() => separator();
  @override
  Color whatsappButton() => Color(0xFF1BD741);

  //app bar
  @override
  Color appBar() => primary();
  @override
  Color appBarHome() => primary();
  @override
  Color statusBarColor() => primary();

  //card
  @override
  Color greyCard() => Color(0xFFF5F5F5);
}
