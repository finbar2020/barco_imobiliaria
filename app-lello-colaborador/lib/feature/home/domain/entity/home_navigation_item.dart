import 'package:flutter/material.dart';

enum HomeNavigationItemEnum {
  home,
  myDocuments,
  benefits,
  digitalPoint,
}

class HomeNavigationItem {
  final HomeNavigationItemEnum item;
  final Widget child;
  final bool activated;

  HomeNavigationItem({
    required this.item,
    required this.child,
    this.activated = true,
  });

  String get titleKey {
    switch (item) {
      case HomeNavigationItemEnum.home:
        return "home_navigation_home";
      case HomeNavigationItemEnum.myDocuments:
        return "home_navigation_my_documents";
      case HomeNavigationItemEnum.benefits:
        return "home_navigation_advantages";
      case HomeNavigationItemEnum.digitalPoint:
        return "home_navigation_digital_point";
    }
  }

  String get icon {
    switch (item) {
      case HomeNavigationItemEnum.home:
        return "assets/ic_home_navigation_home.svg";
      case HomeNavigationItemEnum.myDocuments:
        return "assets/ic_home_navigation_my_documents.svg";
      case HomeNavigationItemEnum.benefits:
        return "assets/ic_home_navigation_advantages.svg";
      case HomeNavigationItemEnum.digitalPoint:
        return "assets/ic_home_navigation_digital_point.svg";
    }
  }
}
