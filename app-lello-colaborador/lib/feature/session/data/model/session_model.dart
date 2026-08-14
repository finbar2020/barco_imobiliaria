import 'package:colaborador/feature/me/data/model/condominium_model.dart';
import 'package:colaborador/feature/me/data/model/me_model.dart';
import 'package:colaborador/feature/session/domain/entity/session.dart';
import 'package:json_annotation/json_annotation.dart';

part 'session_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SessionModel {
  MeModel? meModel;
  CondominiumModel? condominiumModel;

  SessionModel({
    this.meModel,
    this.condominiumModel,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) =>
      _$SessionModelFromJson(json);
  Map<String, dynamic> toJson() => _$SessionModelToJson(this);

  static SessionModel? fromEntity(Session? entity) => entity == null
      ? null
      : SessionModel(
          meModel: MeModel.fromEntity(entity.me),
          condominiumModel: CondominiumModel.fromEntity(entity.condominium),
        );

  Session? toEntity() => isValid
      ? Session(
          me: meModel!.toEntity(),
          condominium: condominiumModel!.toEntity(),
        )
      : null;

  bool get isValid {
    if (meModel == null) {
      return false;
    }
    if (condominiumModel == null) {
      return false;
    }
    return true;
  }
}
