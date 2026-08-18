import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:colaborador/feature/authentication_tablet/data/data_source/remote/authentication_tablet_api.dart';
import 'package:colaborador/feature/authentication_tablet/data/data_source/remote/authentication_tablet_remote_data_source_impl.dart';
import 'package:colaborador/feature/authentication_tablet/data/model/condominium_code_info_model.dart';
import 'package:colaborador/feature/digital_point/data/data_source/remote/digital_point_api.dart';
import 'package:colaborador/feature/digital_point/data/data_source/remote/digital_point_remote_data_source_impl.dart';
import 'package:colaborador/feature/digital_point/data/model/digital_point_model.dart';
import 'package:colaborador/feature/documents/data/data_source/documents_api.dart';
import 'package:colaborador/feature/documents/data/data_source/documents_remote_data_source_impl.dart';
import 'package:colaborador/feature/documents/data/model/document_file_model.dart';
import 'package:colaborador/feature/documents/data/model/document_info_model.dart';
import 'package:colaborador/feature/employee_referral/data/data_source/employee_referral_api.dart';
import 'package:colaborador/feature/employee_referral/data/data_source/employee_referral_remote_data_source_impl.dart';
import 'package:colaborador/feature/employee_referral/data/model/city_model.dart';
import 'package:colaborador/feature/employee_referral/data/model/employee_referral_model.dart';
import 'package:colaborador/feature/manual_timesheet/data/data_source/remote/manual_timesheet_api.dart';
import 'package:colaborador/feature/manual_timesheet/data/data_source/remote/manual_timesheet_remote_data_source_impl.dart';
import 'package:colaborador/feature/manual_timesheet/data/model/manual_timesheet_model.dart';
import 'package:colaborador/feature/me/data/data_source/remote/me_api.dart';
import 'package:colaborador/feature/me/data/data_source/remote/me_remote_data_source_impl.dart';
import 'package:colaborador/feature/me/data/model/me_model.dart';
import 'package:colaborador/feature/me/data/model/me_password_model.dart';
import 'package:colaborador/feature/proof/data/data_source/remote/proof_api.dart';
import 'package:colaborador/feature/proof/data/data_source/remote/proof_remote_data_source_impl.dart';
import 'package:colaborador/feature/proof/data/model/proof_file_model.dart';
import 'package:colaborador/feature/proof/data/model/proof_model.dart';
import 'package:colaborador/feature/sick_note/data/data_source/remote/sick_note_api.dart';
import 'package:colaborador/feature/sick_note/data/data_source/remote/sick_note_remote_data_source_impl.dart';
import 'package:colaborador/feature/sick_note/data/model/sick_note_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Response<dynamic> _ok(dynamic body) {
  final encoded = body is String ? body : jsonEncode(body);
  return Response(http.Response(encoded, 200), body);
}

Response<dynamic> _fail() => Response(http.Response('erro', 500), 'erro');

class _FakeDocumentsApi extends Fake implements DocumentsApi {
  bool failList = false;
  bool failFile = false;

  @override
  Future<Response<dynamic>> getDocumentsInfoList(
    String condoId,
    String documentType,
    DateTime? dateFrom,
    DateTime? dateTo,
  ) async =>
      failList
          ? _fail()
          : _ok([
              {
                'name': 'doc.pdf',
                'type': 'payStub',
                'document_processing_date': '2026-01-10T00:00:00.000',
              },
            ]);

  @override
  Future<Response<dynamic>> getDocumentsFile(String documentName) async =>
      failFile
          ? _fail()
          : _ok({
              'id': '1',
              'name': documentName,
              'type': 'pdf',
              'data': 'abc',
            });
}

class _FakeSickApi extends Fake implements SickNoteApi {
  bool failRegister = false;
  bool failGetUrl = false;

  @override
  Future<Response<dynamic>> getAwsUrl(String condoId) async =>
      failGetUrl ? _fail() : _ok({
        'file_name': 'f.jpg',
        'url': 'http://s3/x',
      });

  @override
  Future<Response<dynamic>> registerSickNote(
    SickNoteModel model,
    String condoId,
  ) async =>
      failRegister ? _fail() : _ok({});
}

class _FakeManualApi extends Fake implements ManualTimeSheetApi {
  bool failRegister = false;
  bool failGetUrl = false;

