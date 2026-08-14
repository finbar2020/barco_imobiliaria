import 'package:morar/feature/access_control/data/model/access_control_recurrence_model.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_authorizations.dart';
import 'package:json_annotation/json_annotation.dart';

part 'access_control_authorizations_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AccessControlAuthorizationsModel {
  String? id;
  String? idUnit;
  String? idGest;
  String? idConcierge;
  String? start;
  String? end;
  AccessControlRecurrenceModel? recurrence;
  String? autorizationType;
  bool? useFacialBiometric;

  AccessControlAuthorizationsModel({
    this.id,
    this.idUnit,
    this.idGest,
    this.start,
    this.end,
    this.recurrence,
    this.idConcierge,
    this.autorizationType,
    this.useFacialBiometric,
  });

  factory AccessControlAuthorizationsModel.fromJson(
          Map<String, dynamic> json) =>
      _$AccessControlAuthorizationsModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AccessControlAuthorizationsModelToJson(this);

  static AccessControlAuthorizationsModel? fromEntity(
          AccessControlAuthorizations? entity) =>
      entity == null
          ? null
          : (AccessControlAuthorizationsModel()
            ..id = entity.id
            ..start = entity.start
            ..end = entity.end
            ..autorizationType = entity.autorizationType
            ..useFacialBiometric = entity.useFacialBiometric ?? false
            ..recurrence =
                AccessControlRecurrenceModel.fromEntity(entity.recurrence));

  AccessControlAuthorizations toEntity() => AccessControlAuthorizations()
    ..id = id
    ..start = start
    ..end = end
    ..useFacialBiometric = useFacialBiometric ?? false
    ..autorizationType = autorizationType
    ..recurrence = recurrence != null ? recurrence!.toEntity() : null;

  @override
  String toString() {
    return 'AccessControlAuthorizationsModel(id: $id, idConcierge: $idConcierge, start: $start, end: $end, recurrence: $recurrence)';
  }
}
