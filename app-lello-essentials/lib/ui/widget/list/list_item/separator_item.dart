import 'package:flutter/material.dart';

import 'list_item.dart';

class SeparatorItem implements ListItem {
  final double height;

  SeparatorItem({this.height = 1.0});

  Widget buildTitle(BuildContext context) => Divider(height: height);
  Widget? buildSubtitle(BuildContext context) => null;

  @override
  bool? shouldWrapContent = false;
}
