import 'package:essentials/base/api_meta.dart';
import 'package:essentials/base/api_meta_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final json = {
    'current_page': 1,
    'total_pages': 2,
    'item_count': 3,
    'items_per_page': 4,
    'total_items': 5,
  };

  test('fromJson/toJson em snake_case', () {
    final model = ApiMetaModel.fromJson(json);
    expect(model.currentPage, 1);
    expect(model.itemsPerPage, 4);
    expect(model.toJson(), json);
  });

  test('toEntity substitui nulos por zero', () {
    final entity = ApiMetaModel.fromJson({}).toEntity();
    expect(entity.currentPage, 0);
    expect(entity.totalPages, 0);
    expect(entity.itemCount, 0);
    expect(entity.itemsPerPage, 0);
    expect(entity.totalItems, 0);
  });

  test('fromEntity e toEntity fazem round trip', () {
    final entity = ApiMeta(
        currentPage: 1, totalPages: 2, itemCount: 3, itemsPerPage: 4, totalItems: 5);
    final model = ApiMetaModel.fromEntity(entity);
    expect(model.toJson(), json);
    final volta = model.toEntity();
    expect(volta.totalItems, 5);
    expect(volta.itemsPerPage, 4);
  });
}
