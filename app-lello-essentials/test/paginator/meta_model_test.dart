import 'package:essentials/paginator/meta.dart';
import 'package:essentials/paginator/meta_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final json = {
    'currentPage': 1,
    'totalPages': 2,
    'itemCount': 3,
    'itemPerPage': 4,
    'totalItems': 5,
  };

  test('fromJson/toJson fazem round trip', () {
    final model = MetaModel.fromJson(json);
    expect(model.currentPage, 1);
    expect(model.totalItems, 5);
    expect(model.toJson(), json);
  });

  test('fromJson aceita campos nulos', () {
    final model = MetaModel.fromJson({});
    expect(model.currentPage, isNull);
    expect(model.toJson()['currentPage'], isNull);
  });

  test('fromEntity e toEntity', () {
    expect(MetaModel.fromEntity(null), isNull);
    final entity = Meta(
        currentPage: 1, totalPages: 2, itemCount: 3, itemPerPage: 4, totalItems: 5);
    final model = MetaModel.fromEntity(entity)!;
    expect(model.toJson(), json);
    final volta = model.toEntity();
    expect(volta.currentPage, 1);
    expect(volta.totalPages, 2);
    expect(volta.itemCount, 3);
    expect(volta.itemPerPage, 4);
    expect(volta.totalItems, 5);
  });

  test('toString', () {
    expect(MetaModel.fromJson(json).toString(),
        'MetaModel(currentPage: 1, totalPages: 2, itemCount: 3, itemPerPage: 4, totalItems: 5)');
  });
}
