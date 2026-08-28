import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/feature/me/domain/entity/me.dart';
import 'package:morar/feature/me/presentation/bloc/me_bloc.dart';
import 'package:morar/feature/me/presentation/bloc/me_event.dart';
import 'package:morar/feature/me/presentation/controllers/me_controller.dart';
import 'package:morar/feature/session/domain/entity/session.dart';
import 'package:morar/feature/sub_user/domain/entity/sub_user.dart';
import 'package:morar/feature/sub_user/domain/use_cases/update_access_request_status/update_access_request_use_case.dart';
import 'package:morar/feature/sub_user/presentation/stores/sub_user_store.dart';

import '../../../access_control/domain/entity/access_control_send_invite.dart';
import '../../domain/entity/sub_user_role.dart';
import '../bloc/sub_user_edit_bloc.dart';
import '../bloc/sub_users_bloc.dart';

class SubUserEditController {
  final SubUserStore _store;

  SubUserEditController({required SubUserStore store}) : _store = store;

  List<SubUser> contacts = [];

  SubUser? userSelected;

  SubUser? creationUser;

  var billetByEmailCounter = 0;

  DateTime? selectedExpirationDate;
  final expirationDateController = TextEditingController();

  void changeExpirationDate(DateTime? date) {
    selectedExpirationDate = date;
    if (date != null) {
      expirationDateController.text = DateFormat('dd/MM/yyyy').format(date);
    } else {
      expirationDateController.clear();
    }
  }

  String phone = "";

  List<SubUserRole> roles = [];
  List<SubUser> subUsers = [];

  bool editMainUser = false;
  bool activeEditMainUser = false;

  bool verifyChanges = false;

  Me? newMe;

  SubUser get mainUser => _store.mainUser;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final cpfController = TextEditingController();
  final phoneController = MaskedTextController(mask: '(00) 00000-0000');
  final maskedPhoneController = TextEditingController();

  void pipeline() async {
    newMe = Me.clone(_store.sessionBloc.state.session!.me!);
    _store.meController.bloc.originalMe =
        Me.clone(_store.sessionBloc.state.session!.me!);
    await getRoles(subUser: userSelected!);
    editBloc.add(SubUserEditLoadedEvent());
    editMainUser = userSelected!.mainUser;
  }

  Future<void> subUserUpdate({
    required bool isBlock,
    required bool isUseApp,
  }) async {
    SubUser? newUser = await _store.subUserUpdate(
      userSelected: userSelected!.copyWith(
          flagBoletoEmail: !isBlock && (userSelected?.flagBoletoEmail == true),
          expiresAt: selectedExpirationDate,
          clearExpiresAt: selectedExpirationDate == null),
      isBlock: isBlock,
      isUseApp: isUseApp,
      expirationDate: selectedExpirationDate,
    );
    if (newUser != null) userSelected = newUser;
    editBloc.add(SubUserEditLoadedEvent());
  }

  Future<void> checkService() => _store.checkService();

  Future<void> subUserSendInvite(
          {required AccessControlSendInviteEntity entity}) =>
      _store.subUserSendInvite(
        isEdit: true,
        body: entity,
      );

  Future<void> getRoles({required SubUser subUser}) async {
    var roles = await _store.getRoles(subUser: subUser);
    if (subUser.role != 'morar.proprietario') {
      roles.removeWhere((element) => element.role == 'morar.proprietario');
    }

    if (mainUser.role == 'morar.inquilino') {
      roles.retainWhere((item) =>
          (item.role == 'morar.inquilino' && mainUser.id == userSelected?.id) ||
          item.role == 'morar.morador' ||
          item.role == 'morar.parcial');
    }

    if (mainUser.role == 'morar.morador') {
      this.roles = roles
          .map((e) => e.copyWith(enabled: e.role != 'morar.inquilino'))
          .toList();
    } else {
      this.roles = roles;
    }
  }

  Future<void> getSubUsers() async {
    subUsers = await _store.getSubUsers();
    billetByEmailCounter =
        subUsers.where((element) => element.flagBoletoEmail == true).length;
  }

  Session get session => _store.sessionBloc.state.session!;

  bool get useFacialBiometric =>
      _store.sessionBloc.state.session!.condominium!.useFacialBiometric;

  String get biometricImageLink => session.me?.biometriaImageLink ?? "";

  SubUserEditBloc get editBloc => _store.editBloc;

  SubUsersBloc get bloc => _store.bloc;

  Future<void> updateMainUser() async {
    newMe?.email = emailController.text;
    newMe?.name = nameController.text;
    newMe?.phone = phoneController.text;
    blocMe.add(MeEditLoadedEvent(me: newMe!));
    await Future.delayed(const Duration(seconds: 1));
    _store.updateMe();
  }

  MeBloc get blocMe => _store.meController.bloc;

  MeController get meController => _store.meController;

  Future<bool> sendAccessRenewRequest() async {
    final result = await _store.sendAccessRenewRequest();

    if (result) {
      userSelected = userSelected?.copyWith(
        accessRenewalRequestStatus: 'SOLICITADO',
        accessRenewalRequestDate: DateTime.now(),
      );
    }

    return result;
  }

  Future<void> deleteSubUser() async {
    final unitId = _store.sessionBloc.state.session!.unity?.id;
    await _store.deleteSubUserByUnitId(unitId ?? '', userSelected?.id ?? '');
  }
}
