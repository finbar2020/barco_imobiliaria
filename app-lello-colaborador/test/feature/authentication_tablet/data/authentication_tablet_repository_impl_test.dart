import 'package:colaborador/feature/authentication_tablet/data/data_source/local/authentication_tablet_local_data_source.dart';
import 'package:colaborador/feature/authentication_tablet/data/data_source/remote/authentication_tablet_remote_data_source.dart';
import 'package:colaborador/feature/authentication_tablet/data/model/condo_info_model.dart';
import 'package:colaborador/feature/authentication_tablet/data/model/condominium_code_info_model.dart';
import 'package:colaborador/feature/authentication_tablet/data/model/employee_info_model.dart';
import 'package:colaborador/feature/authentication_tablet/data/repository/authentication_tablet_repository_impl.dart';
import 'package:colaborador/feature/authentication_tablet/domain/entity/condominium_code_info.dart';
import 'package:essentials/essentials.dart';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/shared_features.dart';
import 'package:hive/hive.dart';

CondominiumCodeInfoModel _validModel(String code) => CondominiumCodeInfoModel(
      condoCode: code,
      condominium: CondoInfoModel(
        reference: 'R1',
        name: 'Torre',
        picturehash: 'pic',
        status: 'active',
        ref: 'ref1',
      ),
      employees: [EmployeeInfoModel(name: 'Ana')],
    );

class _FakeRemote extends Fake implements AuthenticationTabletRemoteDataSource {
  bool fail = false;
  CondominiumCodeInfoModel? response;

  @override
  Future<CondominiumCodeInfoModel> getInfoByCondoCode(String condoCode) async {
    if (fail) throw Exception('boom');
    return response ?? _validModel(condoCode);
  }
}

class _FakeLocal extends Fake implements AuthenticationTabletLocalDataSource {
  CondominiumCodeInfoModel? cached;

  @override
  Future<CondominiumCodeInfoModel?> select(String condoCode) async =>
      cached?.condoCode == condoCode ? cached : null;

  @override
  Future<CondominiumCodeInfoModel> save(
      String condoCode, CondominiumCodeInfoModel model) async {
    cached = model;
    return model;
  }

  @override
  Future<bool> delete() async {
    cached = null;
    return true;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    // `TabletSessionUtils` guarda o código do condomínio no Hive.
    Hive.init(Directory.systemTemp.createTempSync('colaborador_tablet').path);
  });

  group('AuthenticationTabletRepositoryImpl', () {
    test('rejeita erro remoto', () async {
      final result = await AuthenticationTabletRepositoryImpl(
        remoteDataSource: _FakeRemote()..fail = true,
        localDataSource: _FakeLocal(),
      ).getInfoByCondoCode('ABC');
      expect(result, isA<Rejection<CondominiumCodeInfo>>());
    });

    test('busca remota guarda o condomínio em cache', () async {
      final local = _FakeLocal();

      final result = await AuthenticationTabletRepositoryImpl(
        remoteDataSource: _FakeRemote(),
        localDataSource: local,
      ).getInfoByCondoCode('ABC');

      expect(result, isA<Success<CondominiumCodeInfo>>());
      expect(local.cached?.condoCode, 'ABC');
      // O código só fica disponível porque o repositório aguarda a gravação.
      expect(await TabletSessionUtils.getCondoCode(), 'ABC');
    });

    test('cache devolve o condomínio salvo na última busca', () async {
      final local = _FakeLocal();
      final repository = AuthenticationTabletRepositoryImpl(
        remoteDataSource: _FakeRemote(),
        localDataSource: local,
      );
      // O repositório aguarda a gravação do código no Hive antes de responder.
      await repository.getInfoByCondoCode('ABC');

      final result = await repository.getInfoByCondoCodeFromCache();

      expect(result, isA<Success<CondominiumCodeInfo>>());
    });

    test('sem cache o condomínio não é encontrado', () async {
      final result = await AuthenticationTabletRepositoryImpl(
        remoteDataSource: _FakeRemote(),
        localDataSource: _FakeLocal(),
      ).getInfoByCondoCodeFromCache();

      expect(result, isA<Rejection<CondominiumCodeInfo>>());
    });
  });
}
