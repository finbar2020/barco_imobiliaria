// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:essentials/essentials.dart';
import 'package:morar/feature/easy_fix/domain/entity/city_entity.dart';

part 'city_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CityModel {
  final int ibgeCode;
  final String name;
  CityModel({
    required this.ibgeCode,
    required this.name,
  });

  factory CityModel.fromEntity(City entity) {
    return CityModel(
      ibgeCode: entity.ibgeCode,
      name: entity.name,
    );
  }

  City toEntity() {
    return City(
      ibgeCode: ibgeCode,
      name: name,
    );
  }

  factory CityModel.fromJson(Map<String, dynamic> json) =>
      _$CityModelFromJson(json);

  Map<String, dynamic> toJson() => _$CityModelToJson(this);
}
