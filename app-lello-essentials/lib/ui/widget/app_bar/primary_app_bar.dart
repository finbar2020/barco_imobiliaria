import 'package:essentials/ui/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

AppBar PrimaryAppBar({
  required String title,
  required ThemeData theme,
  List<Widget>? actions,
  bool centerTitle = true,
  Color? iconColor,
  Widget? leading,
  PreferredSizeWidget? tabs,
  Function()? onBackArrowPressed,
}) =>
    AppBar(
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      surfaceTintColor: Colors.transparent,
      backgroundColor: LelloTheme.palleteOf(theme).appBar(),
      centerTitle: centerTitle,
      leading: leading ??
          Builder(
            builder: (context) {
              if (Navigator.canPop(context)) {
                return Container(
                  width: 30,
                  height: 30,
                  margin: const EdgeInsets.only(left: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: iconColor ?? theme.primaryColor,
                    ),
                    onPressed: onBackArrowPressed ??
                        () {
                          Navigator.maybePop(context);
                        },
                  ),
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
      actions: actions,
      bottom: tabs,
      iconTheme: IconThemeData(
        color: iconColor ?? theme.colorScheme.surface,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(8),
          bottomLeft: Radius.circular(8),
        ),
      ),
    );
