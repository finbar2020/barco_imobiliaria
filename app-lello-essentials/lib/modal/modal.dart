import 'package:flutter/material.dart';

class Modal {
  static Future<T?> showBottomSheet<T>(
      {required BuildContext context,
      required WidgetBuilder builder,
      bool isScrollControlled = false,
      Color? backgroundColor,
      bool isDismissible = true,
      bool showDragHandle = false,
      double radius = 8.0}) async {
    return await showModalBottomSheet<T>(
        context: context,
        isScrollControlled: isScrollControlled,
        builder: builder,
        backgroundColor: backgroundColor,
        isDismissible: isDismissible,
        showDragHandle: showDragHandle,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(radius),
                topRight: Radius.circular(radius))));
  }
}
