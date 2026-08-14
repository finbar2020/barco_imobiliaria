import 'package:flutter/material.dart';

/// Widget reutilizável para exibir caixas de informação com ícone e texto
/// 
/// Usado em telas de criação e edição de tarefas para mostrar mensagens
/// informativas ao usuário sobre o comportamento esperado.
class InfoBoxWidget extends StatelessWidget {
  final String message;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? iconColor;
  final Color? textColor;

  const InfoBoxWidget({
    super.key,
    required this.message,
    this.backgroundColor,
    this.borderColor,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? const Color(0x4D2F80ED); // rgba(47,128,237,0.3)
    final bColor = borderColor ?? const Color(0xFF2F80ED);
    final iColor = iconColor ?? const Color(0xFF2F80ED);
    final tColor = textColor ?? const Color(0xFF212121);

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: bColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: iColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.info_outline,
              size: 12,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontFamily: 'Anek Latin',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: tColor,
                height: 1.33,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
