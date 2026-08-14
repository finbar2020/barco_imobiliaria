import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class ResinNewBankAccountDialog extends StatelessWidget {
  final String text;
  const ResinNewBankAccountDialog({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return AlertDialog(
      content: SingleChildScrollView(
        child: Text(text,
            textAlign: TextAlign.center,
            style: LelloTextStyles.subtitle(theme)),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text(
            getString(context, "ok"),
            style: TextStyle(
              fontSize: LelloTextStyles.subtitle(theme)?.fontSize ?? 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
