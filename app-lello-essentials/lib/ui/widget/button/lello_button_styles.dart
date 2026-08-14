import 'package:flutter/material.dart';

import '../../colors/color_pallete.dart';

class LelloButtonStyles {
  static themeWith(ColorPallete pallete) => ButtonThemeData(
        buttonColor: pallete.button(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        height: 48.0,
        textTheme: ButtonTextTheme.normal,
      );
}
