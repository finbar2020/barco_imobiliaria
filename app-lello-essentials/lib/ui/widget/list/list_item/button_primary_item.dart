import 'package:flutter/material.dart';

import '../../button/primary_button.dart';
import 'list_item.dart';

class ButtonPrimaryItem implements ListItem {
  final String? text;
  final VoidCallback onPressed;

  ButtonPrimaryItem({this.text, required this.onPressed});

  Widget buildTitle(BuildContext context) => PrimaryButton(
        text: this.text,
        onPressed: this.onPressed,
      );

  Widget? buildSubtitle(BuildContext context) => null;

  @override
  bool? shouldWrapContent = true;
}
