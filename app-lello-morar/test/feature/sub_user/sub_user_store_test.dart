import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:lib_facedetection/lib_facedetection.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_send_invite.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_service_seventh.dart';
import 'package:morar/feature/access_control/domain/use_case/facial_biometric/facial_biometric_usecase.dart';
import 'package:morar/feature/home/domain/entity/unity.dart';
import 'package:morar/feature/me/domain/entity/me.dart';
import 'package:morar/feature/me/presentation/bloc/me_bloc.dart';
import 'package:morar/feature/me/presentation/bloc/me_state.dart';
import 'package:morar/feature/me/presentation/controllers/me_controller.dart';
import 'package:morar/feature/session/domain/entity/session.dart';
import 'package:morar/feature/session/presentation/bloc/session_state.dart';
import 'package:morar/feature/sub_user/domain/entity/pending_request.dart';
import 'package:morar/feature/sub_user/domain/entity/sub_user.dart';
import 'package:morar/feature/sub_user/domain/entity/sub_user_role.dart';
import 'package:morar/feature/sub_user/domain/use_cases/check_seventh_service/sub_user_check_service.dart';
import 'package:morar/feature/sub_user/domain/use_cases/delete_sub_user/delete_sub_user.dart';
import 'package:morar/feature/sub_user/domain/use_cases/get_roles/sub_user_roles.dart';
import 'package:morar/feature/sub_user/domain/use_cases/get_sub_user/sub_user.dart';
import 'package:morar/feature/sub_user/domain/use_cases/insert_sub_user/insert_sub_user.dart';
import 'package:morar/feature/sub_user/domain/use_cases/pending_requests/get_pending_requests_use_case.dart';
import 'package:morar/feature/sub_user/domain/use_cases/send_access_renew_reques_use_case.dart';
import 'package:morar/feature/sub_user/domain/use_cases/send_invite/send_invite_usecase.dart';
import 'package:morar/feature/sub_user/domain/use_cases/update_access_request_status/update_access_request_use_case.dart';
import 'package:morar/feature/sub_user/domain/use_cases/update_sub_user/update_sub_user.dart';
import 'package:morar/feature/sub_user/presentation/bloc/sub_user_add_bloc.dart';
import 'package:morar/feature/sub_user/presentation/bloc/sub_user_edit_bloc.dart';
import 'package:morar/feature/sub_user/presentation/bloc/sub_users_bloc.dart';
import 'package:morar/feature/sub_user/presentation/controllers/sub_user_add_controller.dart';
import 'package:morar/feature/sub_user/presentation/controllers/sub_user_controller.dart';
import 'package:morar/feature/sub_user/presentation/controllers/sub_user_edit_controller.dart';
import 'package:morar/feature/sub_user/presentation/stores/sub_user_store.dart';
import 'package:shared_features/shared_features.dart';

import '../../helpers/firebase_mocks.dart';
import '../../helpers/fixtures.dart';
import '../../helpers/test_application_container.dart';

SubUser _user({String id = 's1', String role = 'morar.morador', bool main = false, bool? billet, String cpf = '123.456.789-01'}) =>
    SubUser(id: id, name: 'Bia Souza', email: 'b@x', phone: '11999998888', cpf: cpf, role: role, mainUser: main, blocked: false, useApp: true, flagBoletoEmail: billet);

class _Fakes {
  Failure? failure;
  final calls = <String>[];
}

class _FakeGetSubUsers extends Fake implements SubUserUseCase {
  _FakeGetSubUsers(this.f, {this.users});
  final _Fakes f;
  List<SubUser>? users;
  @override
  Future<Try<List<SubUser>>> call(GetSubUserParams params) async {
    f.calls.add('get:${params.unityId}');
    if (f.failure != null) return Rejection(f.failure!);
    return Success(users ?? [_user(main: true), _user(id: 's2', billet: true)]);
  }
}

class _FakeUpdate extends Fake implements UpdateSubUser {
  _FakeUpdate(this.f);
  final _Fakes f;
  SubUser? sent;
  @override
  Future<Try<List<SubUser>>> call(UpdateSubUserParams params) async {
    sent = params.subUser;
    if (f.failure != null) return Rejection(f.failure!);
    return Success([params.subUser]);
  }
}

class _FakeInsert extends Fake implements InsertSubUser {
  _FakeInsert(this.f);
  final _Fakes f;
  SubUser? sent;
  @override
  Future<Try<List<SubUser>>> call(InsertSubUserParam params) async {
    sent = params.subUser;
    if (f.failure != null) return Rejection(f.failure!);
    return Success([params.subUser]);
  }
}

