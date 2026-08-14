import 'package:morar/feature/access_control/domain/entity/access_control_send_invite.dart';
import 'package:morar/feature/sub_user/domain/entity/sub_user.dart';
import 'package:morar/feature/sub_user/presentation/bloc/sub_users_bloc.dart';
import 'package:morar/feature/sub_user/presentation/stores/sub_user_store.dart';

import '../../../session/domain/entity/session.dart';
import '../../../session/presentation/bloc/session_bloc.dart';
import '../../domain/entity/sub_user_role.dart';
import '../../domain/use_cases/update_access_request_status/update_access_request_use_case.dart';

class SubUserController {
  final SubUserStore _store;

  SubUserController({required SubUserStore store}) : _store = store;

  SubUser? creationUser;

  late SubUser userSelected;

  List<SubUserRole> descriptions = [];
  List<SubUser> subUsers = [];

  bool verifyChanges = false;

  Future<void> getSubUsers() async => subUsers = await _store.getSubUsers();

  Future<void> getRoles({required SubUser user}) async =>
      descriptions = await _store.getRoles(subUser: user);

  Future<void> getFacialBiometric() async => await _store.getFacialBiometric();

  Future<void> subUserSendInvite({
    required AccessControlSendInviteEntity entity,
  }) =>
      _store.subUserSendInvite(
        isEdit: false,
        body: entity,
      );

  Future<void> checkService() => _store.checkService();

  Future<void> inviteResident({required SubUser subUser}) =>
      _store.inviteResident(creationUser: subUser);

  String getFormattedName({required String name}) =>
      _store.getFormattedName(fullName: name);

  set mainUser(SubUser user) => _store.mainUser = user;

  SubUsersBloc get bloc => _store.bloc;

  bool get useFacialBiometric =>
      _store.sessionBloc.state.session!.condominium!.useFacialBiometric;

  Session get session => _store.sessionBloc.state.session!;

  SessionBloc get sessionBloc => _store.sessionBloc;

  SubUser get mainUser => _store.mainUser;

  Future<bool> updateAccessRenewalRequestStatus(
    int id,
    String status,
    DateTime? expiresAt,
  ) async {
    final result = await _store.updateAccessRequestStatus(
      UpdateAccessRequestStatusParams(
        id: id,
        status: status,
        expiresAt: expiresAt,
      ),
    );
    return result;
  }
}
