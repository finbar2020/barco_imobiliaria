import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/access_control/data/model/access_control_model.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_visitant.dart';
import 'package:morar/feature/me/data/model/unity_model.dart';

part 'access_control_visitant_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AccessControlVisitantModel {
  String? idGestUnit;
  int? autorizarionType;
  String? observation;
  AccessControlModel? gest;
  List<UnityModel?> units;

  AccessControlVisitantModel({
    this.idGestUnit,
    this.autorizarionType,
    this.observation,
    this.gest,
    this.units = const [],
  });

  factory AccessControlVisitantModel.fromJson(Map<String, dynamic> json) =>
      _$AccessControlVisitantModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccessControlVisitantModelToJson(this);

  static AccessControlVisitantModel? fromEntity(
          AccessControlVisitant? entity) =>
      entity == null
          ? null
          : (AccessControlVisitantModel()
            ..idGestUnit = entity.idGestUnit
            ..autorizarionType = entity.autorizarionType
            ..observation = entity.observation
            ..gest = AccessControlModel.fromEntity(entity.gest)
            ..units = entity.units
                .map((value) => UnityModel.fromEntity(value))
                .toList());

  AccessControlVisitant toEntity() => AccessControlVisitant()
    ..idGestUnit = idGestUnit
    ..autorizarionType = autorizarionType
    ..observation = observation
    ..gest = gest?.toEntity()
    ..units = this.units.isNotEmpty
        ? this.units.map((model) => model!.toEntity()).toList()
        : [];

  @override
  String toString() {
    return 'AccessControlVisitantModel(idAccessControl: $idGestUnit, autorizarionType: $autorizarionType, observation: $observation, gest: $gest, units: $units)';
  }
}
