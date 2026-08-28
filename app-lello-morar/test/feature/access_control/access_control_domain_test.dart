import 'dart:convert';
import 'dart:io';

import 'package:chopper/chopper.dart' show Response;
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:morar/core/uploader/uploader.dart';
import 'package:morar/feature/access_control/data/data_source/access_control_api.dart';
import 'package:morar/feature/access_control/data/data_source/access_control_remote_data_source.dart';
import 'package:morar/feature/access_control/data/data_source/access_control_remote_data_source_impl.dart';
import 'package:morar/feature/access_control/data/model/access_control_authorizations_model.dart';
import 'package:morar/feature/access_control/data/model/access_control_date_model.dart';
import 'package:morar/feature/access_control/data/model/access_control_gest_units_model.dart';
import 'package:morar/feature/access_control/data/model/access_control_itens_model.dart';
import 'package:morar/feature/access_control/data/model/access_control_model.dart';
import 'package:morar/feature/access_control/data/model/access_control_recurrence_model.dart';
import 'package:morar/feature/access_control/data/model/access_control_register_facial_response_model.dart';
import 'package:morar/feature/access_control/data/model/access_control_send_invite_model.dart';
import 'package:morar/feature/access_control/data/model/access_control_visitant_model.dart';
import 'package:morar/feature/access_control/data/model/url_upload_s3_model.dart';
import 'package:morar/feature/access_control/data/repository/access_control_repository_impl.dart';
import 'package:morar/feature/access_control/domain/entity/access_control.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_authorizations.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_date.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_gest_units.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_invite_forward_type.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_itens.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_recurrence.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_register_facial_response.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_send_invite.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_stauts_biometric_enum.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_tyoe_visit_enum.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_type_entry_enum.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_visitant.dart';
import 'package:morar/feature/access_control/domain/entity/access_invite_user_type_enum.dart';
import 'package:morar/feature/access_control/domain/repository/access_control_repository.dart';
import 'package:morar/feature/access_control/domain/use_case/facial_biometric/facial_biometric_usecase.dart';
import 'package:morar/feature/access_control/domain/use_case/facial_biometric/facial_biometric_usecase_impl.dart';
import 'package:morar/feature/access_control/domain/use_case/visit/add_visit.dart';
import 'package:morar/feature/access_control/domain/use_case/visit/add_visit_impl.dart';
import 'package:morar/feature/access_control/domain/use_case/visit/delete_visit.dart';
import 'package:morar/feature/access_control/domain/use_case/visit/delete_visit._impl.dart';
import 'package:morar/feature/access_control/domain/use_case/visit/edit_visit.dart';
import 'package:morar/feature/access_control/domain/use_case/visit/edit_visit_impl.dart';
import 'package:morar/feature/access_control/domain/use_case/visitant/delete_visitant.dart';
import 'package:morar/feature/access_control/domain/use_case/visitant/delete_visitant_impl.dart';
import 'package:morar/feature/access_control/domain/use_case/visitant/edit_visitant.dart';
import 'package:morar/feature/access_control/domain/use_case/visitant/edit_visitant_impl.dart';
import 'package:morar/feature/access_control/domain/use_case/visitant/get_visitants.dart';
import 'package:morar/feature/access_control/domain/use_case/visitant/get_visitants_impl.dart';
import 'package:morar/feature/access_control/domain/use_case/visitant/save_visitant.dart';
import 'package:morar/feature/access_control/domain/use_case/visitant/save_visitant_impl.dart';
import 'package:shared_features/shared_features.dart';

import '../../helpers/firebase_mocks.dart';
import '../../helpers/fixtures.dart';

class MockApi extends Mock implements AccessControlApi {}

File _tempFile() {
  final file = File('${Directory.systemTemp.path}/morar_access_control.jpg');
  file.writeAsStringSync('x');
  return file;
}

AccessControlRecurrence _recurrence() => AccessControlRecurrence(
      idRecurrence: 'rec',
      recurrenceType: 'WEEKLY',
      interval: 1,
      itens: [
        AccessControlItens(recurrenceValue: 2, start: AccessControlDate(hour: 8, minute: 0), end: AccessControlDate(hour: 10, minute: 30)),
        AccessControlItens(recurrenceValue: 6, start: AccessControlDate(hour: 8), end: AccessControlDate(hour: 9)),
      ],
    );

