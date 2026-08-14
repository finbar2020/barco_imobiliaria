import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_collaborator_entity.dart';

part 'timesheet_collaborator_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CollaboratorModel {
  final String name;
  final String numCra;
  final String numCad;
  final String reference;
  final String photo;
  final String date;
  final String jobPosition;
  final String shift;
  CollaboratorModel({
    this.name = '',
    this.numCra = '',
    this.numCad = '',
    this.reference = '',
    this.photo = '',
    this.date = '',
    this.jobPosition = '',
    this.shift = '',
  });

  factory CollaboratorModel.fromJson(Map<String, dynamic> json) =>
      _$CollaboratorModelFromJson(json);

  Map<String, dynamic> toJson() => _$CollaboratorModelToJson(this);

  static CollaboratorModel? fromEntity(CollaboratorEntity? entity) =>
      entity == null
          ? null
          : (CollaboratorModel(
              name: entity.name,
              numCra: entity.numCra,
              numCad: entity.numCad,
              reference: entity.reference,
              photo: entity.photo,
              date: entity.date,
              jobPosition: entity.jobPosition,
              shift: entity.shift,
            ));

  CollaboratorEntity toEntity() => CollaboratorEntity(
        name: name,
        numCra: numCra,
        numCad: numCad,
        reference: reference,
        photo: photo,
        date: date,
        jobPosition: jobPosition,
        shift: shift,
      );
}
