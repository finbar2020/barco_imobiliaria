import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/change_ownership/domain/entity/aws_payload_entity.dart';

part 'aws_payload_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AwsPayloadModel {
  String? fileName;
  String? bucket;
  String? httpMethod;
  String? url;

  AwsPayloadModel({
    this.fileName,
    this.bucket,
    this.httpMethod,
    this.url,
  });

  factory AwsPayloadModel.fromJson(Map<String, dynamic> json) =>
      _$AwsPayloadModelFromJson(json);
  Map<String, dynamic> toJson() => _$AwsPayloadModelToJson(this);

  static AwsPayloadModel fromEntity(AwsPayloadEntity entity) =>
      (AwsPayloadModel()
        ..fileName = entity.fileName
        ..bucket = entity.bucket
        ..httpMethod = entity.httpMethod
        ..url = entity.url);

  AwsPayloadEntity toEntity() => AwsPayloadEntity()
    ..fileName = this.fileName
    ..bucket = this.bucket
    ..httpMethod = this.httpMethod
    ..url = this.url;
}
