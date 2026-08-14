import 'package:flutter/material.dart';

import '../../../app_localization.dart';
import '../../app_theme.dart';
import '../../dimens.dart';
import '../button/primary_button.dart';
import '../text/lello_text_styles.dart';
import 'error_status_icon.dart';

class GenericErrorBottomSheet extends StatelessWidget {
  final String message;
  final Widget? bottomActions;

  const GenericErrorBottomSheet({
    super.key,
    required this.message,
    this.bottomActions,
  });

  static Future<T?> show<T>(
    BuildContext context, {
    required String message,
    Widget? bottomActions,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => GenericErrorBottomSheet(
        message: message,
        bottomActions: bottomActions,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);
    final insets = MediaQuery.of(context).viewInsets;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          Dimens.spacingMedium,
          Dimens.spacingMedium,
          Dimens.spacingMedium,
          Dimens.spacingMedium + insets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ErrorStatusIcon(
              margin: EdgeInsets.only(bottom: Dimens.spacing),
            ),
            Text(
              message,
              textAlign: TextAlign.center,
              style: LelloTextStyles.subtitleBold(theme)
                  ?.copyWith(color: palette.text()),
            ),
            SizedBox(height: Dimens.spacingMedium),
            bottomActions ?? _buildDefaultAction(context, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultAction(BuildContext context, ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: PrimaryButton(
        theme: theme,
        buttonColor: theme.primaryColor,
        onPressed: () => Navigator.of(context).pop(),
        text: getString(context, 'close'),
      ),
    );
  }
}
