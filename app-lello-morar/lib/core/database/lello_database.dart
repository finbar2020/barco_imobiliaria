import 'package:essentials/essentials.dart';
import 'package:morar/core/database/authorization/authorization_dao.dart';
import 'package:morar/core/database/authorization/authorization_table.dart';
import 'package:morar/core/database/block/block_dao.dart';
import 'package:morar/core/database/block/block_table.dart';
import 'package:morar/core/database/condominium/condominium_dao.dart';
import 'package:morar/core/database/condominium/condominium_table.dart';
import 'package:morar/core/database/documents/cached_documents_dao.dart';
import 'package:morar/core/database/documents/cached_documents_table.dart';
import 'package:morar/core/database/layout/layout_dao.dart';
import 'package:morar/core/database/layout/layout_table.dart';
import 'package:morar/core/database/me/me_dao.dart';
import 'package:morar/core/database/me/me_table.dart';
import 'package:morar/core/database/unit/unit_dao.dart';
import 'package:morar/core/database/unit/unit_table.dart';

part 'lello_database.g.dart';

@DriftDatabase(tables: [
  MeTable,
  CondominiumTable,
  BlockTable,
  UnitTable,
  AuthorizationTable,
  LayoutTable,
  CachedDocumentsTable
], daos: [
  MeDao,
  CondominiumDao,
  BlockDao,
  UnitDao,
  AuthorizationDao,
  LayoutDao,
  CachedDocumentsDao
])
class LelloDatabase extends _$LelloDatabase {
  LelloDatabase()
      : super(SqfliteQueryExecutor.inDatabaseFolder(
      path: 'db.sqlite', logStatements: true));

  @override
  int get schemaVersion => 14;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) {
      return m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      try {
        if (from == 1) {
          // add agreement
          await m.addColumn(unitTable, unitTable.agreement);
          // add compliant
          await m.addColumn(unitTable, unitTable.compliant);
          // add home to go
          await m.addColumn(unitTable, unitTable.termHomeToGo);
          // add picture hash colum
          await m.addColumn(meTable, meTable.pictureHash);
          // add active manager
          await m.addColumn(
              condominiumTable, condominiumTable.active_manager);
          // add banner and banner args table
          await m.createTable(layoutTable);

          // add me id Column
          await m.addColumn(meTable, meTable.id);
          // add me biometricPictureHash Column
          await m.addColumn(meTable, meTable.biometricPictureHash);
          // add me useFacialBiometric Column
          await m.addColumn(meTable, meTable.useFacialBiometric);
        }
        if (from == 2) {
          // add picture hash colum
          await m.addColumn(meTable, meTable.pictureHash);

          // add active manager
          await m.addColumn(
              condominiumTable, condominiumTable.active_manager);
          // add banner and banner args table
          await m.createTable(layoutTable);

          // add me id Column
          await m.addColumn(meTable, meTable.id);
          // add me biometricPictureHash Column
          await m.addColumn(meTable, meTable.biometricPictureHash);
          // add me useFacialBiometric Column
          await m.addColumn(meTable, meTable.useFacialBiometric);
        }
        if (from == 3) {
          // add picture hash colum
          await m.addColumn(meTable, meTable.pictureHash);

          // add banner and banner args table
          await m.createTable(layoutTable);

          // add me id Column
          await m.addColumn(meTable, meTable.id);
          // add me biometricPictureHash Column
          await m.addColumn(meTable, meTable.biometricPictureHash);
          // add me useFacialBiometric Column
          await m.addColumn(meTable, meTable.useFacialBiometric);
        }
        if (from == 4) {
          // add banner and banner args table
          await m.createTable(layoutTable);

          // add me id Column
          await m.addColumn(meTable, meTable.id);
          // add me biometricPictureHash Column
          await m.addColumn(meTable, meTable.biometricPictureHash);
          // add me useFacialBiometric Column
          await m.addColumn(meTable, meTable.useFacialBiometric);
        }
        if (from == 5) {
          await m.addColumn(unitTable, unitTable.notificationContext);

          // add me id Column
          await m.addColumn(meTable, meTable.id);
          // add me biometricPictureHash Column
          await m.addColumn(meTable, meTable.biometricPictureHash);
          // add me useFacialBiometric Column
          await m.addColumn(meTable, meTable.useFacialBiometric);
        }
        if (from == 6) {
          await m.createTable(layoutTable);

          // add me id Column
          await m.addColumn(meTable, meTable.id);
          // add me biometricPictureHash Column
          await m.addColumn(meTable, meTable.biometricPictureHash);
          // add me useFacialBiometric Column
          await m.addColumn(meTable, meTable.useFacialBiometric);
        }
        if (from == 7) {
          await m.createTable(layoutTable);

          // add me id Column
          await m.addColumn(meTable, meTable.id);
          // add me biometricPictureHash Column
          await m.addColumn(meTable, meTable.biometricPictureHash);
          // add me useFacialBiometric Column
          await m.addColumn(meTable, meTable.useFacialBiometric);
        }
        if (from == 8) {
          await m.createTable(layoutTable);

          // add me id Column
          await m.addColumn(meTable, meTable.id);
          // add me biometricPictureHash Column
          await m.addColumn(meTable, meTable.biometricPictureHash);
          // add me useFacialBiometric Column
          await m.addColumn(meTable, meTable.useFacialBiometric);
        }
        if (from == 9) {
          // add me id Column
          await m.addColumn(meTable, meTable.id);
          // add me biometricPictureHash Column
          await m.addColumn(meTable, meTable.biometricPictureHash);
          // add me useFacialBiometric Column
          await m.addColumn(meTable, meTable.useFacialBiometric);
        }
        if (from == 11) {
          // add me id Column
          await m.addColumn(meTable, meTable.id);
          // add me biometricPictureHash Column
          await m.addColumn(meTable, meTable.biometricPictureHash);
          // add me useFacialBiometric Column
          await m.addColumn(meTable, meTable.useFacialBiometric);
        }
        if (from == 12) {
          // add me useFacialBiometric Column
          await m.addColumn(meTable, meTable.useFacialBiometric);
        }
        if (from == 13) {
          await m.createTable(cachedDocumentsTable);
        }
      } on Exception {
        for (var table in allTables) {
          await m.drop(table);
        }
        await m.createAll();
      }
    },
  );

  Future<Try<Nothing>> resetDb() async {
    for (var table in allTables) {
      await table.deleteAll();
    }
    return Success(Nothing());
  }
}