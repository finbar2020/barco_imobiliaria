import 'package:flutter/material.dart';

import '../../dimens.dart';
import 'list_item/list_item.dart';

class ListBuilder {
  static ListView build(List<ListItem> items,
      {bool shrinkWrap = false, ScrollPhysics? physics}) {
    return ListView.builder(
      itemCount: items.length,
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemBuilder: (context, index) {
        final item = items[index];
        return item.shouldWrapContent!
            ? ListTile(
                contentPadding: EdgeInsets.symmetric(
                    horizontal: Dimens.spacingMedium, vertical: 0),
                title: item.buildTitle(context),
                subtitle: item.buildSubtitle(context),
              )
            : item.buildTitle(context);
      },
    );
  }
}
