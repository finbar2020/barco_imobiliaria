import 'package:colaborador/feature/employee_referral/domain/entity/city.dart';
import 'package:json_annotation/json_annotation.dart';

part 'city_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CityModel {
  String name;
  List<String> regions;

  CityModel({
    required this.name,
    required this.regions,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) =>
      _$CityModelFromJson(json);
  Map<String, dynamic> toJson() => _$CityModelToJson(this);

  static CityModel fromEntity(CityEntity entity) => CityModel(
        name: entity.name,
        regions: entity.regions,
      );

  CityEntity toEntity() => CityEntity(
        name: name,
        regions: regions,
      );
}
