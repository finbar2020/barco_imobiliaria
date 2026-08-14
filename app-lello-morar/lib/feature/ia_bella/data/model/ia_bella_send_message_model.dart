import 'package:essentials/essentials.dart';
import 'package:morar/feature/ia_bella/domain/entity/ia_bella_send_message_entity.dart';

part 'ia_bella_send_message_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class IaBellaSendMessageModel {
  final String? question;
  final String? uuidSession;

  IaBellaSendMessageModel({
    this.question,
    this.uuidSession,
  });

  factory IaBellaSendMessageModel.fromJson(Map<String, dynamic> json) =>
      _$IaBellaSendMessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$IaBellaSendMessageModelToJson(this);

  static IaBellaSendMessageModel? fromEntity(
          IaBellaSendMessageEntity? entity) =>
      entity == null
          ? null
          : IaBellaSendMessageModel(
              question: entity.message,
              uuidSession: entity.sessionId,
            );

  IaBellaSendMessageEntity toEntity() => IaBellaSendMessageEntity(
        message: question,
        sessionId: uuidSession,
      );
}