class _FakeRoles extends Fake implements SubUserRoleCase {
  _FakeRoles(this.f);
  final _Fakes f;
  @override
  Future<Try<List<SubUserRole>>> call(Session params) async {
    if (f.failure != null) return Rejection(f.failure!);
    return Success(const [
      SubUserRole(role: 'morar.proprietario', enabled: true),
      SubUserRole(role: 'morar.inquilino', enabled: true),
      SubUserRole(role: 'morar.morador', enabled: true),
      SubUserRole(role: 'morar.parcial', enabled: true),
    ]);
  }
}

class _FakeCheck extends Fake implements SubUserCheckServiceCase {
  _FakeCheck(this.f, {this.active = true});
  final _Fakes f;
  final bool active;
  @override
  Future<Try<AccessControlServiceSeventh>> call(GetSubUserCheckServiceParams params) async {
    if (f.failure != null) return Rejection(f.failure!);
    return Success(AccessControlServiceSeventh(condominiumActive: active));
  }
}

class _FakeFacial extends Fake implements FacialBiometricUsecase {}

class _FakeSendInvite extends Fake implements SendInviteUsecase {
  _FakeSendInvite(this.f);
  final _Fakes f;
  @override
  Future<Try<String>> call(SendInviteParam params) async {
    if (f.failure != null) return Rejection(f.failure!);
    return Success('ok');
  }
}

class _FakeCamera extends Fake implements GetImageFromCameraViewPickerUsecase {}

class _FakeMeController extends Fake implements MeController {
  @override
  Me? originalMe;
  @override
  final MeBloc bloc = MeBloc();
  int saves = 0;
  @override
  Future<void> mapSave({CodeValidation? codeValidation}) async => saves++;
}

class _FakeRenew extends Fake implements SendAccessRenewRequestUseCase {
  _FakeRenew(this.f);
  final _Fakes f;
  @override
  Future<Try<String>> call(String params) async {
    if (f.failure != null) return Rejection(f.failure!);
    return Success('ok');
  }
}

class _FakePending extends Fake implements GetPendingRequestsUseCase {
  _FakePending(this.f);
  final _Fakes f;
  @override
  Future<Try<List<PendingRequestEntity>>> call(String params) async {
    if (f.failure != null) return Rejection(f.failure!);
    return Success(const []);
  }
}

class _FakeStatus extends Fake implements UpdateAccessRequestUseCase {
  _FakeStatus(this.f);
  final _Fakes f;
  @override
  Future<Try<bool>> call(UpdateAccessRequestStatusParams params) async {
    if (f.failure != null) return Rejection(f.failure!);
    return Success(true);
  }
}

class _FakeDelete extends Fake implements DeleteSubUser {
  _FakeDelete(this.f);
  final _Fakes f;
  @override
  Future<Try<bool>> call(DeleteSubUserParams params) async {
    if (f.failure != null) return Rejection(f.failure!);
    return Success(true);
  }
}

