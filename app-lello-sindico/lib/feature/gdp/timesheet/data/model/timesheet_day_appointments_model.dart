import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/gdp/timesheet/data/model/timesheet_appointments_model.dart';
import 'package:lello/feature/gdp/timesheet/data/model/timesheet_collaborator_model.dart';
import 'package:lello/feature/gdp/timesheet/data/model/timesheet_condo_location_model.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_day_appointments_entity.dart';

part 'timesheet_day_appointments_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class DayAppointmentsModel {
  final CollaboratorModel collaborator;
  final List<AppointmentsModel> appointments;
  final CondoLocationModel condoLocation;
  DayAppointmentsModel({
    required this.collaborator,
    required this.appointments,
    required this.condoLocation,
  });

  factory DayAppointmentsModel.fromJson(Map<String, dynamic> json) =>
      _$DayAppointmentsModelFromJson(json);

  Map<String, dynamic> toJson() => _$DayAppointmentsModelToJson(this);

  static DayAppointmentsModel? fromEntity(DayAppointmentsEntity? entity) =>
      entity == null
          ? null
          : (DayAppointmentsModel(
              collaborator: CollaboratorModel.fromEntity(entity.collaborator)!,
              condoLocation:
                  CondoLocationModel.fromEntity(entity.condoLocation)!,
              appointments: entity.appointments.isEmpty
                  ? []
                  : List.generate(
                      entity.appointments.length,
                      (index) => AppointmentsModel.fromEntity(
                          entity.appointments[index])!),
            ));

  DayAppointmentsEntity toEntity() => DayAppointmentsEntity(
        collaborator: collaborator.toEntity(),
        condoLocation: condoLocation.toEntity(),
        appointments: appointments.isEmpty
            ? []
            : List.generate(
                appointments.length, (index) => appointments[index].toEntity()),
      );
}