AccessControlAuthorizations _authorization({AccessControlRecurrence? recurrence, String? type = 'ACESSO_GRANTED'}) => AccessControlAuthorizations(
      id: 'a1',
      idConcierge: 'c',
      idGest: 'g',
      idUnit: 'u',
      start: '2026-03-01T10:00:00',
      end: '2026-03-01T12:00:00',
      autorizationType: type,
      recurrence: recurrence,
      useFacialBiometric: true,
    );

AccessControl _gest({String? document = '123.456.789-01', String? foreign, String? typeDocument, dynamic type = 'VISITOR'}) => AccessControl(
      idGest: 'g1',
      business: 'Empresa',
      document: document,
      foreignDocument: foreign,
      typeDocument: typeDocument,
      name: 'Carlos',
      type: type,
      phone: '(11) 99999-8888',
      statusBiometric: StatusBiometric.CADASTRADA,
      gestUnits: [
        AccessControlGestUnits(
          idGestUnit: 'gu',
          unit: testUnity(),
          relation: 'amigo',
          autorizationType: 'ACESSO_GRANTED',
          observation: 'obs',
          authorizations: [_authorization(recurrence: _recurrence())],
        ),
      ],
    );

class _FakeDataSource extends Fake implements AccessControlRemoteDataSource {
  _FakeDataSource({this.fail = false});
  final bool fail;
  AccessControlVisitantModel? visitant;
  AccessControlAuthorizationsModel? visit;
  AccessControlSendInviteModel? invite;

  @override
  Future<List<AccessControlModel>> listVisitants(String unitId) async {
    if (fail) throw Exception('x');
    return [AccessControlModel(idGest: unitId, statusBiometric: 'CADASTRADA')];
  }

  @override
  Future<AccessControlModel> saveVisitant(AccessControlVisitantModel v) async {
    if (fail) throw Exception('x');
    visitant = v;
    return v.gest!;
  }

  @override
  Future<String> editVisitant(AccessControlVisitantModel v) async {
    if (fail) throw Exception('x');
    visitant = v;
    return '';
  }

  @override
  Future<String> deleteVisitant(String gestId) async {
    if (fail) throw Exception('x');
    return '';
  }

  @override
  Future<String> addVisit(String gestId, String unitId, AccessControlAuthorizationsModel model) async {
    if (fail) throw Exception('x');
    visit = model;
    return '';
  }

  @override
  Future<String> deleteVisit(String recurrenceId) async {
    if (fail) throw Exception('x');
    return '';
  }

  @override
  Future<String> editVisit(AccessControlAuthorizationsModel model, String recurrenceId) async {
    if (fail) throw Exception('x');
    visit = model;
    return '';
  }

  @override
  Future<AccessControlRegisterFacialResponseModel> registerFacialBiometric(String hash) async {
    if (fail) throw Exception('x');
    return AccessControlRegisterFacialResponseModel(success: true, codigo: hash);
  }

  @override
  Future<UrlUploadS3Model> getUrlAws() async {
    if (fail) throw Exception('x');
    return UrlUploadS3Model(fileName: 'foto.jpg', url: 'https://s3');
  }

  @override
  Future<String> sendInvite(AccessControlSendInviteModel model) async {
    if (fail) throw Exception('x');
    invite = model;
    return 'enviado';
  }
}

class _FakeUploader extends Fake implements Uploader {
  _FakeUploader({this.fail = false, this.throws = false});
  final bool fail;
  final bool throws;
  @override
  Future<String> uploadS3(String url, File file, {required Function(String) onComplete, required Function(Exception) onError}) async {
    if (throws) throw Exception('boom');
    if (fail) {
      onError(Exception('x'));
    } else {
      onComplete('Sended');
    }
    return 'Sending';
  }
}

class _FakeRepository extends Fake implements AccessControlRepository {
  _FakeRepository({this.failure});
  final Failure? failure;
  final calls = <String>[];

