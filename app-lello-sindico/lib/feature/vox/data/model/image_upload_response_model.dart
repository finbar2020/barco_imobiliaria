import 'package:json_annotation/json_annotation.dart';

part 'image_upload_response_model.g.dart';

/// Resposta do upload de imagem (POST /documents/image/upload): a URL pública
/// da imagem, usada para inserir uma tag `<img>` no conteúdo HTML.
@JsonSerializable(fieldRename: FieldRename.snake)
class ImageUploadResponseModel {
  final String url;

  ImageUploadResponseModel({required this.url});

  factory ImageUploadResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ImageUploadResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ImageUploadResponseModelToJson(this);
}
