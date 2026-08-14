import 'package:json_annotation/json_annotation.dart';

part 'upload_legal_obligation_response_model.g.dart';

@JsonSerializable()
class UploadLegalObligationResponseModel {
  final String? link;
  final bool success;
  @JsonKey(name: 'error_code')
  final String? errorCode;

  UploadLegalObligationResponseModel({
    this.link,
    required this.success,
    this.errorCode,
  });

  factory UploadLegalObligationResponseModel.fromJson(Map<String, dynamic> json) =>
      _$UploadLegalObligationResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$UploadLegalObligationResponseModelToJson(this);
}
