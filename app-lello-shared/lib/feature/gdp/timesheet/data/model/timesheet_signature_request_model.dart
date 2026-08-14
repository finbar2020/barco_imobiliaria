import 'package:json_annotation/json_annotation.dart';
import 'package:shared_features/feature/gdp/timesheet/data/model/timesheet_signature_model.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_signature_request.dart';

part 'timesheet_signature_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TimesheetSignatureRequestModel {
  List<TimesheetSignatureModel>? signaturesRequest;

  TimesheetSignatureRequestModel();

  factory TimesheetSignatureRequestModel.fromJson(Map<String, dynamic> json) =>
      _$TimesheetSignatureRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$TimesheetSignatureRequestModelToJson(this);

  static TimesheetSignatureRequestModel? fromEntity(
          TimesheetSignatureRequest? entity) =>
      entity == null
          ? null
          : (TimesheetSignatureRequestModel()
            ..signaturesRequest = entity.signaturesRequest
                    ?.map((e) => TimesheetSignatureModel.fromEntity(e)!)
                    .toList() ??
                []);

  TimesheetSignatureRequest toEntity() => TimesheetSignatureRequest()
    ..signaturesRequest =
        this.signaturesRequest?.map((e) => e.toEntity()).toList();
}
