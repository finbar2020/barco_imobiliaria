import 'package:lello/core/database/agreements_all_info/agreements_rules_installments_table.dart';
import 'package:lello/core/database/lello_database.dart';
import 'package:drift/drift.dart';

part 'agreements_rules_installments_dao.g.dart';

@DriftAccessor(tables: [AgreementsRulesInstallmentsTable])
class AgreementsRulesInstallmentsDao extends DatabaseAccessor<LelloDatabase>
    with _$AgreementsRulesInstallmentsDaoMixin {
  final LelloDatabase database;
  AgreementsRulesInstallmentsDao(this.database) : super(database);

  Future<AgreementsRulesInstallmentsData?> getAgreementsRulesInstallments(
          String condominiumId) =>
      (select(database.agreementsRulesInstallmentsTable)
            ..where((dt) => dt.condominiumId.equals(condominiumId)))
          .getSingle();

  Future<int> deleteAgreementsRulesInstallments(String condominiumId) =>
      (delete(database.agreementsRulesInstallmentsTable)
            ..where((dt) => dt.condominiumId.equals(condominiumId)))
          .go();

  Future<void> insert(Insertable<AgreementsRulesInstallmentsData> data) =>
      into(database.agreementsRulesInstallmentsTable)
          .insert(data, mode: InsertMode.replace);

  Future<int> clear() => delete(database.agreementsRulesInstallmentsTable).go();
}
