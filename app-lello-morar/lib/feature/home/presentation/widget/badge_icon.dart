import 'package:flutter/material.dart';

class BadgeIcon extends StatelessWidget {
  final String text;
  const BadgeIcon({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: 2.0),
      child: Text(
        text,
        style: TextStyle(
          color: theme.primaryColor,
          fontSize: 14.0,
          fontWeight: FontWeight.normal,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
