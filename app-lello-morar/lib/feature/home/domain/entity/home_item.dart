import 'package:flutter/material.dart';

class HomeItem {
  final Widget icon;
  final String title;
  final String? route;
  final Widget child;
  final Widget activeIcon;

  HomeItem(
      {required this.icon,
      required this.activeIcon,
      required this.title,
      required this.child,
      this.route});
}
