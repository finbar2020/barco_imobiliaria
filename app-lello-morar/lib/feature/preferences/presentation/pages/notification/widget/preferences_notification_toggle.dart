import 'package:essentials/essentials.dart' hide Switch;
import 'package:flutter/material.dart';

class PreferencesNotificationToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String title;
  final TextStyle? style;

  const PreferencesNotificationToggle({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.title,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeColor: theme.primaryColor,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: style ?? LelloTextStyles.body(theme),
          ),
        ),
      ],
    );
  }
}
