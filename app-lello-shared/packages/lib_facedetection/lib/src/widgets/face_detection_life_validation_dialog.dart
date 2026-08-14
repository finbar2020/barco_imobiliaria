import 'package:essentials/essentials.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class FaceValidationDialog extends StatelessWidget {
  final VoidCallback onTap;
  const FaceValidationDialog({
    super.key,
    required this.onTap,
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
        child: Semantics(
          label:
              getString(context, "face_detected_title_validation_dialog_title"),
          value: getString(
              context, "face_detected_title_validation_dialog_body_text"),
          button: true,
          enabled: true,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: SvgPicture.asset(
                    "assets/ic_billet_alert.svg",
                    semanticsLabel: getString(context, "alert_icon"),
                  ),
                ),
                SizedBox(height: Dimens.spacing),
                Text(
                  getString(
                      context, "face_detected_title_validation_dialog_title"),
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.subtitleBold(theme)?.copyWith(
                      color: LelloTheme.palleteOf(theme).textLight()),
                ),
                SizedBox(height: Dimens.spacing),
                SizedBox(height: Dimens.spacing),
                Text(
                  getString(context,
                      "face_detected_title_validation_dialog_body_text"),
                  style: LelloTextStyles.subtitle(theme)?.copyWith(
                      color: LelloTheme.palleteOf(theme).textLight()),
                ),
                SizedBox(height: Dimens.spacing),
                InkWell(
                  onTap: onTap,
                  child: Container(
                    padding: EdgeInsets.all(Dimens.spacing),
                    child: Text(
                      getString(context, "ok"),
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

  static Future<void> show(BuildContext context, VoidCallback onTap) async {
    // Play system sound and vibration when showing dialog
    await SystemSound.play(SystemSoundType.alert);
    HapticFeedback.mediumImpact();

    // Announce for accessibility after a short delay to ensure dialog is visible
    Future.delayed(const Duration(milliseconds: 500), () {
      SemanticsService.announce(
        getString(context, "face_detected_title_validation_dialog_title"),
        TextDirection.ltr,
      );
    });

    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return FaceValidationDialog(
            onTap: onTap,
          );
        });
  }
}