  @override
  Future<Response<dynamic>> getAwsUrl(String condoId) async =>
      failGetUrl ? _fail() : _ok({
        'file_name': 'f.jpg',
        'url': 'http://s3/x',
      });

  @override
  Future<Response<dynamic>> registerManualTimeSheet(
    ManualTimeSheetModel model,
    String condoId,
  ) async =>
      failRegister ? _fail() : _ok({});
}

class _FakeReferralApi extends Fake implements EmployeeReferralApi {
  bool failRegister = false;
  bool failGetUrl = false;
  bool failCities = false;

  @override
  Future<Response<dynamic>> getAwsUrl(
    String condoId,
    String employeeId,
  ) async =>
      failGetUrl
          ? _fail()
          : _ok({'file_name': 'f.jpg', 'url': 'http://s3/x'});

  @override
  Future<Response<dynamic>> registerEmployeeReferral(
    EmployeeReferralModel model,
    String condoId,
    String employeeId,
  ) async =>
      failRegister ? _fail() : _ok({});

  @override
  Future<Response<dynamic>> getCities(
    String condoId,
    String employeeId,
  ) async =>
      failCities
          ? _fail()
          : _ok([
              {'name': 'SP', 'regions': ['zona sul']},
            ]);
}

class _FakeDigitalPointApi extends Fake implements DigitalPointApi {
  bool fail = false;

  @override
  Future<Response<dynamic>> registerPoint(
    DigitalPointModel model,
    String condoId,
  ) async =>
      fail ? _fail() : _ok({});

  @override
  Future<Response<dynamic>> requestDigitalPointService(
    String condoId,
    String imageHash,
  ) async =>
      fail ? _fail() : _ok(true);

  @override
  Future<Response<dynamic>> getAwsUrl(String condoId) async =>
      fail ? _fail() : _ok({'file_name': 'f.jpg', 'url': 'http://s3/x'});

  @override
  Future<Response<dynamic>> checkDigitalPoint(
    String condoId,
    DateTime date,
  ) async =>
      fail ? _fail() : _ok(true);

  @override
  Future<Response<dynamic>> syncDigitalPointWithoutLogin(
    DigitalPointModel model,
  ) async =>
      fail ? _fail() : _ok(null);
}

class _FakeTabletApi extends Fake implements AuthenticationTabletApi {
  @override
  Future<Response<dynamic>> getInfoByCondominiumCode(int code) async => _ok({
        'condo_code': '123',
        'condominium': {
          'reference': 'R1',
          'name': 'Torre',
          'picturehash': 'p',
          'status': 'ok',
          'ref': 'r',
        },
        'employees': [],
      });
}

class _FakeMeApi extends Fake implements MeApi {
  @override
  Future<Response<dynamic>> get([int? idEmpresa]) async => _ok({
        'id': 'm1',
        'name': 'ana',
        'email': 'a@b.com',
        'cpf': '12345678901',
        'phone': '11',
        'picture_hash': 'h',
        'is_tablet_session': false,
        'condominiums': [],
      });

  @override
  Future<Response<dynamic>> patch(MeModel model, String code) async => _ok({
        'id': 'm1',
        'name': 'ana',
        'email': 'a@b.com',
        'cpf': '12345678901',
        'phone': '11',
        'picture_hash': 'h',
        'is_tablet_session': false,
        'condominiums': [],
      });

  @override
  Future<Response<dynamic>> updatePassword(MePasswordModel model) async =>
      _ok({});
}

class _FakeProofApi extends Fake implements ProofApi {
  bool failList = false;
  bool failFile = false;

  @override
  Future<Response<dynamic>> getProof(
    String condominiumId,
    DateTime date,
  ) async =>
      failList
          ? _fail()
          : _ok([
              {
                'nsr': 1,
                'date_time_clock_in': '2026-01-10T08:00:00.000',
                'proof_name': 'comprovante.pdf',
              },
            ]);

  @override
  Future<Response<dynamic>> getFileProof(
    String condominiumId,
    String fileName,
  ) async =>
      failFile ? _fail() : _ok({'content_bytes': 'YmFzZTY0'});
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DocumentsRemoteDataSourceImpl', () {
    test('lista documentos e busca arquivo', () async {
      final ds = DocumentsRemoteDataSourceImpl(api: _FakeDocumentsApi());
      final list = await ds.getDocumentsInfoList('c1', 'payStub', null, null);
      expect(list.first, isA<DocumentInfoModel>());
      final file = await ds.getDocumentFile('holerite.pdf');
      expect(file, isA<DocumentFileModel>());
      expect(file.name, 'holerite.pdf');
    });

