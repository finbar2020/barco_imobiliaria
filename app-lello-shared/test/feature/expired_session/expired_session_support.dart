import 'dart:async';

import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/shared_features.dart' hide isNull, isNotNull;

class FakeLogout extends Fake implements Logout {
  int calls = 0;

  /// Quando definido, a chamada só termina quando o completer completar.
  Completer<Try<Nothing>>? pending;

  @override
  Future<Try<Nothing>> call() async {
    calls++;
    if (pending != null) return pending!.future;
    return Success(Nothing());
  }
}

class FakeClearData extends Fake implements ClearData {
  int calls = 0;

  @override
  Future<Try<Nothing>> call() async {
    calls++;
    return Success(Nothing());
  }
}
