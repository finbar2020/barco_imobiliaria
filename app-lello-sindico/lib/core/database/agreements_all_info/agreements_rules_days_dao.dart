import 'package:lello/core/database/agreements_all_info/agreements_rules_days_table.dart';
import 'package:lello/core/database/lello_database.dart';
import 'package:drift/drift.dart';

part 'agreements_rules_days_dao.g.dart';

@DriftAccessor(tables: [AgreementsRulesDaysTable])
class AgreementsRulesDaysDao extends DatabaseAccessor<LelloDatabase>
    with _$AgreementsRulesDaysDaoMixin {
  final LelloDatabase database;
  AgreementsRulesDaysDao(this.database) : super(database);

  Future<List<AgreementsRulesDaysData>?> getAgreementsRulesDays(
          String condominiumId) =>
      (select(database.agreementsRulesDaysTable)
            ..where((dt) => dt.condominiumId.equals(condominiumId)))
          .get();

  Future<int> deleteAgreementsRulesDays(String condominiumId) =>
      (delete(database.agreementsRulesDaysTable)
            ..where((dt) => dt.condominiumId.equals(condominiumId)))
          .go();

  Future<void> insert(Insertable<AgreementsRulesDaysData> data) =>
      into(database.agreementsRulesDaysTable).insert(data);

  Future<int> clear() => delete(database.agreementsRulesDaysTable).go();
}
