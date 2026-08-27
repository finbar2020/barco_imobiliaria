import 'package:essentials/base/api_meta.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ApiMeta guarda os campos', () {
    final meta = ApiMeta(
        currentPage: 1, totalPages: 2, itemCount: 3, itemsPerPage: 4, totalItems: 5);
    expect(meta.currentPage, 1);
    expect(meta.totalPages, 2);
    expect(meta.itemCount, 3);
    expect(meta.itemsPerPage, 4);
    expect(meta.totalItems, 5);
  });
}
