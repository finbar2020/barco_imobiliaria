import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/vox/domain/entity/document_template.dart';

part 'document_template_model.g.dart';

/// Model único de template (unifica `WarningTemplateModel`, `FinesTemplateModel`
/// e `AnnouncementsTemplateModel`). Corrige a dívida A2: o `toEntity()` agora
/// devolve `DocumentTemplate` (o antigo de comunicado devolvia `FinesTemplate`).
@JsonSerializable(fieldRename: FieldRename.snake)
class DocumentTemplateModel {
  String? id;
  String? name;
  String? description;
  String? group;
  String? thumbnail;

  DocumentTemplateModel();

  factory DocumentTemplateModel.fromJson(Map<String, dynamic> json) =>
      _$DocumentTemplateModelFromJson(json);
  Map<String, dynamic> toJson() => _$DocumentTemplateModelToJson(this);

  DocumentTemplate toEntity() => DocumentTemplate()
    ..id = id
    ..name = name
    ..description = description
    ..group = group
    ..thumbnail = thumbnail;
}
