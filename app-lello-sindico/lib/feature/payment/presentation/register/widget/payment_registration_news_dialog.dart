import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentRegistrationNewsDialog extends StatefulWidget {
  final Function onContinuePressedEvent;
  final Function onBackPressedEvent;
  const PaymentRegistrationNewsDialog(
      {super.key,
      required this.onContinuePressedEvent,
      required this.onBackPressedEvent});

  @override
  _PaymentRegistrationNewsDialogState createState() {
    return _PaymentRegistrationNewsDialogState();
  }
}

class _PaymentRegistrationNewsDialogState
    extends State<PaymentRegistrationNewsDialog> {
  bool _dontShowAgain = false;

  @override
  void initState() {
    super.initState();
    _checkIfShouldShowDialog();
  }

  Future<void> _checkIfShouldShowDialog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool dontShowAgain = prefs.getBool('dontShowAgain') ?? false;
    String? firstSeenDateStr = prefs.getString('firstSeenDate');
    if (dontShowAgain) {
      if (mounted) {
        Navigator.pop(context);
      }
      return;
    }
    if (firstSeenDateStr != null) {
      DateTime firstSeenDate = DateTime.parse(firstSeenDateStr);
      if (DateTime.now().difference(firstSeenDate).inDays >= 7) {
        if (mounted) {
          Navigator.pop(context);
        }
        return;
      }
    } else {
      await prefs.setString('firstSeenDate', DateTime.now().toIso8601String());
    }
  }

  Future<void> _savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_dontShowAgain) {
      await prefs.setBool('dontShowAgain', true);
    } else {
      await prefs.setString('firstSeenDate', DateTime.now().toIso8601String());
    }
  }

  void _onContinuePressed() async {
    widget.onContinuePressedEvent();
    await _savePreferences();
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _onBackPressed() {
    widget.onBackPressedEvent();
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        "${getString(context, "payments_news_dialog_title")}\n",
                    style: LelloTextStyles.subtitle(theme)?.copyWith(
                      color: theme.primaryColor,
                    ),
                  ),
                  TextSpan(
                    text:
                        "${getString(context, "payments_news_dialog_description")}\n",
                    style: LelloTextStyles.subtitleBold(theme),
                  ),
                  TextSpan(
                    text: getString(context, "payments_simplified_notice"),
                    style: LelloTextStyles.body(theme),
                  ),
                ],
              ),
            ),
            SizedBox(height: Dimens.spacingMedium),
            Column(
              children: [
                _buildIconTextRow(
                  context,
                  iconPath: "assets/ic_payment_autofill.svg",
                  highlightedText: getString(context, "payments_autofill"),
                  text: getString(context, "payments_autofill_description"),
                ),
                SizedBox(height: Dimens.spacingLarge),
                _buildIconTextRow(
                  context,
                  iconPath: "assets/ic_smart_account_entry.svg",
                  highlightedText: getString(context, "payments_account_entry"),
                  text:
                      getString(context, "payments_account_entry_description"),
                ),
                SizedBox(height: Dimens.spacingLarge),
                _buildIconTextRow(
                  context,
                  iconPath: "assets/ic_early_payment.svg",
                  highlightedText: getString(context, "payments_early_payment"),
                  text:
                      getString(context, "payments_early_payment_description"),
                ),
              ],
            ),
            SizedBox(height: Dimens.spacingLarge),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: _dontShowAgain,
                  onChanged: (value) {
                    setState(() {
                      _dontShowAgain = value!;
                    });
                  },
                ),
                Text(getString(context, "payments_dialog_dont_show_again")),
              ],
            ),
            SizedBox(height: Dimens.spacingSmall),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PrimaryButton(
                      onPressed: _onContinuePressed,
                      text: getString(context, "continue")),
                  SizedBox(height: Dimens.spacingSmall),
                  TertiaryButton(
                      onPressed: _onBackPressed,
                      style: TextStyle(color: theme.primaryColor),
                      text: getString(context, "back")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconTextRow(BuildContext context,
      {required String iconPath,
      required String highlightedText,
      required String text}) {
    ThemeData theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          iconPath,
          color: theme.primaryColor,
          height: 24.0,
          width: 24.0,
        ),
        SizedBox(width: Dimens.spacingSmall),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: highlightedText,
                  style: LelloTextStyles.bodyBold(theme)?.copyWith(
                    color: theme.primaryColor,
                  ),
                ),
                const WidgetSpan(
                  child: SizedBox(width: 4.0),
                ),
                TextSpan(
                  text: text,
                  style: LelloTextStyles.body(theme),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
