import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/space/registration/domain/entity/space_registration_request.dart';

part 'space_registration_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SpaceRegistrationRequestModel {
  String? id;
  String? space;
  DateTime? date;

  SpaceRegistrationRequestModel();

  factory SpaceRegistrationRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SpaceRegistrationRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$SpaceRegistrationRequestModelToJson(this);

  static SpaceRegistrationRequestModel? fromEntity(
          SpaceRegistrationRequest? entity) =>
      entity == null
          ? null
          : (SpaceRegistrationRequestModel()
            ..id = entity.id
            ..space = entity.space
            ..date = entity.date);

  SpaceRegistrationRequest toEntity() => SpaceRegistrationRequest()
    ..id = this.id
    ..space = this.space
    ..date = this.date;
}
