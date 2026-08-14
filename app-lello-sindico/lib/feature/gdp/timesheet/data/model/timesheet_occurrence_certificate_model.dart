import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_occurrence_certificate_entity.dart';

part 'timesheet_occurrence_certificate_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TimesheetOccurrenceCertificateModel {
  String name;
  String numCra;
  String initDate;
  String endDate;
  String reference;
  String archiveHash;

  TimesheetOccurrenceCertificateModel({
    this.numCra = "",
    this.name = '',
    this.initDate = '',
    this.endDate = '',
    this.reference = '',
    this.archiveHash = '',
  });

  factory TimesheetOccurrenceCertificateModel.fromJson(
          Map<String, dynamic> json) =>
      _$TimesheetOccurrenceCertificateModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$TimesheetOccurrenceCertificateModelToJson(this);

  static TimesheetOccurrenceCertificateModel? fromEntity(
          TimesheetOccurrenceCertificateEntity? entity) =>
      entity == null
          ? null
          : (TimesheetOccurrenceCertificateModel()
            ..numCra = entity.numCra
            ..name = entity.name
            ..initDate = entity.initDate
            ..endDate = entity.endDate
            ..reference = entity.reference
            ..archiveHash = entity.archiveHash);

  TimesheetOccurrenceCertificateEntity toEntity() =>
      TimesheetOccurrenceCertificateEntity(
          numCra: numCra,
          name: name,
          initDate: initDate,
          endDate: endDate,
          reference: reference,
          archiveHash: archiveHash);
}
