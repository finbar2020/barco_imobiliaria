import 'package:essentials/essentials.dart';
import 'package:morar/feature/ia_bella/domain/entity/ia_bella_pdf_entity.dart';
part 'ia_bella_pdf_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class IaBellaPdfModel {
  final String? fileName;
  final String? content;

  IaBellaPdfModel({
    this.fileName,
    this.content,
  });

  factory IaBellaPdfModel.fromJson(Map<String, dynamic> json) =>
      _$IaBellaPdfModelFromJson(json);

  Map<String, dynamic> toJson() => _$IaBellaPdfModelToJson(this);

  static IaBellaPdfModel? fromEntity(IaBellaPdfEntity? entity) => entity == null
      ? null
      : IaBellaPdfModel(
          fileName: entity.fileName,
          content: entity.content,
        );

  IaBellaPdfEntity toEntity() => IaBellaPdfEntity(
        fileName: fileName,
        content: content,
      );
}
