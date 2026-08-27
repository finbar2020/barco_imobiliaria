import 'dart:convert';

import 'package:chopper/chopper.dart' show Response;
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:essentials/network/api_failure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:morar/feature/access_control/data/model/access_control_service_seventh_model.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_send_invite.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_service_seventh.dart';
import 'package:morar/feature/access_control/domain/repository/access_control_repository.dart';
import 'package:morar/feature/sub_user/data/data_source/sub_user_remote_data_source.dart';
import 'package:morar/feature/sub_user/data/data_source/sub_user_remote_data_source_impl.dart';
import 'package:morar/feature/sub_user/data/data_source/subuser_api.dart';
import 'package:morar/feature/sub_user/data/model/pending_request_model.dart';
import 'package:morar/feature/sub_user/data/model/sub_user_model.dart';
import 'package:morar/feature/sub_user/data/model/sub_user_role_model.dart';
import 'package:morar/feature/sub_user/data/model/update_access_request_status_model.dart';
import 'package:morar/feature/sub_user/data/repository/sub_user_repository_impl.dart';
import 'package:morar/feature/sub_user/domain/entity/pending_request.dart';
import 'package:morar/feature/sub_user/domain/entity/sub_user.dart';
import 'package:morar/feature/sub_user/domain/entity/sub_user_app_access_enum.dart';
import 'package:morar/feature/sub_user/domain/entity/sub_user_role.dart';
import 'package:morar/feature/sub_user/domain/repository/sub_user_repository.dart';
import 'package:morar/feature/sub_user/domain/use_cases/check_seventh_service/sub_user_check_service.dart';
import 'package:morar/feature/sub_user/domain/use_cases/check_seventh_service/sub_user_check_service_impl.dart';
import 'package:morar/feature/sub_user/domain/use_cases/delete_sub_user/delete_sub_user.dart';
import 'package:morar/feature/sub_user/domain/use_cases/delete_sub_user/delete_sub_user_impl.dart';
import 'package:morar/feature/sub_user/domain/use_cases/get_roles/sub_user_roles_impl.dart';
import 'package:morar/feature/sub_user/domain/use_cases/get_sub_user/sub_user.dart';
import 'package:morar/feature/sub_user/domain/use_cases/get_sub_user/sub_user_impl.dart';
import 'package:morar/feature/sub_user/domain/use_cases/insert_sub_user/insert_sub_user.dart';
import 'package:morar/feature/sub_user/domain/use_cases/insert_sub_user/insert_sub_user_failures.dart';
import 'package:morar/feature/sub_user/domain/use_cases/insert_sub_user/insert_sub_user_impl.dart';
import 'package:morar/feature/sub_user/domain/use_cases/pending_requests/get_pending_requests_impl_use_case.dart';
import 'package:morar/feature/sub_user/domain/use_cases/send_access_renew_reques_use_case.dart';
import 'package:morar/feature/sub_user/domain/use_cases/send_invite/send_invite_usecase.dart';
import 'package:morar/feature/sub_user/domain/use_cases/send_invite/send_invite_usecase_impl.dart';
import 'package:morar/feature/sub_user/domain/use_cases/update_access_request_status/update_access_request_status_use_case_impl.dart';
import 'package:morar/feature/sub_user/domain/use_cases/update_access_request_status/update_access_request_use_case.dart';
import 'package:morar/feature/sub_user/domain/use_cases/update_sub_user/update_sub_user.dart';
import 'package:morar/feature/sub_user/domain/use_cases/update_sub_user/update_sub_user_impl.dart';
import 'package:morar/feature/sub_user/presentation/enum/staff_access_permission_enum.dart';
import 'package:morar/feature/sub_user/presentation/pages/pending_requests/pending_requests_enum.dart';
import 'package:morar/feature/vehicles/domain/entity/concierge_creator.dart';

import '../../helpers/firebase_mocks.dart';
import '../../helpers/fixtures.dart';
import '../../helpers/pump_app.dart';

class MockApi extends Mock implements SubUserApi {}

