import 'package:colaborador/core/database/authentication_tablet_database/authentication_tablet_database.dart';
import 'package:colaborador/feature/authentication_tablet/data/data_source/local/authentication_tablet_local_data_source_impl.dart';
import 'package:colaborador/feature/authentication_tablet/data/model/condo_info_model.dart';
import 'package:colaborador/feature/authentication_tablet/data/model/condominium_code_info_model.dart';
import 'package:colaborador/feature/authentication_tablet/data/model/employee_info_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/init_sqflite_ffi.dart';

CondominiumCodeInfoModel _model(String code) => CondominiumCodeInfoModel(
      condoCode: code,
      condominium: CondoInfoModel(
        reference: 'R1',
        name: 'Torre Lello',
        picturehash: 'pic',
        status: 'active',
        ref: 'ref1',
      ),
      employees: [
        EmployeeInfoModel(
          numCra: '1',
          numCad: '2',
          cpf: '12345678901',
          name: 'Ana Silva',
          jobPosition: 'porteiro',
        ),
      ],
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  initSqfliteForTests();

  late AuthenticationTabletDatabase database;
  late AuthenticationTabletLocalDataSourceImpl dataSource;

  setUp(() async {
    database = AuthenticationTabletDatabase();
    dataSource = AuthenticationTabletLocalDataSourceImpl(
      condominiumInfoDao: database.condominiumInfoDao,
      employeeInfoDao: database.employeeInfoDao,
    );
    await dataSource.delete();
  });

  tearDown(() async {
    await database.close();
  });

  group('AuthenticationTabletLocalDataSourceImpl', () {
    test('save e select retornam condomínio e funcionários', () async {
      await dataSource.save('123', _model('123'));
      final cached = await dataSource.select('123');
      expect(cached, isNotNull);
      expect(cached!.condominium?.name, 'Torre Lello');
      expect(cached.employees, hasLength(1));
      expect(cached.employees.first?.name, 'Ana Silva');
    });

    test('select retorna null quando não existe', () async {
      expect(await dataSource.select('999'), isNull);
    });

    test('select retorna null sem funcionários', () async {
      await dataSource.save(
        'empty',
        CondominiumCodeInfoModel(
          condoCode: 'empty',
          condominium: CondoInfoModel(name: 'Sem equipe'),
          employees: [],
        ),
      );
      expect(await dataSource.select('empty'), isNull);
    });

    test('delete limpa cache', () async {
      await dataSource.save('123', _model('123'));
      expect(await dataSource.delete(), isTrue);
      expect(await dataSource.select('123'), isNull);
    });

    test('save substitui dados anteriores', () async {
      await dataSource.save('123', _model('123'));
      await dataSource.save(
        '123',
        CondominiumCodeInfoModel(
          condoCode: '123',
          condominium: CondoInfoModel(reference: 'R2', name: 'Novo Condo'),
          employees: [
            EmployeeInfoModel(
              numCra: '1',
              numCad: '10',
              cpf: '11111111111',
              name: 'João',
            ),
            EmployeeInfoModel(
              numCra: '2',
              numCad: '20',
              cpf: '22222222222',
              name: 'Maria',
            ),
          ],
        ),
      );
      final cached = await dataSource.select('123');
      expect(cached?.condominium?.name, 'Novo Condo');
      expect(cached?.employees, hasLength(2));
    });
  });
}
