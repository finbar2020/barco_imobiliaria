import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool useGetString;
  final bool autoSizeTitle;
  final VoidCallback? onPressed;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.useGetString = true,
    this.autoSizeTitle = false,
    this.onPressed,
  }) : super(key: key);

  @override
  PreferredSizeWidget build(BuildContext context) {
    final theme = Theme.of(context);
    final pallet = LelloTheme.palleteOf(theme);
    return AppBar(
      backgroundColor: pallet.appBar(),
      surfaceTintColor: Colors.transparent,
      title: autoSizeTitle
          ? AutoSizeText(
              useGetString ? getString(context, title) : title,
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              maxLines: 1,
              minFontSize: 12,
            )
          : Text(
              useGetString ? getString(context, title) : title,
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
      centerTitle: true,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      leading: IconButton(
        onPressed: onPressed ??
            () {
              Navigator.of(context).pop();
            },
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
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