void main() {
  late _Fakes f;
  late FakeSessionBloc sessionBloc;
  late _FakeMeController meController;
  late _FakeUpdate update;
  late _FakeInsert insert;
  late _FakeGetSubUsers getSubUsers;
  late SubUserStore store;

  setUpAll(() async {
    await setUpFakeFirebase();
  });

  setUp(() {
    f = _Fakes();
    sessionBloc = FakeSessionBloc();
    meController = _FakeMeController();
    update = _FakeUpdate(f);
    insert = _FakeInsert(f);
    getSubUsers = _FakeGetSubUsers(f);
    store = SubUserStore(
      addBloc: SubUserAddBloc(),
      bloc: SubUsersBloc(),
      editBloc: SubUserEditBloc(),
      subUserUseCase: getSubUsers,
      sessionBloc: sessionBloc,
      updateSubUser: update,
      insertSubUser: insert,
      subUserRoleCase: _FakeRoles(f),
      checkServiceCase: _FakeCheck(f),
      facialBiometricUsecase: _FakeFacial(),
      sendInviteUsecase: _FakeSendInvite(f),
      getImageFromCameraViewPickerUsecase: _FakeCamera(),
      meController: meController,
      sendAccessRenewRequestUseCase: _FakeRenew(f),
      getPendingRequestsUseCase: _FakePending(f),
      updateAccessRequestUseCase: _FakeStatus(f),
      deleteSubUser: _FakeDelete(f),
    );
  });

  tearDown(() async {
    await store.bloc.close();
    await store.addBloc.close();
    await store.editBloc.close();
  });

  group('SubUserStore', () {
    test('getSubUsers carrega e loga analytics', () async {
      fakeAnalytics.reset();
      final users = await store.getSubUsers();
      expect(users, hasLength(2));
      await waitFor(() => store.bloc.state is SubUserLoadedState);
      expect(meController.originalMe, isNotNull);
      expect(fakeAnalytics.eventNames, containsAll(['moradores_acessar', 'morar_moradores_principal_read']));

      getSubUsers.users = [_user()];
      fakeAnalytics.reset();
      await store.getSubUsers();
      expect(fakeAnalytics.eventNames, contains('morar_moradores_outros_read'));

      f.failure = UnknownFailure('x');
      expect(await store.getSubUsers(), isEmpty);
      await waitFor(() => store.bloc.state is SubUserErrorState);

      sessionBloc.session.unity = Unity();
      expect(await store.getSubUsers(), isEmpty);
    });

    test('subUserUpdate bloqueia, libera app e normaliza cpf', () async {
      final blocked = await store.subUserUpdate(userSelected: _user(), isBlock: true, expirationDate: DateTime(2027));
      expect(blocked!.blocked, isTrue);
      expect(blocked.cpf, '12345678901');
      expect(blocked.unitId, 'u1');
      expect(blocked.expiresAt, DateTime(2027));
      await waitFor(() => store.editBloc.state is SubUserEditConcludeState);

      final app = await store.subUserUpdate(userSelected: _user(), isUseApp: true);
      expect(app!.useApp, isFalse);
      await waitFor(() => store.editBloc.state is SubUserEditSuccessState);

      f.failure = UnknownFailure('x');
      expect(await store.subUserUpdate(userSelected: _user()), isNull);
      await waitFor(() => store.editBloc.state is SubUserEditErrorState);
    });

    test('getContacts reaproveita a lista e getRoles', () async {
      final contacts = await store.getContacts(contacts: [_user()]);
      expect(contacts, hasLength(1));
      await waitFor(() => store.addBloc.state is SubUserAddSuccessState);
      expect(await store.getRoles(subUser: _user()), hasLength(4));
      f.failure = UnknownFailure('x');
      expect(await store.getRoles(subUser: _user()), isEmpty);
      sessionBloc.currentState = const SessionInitialState();
      expect(await store.getRoles(subUser: _user()), isEmpty);
    });

    test('inviteResident', () async {
      fakeAnalytics.reset();
      await store.inviteResident(creationUser: _user());
      await waitFor(() => store.bloc.state is SubUserInviteSuccessState);
      expect(insert.sent!.cpf, '12345678901');
      expect(insert.sent!.creator!.name, 'ana silva');
      expect(insert.sent!.useApp, isTrue);
      expect(fakeAnalytics.eventNames, contains('moradores_adicionar_novo_usuario_sucesso'));

      f.failure = UnknownFailure('x');
      await store.inviteResident(creationUser: _user());
      await waitFor(() => store.bloc.state is InsertSubUserErrorState);
    });

    test('checkService e convites', () async {
      await store.checkService();
      await waitFor(() => store.bloc.state is CheckServiceOnlineState);
      f.failure = UnknownFailure('x');
      await store.checkService();
      await waitFor(() => store.bloc.state is CheckServiceOfflineState);

      f.failure = null;
      final body = AccessControlSendInviteEntity(name: 'n');
      await store.subUserSendInvite(body: body, isEdit: false);
      await waitFor(() => store.bloc.state is SendInviteSuccessState);
      await store.subUserSendInvite(body: body, isEdit: true);
      await waitFor(() => store.editBloc.state is SubUserEditSendInviteSuccessState);
      await store.subUserSendInviteFromList(body: body);
      await waitFor(() => store.bloc.state is SendInviteSuccessState);

      f.failure = UnknownFailure('x');
      await store.subUserSendInvite(body: body, isEdit: false);
      await waitFor(() => store.bloc.state is SendInviteFailedState);
      await store.subUserSendInvite(body: body, isEdit: true);
      await waitFor(() => store.editBloc.state is SubUserEditSendInviteErrorState);
      await store.subUserSendInviteFromList(body: body);
      await waitFor(() => store.bloc.state is SendInviteFailedState);
    });

    test('helpers e getters', () {
      expect(store.getFormattedName(fullName: 'Ana Maria Souza'), 'Ana Souza');
      expect(store.getFormattedName(fullName: '  Ana  '), 'Ana');
      expect(store.getFormattedName(fullName: ''), '');
      expect(store.getFormattedName(fullName: null), '');
      expect(store.getFormattedName(fullName: '   '), '');
      expect(store.condoUseFacialBiometric, isTrue);
      expect(store.useFacialBiometric, isFalse);
      expect(store.biometricImageLink, '');
      store.updateMe();
      expect(meController.saves, 1);
    });

    test('renovação de acesso, status e exclusão', () async {
      expect(await store.sendAccessRenewRequest(), isTrue);
      await waitFor(() => store.bloc.state is SubUserLoadedState);
      expect(await store.updateAccessRequestStatus(UpdateAccessRequestStatusParams(id: 1, status: 'APROVADO')), isTrue);
      await waitFor(() => store.bloc.state is UpdateAccessStatusRequestSuccessState);
      expect(await store.deleteSubUserByUnitId('u1', 'c'), isTrue);
      await waitFor(() => store.editBloc.state is SubUserDeleteSuccessState);

      f.failure = UnknownFailure('x');
      expect(await store.sendAccessRenewRequest(), isFalse);
      await waitFor(() => store.bloc.state is SubUserErrorState);
      expect(await store.updateAccessRequestStatus(UpdateAccessRequestStatusParams(id: 1, status: 'x')), isFalse);
      await waitFor(() => store.bloc.state is UpdateAccessStatusRequestErrorState);
      // Corrigido: deleteSubUserByUnitId devolve false em vez de relançar a falha.
      expect(await store.deleteSubUserByUnitId('u1', 'c'), isFalse);
      await waitFor(() => store.editBloc.state is SubUserDeleteErrorState);
      // espera o getSubUsers disparado após a atualização de status
      await Future<void>.delayed(const Duration(milliseconds: 600));
    });
  });

  group('controllers', () {
    test('SubUserAddController', () async {
      final controller = SubUserAddController(store);
      await controller.getSubUsers();
      expect(controller.subUsers, hasLength(2));
      expect(controller.billetByEmailCounter, 1);
      controller.contacts = [_user()..copyWith(name: 'x')];
      await controller.getContacts();
      controller.searchText = 'bia';
      expect(controller.filteredContacts, hasLength(1));
      controller.searchText = 'zzz';
      expect(controller.filteredContacts, isEmpty);

      await controller.getRoles();
      expect(controller.roles.map((r) => r.role), isNot(contains('morar.proprietario')));
      await controller.getRoles(user: _user(role: 'morar.inquilino'));
      expect(controller.roles.map((r) => r.role), ['morar.morador', 'morar.parcial']);

      expect(controller.initialDDD(initialValue: '+55 11 99999-8888'), '11');
      expect(controller.initialDDD(initialValue: '(11) 99999-8888'), '11');
      expect(controller.initialDDD(initialValue: '11999998888'), '11');
      expect(controller.initialDDD(initialValue: '999'), isNull);
      expect(controller.initialDDD(initialValue: ''), isNull);
      expect(controller.initialPhone(initialValue: '+55 11 99999-8888'), '999998888');
      expect(controller.initialPhone(initialValue: '(11) 99999-8888'), '999998888');
      expect(controller.initialPhone(initialValue: '11999998888'), '999998888');
      expect(controller.initialPhone(initialValue: '(11)'), isNull);
      expect(controller.initialPhone(initialValue: '9999'), '9999');
      expect(controller.initialPhone(initialValue: ''), isNull);
      controller.ddd = '11';
      controller.phone = '999998888';
      expect(controller.getPhone(), '(11)999998888');

      expect(controller.allRequiresFieldsFilled(), isFalse);
      controller.nameController.text = 'n';
      controller.emailController.text = 'e';
      controller.cpfCnpjController.text = 'c';
      controller.phoneController.text = '(11) 99999-8888';
      controller.setItemSelecionado(const SubUserRole(role: 'r'));
      expect(controller.allRequiresFieldsFilled(), isTrue);
      controller.billetByEmailCounter = 3;
      controller.creationUser = _user(billet: true);
      expect(controller.allRequiresFieldsFilled(), isFalse);
      controller.changeExpirationDate(DateTime(2027, 1, 5));
      expect(controller.expirationDateController.text, '05/01/2027');
      controller.changeExpirationDate(null);
      expect(controller.expirationDateController.text, '');
      controller.mainUser = _user(main: true);
      expect(controller.mainUser.mainUser, isTrue);
      expect(controller.bloc, same(store.addBloc));
      expect(controller.useFacialBiometric, isTrue);
      expect(controller.biometricImageLink, '');
      expect(controller.session.condominium!.id, 'c1');
      expect(controller.sessionBloc, same(sessionBloc));
    });

    test('SubUserController', () async {
      final controller = SubUserController(store: store);
      await controller.getSubUsers();
      expect(controller.subUsers, hasLength(2));
      await controller.getRoles(user: _user());
      expect(controller.descriptions, hasLength(4));
      await controller.checkService();
      await controller.inviteResident(subUser: _user());
      await controller.subUserSendInvite(entity: AccessControlSendInviteEntity());
      expect(controller.getFormattedName(name: 'A B C'), 'A C');
      controller.mainUser = _user(main: true);
      expect(controller.mainUser.mainUser, isTrue);
      expect(controller.bloc, same(store.bloc));
      expect(controller.useFacialBiometric, isTrue);
      expect(controller.session.unity!.id, 'u1');
      expect(controller.sessionBloc, same(sessionBloc));
      expect(await controller.updateAccessRenewalRequestStatus(1, 'ok', null), isTrue);
      await Future<void>.delayed(const Duration(milliseconds: 600));
    });

    test('SubUserEditController', () async {
      final controller = SubUserEditController(store: store);
      store.mainUser = _user(id: 'main', role: 'morar.proprietario', main: true);
      controller.userSelected = _user(id: 'main', role: 'morar.proprietario', main: true);
      controller.pipeline();
      await waitFor(() => store.editBloc.state is SubUserEditLoadedState);
      expect(controller.editMainUser, isTrue);
      expect(controller.newMe!.name, 'ana silva');
      expect(meController.bloc.originalMe!.name, 'ana silva');
      expect(controller.roles.map((r) => r.role), contains('morar.proprietario'));

      await controller.getRoles(subUser: _user());
      expect(controller.roles.map((r) => r.role), isNot(contains('morar.proprietario')));

      store.mainUser = _user(id: 'main', role: 'morar.inquilino');
      controller.userSelected = _user(id: 'main', role: 'morar.inquilino');
      await controller.getRoles(subUser: controller.userSelected!);
      expect(controller.roles.map((r) => r.role), ['morar.inquilino', 'morar.morador', 'morar.parcial']);

      store.mainUser = _user(id: 'main', role: 'morar.morador');
      await controller.getRoles(subUser: _user());
      expect(controller.roles.firstWhere((r) => r.role == 'morar.inquilino').enabled, isFalse);
      expect(controller.roles.firstWhere((r) => r.role == 'morar.morador').enabled, isTrue);

      controller.changeExpirationDate(DateTime(2027, 2, 3));
      expect(controller.expirationDateController.text, '03/02/2027');
      controller.userSelected = _user(billet: true);
      await controller.subUserUpdate(isBlock: false, isUseApp: false);
      expect(update.sent!.flagBoletoEmail, isTrue);
      expect(update.sent!.expiresAt, DateTime(2027, 2, 3));
      await controller.subUserUpdate(isBlock: true, isUseApp: false);
      expect(update.sent!.flagBoletoEmail, isFalse);
      expect(controller.userSelected!.blocked, isTrue);

      await controller.getSubUsers();
      expect(controller.billetByEmailCounter, 1);
      expect(controller.mainUser.id, 'main');
      expect(controller.session.condominium!.id, 'c1');
      expect(controller.useFacialBiometric, isTrue);
      expect(controller.biometricImageLink, '');
      expect(controller.editBloc, same(store.editBloc));
      expect(controller.blocMe, same(meController.bloc));
      expect(controller.meController, same(meController));

      expect(await controller.sendAccessRenewRequest(), isTrue);
      expect(controller.userSelected!.accessRenewalRequestStatus, 'SOLICITADO');
      await controller.checkService();
      await controller.subUserSendInvite(entity: AccessControlSendInviteEntity());
      await controller.deleteSubUser();
      await waitFor(() => store.editBloc.state is SubUserDeleteSuccessState);

      controller.nameController.text = 'Novo Nome';
      controller.emailController.text = 'novo@x';
      controller.phoneController.text = '(11) 90000-0000';
      final future = controller.updateMainUser();
      await waitFor(() => meController.bloc.state is MeEditState);
      expect(meController.bloc.state.me.name, 'Novo Nome');
      await future;
      expect(meController.saves, 1);

      f.failure = UnknownFailure('x');
      expect(await controller.sendAccessRenewRequest(), isFalse);
    });
  });
}
