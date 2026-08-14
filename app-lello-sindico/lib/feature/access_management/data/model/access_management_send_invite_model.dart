import 'package:essentials/essentials.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/access_management/domain/entity/access_management_invite_forward_type.dart';
import 'package:lello/feature/access_management/domain/entity/access_management_invite_user_type_enum.dart';
import 'package:lello/feature/access_management/domain/entity/access_management_send_invite.dart';

part 'access_management_send_invite_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AccessManagementSendInviteModel {
  String? cpf;
  String? name;
  String? phone;
  String? email;
  String? userType;
  String? forwardType;

  AccessManagementSendInviteModel();

  factory AccessManagementSendInviteModel.fromJson(Map<String, dynamic> json) =>
      _$AccessManagementSendInviteModelFromJson(json);
  Map<String, dynamic> toJson() =>
      _$AccessManagementSendInviteModelToJson(this);

  static AccessManagementSendInviteModel? fromEntity(
          AccessManagementSendInviteEntity? entity) =>
      entity == null
          ? null
          : (AccessManagementSendInviteModel()
            ..cpf = entity.cpf
            ..name = entity.name
            ..phone = entity.phone
            ..email = entity.email
            ..userType = enumToString(entity.userType)
            ..forwardType = enumToString(entity.forwardType));

  AccessManagementSendInviteEntity toEntity() =>
      AccessManagementSendInviteEntity()
        ..cpf = this.cpf
        ..name = this.name
        ..phone = this.phone
        ..email = this.email
        ..userType =
            stringToEnum(AccessManagementInviteUserType.values, this.userType)
        ..forwardType = stringToEnum(
            AccessManagementInviteForwardType.values, this.forwardType);
}
