import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/button/inverted_primary_button.dart';
import 'package:flutter/material.dart';

class TaskInitStepResetConfirmationModal extends StatelessWidget {
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const TaskInitStepResetConfirmationModal({
    super.key,
    this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Container(
        padding: EdgeInsets.all(Dimens.spacingMedium),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Sua etapa não será salva.',
              style: LelloTextStyles.title(theme)
                  ?.copyWith(fontWeight: FontWeight.normal),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Deseja continuar?',
              style: LelloTextStyles.bodyBold(theme)?.copyWith(),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Dimens.spacingSmall),
            PrimaryButton(
                onPressed: onConfirm,
                text: 'Sim, sair da etapa',
                buttonColor: theme.primaryColor),
            SizedBox(height: Dimens.spacingSmall),
            InvertedPrimaryButton(
              onPressed: onCancel ?? () => Navigator.of(context).pop(),
              text: 'Não, voltar para a etapa',
              buttonColor: theme.primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => TaskInitStepResetConfirmationModal(
        onConfirm: () => Navigator.of(context).pop(true),
        onCancel: () => Navigator.of(context).pop(false),
      ),
    );
  }
}
