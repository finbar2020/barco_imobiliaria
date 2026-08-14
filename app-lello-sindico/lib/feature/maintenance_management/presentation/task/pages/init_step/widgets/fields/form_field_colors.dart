import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

/// Helper class para cores padronizadas dos campos de formulário
/// Garante consistência com o Design System e suporte a White Label
class FormFieldColors {
  /// Cor de fundo dos campos (branco)
  static Color background(ColorPallete palette) => palette.background();
  
  /// Cor da borda padrão (cinza)
  static Color border(ColorPallete palette) => palette.grey();
  
  /// Cor da borda quando focado (primária)
  static Color borderFocused(ColorPallete palette) => palette.primary();
  
  /// Cor do texto (preto)
  static Color text(ColorPallete palette) => palette.text();
  
  /// Cor do placeholder (cinza)
  static Color placeholder(ColorPallete palette) => palette.grey();
  
  /// Cor de erro (vermelho)
  static Color error(ColorPallete palette) => palette.error();
  
  /// Cor de sucesso (verde)
  static Color success(ColorPallete palette) => palette.success();
  
  /// Cor de fundo do container externo (cinza claro)
  static Color containerBackground(ColorPallete palette) => 
      palette.grey().withOpacity(0.1);
  
  /// Cor de fundo do botão de remover (vermelho)
  static Color removeButton(ColorPallete palette) => palette.error();
  
  /// Cor de fundo do botão adicionar (cinza claro)
  static Color addButton(ColorPallete palette) => 
      palette.grey().withOpacity(0.05);
}
