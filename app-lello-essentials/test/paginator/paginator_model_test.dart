import 'package:essentials/paginator/meta.dart';
import 'package:essentials/paginator/meta_model.dart';
import 'package:essentials/paginator/paginator.dart';
import 'package:essentials/paginator/paginator_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('fromJson com meta e data', () {
    final model = PaginatorModel.fromJson({
      'meta': {'currentPage': 2},
      'data': ['a'],
    });
    expect(model.meta!.currentPage, 2);
    expect(model.data, ['a']);
    final json = model.toJson();
    expect(json['data'], ['a']);
    expect((json['meta'] as MetaModel).currentPage, 2);
  });

  test('fromJson sem meta', () {
    final model = PaginatorModel.fromJson({'data': null});
    expect(model.meta, isNull);
    expect(model.toJson()['meta'], isNull);
  });

  test('fromEntity/toEntity', () {
    expect(PaginatorModel.fromEntity(null), isNull);
    final model = PaginatorModel.fromEntity(
        Paginator(meta: Meta(totalItems: 9), data: 'x'))!;
    expect(model.meta!.totalItems, 9);
    expect(model.data, 'x');
    final entity = model.toEntity();
    expect(entity.meta!.totalItems, 9);
    expect(entity.data, 'x');
    expect(PaginatorModel().toEntity().meta, isNull);
  });
}
