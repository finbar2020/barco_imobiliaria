import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/vox/data/model/document_content_codec.dart';
import 'package:lello/feature/vox/domain/entity/document_request.dart';

part 'announcement_create_model.g.dart';

/// Model de fio da criação direta de comunicado
/// (POST /announcements/{id}/templates). Envia `content` (Base64);
/// `flag_overrride` (typo) via [JsonKey]; `single_copies_quantity` como String.
///
/// `content_html` NÃO é enviado: o backend novo (novovox) tenta decodificar o
/// valor como Base64 e o HTML cru quebra ("not a valid Base-64 string"). O
/// conteúdo já vai em `content` (Base64).
@JsonSerializable(fieldRename: FieldRename.snake)
class AnnouncementCreateModel {
  String? templateId;
  String? modelId;
  String? title;
  String? content;
  @JsonKey(includeIfNull: false)
  String? contentHtml;
  bool? flagEmailDistribution;
  bool? flagPrintDistribution;
  @JsonKey(name: 'flag_overrride')
  bool? flagOverride;
  int? recipientType;
  List<String> recipientList;
  bool? flagEmailBodyAttachment;
  String? singleCopiesQuantity;

  AnnouncementCreateModel({this.recipientList = const []});

  factory AnnouncementCreateModel.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementCreateModelFromJson(json);
  Map<String, dynamic> toJson() => _$AnnouncementCreateModelToJson(this);

  static AnnouncementCreateModel fromEntity(DocumentRequest entity) =>
      AnnouncementCreateModel()
        ..templateId = entity.model
        ..title = entity.title
        ..content = encodeHtmlToBase64(entity.content)
        ..flagEmailDistribution = entity.flagEmailDistribution
        ..flagPrintDistribution = entity.flagPrintDistribution
        ..flagOverride = entity.flagOverride
        ..recipientType = entity.recipientType?.value
        ..recipientList = entity.recipientList
        ..flagEmailBodyAttachment = entity.flagEmailBodyAttachment
        ..singleCopiesQuantity = entity.singleCopiesQuantity?.toString();
}
