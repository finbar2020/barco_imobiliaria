import 'package:flutter/material.dart';

class HubBadge extends StatelessWidget {
  final String text;
  HubBadge({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ),
      decoration: BoxDecoration(
          color: theme.primaryColor, borderRadius: BorderRadius.circular(3)),
    );
  }
}
