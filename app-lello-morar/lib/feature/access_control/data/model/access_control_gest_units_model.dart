import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/access_control/data/model/access_control_authorizations_model.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_gest_units.dart';
import 'package:morar/feature/me/data/model/unity_model.dart';

part 'access_control_gest_units_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AccessControlGestUnitsModel {
  String? idGestUnit;
  UnityModel? unit;
  String? relation;
  String? autorizationType;
  String? observation;
  List<AccessControlAuthorizationsModel?> authorizations;

  AccessControlGestUnitsModel({this.authorizations = const []});

  factory AccessControlGestUnitsModel.fromJson(Map<String, dynamic> json) =>
      _$AccessControlGestUnitsModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccessControlGestUnitsModelToJson(this);

  static AccessControlGestUnitsModel? fromEntity(
          AccessControlGestUnits? entity) =>
      entity == null
          ? null
          : (AccessControlGestUnitsModel()
            ..idGestUnit = entity.idGestUnit
            ..unit = UnityModel.fromEntity(entity.unit)
            ..relation = entity.relation
            ..autorizationType = entity.autorizationType
            ..observation = entity.observation
            ..authorizations = entity.authorizations
                .map((value) =>
                    AccessControlAuthorizationsModel.fromEntity(value))
                .toList());

  AccessControlGestUnits toEntity() => AccessControlGestUnits(
        idGestUnit: idGestUnit,
        unit: unit?.toEntity(),
        relation: relation,
        autorizationType: autorizationType,
        observation: observation,
        authorizations: this.authorizations.isNotEmpty
            ? this.authorizations.map((model) => model!.toEntity()).toList()
            : [],
      );
}
