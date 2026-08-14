import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  const CustomAppBar({Key? key, required this.title, this.actions})
      : super(key: key);

  @override
  PreferredSizeWidget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: LelloTheme.palleteOf(theme).primary(),
        ),
      ),
      title: Text(getString(context, title),
          textAlign: TextAlign.center,
          style: TextStyle(color: LelloTheme.palleteOf(theme).customColor())),
      centerTitle: true,
      iconTheme: IconThemeData(
        color: LelloTheme.palleteOf(theme).customColor(),
      ),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(12),
              bottomLeft: Radius.circular(12))),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
