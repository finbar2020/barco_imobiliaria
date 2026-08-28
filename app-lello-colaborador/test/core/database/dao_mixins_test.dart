import 'package:colaborador/core/database/authentication_tablet_database/authentication_tablet_database.dart';
import 'package:colaborador/core/database/digital_point_database/digital_point_database.dart';
import 'package:colaborador/core/database/lello_database/lello_database.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/init_sqflite_ffi.dart';

/// Os mixins gerados para cada DAO expõem a tabela do banco anexado; os DAOs
/// da aplicação acessam as tabelas pelo banco, então esses getters só são
/// exercitados aqui.
void main() {
  initSqfliteForTests();

  test('mixins do LelloDatabase apontam para as tabelas do banco', () async {
    final database = LelloDatabase();
    addTearDown(database.close);

    expect(database.meDao.meTable, database.meTable);
    expect(database.condominiumDao.condominiumTable, database.condominiumTable);
    expect(database.employeeDao.employeeTable, database.employeeTable);
    expect(
      database.condominiumEmployeeScheduleDao.condominiumEmployeeScheduleTable,
      database.condominiumEmployeeScheduleTable,
    );
  });

  test('mixins do DigitalPointDatabase apontam para as tabelas', () async {
    final database = DigitalPointDatabase();
    addTearDown(database.close);

    expect(database.digitalPointDao.digitalPointTable,
        database.digitalPointTable);
    expect(database.digitalPointLogDao.digitalPointLogTable,
        database.digitalPointLogTable);
  });

  test('mixins do AuthenticationTabletDatabase apontam para as tabelas',
      () async {
    final database = AuthenticationTabletDatabase();
    addTearDown(database.close);

    expect(database.employeeInfoDao.employeeInfoTable,
        database.employeeInfoTable);
    expect(database.condominiumInfoDao.condominiumInfoTable,
        database.condominiumInfoTable);
  });
}
