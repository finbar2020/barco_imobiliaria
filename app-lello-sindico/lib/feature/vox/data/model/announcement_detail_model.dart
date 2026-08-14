import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/vox/domain/entity/document_detail.dart';

part 'announcement_detail_model.g.dart';

/// Model de detalhe de comunicado (GET /announcements/{id}). Fiel ao `fromJson`
/// antigo (`AnnouncementsDetailModel`). É o único detalhe que traz
/// `recipient_list` (string) e `occurrence_date`.
@JsonSerializable(fieldRename: FieldRename.snake)
class AnnouncementDetailModel {
  String? id;
  String? name;
  String? description;
  DateTime? occurrenceDate;
  String? content;
  DateTime? createdAt;
  bool? flagEmailDistribution;
  bool? flagPrintDistribution;
  int? pagesQuantity;
  String? status;
  String? recipientList;

  AnnouncementDetailModel();

  factory AnnouncementDetailModel.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementDetailModelFromJson(json);
  Map<String, dynamic> toJson() => _$AnnouncementDetailModelToJson(this);

  DocumentDetail toDetail() => DocumentDetail()
    ..id = id
    ..name = name
    ..description = description
    ..occurrenceDate = occurrenceDate
    ..content = content
    ..createdAt = createdAt?.toIso8601String()
    ..flagEmailDistribution = flagEmailDistribution
    ..flagPrintDistribution = flagPrintDistribution
    ..pagesQuantity = pagesQuantity
    ..status = status
    ..recipientList = recipientList;
}
