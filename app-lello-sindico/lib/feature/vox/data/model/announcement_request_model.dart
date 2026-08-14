import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/vox/data/model/document_attachment_model.dart';
import 'package:lello/feature/vox/data/model/request_content_composer.dart';
import 'package:lello/feature/vox/domain/entity/document_request.dart';
import 'package:lello/feature/vox/domain/entity/document_type.dart';
import 'package:lello/feature/vox/domain/entity/recipient_type.dart';

part 'announcement_request_model.g.dart';

/// Model de fio da solicitação de comunicado (POST /requests/service).
///
/// Fiel byte-a-byte ao contrato antigo (`AnnouncementsRequestModel`): não tem
/// `reason`/`model`/`value`/`occurrence_date`/`user_id`, e `single_copies_quantity`
/// trafega como **String** (não int como advertência/multa) — divergência de
/// fio preservada (item B5 / Q5).
@JsonSerializable(fieldRename: FieldRename.snake)
class AnnouncementRequestModel {
  String? id;
  String serviceId;
  String? condominiumId;
  String? unityId;
  String? content;
  String? block;
  List<String> recipientList;
  bool? flagEmailDistribution;
  bool? flagPrintDistribution;
  @JsonKey(name: 'flag_overrride')
  bool? flagOverride;
  int? recipientType;
  bool? flagEmailBodyAttachment;
  String? singleCopiesQuantity;
  List<DocumentAttachmentModel?> attachments;

  AnnouncementRequestModel({
    this.serviceId = "790829",
    this.recipientList = const [],
    this.attachments = const [],
  });

  factory AnnouncementRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$AnnouncementRequestModelToJson(this);

  static AnnouncementRequestModel fromEntity(DocumentRequest entity) =>
      AnnouncementRequestModel(serviceId: DocumentType.announcement.serviceId)
        ..id = entity.id
        ..condominiumId = entity.condominiumId
        ..unityId = entity.unityId
        ..content = composeRequestContent(entity.content, entity.title)
        ..block = entity.block
        ..recipientList = entity.recipientList
        ..flagEmailDistribution = entity.flagEmailDistribution
        ..flagPrintDistribution = entity.flagPrintDistribution
        ..flagOverride = entity.flagOverride
        ..recipientType = entity.recipientType?.value
        ..flagEmailBodyAttachment = entity.flagEmailBodyAttachment
        ..singleCopiesQuantity = entity.singleCopiesQuantity?.toString()
        ..attachments = entity.attachments
            .map((a) => DocumentAttachmentModel.fromEntity(a))
            .toList();

  DocumentRequest toEntity() => DocumentRequest(
        id: id,
        condominiumId: condominiumId,
        unityId: unityId,
        content: content,
        block: block,
        recipientList: recipientList,
        flagEmailDistribution: flagEmailDistribution,
        flagPrintDistribution: flagPrintDistribution,
        flagOverride: flagOverride,
        recipientType: RecipientType.fromValue(recipientType),
        flagEmailBodyAttachment: flagEmailBodyAttachment,
        singleCopiesQuantity: singleCopiesQuantity == null
            ? null
            : int.tryParse(singleCopiesQuantity!),
        attachments: attachments.map((m) => m!.toEntity()).toList(),
      );
}
