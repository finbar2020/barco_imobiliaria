import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/resin/domain/entity/resin_person.dart';

part 'resin_person_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ResinPersonModel {
  String id;
  String document;
  String name;
  String role;

  ResinPersonModel({
    this.id = "",
    this.document = "",
    this.name = "",
    this.role = "",
  });

  factory ResinPersonModel.fromJson(Map<String, dynamic> json) =>
      _$ResinPersonModelFromJson(json);
  Map<String, dynamic> toJson() => _$ResinPersonModelToJson(this);

  static ResinPersonModel? fromEntity(ResinPerson? entity) => entity == null
      ? null
      : (ResinPersonModel(
          id: entity.id,
          document: entity.document,
          name: entity.name,
          role: entity.role,
        ));

  ResinPerson? toEntity() => this.isValid
      ? ResinPerson(
          id: this.id,
          document: this.document,
          name: this.name,
          role: this.role,
        )
      : null;

  bool get isValid {
    if (document.isEmpty) {
      return false;
    }
    if (name.isEmpty) {
      return false;
    }
    // if (cargo.isEmpty) {
    //   return false;
    // }
    return true;
  }
}
