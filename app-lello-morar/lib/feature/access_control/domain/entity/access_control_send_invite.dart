import 'package:morar/feature/access_control/domain/entity/access_control_invite_forward_type.dart';
import 'package:morar/feature/access_control/domain/entity/access_invite_user_type_enum.dart';

class AccessControlSendInviteEntity {
  String? cpf;
  String? name;
  String? phone;
  AccessControlInviteUserType? userType;
  AccessControlInviteForwardType? forwardType;
  String? foreignDocument;
  String? foreignDocumentType;

  AccessControlSendInviteEntity({
    this.cpf,
    this.name,
    this.userType,
    this.forwardType,
    this.phone,
    this.foreignDocument,
    this.foreignDocumentType,
  });
}
