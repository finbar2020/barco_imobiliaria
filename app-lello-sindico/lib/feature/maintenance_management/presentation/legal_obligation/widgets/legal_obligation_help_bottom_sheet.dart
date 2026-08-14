import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

import '../../../domain/entity/legal_obligation_status.dart';
import 'legal_obligation_status_tag.dart';

class LegalObligationHelpBottomSheet extends StatelessWidget {
  const LegalObligationHelpBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const LegalObligationHelpBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);
    final mediaQuery = MediaQuery.of(context);
    final maxHeightWithoutAppBar =
        mediaQuery.size.height - mediaQuery.padding.top - kToolbarHeight;
    final desiredHeight = mediaQuery.size.height * 0.88;
    final sheetHeight =
        desiredHeight.clamp(0.0, maxHeightWithoutAppBar).toDouble();

    return SizedBox(
      height: sheetHeight,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            Dimens.spacing,
            Dimens.spacing,
            Dimens.spacing,
            Dimens.spacing,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getString(context, 'legal_obligation_help_why_title'),
                        style: LelloTextStyles.subtitleBold(theme)?.copyWith(
                          color: palette.text(),
                        ),
                      ),
                      SizedBox(height: Dimens.spacingSmall),
                      Text(
                        getString(
                            context, 'legal_obligation_help_why_description'),
                        style: LelloTextStyles.body(theme)?.copyWith(
                          color: palette.textLight(),
                        ),
                      ),
                      SizedBox(height: Dimens.spacing),
                      Text(
                        getString(context, 'legal_obligation_help_how_title'),
                        style: LelloTextStyles.subtitleBold(theme)?.copyWith(
                          color: palette.text(),
                        ),
                      ),
                      SizedBox(height: Dimens.spacingXSmall),
                      for (final status in LegalObligationStatus.values)
                        _buildHelpStatusItem(
                          context: context,
                          theme: theme,
                          status: status,
                        ),
                      SizedBox(height: Dimens.spacingSmall),
                      Text(
                        getString(context,
                            'legal_obligation_help_actions_disclaimer'),
                        style: LelloTextStyles.bodyBold(theme)?.copyWith(
                          color: palette.text(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: Dimens.spacing),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 320),
                  child: SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      theme: theme,
                      buttonColor: palette.primary(),
                      onPressed: () => Navigator.of(context).pop(),
                      text: getString(
                          context, 'legal_obligation_help_understood_button'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpStatusItem({
    required BuildContext context,
    required ThemeData theme,
    required LegalObligationStatus status,
  }) {
    final palette = LelloTheme.palleteOf(theme);

    return Padding(
      padding: EdgeInsets.only(bottom: Dimens.spacingXSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LegalObligationStatusTag(
            status: status,
            theme: theme,
            label: getString(context, status.statusLabelKey),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              Dimens.spacingSmall,
              0,
              Dimens.spacingSmall,
              Dimens.spacingXSmall,
            ),
            child: _buildStatusDescription(
              context: context,
              theme: theme,
              status: status,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusDescription({
    required BuildContext context,
    required ThemeData theme,
    required LegalObligationStatus status,
  }) {
    final palette = LelloTheme.palleteOf(theme);
    final baseStyle =
        LelloTextStyles.body(theme)?.copyWith(color: palette.text()) ??
            TextStyle(color: palette.text());
    final content = getString(context, status.helpDescriptionKey);
    final separatorIndex = content.indexOf(':');

    if (separatorIndex <= 0 || separatorIndex == content.length - 1) {
      return Text(content, style: baseStyle);
    }

    final title = content.substring(0, separatorIndex + 1);
    final description = content.substring(separatorIndex + 1).trimLeft();

    return RichText(
      text: TextSpan(
        style: baseStyle,
        children: [
          TextSpan(
            text: '$title ',
            style: baseStyle.copyWith(fontWeight: FontWeight.w700),
          ),
          TextSpan(text: description),
        ],
      ),
    );
  }
}
