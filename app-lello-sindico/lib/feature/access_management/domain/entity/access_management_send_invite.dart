import 'package:lello/feature/access_management/domain/entity/access_management_invite_forward_type.dart';
import 'package:lello/feature/access_management/domain/entity/access_management_invite_user_type_enum.dart';

class AccessManagementSendInviteEntity {
  String? cpf;
  String? name;
  String? phone;
  String? email;
  AccessManagementInviteUserType? userType;
  AccessManagementInviteForwardType? forwardType;

  AccessManagementSendInviteEntity({
    this.cpf,
    this.name,
    this.userType,
    this.forwardType,
    this.phone,
    this.email,
  });
}
