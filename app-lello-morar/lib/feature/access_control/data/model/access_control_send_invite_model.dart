import 'package:essentials/essentials.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_invite_forward_type.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_send_invite.dart';
import 'package:morar/feature/access_control/domain/entity/access_invite_user_type_enum.dart';

part 'access_control_send_invite_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AccessControlSendInviteModel {
  String? cpf;
  String? name;
  String? phone;
  String? userType;
  String? forwardType;
  String? foreignDocument;
  String? foreignDocumentType;

  AccessControlSendInviteModel();

  factory AccessControlSendInviteModel.fromJson(Map<String, dynamic> json) =>
      _$AccessControlSendInviteModelFromJson(json);
  Map<String, dynamic> toJson() => _$AccessControlSendInviteModelToJson(this);

  static AccessControlSendInviteModel? fromEntity(
          AccessControlSendInviteEntity? entity) =>
      entity == null
          ? null
          : (AccessControlSendInviteModel()
            ..cpf = entity.cpf
            ..foreignDocument = entity.foreignDocument
            ..foreignDocumentType = entity.foreignDocumentType
            ..name = entity.name
            ..phone = entity.phone
            ..userType = enumToString(entity.userType)
            ..forwardType = enumToString(entity.forwardType));

  AccessControlSendInviteEntity toEntity() => AccessControlSendInviteEntity()
    ..cpf = this.cpf
    ..foreignDocument = this.foreignDocument
    ..foreignDocumentType = this.foreignDocumentType
    ..name = this.name
    ..phone = this.phone
    ..userType = stringToEnum(AccessControlInviteUserType.values, this.userType)
    ..forwardType =
        stringToEnum(AccessControlInviteForwardType.values, this.forwardType);
}
