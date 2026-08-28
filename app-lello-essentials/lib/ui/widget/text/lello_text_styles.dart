import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../colors/color_pallete.dart';

class LelloTextStyles {
  /// MATERIAL DESIGN DEFAULTS:
  /// headline1               112.0  thin     0.0
  /// headline2               56.0   normal   0.0
  /// headline3               45.0   normal   0.0
  /// headline4               34.0   normal   0.0
  /// headline5               24.0   normal   0.0
  /// headline6               20.0   medium   0.0
  /// subtitle1               16.0   normal   0.0
  /// body1 (bodyText1)       14.0   medium   0.0
  /// body2 (bodyText2)       14.0   normal   0.0
  /// button                  14.0   medium   0.0
  /// subtitle2               14.0   medium   0.0
  /// caption                 12.0   normal   0.0
  /// overline                10.0   normal   0.0
  static themeWith(ColorPallete pallete) => TextTheme(
      displayLarge: TextStyle(
          fontSize: 36.0,
          fontWeight: FontWeight.w200,
          color: pallete.text(),
          height: 1.2),
      displayMedium: TextStyle(
          fontSize: 56.0,
          fontWeight: FontWeight.normal,
          color: pallete.text(),
          height: 1.2),
      displaySmall: TextStyle(
          fontSize: 45.0,
          fontWeight: FontWeight.normal,
          color: pallete.text(),
          height: 1.2),
      headlineMedium: TextStyle(
          fontSize: 34.0,
          fontWeight: FontWeight.normal,
          color: pallete.text(),
          height: 1.2),
      headlineSmall: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          color: pallete.text(),
          height: 1.3),
      titleLarge: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.normal,
          color: pallete.text(),
          height: 1.3),
      titleMedium: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.normal,
          color: pallete.text(),
          height: 1.4),
      titleSmall: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w700,
          color: pallete.text(),
          height: 1.4),
      bodyLarge: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
          color: pallete.text(),
          height: 1.3),
      bodyMedium: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.normal,
          color: pallete.text(),
          height: 1.3),
      bodySmall: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.normal,
          color: pallete.text(),
          height: 1.3), 
      labelLarge: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w700,
          color: pallete.buttonText(),
          height: 1.2),  
      labelSmall: TextStyle(
          fontSize: 10.0,
          fontWeight: FontWeight.normal,
          color: pallete.text(),
          height: 1.2), 
    );


  /// Tamanho 112.0
  static TextStyle? headline(ThemeData theme) => theme.textTheme.displayLarge;

  /// Tamanho 24.0
  static TextStyle? title(ThemeData theme) => theme.textTheme.headlineSmall;

  /// Tamanho 24.0
  static TextStyle? titleBold(ThemeData theme) =>
      theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold);

  /// Tamanho 20.0
  static TextStyle? titleSmall(ThemeData theme) => theme.textTheme.titleLarge;

  /// Tamanho 20.0
  static TextStyle? titleSmallBold(ThemeData theme) =>
      theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold);

  /// Tamanho 16.0
  static TextStyle? subtitle(ThemeData theme) => theme.textTheme.titleMedium;

  /// Tamanho 16.0
  static TextStyle? subtitleBold(ThemeData theme) =>
      theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold);

  /// Tamanho 14.0
  static TextStyle? body(ThemeData theme) => theme.textTheme.bodyMedium;

  /// Tamanho 14.0
  static TextStyle? bodyBold(ThemeData theme) => theme.textTheme.titleSmall;

  /// Tamanho 16.0 (deriva de `bodyLarge`)
  static TextStyle? subBody(ThemeData theme) =>
      theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.normal);

  /// Tamanho 14.0
  static TextStyle? button(ThemeData theme) => theme.textTheme.labelLarge;

  /// Tamanho 14.0
  static TextStyle? error(ThemeData theme) => theme.textTheme.bodyMedium
      ?.copyWith(color: LelloTheme.palleteOf(theme).error());

  /// Tamanho 14.0
  static TextStyle? inverseButton(ThemeData theme) => theme.textTheme.labelLarge
      ?.copyWith(color: LelloTheme.palleteOf(theme).buttonLink());

  /// Tamanho 12.0
  static TextStyle? captionBold(ThemeData theme) =>
      theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold);

  /// Tamanho 12.0
  static TextStyle? caption(ThemeData theme) => theme.textTheme.bodySmall;

  LelloTextStyles._();
}
