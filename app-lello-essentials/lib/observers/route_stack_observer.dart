import 'dart:developer';

import 'package:flutter/material.dart';

class RouteStackObserver extends NavigatorObserver {
  final List<String> routeStack = [];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    try {
      if (route.settings.name != null) {
        // Adding the route to the stack when a new route is pushed.
        log('RouteStack before push : $routeStack');
        routeStack.add(route.settings.name!);
        log('RouteStack after push : $routeStack');
      } else {
        log('RouteStack noName push : $routeStack');
        routeStack.add("RouteWithoutName");
      }
      log('RouteStack after push : $routeStack');
    } catch (e) {
      log('RouteStack push error : $e');
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    try {
      if (previousRoute != null && previousRoute.settings.name != null) {
        // Removing the last route from the stack when a route is popped.
        log('RouteStack before popped: $routeStack');
      } else {
        log('RouteStack noName popped : $routeStack');
      }
      routeStack.removeLast();
      log('RouteStack after popped: $routeStack');
    } catch (e) {
      log('RouteStack pop error : $e');
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    try {
      if (route.settings.name != null) {
        // Removing a specific route from the stack when it is removed.
        log('RouteStack before removed: $routeStack');
        routeStack.remove(route.settings.name);
        log('RouteStack after removed: $routeStack');
      } else {
        log('RouteStack before removed: $routeStack');
        routeStack.removeLast();
        log('RouteStack noName removed : $routeStack');
      }
    } catch (e) {
      log('RouteStack remove error : $e');
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    try {
      if (newRoute != null && newRoute.settings.name != null) {
        // Replacing the last route in the stack with the new route.
        log('RouteStack before replaced: $routeStack');
        if (routeStack.isNotEmpty) {
          routeStack.removeLast();
        }
        routeStack.add(newRoute.settings.name!);
        log('RouteStack after replaced: $routeStack');
      } else {
        log('RouteStack before replaced: $routeStack');
        if (routeStack.isNotEmpty) {
          routeStack.removeLast();
        }
        routeStack.add("RouteWithoutName");
        log('RouteStack noName replaced : $routeStack');
      }
    } catch (e) {
      log('RouteStack replace error : $e');
    }
  }
}
