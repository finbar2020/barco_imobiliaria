import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/vox/data/model/document_attachment_model.dart';
import 'package:lello/feature/vox/data/model/request_content_composer.dart';
import 'package:lello/feature/vox/domain/entity/document_request.dart';
import 'package:lello/feature/vox/domain/entity/document_type.dart';
import 'package:lello/feature/vox/domain/entity/recipient_type.dart';

part 'warning_request_model.g.dart';

/// Model de fio da solicitação de advertência (POST /requests/service).
///
/// Fiel byte-a-byte ao contrato antigo (`WarningsRequestModel`). O typo
/// histórico `flag_overrride` é preservado no fio via [JsonKey] (item B5),
/// mesmo com o campo Dart usando o nome limpo `flagOverride`.
@JsonSerializable(fieldRename: FieldRename.snake)
class WarningRequestModel {
  String? id;
  String serviceId;
  String? condominiumId;
  String? unityId;
  String? content;
  String? block;
  String? reason;
  String? model;
  List<String> recipientList;
  bool? flagEmailDistribution;
  DateTime? occurrenceDate;
  bool? flagPrintDistribution;
  @JsonKey(name: 'flag_overrride')
  bool? flagOverride;
  int? recipientType;
  bool? flagEmailBodyAttachment;
  int? singleCopiesQuantity;
  String? userId;
  List<DocumentAttachmentModel?> attachments;

  WarningRequestModel({
    this.serviceId = "790850",
    this.recipientList = const [],
    this.attachments = const [],
  });

  factory WarningRequestModel.fromJson(Map<String, dynamic> json) =>
      _$WarningRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$WarningRequestModelToJson(this);

  static WarningRequestModel fromEntity(DocumentRequest entity) =>
      WarningRequestModel(serviceId: DocumentType.warning.serviceId)
        ..id = entity.id
        ..userId = entity.userId
        ..reason = entity.reason
        ..model = entity.model
        ..condominiumId = entity.condominiumId
        ..unityId = entity.unityId
        ..content = composeRequestContent(entity.content, entity.title)
        ..block = entity.block
        ..recipientList = entity.recipientList
        ..flagEmailDistribution = entity.flagEmailDistribution
        ..occurrenceDate = entity.occurrenceDate
        ..flagPrintDistribution = entity.flagPrintDistribution
        ..flagOverride = entity.flagOverride
        ..recipientType = entity.recipientType?.value
        ..flagEmailBodyAttachment = entity.flagEmailBodyAttachment
        ..singleCopiesQuantity = entity.singleCopiesQuantity
        ..attachments = entity.attachments
            .map((a) => DocumentAttachmentModel.fromEntity(a))
            .toList();

  DocumentRequest toEntity() => DocumentRequest(
        id: id,
        userId: userId,
        reason: reason,
        model: model,
        condominiumId: condominiumId,
        unityId: unityId,
        content: content,
        block: block,
        recipientList: recipientList,
        flagEmailDistribution: flagEmailDistribution,
        occurrenceDate: occurrenceDate,
        flagPrintDistribution: flagPrintDistribution,
        flagOverride: flagOverride,
        recipientType: RecipientType.fromValue(recipientType),
        flagEmailBodyAttachment: flagEmailBodyAttachment,
        singleCopiesQuantity: singleCopiesQuantity,
        attachments:
            attachments.map((m) => m!.toEntity()).toList(),
      );
}
