import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_doubt_attachments.dart';

part 'acountability_doubt_attachments_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AttachmentsModel {
  String id;
  String name;
  String? type;
  String? fileName;

  AttachmentsModel(
      {required this.id,
      required this.name,
      required this.type,
      required this.fileName});

  factory AttachmentsModel.fromJson(Map<String, dynamic> json) =>
      _$AttachmentsModelFromJson(json);
  Map<String, dynamic> toJson() => _$AttachmentsModelToJson(this);

  static AttachmentsModel fromEntity(Attachments entity) => (AttachmentsModel(
        id: entity.id,
        name: entity.name,
        type: entity.type,
        fileName: entity.fileName,
      ));

  Attachments toEntity() => Attachments(
        id: this.id,
        name: this.name,
        type: this.type,
        fileName: this.fileName,
      );
}
