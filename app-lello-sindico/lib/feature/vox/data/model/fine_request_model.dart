import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/vox/data/model/document_attachment_model.dart';
import 'package:lello/feature/vox/data/model/request_content_composer.dart';
import 'package:lello/feature/vox/domain/entity/document_request.dart';
import 'package:lello/feature/vox/domain/entity/document_type.dart';
import 'package:lello/feature/vox/domain/entity/recipient_type.dart';

part 'fine_request_model.g.dart';

/// Model de fio da solicitação de multa (POST /requests/service).
///
/// Fiel byte-a-byte ao contrato antigo (`FinesRequestModel`): tem `value`,
/// não tem `reason`/`model` no fio, e o typo `flag_overrride` é preservado
/// via [JsonKey] (item B5).
@JsonSerializable(fieldRename: FieldRename.snake)
class FineRequestModel {
  String? id;
  String? userId;
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
  int? singleCopiesQuantity;
  List<DocumentAttachmentModel?> attachments;
  String? value;
  DateTime? occurrenceDate;

  FineRequestModel({
    this.serviceId = "790851",
    this.recipientList = const [],
    this.attachments = const [],
  });

  factory FineRequestModel.fromJson(Map<String, dynamic> json) =>
      _$FineRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$FineRequestModelToJson(this);

  static FineRequestModel fromEntity(DocumentRequest entity) =>
      FineRequestModel(serviceId: DocumentType.fine.serviceId)
        ..id = entity.id
        ..userId = entity.userId
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
        ..singleCopiesQuantity = entity.singleCopiesQuantity
        ..attachments = entity.attachments
            .map((a) => DocumentAttachmentModel.fromEntity(a))
            .toList()
        ..value = entity.value
        ..occurrenceDate = entity.occurrenceDate;

  DocumentRequest toEntity() => DocumentRequest(
        id: id,
        userId: userId,
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
        singleCopiesQuantity: singleCopiesQuantity,
        attachments: attachments.map((m) => m!.toEntity()).toList(),
        value: value,
        occurrenceDate: occurrenceDate,
      );
}
