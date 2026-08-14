import 'package:flutter/material.dart';

import '../../text/lello_text_styles.dart';
import 'list_item.dart';

class FormDisplayItem implements ListItem {
  final String title;
  final String text;

  FormDisplayItem({required this.title, required this.text});

  Widget buildTitle(BuildContext context) =>
      Text(title, style: LelloTextStyles.bodyBold(Theme.of(context)));

  Widget buildSubtitle(BuildContext context) =>
      Text(text, style: LelloTextStyles.body(Theme.of(context)));

  @override
  bool? shouldWrapContent = true;
}
