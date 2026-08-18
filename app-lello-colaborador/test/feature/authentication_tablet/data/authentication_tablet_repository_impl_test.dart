import 'package:colaborador/feature/authentication_tablet/data/data_source/local/authentication_tablet_local_data_source.dart';
import 'package:colaborador/feature/authentication_tablet/data/data_source/remote/authentication_tablet_remote_data_source.dart';
import 'package:colaborador/feature/authentication_tablet/data/model/condo_info_model.dart';
import 'package:colaborador/feature/authentication_tablet/data/model/condominium_code_info_model.dart';
import 'package:colaborador/feature/authentication_tablet/data/model/employee_info_model.dart';
import 'package:colaborador/feature/authentication_tablet/data/repository/authentication_tablet_repository_impl.dart';
import 'package:colaborador/feature/authentication_tablet/domain/entity/condominium_code_info.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';

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
  group('AuthenticationTabletRepositoryImpl', () {
    test('rejeita erro remoto', () async {
      final result = await AuthenticationTabletRepositoryImpl(
        remoteDataSource: _FakeRemote()..fail = true,
        localDataSource: _FakeLocal(),
      ).getInfoByCondoCode('ABC');
      expect(result, isA<Rejection<CondominiumCodeInfo>>());
    });
  });
}