SubUser _user({String id = 's1', String role = 'morar.morador', bool main = false, bool? billet}) => SubUser(
      id: id,
      name: 'Bia Souza',
      email: 'b@x',
      phone: '11999998888',
      cpf: '123.456.789-01',
      role: role,
      mainUser: main,
      blocked: false,
      useApp: true,
      flagBoletoEmail: billet,
      expiresAt: DateTime(2027, 1, 1),
      creator: ConciergeCreator(name: 'Ana', type: ConciergeCreatorType.appmorar),
    );

class _FakeDataSource extends Fake implements SubUserRemoteDataSource {
  _FakeDataSource({this.error});
  final Object? error;
  SubUserModel? sent;
  UpdateAccessRequestStatusModel? statusBody;

  @override
  Future<List<SubUserModel>?> getSubUsers(String unityId) async {
    if (error != null) throw error!;
    return [SubUserModel(id: unityId, mainUser: true)];
  }

  @override
  Future<List<SubUserModel>?> updateSubUser(SubUserModel resident) async {
    if (error != null) throw error!;
    sent = resident;
    return null;
  }

  @override
  Future<List<SubUserModel>?> insertSubUser(SubUserModel resident) async {
    if (error != null) throw error!;
    sent = resident;
    return [resident];
  }

  @override
  Future<List<SubUserRoleModel>?> getRoles() async {
    if (error != null) throw error!;
    return [SubUserRoleModel()..role = 'morar.morador'];
  }

  @override
  Future<AccessControlServiceSeventhModel> checkSeventhService(String reference) async {
    if (error != null) throw error!;
    return AccessControlServiceSeventhModel(condominiumActive: true);
  }

  @override
  Future<String> sendAccessRenewRequest(String unitId) async {
    if (error != null) throw error!;
    return 'ok';
  }

  @override
  Future<List<PendingRequestModel>> getPendingRequests(String unitId) async {
    if (error != null) throw error!;
    return [const PendingRequestModel(id: 1, registrationOrigin: 'portaria')];
  }

  @override
  Future<bool> updateAccessRequestStatus(UpdateAccessRequestStatusModel body) async {
    if (error != null) throw error!;
    statusBody = body;
    return true;
  }

  @override
  Future<bool> deleteSubUser(String unitId, String cpfCnpj) async {
    if (error != null) throw error!;
    return true;
  }
}

class _FakeRepository extends Fake implements SubUserRepository {
  final calls = <String>[];
  @override
  Future<Try<List<SubUser>>> getSubUsers(String unityId) async {
    calls.add('get:$unityId');
    return Success([_user()]);
  }

  @override
  Future<Try<List<SubUser>>> updateSubUser(SubUser resident) async {
    calls.add('update:${resident.id}');
    return Success([resident]);
  }

  @override
  Future<Try<List<SubUser>>> insertSubUser(SubUser resident) async {
    calls.add('insert:${resident.name}');
    return Success([resident]);
  }

  @override
  Future<Try<List<SubUserRole>>> getRoles() async {
    calls.add('roles');
    return Success(const []);
  }

  @override
  Future<Try<AccessControlServiceSeventh>> checkSeventhService(String reference) async {
    calls.add('check:$reference');
    return Success(AccessControlServiceSeventh(condominiumActive: true));
  }

  @override
  Future<Try<String>> sendAccessRenewRequest(String unitId) async {
    calls.add('renew:$unitId');
    return Success('ok');
  }

  @override
  Future<Try<List<PendingRequestEntity>>> getPendingRequests(String unitId) async {
    calls.add('pending:$unitId');
    return Success(const []);
  }

  @override
  Future<Try<bool>> updateAccessRequestStatus(int id, String status, DateTime? expiresAt) async {
    calls.add('status:$id:$status');
    return Success(true);
  }

  @override
  Future<Try<bool>> deleteSubUser(String unitId, String cpfCnpj) async {
    calls.add('delete:$unitId:$cpfCnpj');
    return Success(true);
  }
}

class _FakeAccessControlRepository extends Fake implements AccessControlRepository {
  AccessControlSendInviteEntity? body;
  @override
  Future<Try<String>> sendInvite(AccessControlSendInviteEntity entity) async {
    body = entity;
    return Success('sent');
  }
}