  @override
  Future<Try<List<AccessControl>>> listVisitants(String unitId) async {
    calls.add('list:$unitId');
    if (failure != null) return Rejection(failure!);
    return Success([_gest()]);
  }

  @override
  Future<Try<AccessControl>> saveVisitant(AccessControlVisitant visitant) async {
    calls.add('save:${visitant.gest?.name}');
    return Success(_gest());
  }

  @override
  Future<Try<String>> editVisitant(AccessControlVisitant visitant) async {
    calls.add('editVisitant:${visitant.idGestUnit}');
    return Success('');
  }

  @override
  Future<Try<String>> deleteVisitant(String gestId) async {
    calls.add('deleteVisitant:$gestId');
    return Success('');
  }

  @override
  Future<Try<String>> addVisit(String gestId, String unitId, AccessControlAuthorizations model) async {
    calls.add('addVisit:$gestId:$unitId');
    return Success('');
  }

  @override
  Future<Try<String>> deleteVisit(String recurrenceId) async {
    calls.add('deleteVisit:$recurrenceId');
    return Success('');
  }

  @override
  Future<Try<String>> editVisit(AccessControlAuthorizations model, String recurrenceId) async {
    calls.add('editVisit:$recurrenceId');
    return Success('');
  }

  @override
  Future<Try<UrlUploadS3>> getUrlAws() async {
    calls.add('aws');
    if (failure != null) return Rejection(failure!);
    return Success(UrlUploadS3(fileName: 'hash.jpg', url: 'u'));
  }

  @override
  Future<Try<String>> uploadImageToAws(File file, String url) async {
    calls.add('upload:$url');
    return Success('ok');
  }

  @override
  Future<Try<AccessControlRegisterFacialResponse>> registerFacialBiometric(String hash) async {
    calls.add('facial:$hash');
    return Success(AccessControlRegisterFacialResponse(success: true));
  }
}

class _FakeAwsUpload extends Fake implements AwsUploadFileUsecase {
  _FakeAwsUpload({this.fail = false});
  final bool fail;
  @override
  Future<Try<UrlUploadS3>> call(AwsUploadFileParam params) async {
    if (fail) return Rejection(UnknownFailure('x'));
    final url = await params.getUrlUploadS3();
    return url.fold((f) => Rejection(f), (u) async => (await params.uploadFileToS3(params.file, u.url)).fold((f) => Rejection(f), (_) => Success(u)));
  }
}

