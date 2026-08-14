import 'package:colaborador/feature/preferences/presentation/widget/preferences_checkbox.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class PreferencesNotificationCheckBox extends StatefulWidget {
  final VoidCallback onTap;
  final bool checked;
  final String title;
  final TextStyle? style;
  const PreferencesNotificationCheckBox(
      {Key? key,
      required this.onTap,
      required this.checked,
      required this.title,
      this.style})
      : super(key: key);

  @override
  State<PreferencesNotificationCheckBox> createState() =>
      _PreferencesNotificationCheckBoxState();
}

class _PreferencesNotificationCheckBoxState
    extends State<PreferencesNotificationCheckBox> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        PreferencesCheckBox(onTap: widget.onTap, checked: widget.checked),
        SizedBox(width: Dimens.spacing),
        Text(
          widget.title,
          style: widget.style ?? LelloTextStyles.body(theme),
        )
      ],
    );
  }
}
