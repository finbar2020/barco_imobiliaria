import 'package:flutter/material.dart';

import '../../text/lello_text_styles.dart';
import 'list_item.dart';

class SubtitleItem implements ListItem {
  final String text;

  SubtitleItem({required this.text});

  Widget buildTitle(BuildContext context) =>
      Text(text, style: LelloTextStyles.subtitleBold(Theme.of(context)));

  Widget? buildSubtitle(BuildContext context) => null;

  @override
  bool? shouldWrapContent = true;
}
