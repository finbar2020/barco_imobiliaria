import 'package:essentials/extension/list_extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('lastOrNull devolve o último elemento', () {
    expect([1, 2, 3].lastOrNull(), 3);
  });

  test('lastOrNull devolve nulo para lista vazia', () {
    expect(<int>[].lastOrNull(), isNull);
  });
}
