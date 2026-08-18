import 'package:lello/feature/access_management/domain/entity/access_management_invite_forward_type.dart';

abstract class UnitDetailEvent {}

class UnitDetailLoadEvent extends UnitDetailEvent {
  final String condominiumId;
  final String unitId;
  UnitDetailLoadEvent(this.condominiumId, this.unitId);
}

class UnitDetailSendInviteEvent extends UnitDetailEvent {
  final String cpf;
  final String name;
  final String phone;
  final String email;
  final AccessManagementInviteForwardType type;

  UnitDetailSendInviteEvent({
    required this.type,
    required this.cpf,
    required this.phone,
    required this.name,
    required this.email,
  });
}
