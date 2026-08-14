import 'package:essentials/essentials.dart';
import 'package:lello/feature/access_management/domain/entity/access_management_invite_forward_type.dart';

abstract class UnitDetailEvent extends Equatable {
  const UnitDetailEvent();

  @override
  List<Object?> get props => [];
}

class UnitDetailLoadEvent extends UnitDetailEvent {
  final String condominiumId;
  final String unitId;

  const UnitDetailLoadEvent(this.condominiumId, this.unitId);

  @override
  List<Object?> get props => [condominiumId, unitId];
}

class UnitDetailSendInviteEvent extends UnitDetailEvent {
  final String cpf;
  final String name;
  final String phone;
  final String email;
  final AccessManagementInviteForwardType type;

  const UnitDetailSendInviteEvent({
    required this.type,
    required this.cpf,
    required this.phone,
    required this.name,
    required this.email,
  });

  @override
  List<Object?> get props => [cpf, name, phone, email, type];
}
