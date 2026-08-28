import 'package:essentials/paginator/meta.dart';
import 'package:essentials/paginator/paginator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Paginator guarda meta e data e formata toString', () {
    final p = Paginator(meta: Meta(currentPage: 1), data: [1]);
    expect(p.meta!.currentPage, 1);
    expect(p.data, [1]);
    expect(p.toString(), startsWith('Paginator(meta: Meta(currentPage: 1'));
    expect(Paginator().meta, isNull);
  });
}
