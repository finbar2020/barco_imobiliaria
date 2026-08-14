import 'package:flutter/foundation.dart';

String? enumToString<T>(T e) => e != null ? describeEnum(e) : null;

T? stringToEnum<T>(Iterable<T> values, String? value) => values
    .cast<T?>()
    .firstWhere((element) => describeEnum(element as Object) == value,
        orElse: () => null);
