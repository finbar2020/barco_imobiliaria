import 'package:lello/core/database/agreements_all_info/agreements_Quote_table.dart';
import 'package:lello/core/database/lello_database.dart';
import 'package:drift/drift.dart';

part 'agreements_quote_dao.g.dart';

@DriftAccessor(tables: [AgreementsQuoteTable])
class AgreementsQuoteDao extends DatabaseAccessor<LelloDatabase>
    with _$AgreementsQuoteDaoMixin {
  final LelloDatabase database;
  AgreementsQuoteDao(this.database) : super(database);

  Future<List<AgreementsQuoteData>?> getAgreementsQuote(String agreementId) =>
      (select(database.agreementsQuoteTable)
            ..where((dt) => dt.agreementId.equals(agreementId)))
          .get();

  Future<int> deleteQuote(String id) =>
      (delete(database.agreementsQuoteTable)..where((dt) => dt.id.equals(id)))
          .go();

  Future<int> deleteCondominiumQuotes(String condominiumId) =>
      (delete(database.agreementsQuoteTable)
            ..where((dt) => dt.condominiumId.equals(condominiumId)))
          .go();

  Future<void> insert(Insertable<AgreementsQuoteData> data) =>
      into(database.agreementsQuoteTable)
          .insert(data, mode: InsertMode.replace);

  Future<int> clear() => delete(database.agreementsQuoteTable).go();
}
