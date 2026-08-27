import 'package:flutter/material.dart';

import 'color_pallete.dart';

class DarkPallete implements ColorPallete {
  /// Cores padrão do singleton.
  static const Color defaultPrimary = Color(0xFFCB2640);
  static const Color defaultSecondary = Color(0xFFCB2640);

  static final DarkPallete _instance =
      DarkPallete._internal(defaultPrimary, defaultSecondary);

  Color _primary;
  Color _secondary;

  /// Sem parâmetros devolve o singleton compartilhado. Com `primary` e/ou
  /// `secondary` devolve uma NOVA instância com essas cores (as omitidas são
  /// herdadas do singleton) sem alterar o singleton. Para mudar as cores do
  /// singleton use [customize] / [restoreDefaults].
  factory DarkPallete({Color? primary, Color? secondary}) {
    if (primary == null && secondary == null) return _instance;
    return DarkPallete._internal(
        primary ?? _instance._primary, secondary ?? _instance._secondary);
  }

  DarkPallete._internal(this._primary, this._secondary);

  /// Altera as cores do singleton (afeta todo `DarkPallete()`); as cores
  /// omitidas são mantidas. Use só para trocar a identidade visual global
  /// (ex.: `LelloTheme.viverDefaultTheme`).
  static DarkPallete customize({Color? primary, Color? secondary}) {
    _instance._primary = primary ?? _instance._primary;
    _instance._secondary = secondary ?? _instance._secondary;
    return _instance;
  }

  /// Restaura as cores padrão do singleton.
  static DarkPallete restoreDefaults() {
    _instance._primary = defaultPrimary;
    _instance._secondary = defaultSecondary;
    return _instance;
  }

  @override
  Color primary() => _primary;
  @override
  Color secondary() => _secondary;
  @override
  Color accent() => secondary();
  @override
  Color background() => Color(0xFF000000);
  @override
  Color backgroundDark() => Color(0x89000000);
  @override
  Color contrastBackground() => Color(0xFFF5F5F5);
  @override
  Color error() => Color(0xFFFF0000);
  @override
  Color negative() => Color(0xFFF22200);
  @override
  Color overlay() => Color(0x89000000);
  @override
  Color separator() => Color(0xFFECECEC);
  @override
  Color success() => Color(0xFF42B883);
  @override
  Color raffle() => Color(0xFF4D86F4);
  @override
  Color routineBlue() => Color(0xFF0058A0);
  @override
  Color warning() => Color(0XFFFF8A00);
  @override
  Color secondGradient() => Color(0xFF8F0F23);
  @override
  Color customColor() => Color(0xFF000000);
  @override
  Color crimsonRed() => Color(0xFFE5073E);
  @override
  Color hubertSindico() => Color(0xFF0C3959);
  @override
  Color hubertMorador() => Color(0xFF36ACE2);

  //text
  @override
  Color text() => Color(0xFFFFFFFF);
  @override
  Color textLight() => Color(0x89FFFFFF);
  @override
  Color textLightest() => Color(0x44FFFFFF);
  @override
  Color hubText() => Color(0xFFFFFFFF);
  @override
  Color textAccent() => Color(0xFF2F80ED);
  @override
  Color grey() => Colors.grey;
  @override
  Color greyDarker() => Color(0xFF2D2D2D);
  @override
  Color textOpaque() => Color(0xFF828282);
  @override
  Color purpleText() => Color(0xFF922885);

  //button
  @override
  Color button() => Color(0xFFFFFFFF);
  @override
  Color buttonText() => Color(0xFF000000);
  @override
  Color buttonLink() => text();
  @override
  Color buttonSystem() => Color(0xFF2F80ED);
  @override
  Color secondaryButtonBorder() => Color(0xFFFFFFFF);
  @override
  Color whatsappButton() => Color(0xFF1BD741);

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
