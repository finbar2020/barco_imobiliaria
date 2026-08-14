import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_appointments_entity.dart';

part 'timesheet_appointments_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AppointmentsModel {
  final String numCad;
  final String reference;
  final String photo;
  final DateTime date;
  final double distance;

  AppointmentsModel({
    this.numCad = '',
    this.reference = '',
    this.photo = '',
    required this.date,
    this.distance = 0,
  });

  factory AppointmentsModel.fromJson(Map<String, dynamic> json) =>
      _$AppointmentsModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentsModelToJson(this);

  static AppointmentsModel? fromEntity(AppointmentsEntity? entity) =>
      entity == null
          ? null
          : (AppointmentsModel(
              numCad: entity.numCad,
              reference: entity.reference,
              photo: entity.photo,
              date: entity.date,
              distance: entity.distance,
            ));

  AppointmentsEntity toEntity() => AppointmentsEntity(
        numCad: numCad,
        reference: reference,
        photo: photo,
        date: date,
        distance: distance,
      );
}
