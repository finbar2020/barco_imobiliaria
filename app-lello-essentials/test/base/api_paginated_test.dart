import 'package:essentials/base/api_meta.dart';
import 'package:essentials/base/api_paginated.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ApiPaginated guarda meta e data tipados', () {
    final meta = ApiMeta(
        currentPage: 1, totalPages: 1, itemCount: 1, itemsPerPage: 1, totalItems: 1);
    final p = ApiPaginated<List<String>>(meta: meta, data: ['a']);
    expect(p.meta, meta);
    expect(p.data, ['a']);
  });
}
