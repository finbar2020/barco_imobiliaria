import 'package:essentials/paginator/meta.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Meta guarda os campos e formata toString', () {
    final meta = Meta(
        currentPage: 1, totalPages: 2, itemCount: 3, itemPerPage: 4, totalItems: 5);
    expect(meta.currentPage, 1);
    expect(meta.totalPages, 2);
    expect(meta.itemCount, 3);
    expect(meta.itemPerPage, 4);
    expect(meta.totalItems, 5);
    expect(meta.toString(),
        'Meta(currentPage: 1, totalPages: 2, itemCount: 3, itemPerPage: 4, totalItems: 5)');
  });

  test('Meta sem parâmetros tem campos nulos', () {
    expect(Meta().currentPage, isNull);
  });
}
