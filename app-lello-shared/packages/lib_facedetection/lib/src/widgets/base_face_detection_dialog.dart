import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class BaseFaceDetectionDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onTap;
  final String buttonText;
  final String? iconAsset;

  const BaseFaceDetectionDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onTap,
    this.buttonText = "OK",
    this.iconAsset = "assets/ic_billet_alert.svg",
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      child: WillPopScope(
        onWillPop: () async {
          onTap();
          return true;
        },
        child: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 300),
          tween: Tween(begin: 0.8, end: 1.0),
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: child,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (iconAsset != null)
                  Center(
                    child: SvgPicture.asset(iconAsset!),
                  ),
                SizedBox(height: Dimens.spacing),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.subtitleBold(theme)?.copyWith(
                    color: LelloTheme.palleteOf(theme).textLight(),
                  ),
                ),
                SizedBox(height: Dimens.spacing),
                SizedBox(height: Dimens.spacing),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.subtitle(theme)?.copyWith(
                    color: LelloTheme.palleteOf(theme).textLight(),
                  ),
                ),
                SizedBox(height: Dimens.spacing),
                InkWell(
                  onTap: onTap,
                  child: Container(
                    padding: EdgeInsets.all(Dimens.spacing),
                    child: Text(
                      buttonText,
                      style: LelloTextStyles.subBody(theme)?.copyWith(
                        color: LelloTheme.palleteOf(theme).primary(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onTap,
    String? buttonText,
    String? iconAsset,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return BaseFaceDetectionDialog(
          title: title,
          message: message,
          onTap: onTap,
          buttonText: buttonText ?? "OK",
          iconAsset: iconAsset,
        );
      },
    );
  }
}