void main() {
  setUpAll(() async {
    await setUpFakeFirebase();
  });

  testWidgets('SubUser', (tester) async {
    final user = _user();
    expect(user.isItself('s1'), isTrue);
    expect(user.isItself('x'), isFalse);
    final copy = user.copyWith(name: 'Novo', blocked: true);
    expect(copy.name, 'Novo');
    expect(copy.blocked, isTrue);
    /// Corrigido: copyWith preserva expiresAt quando não informado; limpar é
    /// explícito via `clearExpiresAt`.
    expect(copy.expiresAt, user.expiresAt, reason: 'copyWith preserva expiresAt quando não informado');
    expect(user.copyWith(expiresAt: DateTime(2030)).expiresAt, DateTime(2030));
    expect(user.copyWith(clearExpiresAt: true).expiresAt, isNull);
    expect(user.copyWith(expiresAt: DateTime(2030), clearExpiresAt: true).expiresAt, isNull);

    await pumpApp(tester, const Text('x'), localized: true);
    final context = tester.element(find.text('x'));
    expect(user.descriptionText(context), 'creator_vehicle Ana');
    expect(user.copyWith(creator: ConciergeCreator(type: ConciergeCreatorType.appsindico)).descriptionText(context),
        'creator_vehicle_sindico');
    expect(user.copyWith(creator: ConciergeCreator(type: ConciergeCreatorType.portaria)).descriptionText(context),
        'creator_vehicle_concierge');
    expect(SubUser().descriptionText(context), '');

    expect(SubUserAppAccessEnum.withAccess.withAccess, isTrue);
    expect(SubUserAppAccessEnum.withoutAccess.withoutAccess, isTrue);
    expect(SubUserAppAccessEnum.blockedAccess.blockedAccess, isTrue);
    expect(SubUserAppAccessEnum.registered.registered, isTrue);
    expect(SubUserAppAccessEnum.available.available, isTrue);
    expect(SubUserAppAccessEnum.available.withAccess, isFalse);

    for (final permission in StaffAccessTypePermissionEnum.values) {
      expect(permission.labelOf(context), isNotEmpty);
      expect(accessPermissions[permission]!.isAllowed(StaffAccessRole.adultResident), isTrue);
    }
    for (final role in StaffAccessRole.values) {
      expect(role.labelOf(context), isNotEmpty);
    }
    expect(accessPermissions[StaffAccessTypePermissionEnum.inviteOtherResidents]!.isAllowed(StaffAccessRole.realEstate), isFalse);
  });

  test('SubUserRole e PendingRequestEntity', () {
    const role = SubUserRole(role: 'r', description: 'd', enabled: true);
    expect(role.copyWith(enabled: false).enabled, isFalse);
    expect(role.copyWith().role, 'r');
    expect(role.toString(), contains('role: r'));
    expect(role, const SubUserRole(role: 'r', description: 'd', enabled: true));

    const pending = PendingRequestEntity(
      id: 1,
      typeOfLink: 't',
      linkDescription: 'l',
      requestStatus: 's',
      requestDate: null,
      registrationOrigin: RegistrationOrigin.lelloRegistration,
      expirationDate: null,
      unitId: 2,
      cpfCnpj: 'c',
      email: 'e',
      phone: 'p',
      name: 'n',
      remainingDays: '3',
    );
    expect(pending.copyWith(name: 'x', registrationOrigin: RegistrationOrigin.changeOfOwnership).name, 'x');
    expect(pending.copyWith().props.length, 13);
    expect(RegistrationOrigin.lelloRegistration.value, 'LELLO');
    expect(RegistrationOrigin.conciergeRegistration.value, 'PORTARIA');
    expect(RegistrationOrigin.registrationWithoutContract.value, 'RESOLVA_FACIL_SEM_CONTRATO');
    expect(RegistrationOrigin.changeOfOwnership.value, 'JOB_ALTERACAO_TITULARIDADE');
    final theme = ThemeData();
    expect(RegistrationOrigin.conciergeRegistration.color(theme), const Color(0xFF0058A0));
    expect(RegistrationOrigin.changeOfOwnership.color(theme), const Color(0xFF8D3393));
    expect(RegistrationOrigin.lelloRegistration.color(theme), isA<Color>());
    expect(RegistrationOrigin.registrationWithoutContract.color(theme), isA<Color>());
    expect(PendingRequestStatus.values, hasLength(1));
  });

  test('models', () {
    final model = SubUserModel.fromEntity(_user(billet: true));
    final json = jsonDecode(jsonEncode(model.toJson())) as Map<String, dynamic>;
    expect(json['flag_boleto_email'], isTrue);
    expect(json['creator']['type'], 'appmorar');
    final back = SubUserModel.fromJson(json).toEntity();
    expect(back.name, 'Bia Souza');
    expect(back.mainUser, isFalse);
    expect(back.creator!.name, 'Ana');
    expect(SubUserModel.fromJson({}).toEntity().mainUser, isFalse);

    final role = SubUserRoleModel.fromEntity(const SubUserRole(role: 'r', enabled: true))!;
    expect(SubUserRoleModel.fromJson(role.toJson()).toEntity(), const SubUserRole(role: 'r', enabled: true));
    expect(SubUserRoleModel.fromEntity(null), isNull);

    const pending = PendingRequestModel(id: 1, registrationOrigin: 'JOB_ALTERACAO_TITULARIDADE', name: 'n');
    final pendingBack = PendingRequestModel.fromJson(jsonDecode(jsonEncode(pending.toJson())));
    expect(pendingBack.toEntity().registrationOrigin, RegistrationOrigin.changeOfOwnership);
    expect(pendingBack.toEntity().name, 'n');
    expect(const PendingRequestModel().toEntity().registrationOrigin, RegistrationOrigin.lelloRegistration);
    expect(const PendingRequestModel().toEntity().remainingDays, '');

    final status = UpdateAccessRequestStatusModel(id: 1, status: 'APROVADO', expiresAt: DateTime(2027));
    expect(UpdateAccessRequestStatusModel.fromJson(jsonDecode(jsonEncode(status.toJson()))).status, 'APROVADO');
    expect(AccessControlServiceSeventhModel.fromEntity(null), isNull);
    expect(AccessControlServiceSeventhModel.fromJson({'condominium_active': true}).toEntity().condominiumActive, isTrue);
  });

  test('use cases', () async {
    final repo = _FakeRepository();
    Failure? f(Try r) => r.fold((e) => e, (_) => null);
    expect(f(await SubUserCheckServiceImpl(repository: repo)(GetSubUserCheckServiceParams(reference: ''))), isA<InvalidParamFailure>());
    expect(f(await DeleteSubUserImpl(repository: repo)(DeleteSubUserParams(unitId: '', cpfCnpj: 'c'))), isA<InvalidParamFailure>());
    expect(f(await DeleteSubUserImpl(repository: repo)(DeleteSubUserParams(unitId: 'u', cpfCnpj: ''))), isA<InvalidParamFailure>());
    expect(f(await SubUserUseCaseImpl(repository: repo)(GetSubUserParams(unityId: ''))), isA<InvalidParamFailure>());
    expect(f(await InsertSubUserImpl(repository: repo)(InsertSubUserParam(subUser: SubUser(name: '')))), isA<InvalidParamFailure>());
    expect(f(await GetPendingRequestsUseCaseImpl(repo)('')), isA<InvalidParamFailure>());
    expect(f(await SendAccessRenewRequestUseCaseImpl(repository: repo)('')), isA<InvalidParamFailure>());
    expect(f(await UpdateAccessRequestStatusUseCaseImpl(repo)(UpdateAccessRequestStatusParams(id: 0, status: 's'))), isA<InvalidParamFailure>());
    expect(f(await UpdateAccessRequestStatusUseCaseImpl(repo)(UpdateAccessRequestStatusParams(id: 1, status: ''))), isA<InvalidParamFailure>());
    expect(f(await UpdateSubUserImpl(repository: repo)(UpdateSubUserParams(subUser: SubUser()))), isA<InvalidParamFailure>());
    expect(f(await UpdateSubUserImpl(repository: repo)(UpdateSubUserParams(subUser: SubUser(name: 'n')))), isA<InvalidParamFailure>());
    expect(repo.calls, isEmpty);

    await SubUserCheckServiceImpl(repository: repo)(GetSubUserCheckServiceParams(reference: 'R1'));
    await DeleteSubUserImpl(repository: repo)(DeleteSubUserParams(unitId: 'u', cpfCnpj: 'c'));
    await SubUserRoleCaseImpl(repository: repo)(testSession());
    await SubUserUseCaseImpl(repository: repo)(GetSubUserParams(unityId: 'u'));
    await InsertSubUserImpl(repository: repo)(InsertSubUserParam(subUser: _user()));
    await GetPendingRequestsUseCaseImpl(repo)('u');
    await SendAccessRenewRequestUseCaseImpl(repository: repo)('u');
    await UpdateAccessRequestStatusUseCaseImpl(repo)(UpdateAccessRequestStatusParams(id: 1, status: 'ok'));
    await UpdateSubUserImpl(repository: repo)(UpdateSubUserParams(subUser: _user()));
    expect(repo.calls, [
      'check:R1', 'delete:u:c', 'roles', 'get:u', 'insert:Bia Souza', 'pending:u', 'renew:u', 'status:1:ok', 'update:s1',
    ]);

    final access = _FakeAccessControlRepository();
    final invite = await SendInviteUsecaseImpl(repository: access)(SendInviteParam(body: AccessControlSendInviteEntity(name: 'n')));
    expect(invite.fold((_) => null, (r) => r), 'sent');
    expect(access.body!.name, 'n');
  });

  group('SubUserRepositoryImpl', () {
    test('sucesso', () async {
      final ds = _FakeDataSource();
      final repo = SubUserRepositoryImpl(dataSource: ds);
      expect((await repo.getSubUsers('u')).fold((_) => null, (l) => l.single.mainUser), isTrue);
      expect((await repo.updateSubUser(_user())).fold((_) => null, (l) => l), isEmpty);
      expect(ds.sent!.cpf, '123.456.789-01');
      expect((await repo.insertSubUser(_user())).fold((_) => null, (l) => l.single.name), 'Bia Souza');
      expect((await repo.getRoles()).fold((_) => null, (l) => l.single.role), 'morar.morador');
      expect((await repo.checkSeventhService('R1')).fold((_) => null, (s) => s.condominiumActive), isTrue);
      expect((await repo.sendAccessRenewRequest('u')).fold((_) => null, (r) => r), 'ok');
      expect((await repo.getPendingRequests('u')).fold((_) => null, (l) => l.single.registrationOrigin),
          RegistrationOrigin.conciergeRegistration);
      expect((await repo.updateAccessRequestStatus(1, 'APROVADO', DateTime(2027))).fold((_) => null, (b) => b), isTrue);
      expect(ds.statusBody!.expiresAt, DateTime(2027));
      expect((await repo.deleteSubUser('u', 'c')).fold((_) => null, (b) => b), isTrue);
    });

    test('conflito de inserção vira InsertSubUserConflictFailure', () async {
      final conflict = ApiFailure.fromJson({'failure': 'insert_sub_user_conflict_failure', 'title': 'já existe'});
      final repo = SubUserRepositoryImpl(dataSource: _FakeDataSource(error: conflict));
      final failure = (await repo.insertSubUser(_user())).fold((f) => f, (_) => null);
      expect(failure, isA<InsertSubUserConflictFailure>());
      expect((failure as KnownFailure).code, 'já existe');
      final other = SubUserRepositoryImpl(dataSource: _FakeDataSource(error: ApiFailure.fromJson({'failure': 'x'})));
      expect((await other.insertSubUser(_user())).fold((f) => f, (_) => null), isA<UnknownFailure>());
    });

    test('exceções genéricas', () async {
      final repo = SubUserRepositoryImpl(dataSource: _FakeDataSource(error: Exception('x')));
      expect((await repo.getSubUsers('u')).fold((f) => f, (_) => null), isA<UnknownFailure>());
      expect((await repo.updateSubUser(_user())).fold((f) => f, (_) => null), isA<UnknownFailure>());
      expect((await repo.insertSubUser(_user())).fold((f) => f, (_) => null), isA<UnknownFailure>());
      expect((await repo.getRoles()).fold((f) => f, (_) => null), isA<UnknownFailure>());
      expect((await repo.checkSeventhService('R1')).fold((f) => f, (_) => null), isA<UnknownFailure>());
      expect((await repo.sendAccessRenewRequest('u')).fold((f) => f, (_) => null), isA<UnknownFailure>());
      expect((await repo.getPendingRequests('u')).fold((f) => f, (_) => null), isA<UnknownFailure>());
      expect((await repo.updateAccessRequestStatus(1, 's', null)).fold((f) => f, (_) => null), isA<UnknownFailure>());
      expect((await repo.deleteSubUser('u', 'c')).fold((f) => f, (_) => null), isA<UnknownFailure>());
    });
  });

  test('data source', () async {
    final api = MockApi();
    registerFallbackValue(SubUserModel());
    registerFallbackValue(UpdateAccessRequestStatusModel());
    final ds = SubUserRemoteDataSourceImpl(api: api);
    Response<dynamic> ok(Object body) => Response<dynamic>(http.Response(jsonEncode(body), 200), body);
    when(() => api.fetchSubUser('u')).thenAnswer((_) async => ok([{'id': '1'}]));
    when(() => api.upateSubUser(any())).thenAnswer((_) async => ok([{'id': '2'}]));
    when(() => api.insertSubUser(any())).thenAnswer((_) async => ok([{'id': '3'}]));
    when(() => api.fetchSubUserRoles()).thenAnswer((_) async => ok([{'role': 'r'}]));
    when(() => api.checkSeventhService('R1')).thenAnswer((_) async => ok({'condominium_active': true}));
    when(() => api.sendAccessRenewRequest('u')).thenAnswer((_) async => Response<dynamic>(http.Response('enviado', 200), 'enviado'));
    when(() => api.getPendingRequests('u', 'PENDENTE_PROPRIETARIO')).thenAnswer((_) async => ok([{'id': 9}]));
    when(() => api.updateAccessRequestStatus(any())).thenAnswer((_) async => Response<dynamic>(http.Response('', 200), null));
    when(() => api.deleteSubUser('u', 'c')).thenAnswer((_) async => Response<dynamic>(http.Response('true', 200), true));
    expect((await ds.getSubUsers('u'))!.single.id, '1');
    expect((await ds.updateSubUser(SubUserModel()))!.single.id, '2');
    expect((await ds.insertSubUser(SubUserModel()))!.single.id, '3');
    expect((await ds.getRoles())!.single.role, 'r');
    expect((await ds.checkSeventhService('R1')).condominiumActive, isTrue);
    expect(await ds.sendAccessRenewRequest('u'), 'enviado');
    expect((await ds.getPendingRequests('u')).single.id, 9);
    expect(await ds.updateAccessRequestStatus(UpdateAccessRequestStatusModel()), isTrue);
    expect(await ds.deleteSubUser('u', 'c'), isTrue);

    /// Corrigido: updateAccessRequestStatus lança quando a resposta não é
    /// sucesso (antes devolvia `isSuccessful` e HTTP 500 virava Success(false)).
    when(() => api.updateAccessRequestStatus(any()))
        .thenAnswer((_) async => Response<dynamic>(http.Response('erro', 500), null, error: 'erro'));
    await expectLater(ds.updateAccessRequestStatus(UpdateAccessRequestStatusModel()), throwsA('erro'));
    when(() => api.updateAccessRequestStatus(any()))
        .thenAnswer((_) async => Response<dynamic>(http.Response('', 500), null));
    await expectLater(ds.updateAccessRequestStatus(UpdateAccessRequestStatusModel()), throwsA(''));
  });
}
