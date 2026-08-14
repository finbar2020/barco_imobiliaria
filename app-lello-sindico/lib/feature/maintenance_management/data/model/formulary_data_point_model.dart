import 'package:json_annotation/json_annotation.dart';

part 'formulary_data_point_model.g.dart';

@JsonSerializable()
class FormularyDataPointModel {
  final String key;
  @JsonKey(fromJson: _valueFromJson)
  final int value;

  const FormularyDataPointModel({
    required this.key,
    required this.value,
  });

  static int _valueFromJson(dynamic value) {
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    if (value is int) {
      return value;
    }
    return 0;
  }

  factory FormularyDataPointModel.fromJson(Map<String, dynamic> json) =>
      _$FormularyDataPointModelFromJson(json);

  Map<String, dynamic> toJson() => _$FormularyDataPointModelToJson(this);
}
