import 'package:flutter/material.dart';

class HomeItem {
  final Widget icon;
  final Widget activeIcon;
  final String title;
  final Widget child;

  HomeItem({
    required this.icon,
    required this.activeIcon,
    required this.title,
    required this.child,
  });
}
