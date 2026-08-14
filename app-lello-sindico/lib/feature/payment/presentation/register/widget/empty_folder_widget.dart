import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class EmptyFolderWidget extends StatelessWidget {
  final double height;
  final double width;
  final ThemeData theme;

  const EmptyFolderWidget({
    Key? key,
    required this.height,
    required this.width,
    required this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: height * 0.08),
      height: height,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/ic_empty_folder.svg',
            width: 300,
            height: 120,
          ),
          Text(
            getString(context, "register_payment_empty_carousel_text"),
            style: theme.textTheme.titleLarge!.copyWith(
              color: theme.disabledColor,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
