import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_subcategories.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_type.dart';

part 'comfort_subcategories_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ComfortSubcategoriesModel {
  String? comfortType;

  ComfortSubcategoriesModel({this.comfortType});

  factory ComfortSubcategoriesModel.fromJson(Map<String, dynamic> json) =>
      _$ComfortSubcategoriesModelFromJson(json);

  Map<String, dynamic> toJson() => _$ComfortSubcategoriesModelToJson(this);

  static ComfortSubcategoriesModel? fromEntity(ComfortSubcategories? entity) =>
      entity == null
          ? null
          : ComfortSubcategoriesModel(
              comfortType: enumToString(entity.comfortType),
            );

  ComfortSubcategories toEntity() => ComfortSubcategories(
      comfortType:
          stringToEnum(ComfortType.values, comfortType) ?? ComfortType.others);
}
