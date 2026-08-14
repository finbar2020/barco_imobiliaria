import 'package:flutter/material.dart';

class SessionDataProvider<T> extends ChangeNotifier {
  T? _value;
  T? get value => _value;

  void update(T value) {
    _value = value;
    notifyListeners();
  }
}
