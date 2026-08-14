import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/gdp/timesheet/data/model/timesheet_signature_model.dart';

part 'timesheet_signature_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TimesheetSignatureRequestModel {
  final List<TimesheetSignatureModel> signaturesRequest;

  TimesheetSignatureRequestModel({
    required this.signaturesRequest,
  });

  factory TimesheetSignatureRequestModel.fromJson(Map<String, dynamic> json) =>
      _$TimesheetSignatureRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$TimesheetSignatureRequestModelToJson(this);
}
