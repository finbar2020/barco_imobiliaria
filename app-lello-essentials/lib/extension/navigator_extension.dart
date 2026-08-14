import 'package:flutter/material.dart';

Future<T?> pushNamedAndPopUntil<T extends Object>(
    BuildContext context, String newRouteName, RoutePredicate predicate,
    {Object? arguments}) {
  var popped = false;
  return Navigator.pushNamedAndRemoveUntil(context, newRouteName, (route) {
    final val = predicate(route);
    if (val) {
      popped = true;
    }
    return popped || val;
  }, arguments: arguments);
}
