import 'package:flutter/material.dart';
import 'package:essentials/essentials.dart';

class BellaNotResolvedDialog extends StatelessWidget {
  final VoidCallback onRetry;
  final VoidCallback onClose;

  const BellaNotResolvedDialog({
    super.key,
    required this.onRetry,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Container(
        padding: EdgeInsets.all(Dimens.spacingMedium),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              child: SvgPicture.asset(
                "assets/ic_success_green.svg",
              ),
            ),
            SizedBox(height: Dimens.spacingMedium),
            Text(
              "Sua avaliação foi enviada!",
              style: theme.textTheme.titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Dimens.spacingMedium),
            Text(
              "Obrigada por avaliar. Como sou uma IA em treinamento, você pode tentar me perguntar novamente de uma outra forma.",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: Dimens.spacingMedium),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PrimaryButton(
                  onPressed: onRetry,
                  text: "Tentar novamente",
                  buttonColor: LelloTheme.palleteOf(theme).primary(),
                ),
                SizedBox(height: Dimens.spacingSmall),
                InvertedPrimaryButton(
                  onPressed: onClose,
                  text: "Encerrar",
                  buttonColor: LelloTheme.palleteOf(theme).secondary(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
