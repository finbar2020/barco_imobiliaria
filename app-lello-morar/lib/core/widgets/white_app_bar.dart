import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class WhiteAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onPressed;
  final bool isGetString;

  const WhiteAppBar({
    Key? key,
    required this.title,
    this.onPressed,
    this.isGetString = false,
  }) : super(key: key);

  @override
  PreferredSizeWidget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      leading: onPressed != null
          ? Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                color: theme.primaryColor,
                onPressed: onPressed,
              ),
            )
          : Container(),
      title: Text(
        isGetString ? getString(context, title) : title,
        style: LelloTextStyles.titleSmall(theme)!
            .copyWith(color: LelloTheme.palleteOf(theme).hubText()),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60);
}
