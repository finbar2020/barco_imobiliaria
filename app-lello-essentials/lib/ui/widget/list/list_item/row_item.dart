import 'package:flutter/material.dart';

import 'list_item.dart';

class RowItem implements ListItem {
  final List<Widget> children;

  RowItem({required this.children});

  Widget buildTitle(BuildContext context) => Row(children: this.children);

  Widget? buildSubtitle(BuildContext context) => null;

  @override
  bool? shouldWrapContent = false;
}