    test('lança em falhas', () async {
      final api = _FakeDocumentsApi();
      final ds = DocumentsRemoteDataSourceImpl(api: api);
      api.failList = true;
      expect(
        () => ds.getDocumentsInfoList('c1', 'payStub', null, null),
        throwsA(anything),
      );
      api.failList = false;
      api.failFile = true;
      expect(() => ds.getDocumentFile('doc.pdf'), throwsA(anything));
    });
  });

  group('SickNoteRemoteDataSourceImpl', () {
    test('busca url e registra', () async {
      final ds = SickNoteRemoteDataSourceImpl(api: _FakeSickApi());
      expect((await ds.getUrlAws('c1')).url, 'http://s3/x');
      final model = SickNoteModel(
        date: DateTime(2026, 1, 10),
        fileHash: 'h',
        fileExtension: 'jpg',
        sickNoteDays: 2,
      );
      expect(await ds.registerSickNote(model, 'c1'), model);
    });

    test('lança ao registrar com erro', () async {
      final ds = SickNoteRemoteDataSourceImpl(
        api: _FakeSickApi()..failRegister = true,
      );
      expect(
        () => ds.registerSickNote(
          SickNoteModel(
            date: DateTime(2026, 1, 10),
            fileHash: 'h',
            fileExtension: 'jpg',
            sickNoteDays: 2,
          ),
          'c1',
        ),
        throwsA(anything),
      );
    });

    test('lança ao buscar url com erro', () async {
      final ds = SickNoteRemoteDataSourceImpl(
        api: _FakeSickApi()..failGetUrl = true,
      );
      expect(() => ds.getUrlAws('c1'), throwsA(anything));
    });
  });

  group('ManualTimeSheetRemoteDataSourceImpl', () {
    test('busca url e registra', () async {
      final ds = ManualTimeSheetRemoteDataSourceImpl(api: _FakeManualApi());
      expect((await ds.getUrlAws('c1')).fileName, 'f.jpg');
      final model = ManualTimeSheetModel(
        date: DateTime(2026, 1, 10),
        fileHash: 'h',
      );
      expect(await ds.registerManualTimeSheet(model, 'c1'), model);
    });

    test('lança ao registrar com erro', () async {
      final ds = ManualTimeSheetRemoteDataSourceImpl(
        api: _FakeManualApi()..failRegister = true,
      );
      expect(
        () => ds.registerManualTimeSheet(
          ManualTimeSheetModel(
            date: DateTime(2026, 1, 10),
            fileHash: 'h',
          ),
          'c1',
        ),
        throwsA(anything),
      );
    });

    test('lança ao buscar url com erro', () async {
      final ds = ManualTimeSheetRemoteDataSourceImpl(
        api: _FakeManualApi()..failGetUrl = true,
      );
      expect(() => ds.getUrlAws('c1'), throwsA(anything));
    });
  });

  group('EmployeeReferralRemoteDataSourceImpl', () {
    test('busca url, cidades e registra', () async {
      final ds = EmployeeReferralRemoteDataSourceImpl(api: _FakeReferralApi());
      expect((await ds.getUrlAws('c1', 'm1')).url, 'http://s3/x');
      final cities = await ds.getCities('c1', 'm1');
      expect(cities.first, isA<CityModel>());
      expect(cities.first.name, 'SP');
      final model = EmployeeReferralModel(
        description: 'vaga',
        city: 'SP',
        region: 'zona sul',
        hash: 'h',
      );
      expect(await ds.registerEmployeeReferral(model, 'c1', 'm1'), model);
    });

    test('lança ao registrar com erro', () async {
      final ds = EmployeeReferralRemoteDataSourceImpl(
        api: _FakeReferralApi()..failRegister = true,
      );
      expect(
        () => ds.registerEmployeeReferral(
          EmployeeReferralModel(
            description: 'vaga',
            city: 'SP',
            region: 'zona sul',
            hash: 'h',
          ),
          'c1',
          'm1',
        ),
        throwsA(anything),
      );
    });

    test('lança ao buscar url ou cidades com erro', () async {
      final api = _FakeReferralApi();
      final ds = EmployeeReferralRemoteDataSourceImpl(api: api);
      api.failGetUrl = true;
      expect(() => ds.getUrlAws('c1', 'm1'), throwsA(anything));
      api.failGetUrl = false;
      api.failCities = true;
      expect(() => ds.getCities('c1', 'm1'), throwsA(anything));
    });
  });

  group('DigitalPointRemoteDataSourceImpl', () {
    test('registra, solicita, url, check e sync', () async {
      final api = _FakeDigitalPointApi();
      final ds = DigitalPointRemoteDataSourceImpl(api: api);
      final model = DigitalPointModel(
        date: DateTime(2026, 1, 10),
        latitude: '-23',
        longitude: '-46',
        typePoint: 'offline',
        photoPath: 'p.jpg',
        status: 'pending',
        typeCapture: 'manual',
        uniqueHash: 'h',
        tabletSession: false,
      );
      final registered = await ds.registerPoint(model, 'c1');
      expect(registered.status, 'sended');
      expect(await ds.requestDigitalPointService('c1', 'hash'), isTrue);
      expect((await ds.getUrlAws('c1')).fileName, 'f.jpg');
      expect(await ds.checkDigitalPoint('c1', DateTime(2026, 1, 10)), isTrue);
      await ds.syncPointWithouLogin(model);
    });

    test('lança em falhas', () async {
      final ds = DigitalPointRemoteDataSourceImpl(
        api: _FakeDigitalPointApi()..fail = true,
      );
      final model = DigitalPointModel(
        date: DateTime(2026, 1, 10),
        latitude: '-23',
        longitude: '-46',
        typePoint: 'offline',
        photoPath: 'p.jpg',
        status: 'pending',
        typeCapture: 'manual',
        uniqueHash: 'h',
        tabletSession: false,
      );
      expect(() => ds.registerPoint(model, 'c1'), throwsA(anything));
      expect(
        () => ds.requestDigitalPointService('c1', 'h'),
        throwsA(anything),
      );
      expect(() => ds.getUrlAws('c1'), throwsA(anything));
      expect(
        () => ds.checkDigitalPoint('c1', DateTime(2026, 1, 10)),
        throwsA(anything),
      );
    });
  });

  group('AuthenticationTabletRemoteDataSourceImpl', () {
    test('busca info por código', () async {
      final info = await AuthenticationTabletRemoteDataSourceImpl(
        api: _FakeTabletApi(),
      ).getInfoByCondoCode('123');
      expect(info, isA<CondominiumCodeInfoModel>());
      expect(info.condoCode, '123');
    });
  });

  group('ProofRemoteDataSourceImpl', () {
    test('lista comprovantes e baixa arquivo', () async {
      final ds = ProofRemoteDataSourceImpl(api: _FakeProofApi());
      final proofs = await ds.getProof('c1', DateTime(2026, 1, 10));
      expect(proofs.first, isA<ProofModel>());
      expect(proofs.first.proofName, 'comprovante.pdf');
      final file = await ds.getFileProof('c1', 'comprovante.pdf');
      expect(file, isA<ProofFileModel>());
      expect(file.contentBytes, 'YmFzZTY0');
    });

    test('lança em falhas', () async {
      final api = _FakeProofApi();
      final ds = ProofRemoteDataSourceImpl(api: api);
      api.failList = true;
      expect(
        () => ds.getProof('c1', DateTime(2026, 1, 10)),
        throwsA(anything),
      );
      api.failList = false;
      api.failFile = true;
      expect(() => ds.getFileProof('c1', 'comprovante.pdf'), throwsA(anything));
    });
  });

  group('MeRemoteDataSourceImpl', () {
    test('get retorna perfil', () async {
      SharedPreferences.setMockInitialValues({});
      final ds = MeRemoteDataSourceImpl(api: _FakeMeApi());
      final me = await ds.get();
      expect(me.id, 'm1');
      expect(me.name, 'ana');
    });

    test('patch e updatePassword', () async {
      final ds = MeRemoteDataSourceImpl(api: _FakeMeApi());
      final me = await ds.patch(MeModel()..id = 'm1', 'code');
      expect(me.id, 'm1');
      await ds.updatePassword(MePasswordModel());
    });
  });
}
