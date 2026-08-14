import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_ocurrence_entity.dart';

part 'timesheet_occurrence_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TimesheetOccurrenceModel {
  String? photo;
  String? name;
  String? jobPosition;
  String? numCra;
  String? receivedMark;
  String? hourRange;
  String? referenceDate;
  int occurenceDuration;
  String? occurrenceName;
  bool canTreat;
  String? occurrenceType;
  TimesheetOccurrenceModel({
    this.photo,
    this.name,
    this.jobPosition,
    this.numCra,
    this.receivedMark,
    this.hourRange,
    this.referenceDate,
    this.occurrenceName,
    this.occurrenceType,
    required this.occurenceDuration,
    required this.canTreat,
  });

  factory TimesheetOccurrenceModel.fromJson(Map<String, dynamic> json) =>
      _$TimesheetOccurrenceModelFromJson(json);

  Map<String, dynamic> toJson() => _$TimesheetOccurrenceModelToJson(this);

  static TimesheetOccurrenceModel? fromEntity(
          TimesheetOccurrenceEntity? entity) =>
      entity == null
          ? null
          : TimesheetOccurrenceModel(
              photo: entity.photo,
              name: entity.name,
              jobPosition: entity.jobPosition,
              numCra: entity.numCra,
              receivedMark: entity.receivedMark,
              hourRange: entity.hourRange,
              referenceDate: entity.referenceDate,
              occurenceDuration: entity.occurenceDuration,
              occurrenceName: entity.occurrenceName,
              occurrenceType: entity.occurrenceType,
              canTreat: entity.canTreat);

  TimesheetOccurrenceEntity toEntity() => TimesheetOccurrenceEntity(
      photo: photo ?? "",
      name: name ?? "",
      jobPosition: jobPosition ?? "",
      numCra: numCra ?? "",
      receivedMark: receivedMark ?? "",
      hourRange: hourRange ?? "",
      referenceDate: referenceDate ?? "",
      occurenceDuration: occurenceDuration,
      occurrenceName: occurrenceName ?? "",
      occurrenceType: occurrenceType ?? "",
      canTreat: canTreat);
}
