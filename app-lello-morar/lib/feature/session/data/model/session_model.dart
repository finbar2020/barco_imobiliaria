import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/me/data/model/condominium_model.dart';
import 'package:morar/feature/me/data/model/me_model.dart';
import 'package:morar/feature/me/data/model/unity_model.dart';
import 'package:morar/feature/session/domain/entity/session.dart';

part 'session_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SessionModel {
  MeModel? me;
  UnityModel? unity;
  CondominiumModel? condominium;

  SessionModel();

  factory SessionModel.fromJson(Map<String, dynamic> json) =>
      _$SessionModelFromJson(json);
  Map<String, dynamic> toJson() => _$SessionModelToJson(this);

  static SessionModel? fromEntity(Session? entity) => entity == null
      ? null
      : (SessionModel()
        ..me = MeModel.fromEntity(entity.me)
        ..unity = UnityModel.fromEntity(entity.unity)
        ..condominium = CondominiumModel.fromEntity(entity.condominium));

  Session toEntity() {
    Session session = Session()..me = this.me?.toEntity();
    session.condominium = this.condominium?.toEntity();
    session.unity = this.unity?.toEntity();
    return session;
  }
}
