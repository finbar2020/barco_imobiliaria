import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class CreateTaskErrorModal extends StatelessWidget {
  final VoidCallback onTryAgain;
  final ThemeData theme;
  final ColorPallete palette;

  const CreateTaskErrorModal({
    super.key,
    required this.onTryAgain,
    required this.theme,
    required this.palette,
  });

  static Future<void> show({
    required BuildContext context,
    required ThemeData theme,
    required ColorPallete palette,
    VoidCallback? onTryAgain,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => CreateTaskErrorModal(
        theme: theme,
        palette: palette,
        onTryAgain: onTryAgain ?? () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      contentPadding: EdgeInsets.all(Dimens.spacingLarge),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Error Icon
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: palette.error(),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.close,
              color: Colors.white,
              size: 32,
            ),
          ),

          SizedBox(height: Dimens.spacingLarge),

          // Title
          Text(
            'Não foi possível criar a tarefa',
            textAlign: TextAlign.center,
            style: LelloTextStyles.title(theme)?.copyWith(
              color: palette.text(),
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: Dimens.spacingMedium),

          // Error message
          Text(
            'Ocorreu um erro durante a criação da tarefa.\nPor favor, revise os dados informados e tente novamente.',
            textAlign: TextAlign.center,
            style: LelloTextStyles.body(theme)?.copyWith(
              color: palette.textLight(),
            ),
          ),

          SizedBox(height: Dimens.spacingLarge),

          // Try again button
          SizedBox(
            width: double.infinity,
            height: 54.0,
            child: PrimaryButton(
              text: 'Tentar novamente',
              onPressed: onTryAgain,
            ),
          ),
        ],
      ),
    );
  }
}
