import 'package:essentials/base/api_paginated_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ApiPaginatedModel pode ser instanciado com tipo genérico', () {
    expect(ApiPaginatedModel<int>(), isA<ApiPaginatedModel<int>>());
  });
}
