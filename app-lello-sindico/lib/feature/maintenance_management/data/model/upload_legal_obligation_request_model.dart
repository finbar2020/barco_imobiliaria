import 'package:json_annotation/json_annotation.dart';

part 'upload_legal_obligation_request_model.g.dart';

@JsonSerializable()
class UploadLegalObligationRequestModel {
  @JsonKey(name: 'type')
  final String type;
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'fileName')
  final String fileName;
  @JsonKey(name: 'fileUrl')
  final String fileUrl;
  @JsonKey(name: 'date')
  final String date;

  UploadLegalObligationRequestModel({
    required this.type,
    required this.id,
    required this.fileName,
    required this.fileUrl,
    required this.date,
  });

  factory UploadLegalObligationRequestModel.fromJson(Map<String, dynamic> json) =>
      _$UploadLegalObligationRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$UploadLegalObligationRequestModelToJson(this);
}
