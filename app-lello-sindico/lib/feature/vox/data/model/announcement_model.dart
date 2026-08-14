import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/vox/domain/entity/document.dart';

part 'announcement_model.g.dart';

/// Model de leitura de comunicado (lista GET /announcements/condominium/{id}).
/// Fiel ao `fromJson` antigo (`AnnouncementsModel`). O detalhe usa
/// [AnnouncementDetailModel].
@JsonSerializable(fieldRename: FieldRename.snake)
class AnnouncementModel {
  String? id;
  String? name;
  String? description;
  String? content;
  DateTime? createdAt;
  bool? flagEmailDistribution;
  bool? flagPrintDistribution;
  int? pagesQuantity;
  String? status;

  AnnouncementModel();

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementModelFromJson(json);
  Map<String, dynamic> toJson() => _$AnnouncementModelToJson(this);

  Document toDocument() => Document()
    ..id = id
    ..name = name
    ..description = description
    ..content = content
    ..createdAt = createdAt?.toIso8601String()
    ..flagEmailDistribution = flagEmailDistribution
    ..flagPrintDistribution = flagPrintDistribution
    ..pagesQuantity = pagesQuantity
    ..status = status;
}
