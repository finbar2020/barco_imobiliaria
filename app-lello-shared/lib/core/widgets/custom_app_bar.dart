import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? surfaceTintColor;
  const CustomAppBar(
      {Key? key,
      required this.title,
      this.actions,
      this.backgroundColor,
      this.surfaceTintColor})
      : super(key: key);

  @override
  PreferredSizeWidget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      backgroundColor: backgroundColor,
      surfaceTintColor: surfaceTintColor,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: LelloTheme.palleteOf(theme).primary(),
        ),
      ),
      title: Text(
        getString(context, title),
        textAlign: TextAlign.center,
        style: TextStyle(color: LelloTheme.palleteOf(theme).customColor()),
      ),
      centerTitle: true,
      iconTheme: IconThemeData(
        color: LelloTheme.palleteOf(theme).customColor(),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(12),
              bottomLeft: Radius.circular(12))),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60);
}
