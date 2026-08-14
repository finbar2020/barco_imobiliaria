import 'package:essentials/essentials.dart';
import 'package:lello/feature/access_management/domain/entity/access_management_invite_forward_type.dart';
import 'package:lello/feature/access_management/domain/entity/access_management_invite_user_type_enum.dart';
import 'package:lello/feature/access_management/domain/entity/access_management_send_invite.dart';
import 'package:lello/feature/access_management/domain/usecase/send_invite/send_invite.dart';
import 'package:lello/feature/resident/domain/entity/resident.dart';
import 'package:lello/feature/unit/domain/use_case/list_unit_resident/list_unit_resident.dart';
import 'package:lello/feature/unit/presentation/bloc/detail/unit_detail_event.dart';
import 'package:lello/feature/unit/presentation/bloc/detail/unit_detail_state.dart';

class UnitDetailBloc extends Bloc<UnitDetailEvent, UnitDetailState> {
  final ListUnitResident listUnitResident;
  final SendInviteUsecase sendInvite;
  List<Resident> residents = [];

  UnitDetailBloc({
    required this.listUnitResident,
    required this.sendInvite,
  }) : super(const UnitDetailLoadingState()) {
    on<UnitDetailLoadEvent>(_mapLoad);
    on<UnitDetailSendInviteEvent>(_mapSendInvite);
  }

  Future<void> _mapLoad(
    UnitDetailLoadEvent event,
    Emitter<UnitDetailState> emit,
  ) async {
    emit(const UnitDetailLoadingState());

    final param = ListUnitResidentParam(
        condominiumId: event.condominiumId, unitId: event.unitId);
    final result = await listUnitResident.call(param);

    emit(result.fold((err) => UnitDetailLoadFailedState(err), (items) {
      residents = items;
      return UnitDetailLoadedState(items);
    }));
  }

  Future<void> _mapSendInvite(
    UnitDetailSendInviteEvent event,
    Emitter<UnitDetailState> emit,
  ) async {
    emit(const UnitDetailLoadingState());

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

    emit(result.fold(
        (err) => UnitDetailSendInviteFailedState(residents, err),
        (link) => event.type == AccessManagementInviteForwardType.sms
            ? UnitDetailSendInviteSmsSuccessState(residents, link)
            : UnitDetailSendInviteLinkSuccessState(residents, link)));
  }

  void beginLoad(String condominiumId, String unitId) {
    add(UnitDetailLoadEvent(condominiumId, unitId));
  }
}
