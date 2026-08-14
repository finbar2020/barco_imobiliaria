import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

import '../../../domain/entity/legal_obligation_status.dart';

class LegalObligationStatusTag extends StatelessWidget {
  final LegalObligationStatus status;
  final ThemeData theme;
  final String? label;

  const LegalObligationStatusTag({
    super.key,
    required this.status,
    required this.theme,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final color = status.color(theme);

    final bool outlined = status.isOutlined;
    final Color backgroundColor = outlined ? Colors.white : color;
    final Color borderColor = outlined ? color : Colors.transparent;
    final Color textColor = outlined ? color : Colors.white;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Text(
          label ?? status.label,
          style: LelloTextStyles.caption(theme)?.copyWith(
            color: textColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