void main() {
  setUpAll(() async {
    await setUpFakeFirebase();
  });

  group('entidades', () {
    test('AccessControl', () {
      final gest = _gest();
      expect(gest.prestador, isFalse);
      expect(_gest(type: 'SERVICE').prestador, isTrue);
      expect(gest.documentFormatted, '12345678901');
      expect(_gest(document: null, foreign: 'AB-12.3').documentFormatted, 'AB123');
      expect(_gest(document: null).documentFormatted, isNull);
      expect(_gest(typeDocument: 'RNE').typeDocumentFormatted, 'RNE');
      expect(_gest(typeDocument: 'PASSPORT').typeDocumentFormatted, 'Passaporte');
      expect(gest.typeDocumentFormatted, isNull);
      expect(gest.toString(), contains('name: Carlos'));
    });

    test('AccessControlAuthorizations', () {
      final auth = _authorization(recurrence: _recurrence());
      expect(auth.startDate, DateTime(2026, 3, 1, 10));
      expect(auth.endDate, DateTime(2026, 3, 1, 12));
      expect(_authorization(recurrence: null).recorrente, 'Pontual');
      expect(auth.recorrente, 'Recorrente');
      expect(auth.authType, 'Recorrente');
      expect(_authorization(type: 'PHONE').authType, 'Interfonar');
      expect(_authorization(type: 'PONTUAL').authType, 'Pontual');
      expect(_authorization(type: 'x').authType, 'Interfonar');
      expect(auth.getRecurrenceDays, 'Seg, Sex');
      expect(auth.choices, [false, true, false, false, false, true, false]);
      expect(auth.getRecurrenceDays, 'Seg, Sex');
      expect(_authorization(recurrence: null).getRecurrenceDays, '');
      final semStart = AccessControlAuthorizations();
      expect(semStart.startDate.year, DateTime.now().year);
      expect(semStart.endDate.year, DateTime.now().year);
      expect(auth.toString(), contains('id: a1'));
      expect(AccessControlDate(hour: 1).toString(), contains('hour: 1'));
      expect(AccessControlItens(recurrenceValue: 1).toString(), contains('recurrenceValue: 1'));
      expect(_recurrence().toString(), contains('idRecurrence: rec'));
    });

    test('AccessControlGestUnits e enums', () {
      final unit = _gest().gestUnits.single;
      expect(unit.recorrente, isTrue);
      expect(unit.authType, 'Recorrente');
      expect(unit.editAuthTypeVisit, 'Recorrente');
      final pontual = AccessControlGestUnits(authorizations: const [], autorizationType: 'PHONE');
      expect(pontual.authType, 'Interfonar');
      expect(pontual.editAuthTypeVisit, 'Pontual');
      expect(unit.toString(), contains('relation: amigo'));
      expect(AccessControlTypeVisit.values, hasLength(2));
      expect(AccessControlTypeEntry.values, hasLength(3));
      expect(AccessControlInviteUserType.values, hasLength(5));
      expect(AccessControlInviteForwardType.values, hasLength(2));
      expect(AccessControlVisitant().units, isEmpty);
    });
  });

  group('models', () {
    test('AccessControlModel round trip', () {
      final model = AccessControlModel.fromEntity(_gest())!;
      final json = jsonDecode(jsonEncode(model.toJson())) as Map<String, dynamic>;
      expect(json['gest_units'][0]['authorizations'][0]['recurrence']['itens'][0]['recurrence_value'], 2);
      expect(json['gest_units'][0]['unit']['id'], 'u1');
      json['status_biometric'] = 'CADASTRADA';
      final back = AccessControlModel.fromJson(json).toEntity();
      expect(back.statusBiometric, StatusBiometric.CADASTRADA);
      expect(back.gestUnits.single.authorizations.single.recurrence!.itens!.first.start!.hour, 8);
      expect(back.gestUnits.single.unit!.id, 'u1');
      expect(AccessControlModel().toEntity().statusBiometric, StatusBiometric.NAO_CADASTRADA);
      expect(AccessControlModel(statusBiometric: 0).toEntity().statusBiometric, StatusBiometric.NAO_CADASTRADA);
      expect(AccessControlModel().toEntity().gestUnits, isEmpty);
      expect(AccessControlModel.fromEntity(null), isNull);
    });

    test('modelos auxiliares', () {
      expect(AccessControlAuthorizationsModel.fromEntity(null), isNull);
      final auth = AccessControlAuthorizationsModel.fromEntity(_authorization(recurrence: _recurrence()))!;
      expect(auth.toString(), contains('id: a1'));
      final authBack = AccessControlAuthorizationsModel.fromJson(jsonDecode(jsonEncode(auth.toJson()))).toEntity();
      expect(authBack.useFacialBiometric, isTrue);
      expect(authBack.recurrence!.itens, hasLength(2));
      expect(AccessControlAuthorizationsModel().toEntity().useFacialBiometric, isFalse);
      expect(AccessControlAuthorizationsModel().toEntity().recurrence, isNull);

      expect(AccessControlDateModel.fromEntity(null), isNull);
      expect(AccessControlDateModel.fromJson({'hour': 2, 'nano': 1}).toEntity().nano, 1);
      expect(AccessControlItensModel.fromEntity(null), isNull);
      expect(AccessControlItensModel.fromJson({'recurrence_value': 3}).toEntity().recurrenceValue, 3);
      expect(AccessControlRecurrenceModel.fromEntity(null), isNull);
      expect(AccessControlRecurrenceModel.fromEntity(AccessControlRecurrence())!.itens, isEmpty);
      expect(AccessControlRecurrenceModel().toEntity().itens, isEmpty);
      expect(AccessControlRecurrenceModel.fromEntity(_recurrence())!.toString(), contains('WEEKLY'));
      expect(AccessControlGestUnitsModel.fromEntity(null), isNull);
      expect(AccessControlGestUnitsModel().toEntity().authorizations, isEmpty);

      final facial = AccessControlRegisterFacialResponseModel.fromEntity(AccessControlRegisterFacialResponse(status: 's', success: true, timestamp: DateTime(2026)))!;
      expect(AccessControlRegisterFacialResponseModel.fromJson(jsonDecode(jsonEncode(facial.toJson()))).toEntity().success, isTrue);
      expect(AccessControlRegisterFacialResponseModel.fromEntity(null), isNull);

      final invite = AccessControlSendInviteModel.fromEntity(AccessControlSendInviteEntity(
        cpf: 'c', name: 'n', phone: 'p', userType: AccessControlInviteUserType.gest, forwardType: AccessControlInviteForwardType.sms,
      ))!;
      expect(invite.userType, 'gest');
      expect(invite.forwardType, 'sms');
      final inviteBack = AccessControlSendInviteModel.fromJson(invite.toJson()).toEntity();
      expect(inviteBack.userType, AccessControlInviteUserType.gest);
      expect(inviteBack.forwardType, AccessControlInviteForwardType.sms);
      expect(AccessControlSendInviteModel.fromEntity(null), isNull);

      final visitant = AccessControlVisitantModel.fromEntity(AccessControlVisitant(idGestUnit: 'gu', autorizarionType: 1, gest: _gest(), units: [testUnity()]))!;
      expect(visitant.toString(), contains('idAccessControl: gu'));
      final visitantBack = AccessControlVisitantModel.fromJson(jsonDecode(jsonEncode(visitant.toJson()))).toEntity();
      expect(visitantBack.units.single.id, 'u1');
      expect(visitantBack.gest!.name, 'Carlos');
      expect(AccessControlVisitantModel().toEntity().units, isEmpty);
      expect(AccessControlVisitantModel.fromEntity(null), isNull);

      final aws = UrlUploadS3Model.fromEntity(UrlUploadS3(fileName: 'f', url: 'u'));
      expect(UrlUploadS3Model.fromJson(aws.toJson()).toEntity().url, 'u');
    });
  });

  test('use cases', () async {
    final repo = _FakeRepository();
    Failure? f(Try r) => r.fold((e) => e, (_) => null);
    expect(f(await AddVisitImpl(repository: repo)(AddVisitParam(gestId: '', unitId: 'u', model: _authorization()))), isA<InvalidParamFailure>());
    expect(f(await AddVisitImpl(repository: repo)(AddVisitParam(gestId: 'g', unitId: '', model: _authorization()))), isA<InvalidParamFailure>());
    expect(f(await DeleteVisitImpl(repository: repo)(DeleteVisitParam(recurrenceId: ''))), isA<InvalidParamFailure>());
    expect(f(await EditVisitImpl(repository: repo)(EditVisitParam(recurrenceId: '', model: _authorization()))), isA<InvalidParamFailure>());
    expect(f(await DeleteVisitantImpl(repository: repo)(DeleteVisitantParam(gestId: ''))), isA<InvalidParamFailure>());
    expect(f(await GetVisitantsImpl(repository: repo)(GetVisitantsParam(unitId: ''))), isA<InvalidParamFailure>());
    expect(repo.calls, isEmpty);

    await AddVisitImpl(repository: repo)(AddVisitParam(gestId: 'g', unitId: 'u', model: _authorization()));
    await DeleteVisitImpl(repository: repo)(DeleteVisitParam(recurrenceId: 'r'));
    await EditVisitImpl(repository: repo)(EditVisitParam(recurrenceId: 'r', model: _authorization()));
    await DeleteVisitantImpl(repository: repo)(DeleteVisitantParam(gestId: 'g'));
    await EditVisitantImpl(repository: repo)(EditVisitantParam(visitant: AccessControlVisitant(idGestUnit: 'gu')));
    await GetVisitantsImpl(repository: repo)(GetVisitantsParam(unitId: 'u'));
    await SaveVisitantImpl(repository: repo)(SaveVisitantParam(visitant: AccessControlVisitant(gest: _gest())));
    expect(repo.calls, ['addVisit:g:u', 'deleteVisit:r', 'editVisit:r', 'deleteVisitant:g', 'editVisitant:gu', 'list:u', 'save:Carlos']);
  });

  test('FacialBiometricUsecaseImpl', () async {
    final repo = _FakeRepository();
    final useCase = FacialBiometricUsecaseImpl(repository: repo, awsUploadFileUsecase: _FakeAwsUpload());
    expect((await useCase(FacialBiometricParam(file: File('')))).fold((f) => f, (_) => null), isA<InvalidParamFailure>());
    final ok = await useCase(FacialBiometricParam(file: _tempFile()));
    expect(ok.fold((_) => null, (r) => r.success), isTrue);
    expect(repo.calls, ['aws', 'upload:u', 'facial:hash.jpg']);
    final failed = await FacialBiometricUsecaseImpl(repository: repo, awsUploadFileUsecase: _FakeAwsUpload(fail: true))(FacialBiometricParam(file: _tempFile()));
    expect((failed.fold((f) => f, (_) => null) as KnownFailure).error, 'upload_file_error');
  });

  group('AccessControlRepositoryImpl', () {
    test('sucesso', () async {
      final ds = _FakeDataSource();
      final repo = AccessControlRepositoryImpl(remoteDataSource: ds, uploader: _FakeUploader());
      expect((await repo.listVisitants('u')).fold((_) => null, (l) => l.single.statusBiometric), StatusBiometric.CADASTRADA);
      final visitant = AccessControlVisitant(idGestUnit: 'gu', autorizarionType: 1, observation: 'o', gest: _gest(), units: [testUnity()]);
      expect((await repo.saveVisitant(visitant)).fold((_) => null, (g) => g.name), 'Carlos');
      expect(ds.visitant!.gest!.phone, '11999998888');
      expect((await repo.editVisitant(visitant)).fold((_) => null, (r) => r), '');
      expect(ds.visitant!.idGestUnit, 'gu');
      expect((await repo.deleteVisitant('g')).fold((_) => null, (r) => r), '');
      expect((await repo.addVisit('g', 'u', _authorization(recurrence: _recurrence()))).fold((_) => null, (r) => r), '');
      expect(ds.visit!.recurrence!.itens, hasLength(2));
      expect(ds.visit!.recurrence!.itens.first!.end!.minute, 30);
      expect((await repo.addVisit('g', 'u', _authorization())).fold((_) => null, (r) => r), '');
      expect(ds.visit!.recurrence, isNull);
      expect((await repo.deleteVisit('r')).fold((_) => null, (r) => r), '');
      expect((await repo.editVisit(_authorization(recurrence: AccessControlRecurrence()), 'r')).fold((_) => null, (r) => r), '');
      expect(ds.visit!.recurrence!.recurrenceType, '');
      expect((await repo.editVisit(_authorization(), 'r')).fold((_) => null, (r) => r), '');
      expect((await repo.getUrlAws()).fold((_) => null, (u) => u.fileName), 'foto.jpg');
      expect((await repo.uploadImageToAws(_tempFile(), 'u')).fold((_) => null, (r) => r), 'Sended');
      expect((await repo.registerFacialBiometric('h')).fold((_) => null, (r) => r.codigo), 'h');
      expect((await repo.sendInvite(AccessControlSendInviteEntity(name: 'n', userType: AccessControlInviteUserType.resident))).fold((_) => null, (r) => r), 'enviado');
      expect(ds.invite!.userType, 'resident');
    });

    test('falhas', () async {
      final repo = AccessControlRepositoryImpl(remoteDataSource: _FakeDataSource(fail: true), uploader: _FakeUploader(fail: true));
      Failure? f(Try r) => r.fold((e) => e, (_) => null);
      expect(f(await repo.listVisitants('u')), isA<UnknownFailure>());
      expect(f(await repo.saveVisitant(AccessControlVisitant())), isA<UnknownFailure>());
      expect(f(await repo.editVisitant(AccessControlVisitant())), isA<UnknownFailure>());
      expect(f(await repo.deleteVisitant('g')), isA<UnknownFailure>());
      expect(f(await repo.addVisit('g', 'u', _authorization())), isA<UnknownFailure>());
      expect(f(await repo.deleteVisit('r')), isA<UnknownFailure>());
      expect(f(await repo.editVisit(_authorization(), 'r')), isA<UnknownFailure>());
      expect(f(await repo.getUrlAws()), isA<UnknownFailure>());
      expect(f(await repo.uploadImageToAws(_tempFile(), 'u')), isA<UnknownFailure>());
      expect(f(await repo.registerFacialBiometric('h')), isA<UnknownFailure>());
      expect(f(await repo.sendInvite(AccessControlSendInviteEntity())), isA<UnknownFailure>());
      final throwing = AccessControlRepositoryImpl(remoteDataSource: _FakeDataSource(), uploader: _FakeUploader(throws: true));
      expect(f(await throwing.uploadImageToAws(_tempFile(), 'u')), isA<UnknownFailure>());
    });
  });

  test('data source', () async {
    final api = MockApi();
    registerFallbackValue(AccessControlVisitantModel());
    registerFallbackValue(AccessControlAuthorizationsModel());
    registerFallbackValue(AccessControlSendInviteModel());
    final ds = AccessControlRemoteDataSourceImpl(api: api);
    Response<dynamic> ok([Object? body]) => Response<dynamic>(http.Response(body == null ? '' : jsonEncode(body), 200), body);
    final err = Response<dynamic>(http.Response('', 500), null, error: 'err');
    when(() => api.getVisitants('u')).thenAnswer((_) async => ok([{'id_gest': 'g'}]));
    when(() => api.saveVisitant(any())).thenAnswer((_) async => ok({'id_gest': 'g'}));
    when(() => api.editVisitant(any())).thenAnswer((_) async => ok());
    when(() => api.deleteVisitant('g')).thenAnswer((_) async => ok());
    when(() => api.deleteVisitant('e')).thenAnswer((_) async => err);
    when(() => api.saveVisit(any(), 'g', 'u')).thenAnswer((_) async => ok());
    when(() => api.saveVisit(any(), 'e', 'u')).thenAnswer((_) async => err);
    when(() => api.deleteVisit('r')).thenAnswer((_) async => ok());
    when(() => api.deleteVisit('e')).thenAnswer((_) async => err);
    when(() => api.editVisit(any(), 'r')).thenAnswer((_) async => ok());
    when(() => api.editVisit(any(), 'e')).thenAnswer((_) async => err);
    when(() => api.getAwsUrl()).thenAnswer((_) async => ok({'file_name': 'f', 'url': 'u'}));
    when(() => api.registerFacialBiometric('h')).thenAnswer((_) async => ok({'success': true}));
    when(() => api.sendInvite(any())).thenAnswer((_) async => Response<dynamic>(http.Response('ok', 200), 'ok'));
    expect((await ds.listVisitants('u')).single.idGest, 'g');
    expect((await ds.saveVisitant(AccessControlVisitantModel())).idGest, 'g');
    expect(await ds.editVisitant(AccessControlVisitantModel()), '');
    expect(await ds.deleteVisitant('g'), '');
    expect(() => ds.deleteVisitant('e'), throwsA('err'));
    expect(await ds.addVisit('g', 'u', AccessControlAuthorizationsModel()), '');
    expect(() => ds.addVisit('e', 'u', AccessControlAuthorizationsModel()), throwsA('err'));
    expect(await ds.deleteVisit('r'), '');
    expect(() => ds.deleteVisit('e'), throwsA('err'));
    expect(await ds.editVisit(AccessControlAuthorizationsModel(), 'r'), '');
    expect(() => ds.editVisit(AccessControlAuthorizationsModel(), 'e'), throwsA('err'));
    expect((await ds.getUrlAws()).fileName, 'f');
    expect((await ds.registerFacialBiometric('h')).success, isTrue);
    expect(await ds.sendInvite(AccessControlSendInviteModel()), 'ok');
    when(() => api.editVisitant(any())).thenAnswer((_) async => err);
    expect(() => ds.editVisitant(AccessControlVisitantModel()), throwsA('err'));
    when(() => api.sendInvite(any())).thenAnswer((_) async => err);
    expect(() => ds.sendInvite(AccessControlSendInviteModel()), throwsA('err'));
  });
}
