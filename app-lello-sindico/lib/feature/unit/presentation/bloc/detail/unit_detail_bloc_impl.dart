import 'package:lello/feature/access_management/domain/entity/access_management_invite_forward_type.dart';
import 'package:lello/feature/access_management/domain/entity/access_management_invite_user_type_enum.dart';
import 'package:lello/feature/access_management/domain/entity/access_management_send_invite.dart';
import 'package:lello/feature/access_management/domain/usecase/send_invite/send_invite.dart';
import 'package:lello/feature/resident/domain/entity/resident.dart';
import 'package:lello/feature/unit/domain/use_case/list_unit_resident/list_unit_resident.dart';
import 'package:lello/feature/unit/presentation/bloc/detail/unit_detail_bloc.dart';
import 'package:lello/feature/unit/presentation/bloc/detail/unit_detail_event.dart';
import 'package:lello/feature/unit/presentation/bloc/detail/unit_detail_state.dart';

class UnitDetailBlocImpl extends UnitDetailBloc {
  final ListUnitResident listUnitResident;
  final SendInviteUsecase sendInvite;
  List<Resident> residents = [];

  UnitDetailBlocImpl({
    required this.listUnitResident,
    required this.sendInvite,
  }) : super(UnitDetailLoadingState());

  @override
  Stream<UnitDetailState> mapEventToState(UnitDetailEvent event) async* {
    if (event is UnitDetailLoadEvent) yield* _mapLoad(event);
    if (event is UnitDetailSendInviteEvent) yield* _mapSendInvite(event);
  }

  Stream<UnitDetailState> _mapLoad(UnitDetailLoadEvent event) async* {
    yield UnitDetailLoadingState();

    final param = ListUnitResidentParam(
        condominiumId: event.condominiumId, unitId: event.unitId);
    final result = await listUnitResident.call(param);

    yield result.fold((err) => UnitDetailLoadFailedState(err), (items) {
      residents = items;
      return UnitDetailLoadedState(items);
    });
  }

  Stream<UnitDetailState> _mapSendInvite(
      UnitDetailSendInviteEvent event) async* {
    yield UnitDetailLoadingState();

    final param = SendInviteParam(
        entity: AccessManagementSendInviteEntity(
      cpf: event.cpf.replaceAll(".", "").replaceAll("-", ""),
      name: event.name,
      phone: event.phone,
      email: event.email,
      userType: AccessManagementInviteUserType.resident,
      forwardType: event.type,
    ));
    final result = await sendInvite.call(param);

    yield result.fold(
        (err) => UnitDetailSendInviteFailedState(residents, err),
        (link) => event.type == AccessManagementInviteForwardType.sms
            ? UnitDetailSendInviteSmsSuccessState(residents, link)
            : UnitDetailSendInviteLinkSuccessState(residents, link));
  }

  @override
  void beginLoad(String condominiumId, String unitId) {
    add(UnitDetailLoadEvent(condominiumId, unitId));
  }
}
