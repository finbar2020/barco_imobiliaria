import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class PreferencesCheckBox extends StatefulWidget {
  final VoidCallback onTap;
  final bool checked;
  const PreferencesCheckBox(
      {Key? key, required this.onTap, required this.checked})
      : super(key: key);

  @override
  State<PreferencesCheckBox> createState() => _PreferencesCheckBoxState();
}

class _PreferencesCheckBoxState extends State<PreferencesCheckBox> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        height: 20.0,
        width: 20.0,
        decoration: BoxDecoration(
            color: widget.checked ? theme.primaryColor : Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(3.0)),
            border: Border.all(
                color: widget.checked
                    ? theme.primaryColor
                    : LelloTheme.palleteOf(theme).hubText())),
        child: Icon(
          Icons.check,
          color: Colors.white,
          size: 15.0,
        ),
      ),
    );
  }
}
