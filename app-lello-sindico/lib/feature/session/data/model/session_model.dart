import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/session/domain/entity/session.dart';

part 'session_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SessionModel {
  String? selectedCondominium;

  SessionModel();

  factory SessionModel.fromJson(Map<String, dynamic> json) =>
      _$SessionModelFromJson(json);
  Map<String, dynamic> toJson() => _$SessionModelToJson(this);

  static SessionModel? fromEntity(Session? entity) => entity == null
      ? null
      : (SessionModel()
        ..selectedCondominium = entity.selectedCondominium?.reference);

  Session toEntity() => Session();
}
