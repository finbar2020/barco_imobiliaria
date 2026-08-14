import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class LegalObligationReceiveByEmailBottomSheet extends StatefulWidget {
  const LegalObligationReceiveByEmailBottomSheet({super.key});

  static Future<String?> show(BuildContext context) async {
    return await showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const LegalObligationReceiveByEmailBottomSheet(),
    );
  }

  @override
  State<LegalObligationReceiveByEmailBottomSheet> createState() =>
      _LegalObligationReceiveByEmailBottomSheetState();
}

class _LegalObligationReceiveByEmailBottomSheetState
    extends State<LegalObligationReceiveByEmailBottomSheet> {
  final _emailController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _email = ValueNotifier<String>('');

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() => _email.value = _emailController.text);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    _email.dispose();
    super.dispose();
  }

  bool _isValidEmail(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return false;
    // Validação simples e suficiente para habilitar o botão.
    return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(trimmed);
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
          Dimens.spacing,
          Dimens.spacingLarge,
          Dimens.spacing,
          Dimens.spacingLarge + insets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              getString(context, 'legal_obligation_receive_by_email_title'),
              style: LelloTextStyles.subtitleBold(theme)
                  ?.copyWith(color: palette.text()),
            ),
            SizedBox(height: Dimens.spacingSmall),
            Text(
              getString(context, 'legal_obligation_receive_by_email_description'),
              style: LelloTextStyles.body(theme)
                  ?.copyWith(color: palette.textLight()),
            ),
            SizedBox(height: Dimens.spacingLarge),
            Text(
              getString(context, 'legal_obligation_receive_by_email_email_label'),
              style: LelloTextStyles.bodyBold(theme)
                  ?.copyWith(color: palette.textLight()),
            ),
            SizedBox(height: Dimens.spacingXSmall),
            TextField(
              controller: _emailController,
              focusNode: _emailFocusNode,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                hintText:
                    getString(context, 'legal_obligation_receive_by_email_hint'),
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) {
                final value = _emailController.text;
                if (_isValidEmail(value)) {
                  Navigator.of(context).pop(value.trim());
                }
              },
            ),
            SizedBox(height: Dimens.spacingLarge),
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    onPressed: () => Navigator.of(context).pop(),
                    text: getString(context, 'legal_obligation_cancel'),
                  ),
                ),
                SizedBox(width: Dimens.spacing),
                Expanded(
                  child: ValueListenableBuilder<String>(
                    valueListenable: _email,
                    builder: (_, value, __) {
                      final enabled = _isValidEmail(value);
                      return PrimaryButton(
                        theme: theme,
                        buttonColor: palette.primary(),
                        onPressed: enabled
                            ? () => Navigator.of(context).pop(value.trim())
                            : null,
                        text: getString(context, 'legal_obligation_confirm'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

