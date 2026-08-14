import 'package:flutter/material.dart';

/// Tema visual do dashboard. Dark mode com paleta focada em legibilidade.
class AppTheme {
  static const Color background = Color(0xFF0F1420);
  static const Color surface = Color(0xFF1A2033);
  static const Color surfaceAlt = Color(0xFF232B42);
  static const Color primary = Color(0xFF6C7BF4);
  static const Color primaryLight = Color(0xFF8A97F7);
  static const Color accent = Color(0xFF34D399);
  static const Color danger = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color textPrimary = Color(0xFFE6E9F2);
  static const Color textSecondary = Color(0xFF9AA3B8);
  static const Color divider = Color(0xFF2A3350);

  /// Paleta usada para dados categóricos (charts).
  static const List<Color> chartPalette = [
    Color(0xFF6C7BF4), // roxo/azul
    Color(0xFF34D399), // verde
    Color(0xFFF59E0B), // âmbar
    Color(0xFFEF4444), // vermelho
    Color(0xFF06B6D4), // ciano
    Color(0xFFEC4899), // rosa
    Color(0xFFA78BFA), // violeta claro
    Color(0xFFFACC15), // amarelo
    Color(0xFF10B981), // verde escuro
    Color(0xFF3B82F6), // azul
  ];

  static Color colorFor(int index) =>
      chartPalette[index % chartPalette.length];

  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: background,
      colorScheme: base.colorScheme.copyWith(
        primary: primary,
        secondary: accent,
        surface: surface,
        error: danger,
      ),
      cardTheme: base.cardTheme.copyWith(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: divider, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
      ),
      textTheme: base.textTheme.apply(
        bodyColor: textPrimary,
        displayColor: textPrimary,
      ),
      dividerColor: divider,
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: surfaceAlt,
        side: const BorderSide(color: divider),
        labelStyle: const TextStyle(color: textPrimary, fontSize: 12),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primary,
      ),
    );
  }
}
