import 'package:flutter/material.dart';

abstract class ColorPallete {
  Color primary();
  Color secondary();
  Color accent();
  Color background();
  Color backgroundDark();
  Color contrastBackground();
  Color warning();
  Color raffle();
  Color routineBlue();
  Color success();
  Color error();
  Color negative();
  Color secondGradient();
  Color customColor();
  Color textLightest();
  Color crimsonRed();
  Color hubertSindico();
  Color hubertMorador();

  Color overlay();
  Color separator();
  Color grey();
  Color greyDarker();

  //card
  Color greyCard();

  //button
  Color button();
  Color buttonText();
  Color buttonLink();
  Color buttonSystem();
  Color secondaryButtonBorder();
  Color whatsappButton();

  //text
  Color text();
  Color textLight();
  Color hubText();
  Color textAccent();
  Color textOpaque();
  Color purpleText();

  //appbar
  Color appBar();
  Color appBarHome();
  Color statusBarColor();
}
