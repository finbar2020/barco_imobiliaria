import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../colors/color_pallete.dart';

class LelloAppBarStyles {
  static themeWith(ColorPallete pallete) => AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarIconBrightness: Brightness.light,
          statusBarColor: pallete.statusBarColor(),
        ),
        color: pallete.appBar(),
        iconTheme: IconThemeData(
          color: pallete.appBar(),
        ),
        elevation: 0,
      );
}
