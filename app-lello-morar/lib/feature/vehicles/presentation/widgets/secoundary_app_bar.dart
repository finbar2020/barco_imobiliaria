import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class VehicleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onPressed;
  const VehicleAppBar({Key? key, required this.title, required this.onPressed})
      : super(key: key);

  @override
  PreferredSizeWidget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.white,
      leading: Padding(
        padding: const EdgeInsets.only(left: 28.0),
        child: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: theme.primaryColor,
          onPressed: onPressed,
        ),
      ),
      title: Text(
        title,
        style: LelloTextStyles.titleSmall(theme)!.copyWith(
          color: LelloTheme.palleteOf(theme).text(),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60);
}
