import 'package:lello/core/database/agreements_all_info/agreements_agreement_table.dart';
import 'package:lello/core/database/lello_database.dart';
import 'package:drift/drift.dart';

part 'agreements_agreement_dao.g.dart';

@DriftAccessor(tables: [AgreementsTable])
class AgreementsDao extends DatabaseAccessor<LelloDatabase>
    with _$AgreementsDaoMixin {
  final LelloDatabase database;
  AgreementsDao(this.database) : super(database);

  Future<List<AgreementsData>?> getAgreements(String condominiumId) =>
      (select(database.agreementsTable)
            ..where((dt) => dt.condominiumId.equals(condominiumId)))
          .get();

  Future<int> deleteAgreement(String id) =>
      (delete(database.agreementsTable)..where((dt) => dt.id.equals(id))).go();

  Future<int> deleteCondominiumAgreements(String condominiumId) =>
      (delete(database.agreementsTable)
            ..where((dt) => dt.condominiumId.equals(condominiumId)))
          .go();

  Future<void> insert(Insertable<AgreementsData> data) =>
      into(database.agreementsTable).insert(data, mode: InsertMode.replace);

  Future<int> clear() => delete(database.agreementsTable).go();
}
