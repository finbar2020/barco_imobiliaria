import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_signature_entity.dart';

part 'timesheet_signature_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TimesheetSignatureModel {
  final int? id;
  final bool? approvedFlag;
  final String? numCra;
  final bool? notify;

  TimesheetSignatureModel({
    this.id,
    this.approvedFlag,
    this.numCra,
    this.notify,
  });

  factory TimesheetSignatureModel.fromJson(Map<String, dynamic> json) =>
      _$TimesheetSignatureModelFromJson(json);

  Map<String, dynamic> toJson() => _$TimesheetSignatureModelToJson(this);

  static TimesheetSignatureModel? fromEntity(
          TimesheetSignatureEntity? entity) =>
      entity == null
          ? null
          : (TimesheetSignatureModel(
              id: entity.id,
              numCra: entity.numCra,
              approvedFlag: entity.approvedFlag,
              notify: entity.notify,
            ));

  TimesheetSignatureEntity toEntity() => TimesheetSignatureEntity(
        id: id,
        numCra: numCra,
        approvedFlag: approvedFlag,
        notify: notify,
      );
}
