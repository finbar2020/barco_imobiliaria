import 'package:json_annotation/json_annotation.dart';
import 'package:shared_features/shared_features.dart';

part 'url_upload_s3_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UrlUploadS3Model {
  String fileName;
  String url;

  UrlUploadS3Model({
    required this.fileName,
    required this.url,
  });

  factory UrlUploadS3Model.fromJson(Map<String, dynamic> json) =>
      _$UrlUploadS3ModelFromJson(json);

  Map<String, dynamic> toJson() => _$UrlUploadS3ModelToJson(this);

  static UrlUploadS3Model fromEntity(UrlUploadS3 entity) => UrlUploadS3Model(
        fileName: entity.fileName,
        url: entity.url,
      );

  UrlUploadS3 toEntity() => UrlUploadS3(
        fileName: fileName,
        url: url,
      );
}
