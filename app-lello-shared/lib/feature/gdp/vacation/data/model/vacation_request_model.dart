import 'package:json_annotation/json_annotation.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_request.dart';

part 'vacation_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class VacationRequestModel {
  int? period;
  int? numberOfDays;

  VacationRequestModel();

  factory VacationRequestModel.fromJson(Map<String, dynamic> json) =>
      _$VacationRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$VacationRequestModelToJson(this);

  static VacationRequestModel? fromEntity(VacationRequest? entity) =>
      entity == null
          ? null
          : (VacationRequestModel()
            ..period = entity.period
            ..numberOfDays = entity.numberOfDays);

  VacationRequest toEntity() => VacationRequest()
    ..period = this.period
    ..numberOfDays = this.numberOfDays;
}
