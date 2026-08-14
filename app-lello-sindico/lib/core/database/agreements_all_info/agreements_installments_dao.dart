import 'package:lello/core/database/agreements_all_info/agreements_installments_table.dart';
import 'package:lello/core/database/lello_database.dart';
import 'package:drift/drift.dart';

part 'agreements_installments_dao.g.dart';

@DriftAccessor(tables: [AgreementsInstallmentsTable])
class AgreementsInstallmentsDao extends DatabaseAccessor<LelloDatabase>
    with _$AgreementsInstallmentsDaoMixin {
  final LelloDatabase database;
  AgreementsInstallmentsDao(this.database) : super(database);

  Future<List<AgreementsInstallmentsData>?> getAgreementsInstallments(
          String agreementId) =>
      (select(database.agreementsInstallmentsTable)
            ..where((dt) => dt.agreementId.equals(agreementId)))
          .get();

  Future<int> deleteInstallment(String installmentId) =>
      (delete(database.agreementsInstallmentsTable)
            ..where((dt) => dt.installmentId.equals(installmentId)))
          .go();

  Future<int> deleteCondominiumInstallments(String condominiumId) =>
      (delete(database.agreementsInstallmentsTable)
            ..where((dt) => dt.condominiumId.equals(condominiumId)))
          .go();

  Future<void> insert(Insertable<AgreementsInstallmentsData> data) =>
      into(database.agreementsInstallmentsTable)
          .insert(data, mode: InsertMode.replace);

  Future<int> clear() => delete(database.agreementsInstallmentsTable).go();
}
