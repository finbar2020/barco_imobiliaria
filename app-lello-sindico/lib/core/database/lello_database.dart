import 'package:drift/drift.dart';
import 'package:drift_sqflite/drift_sqflite.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/core/database/account/account_dao.dart';
import 'package:lello/core/database/account/account_table.dart';
import 'package:lello/core/database/agreements_all_info/agreements_agreement_dao.dart';
import 'package:lello/core/database/agreements_all_info/agreements_agreement_table.dart';
import 'package:lello/core/database/agreements_all_info/agreements_installments_dao.dart';
import 'package:lello/core/database/agreements_all_info/agreements_installments_table.dart';
import 'package:lello/core/database/agreements_all_info/agreements_quote_dao.dart';
import 'package:lello/core/database/agreements_all_info/agreements_quote_table.dart';
import 'package:lello/core/database/agreements_all_info/agreements_rules_days_dao.dart';
import 'package:lello/core/database/agreements_all_info/agreements_rules_days_table.dart';
import 'package:lello/core/database/agreements_all_info/agreements_rules_installments_dao.dart';
import 'package:lello/core/database/agreements_all_info/agreements_rules_installments_table.dart';
import 'package:lello/core/database/chat_contact/chat_contact_dao.dart';
import 'package:lello/core/database/chat_contact/chat_contact_table.dart';
import 'package:lello/core/database/condominium/condominium_dao.dart';
import 'package:lello/core/database/condominium/condominium_table.dart';
import 'package:lello/core/database/condominium_balance/condominium_balance_dao.dart';
import 'package:lello/core/database/condominium_balance/condominium_balance_table.dart';
import 'package:lello/core/database/condominium_balance_detail/condominium_balance_debits_dao.dart';
import 'package:lello/core/database/condominium_balance_detail/condominium_balance_debits_table.dart';
import 'package:lello/core/database/condominium_balance_detail/condominium_balance_detail_dao.dart';
import 'package:lello/core/database/condominium_balance_detail/condominium_balance_detail_table.dart';
import 'package:lello/core/database/condominium_balance_detail/condominium_balance_summary_dao.dart';
import 'package:lello/core/database/condominium_balance_detail/condominium_balance_summary_table.dart';
import 'package:lello/core/database/employee/employee_dao.dart';
import 'package:lello/core/database/employee/employee_table.dart';
import 'package:lello/core/database/income/income_dao.dart';
import 'package:lello/core/database/income/income_forecast_table.dart';
import 'package:lello/core/database/income/income_share_table.dart';
import 'package:lello/core/database/income/income_table.dart';
import 'package:lello/core/database/layout/layout_dao.dart';
import 'package:lello/core/database/layout/layout_table.dart';
import 'package:lello/core/database/lello_hub/lello_hub_table.dart';
import 'package:lello/core/database/me/me_dao.dart';
import 'package:lello/core/database/me/me_table.dart';
import 'package:lello/core/database/pendency/pendency_dao.dart';
import 'package:lello/core/database/pendency/pendency_table.dart';
import 'package:lello/core/database/reservation_summary/reservation_summary_dao.dart';
import 'package:lello/core/database/reservation_summary/reservation_summary_table.dart';
import 'package:lello/core/database/resident/resident_dao.dart';
import 'package:lello/core/database/resident/resident_table.dart';
import 'package:lello/core/database/resin/resin_bank_accounts/resin_bank_accounts_dao.dart';
import 'package:lello/core/database/resin/resin_bank_accounts/resin_bank_accounts_table.dart';
import 'package:lello/core/database/resin/resin_banks/resin_banks_dao.dart';
import 'package:lello/core/database/resin/resin_banks/resin_banks_table.dart';
import 'package:lello/core/database/resin/resin_people/resin_people_dao.dart';
import 'package:lello/core/database/resin/resin_people/resin_people_table.dart';
import 'package:lello/core/database/resin/resin_refunds/resin_refunds_dao.dart';
import 'package:lello/core/database/resin/resin_refunds/resin_refunds_table.dart';
import 'package:lello/core/database/space/space_dao.dart';
import 'package:lello/core/database/space/space_table.dart';
import 'package:lello/core/database/unit/unit_dao.dart';
import 'package:lello/core/database/unit/unit_table.dart';

part 'lello_database.g.dart';

@DriftDatabase(tables: [
  PendencyTable,
  MeTable,
  CondominiumTable,
  AccountTable,
  LelloHubTable,
  UnitTable,
  ResidentTable,
  IncomeForecastTable,
  IncomeTable,
  IncomeShareTable,
  ChatContactTable,
  EmployeeTable,
  ReservationSummaryTable,
  SpaceTable,
  CondominiumBalanceTable,
  CondominiumBalanceDetailTable,
  CondominiumBalanceDebitsTable,
  CondominiumBalanceSummaryTable,
  AgreementsTable,
  AgreementsInstallmentsTable,
  AgreementsQuoteTable,
  AgreementsRulesDaysTable,
  AgreementsRulesInstallmentsTable,
  ResinPeopleTable,
  ResinBanksTable,
  ResinBankAccountsTable,
  ResinRefundsTable,
  LayoutTable,
], daos: [
  PendencyDao,
  MeDao,
  CondominiumDao,
  AccountDao,
  UnitDao,
  ResidentDao,
  IncomeDao,
  ChatContactDao,
  EmployeeDao,
  ReservationSummaryDao,
  SpaceDao,
  CondominiumBalanceDao,
  CondominiumBalanceDetailDao,
  CondominiumBalanceDebitsDao,
  CondominiumBalanceSummaryDao,
  AgreementsDao,
  AgreementsInstallmentsDao,
  AgreementsQuoteDao,
  AgreementsRulesDaysDao,
  AgreementsRulesInstallmentsDao,
  ResinPeopleDao,
  ResinBanksDao,
  ResinBankAccountsDao,
  ResinRefundsDao,
  LayoutDao,
])
class LelloDatabase extends _$LelloDatabase {
  LelloDatabase()
      : super(SqfliteQueryExecutor.inDatabaseFolder(
            path: 'db.sqlite', logStatements: true));

  LelloDatabase.forExecutor(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 13;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) {
          return m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from == 1) {
            // add condominium reference
            await m.addColumn(condominiumTable, condominiumTable.reference);
            // add condominium balance
            await m.createTable(condominiumBalanceTable);
            // add condominium balance detail
            await m.createTable(condominiumBalanceDetailTable);
            await m.createTable(condominiumBalanceDebitsTable);
            await m.createTable(condominiumBalanceSummaryTable);
            //agreements
            await m.createTable(agreementsTable);
            await m.createTable(agreementsInstallmentsTable);
            await m.createTable(agreementsQuoteTable);
            await m.createTable(agreementsRulesDaysTable);
            await m.createTable(agreementsRulesInstallmentsTable);
            //pendencies
            await m.addColumn(pendencyTable, pendencyTable.module);
            //resin
            await m.createTable(resinBankAccountsTable);
            await m.createTable(resinBanksTable);
            await m.createTable(resinPeopleTable);
            await m.createTable(resinRefundsTable);
            await m.createTable(layoutTable);
            // add condominium notificationContext
            await m.addColumn(
                condominiumTable, condominiumTable.notificationContext);
          }
          if (from == 2) {
            // add condominium balance
            await m.createTable(condominiumBalanceTable);
            // add condominium balance detail
            await m.createTable(condominiumBalanceDetailTable);
            await m.createTable(condominiumBalanceDebitsTable);
            await m.createTable(condominiumBalanceSummaryTable);
            //agreements
            await m.createTable(agreementsTable);
            await m.createTable(agreementsInstallmentsTable);
            await m.createTable(agreementsQuoteTable);
            await m.createTable(agreementsRulesDaysTable);
            await m.createTable(agreementsRulesInstallmentsTable);
            //pendencies
            await m.addColumn(pendencyTable, pendencyTable.module);
            //resin
            await m.createTable(resinBankAccountsTable);
            await m.createTable(resinBanksTable);
            await m.createTable(resinPeopleTable);
            await m.createTable(resinRefundsTable);
            await m.createTable(layoutTable);
            // add condominium notificationContext
            await m.addColumn(
                condominiumTable, condominiumTable.notificationContext);
          }
          if (from == 3) {
            // add condominium balance detail
            await m.createTable(condominiumBalanceDetailTable);
            await m.createTable(condominiumBalanceDebitsTable);
            await m.createTable(condominiumBalanceSummaryTable);
            //agreements
            await m.createTable(agreementsTable);
            await m.createTable(agreementsInstallmentsTable);
            await m.createTable(agreementsQuoteTable);
            await m.createTable(agreementsRulesDaysTable);
            await m.createTable(agreementsRulesInstallmentsTable);
            //pendencies
            await m.addColumn(pendencyTable, pendencyTable.module);
            //resin
            await m.createTable(resinBankAccountsTable);
            await m.createTable(resinBanksTable);
            await m.createTable(resinPeopleTable);
            await m.createTable(resinRefundsTable);
            await m.createTable(layoutTable);
            // add condominium notificationContext
            await m.addColumn(
                condominiumTable, condominiumTable.notificationContext);
          }
          if (from == 4) {
            await m.addColumn(meTable, meTable.pictureHash);
            //agreements
            await m.createTable(agreementsTable);
            await m.createTable(agreementsInstallmentsTable);
            await m.createTable(agreementsQuoteTable);
            await m.createTable(agreementsRulesDaysTable);
            await m.createTable(agreementsRulesInstallmentsTable);
            //pendencies
            await m.addColumn(pendencyTable, pendencyTable.module);
            //resin
            await m.createTable(resinBankAccountsTable);
            await m.createTable(resinBanksTable);
            await m.createTable(resinPeopleTable);
            await m.createTable(resinRefundsTable);
            await m.createTable(layoutTable);
            // add condominium notificationContext
            await m.addColumn(
                condominiumTable, condominiumTable.notificationContext);
          }
          if (from == 5) {
            //agreements
            await m.createTable(agreementsTable);
            await m.createTable(agreementsInstallmentsTable);
            await m.createTable(agreementsQuoteTable);
            await m.createTable(agreementsRulesDaysTable);
            await m.createTable(agreementsRulesInstallmentsTable);
            //pendencies
            await m.addColumn(pendencyTable, pendencyTable.module);
            //resin
            await m.createTable(resinBankAccountsTable);
            await m.createTable(resinBanksTable);
            await m.createTable(resinPeopleTable);
            await m.createTable(resinRefundsTable);
            await m.createTable(layoutTable);
            // add condominium notificationContext
            await m.addColumn(
                condominiumTable, condominiumTable.notificationContext);
          }
          if (from == 6) {
            //pendencies
            await m.addColumn(pendencyTable, pendencyTable.module);
            //resin
            await m.createTable(resinBankAccountsTable);
            await m.createTable(resinBanksTable);
            await m.createTable(resinPeopleTable);
            await m.createTable(resinRefundsTable);
            await m.createTable(layoutTable);
          }
          if (from == 7) {
            await (condominiumDao.delete(condominiumTable)
                  ..where((tbl) => tbl.id.isNull() | tbl.reference.isNull()))
                .go();
            await m.alterTable(TableMigration(condominiumTable));
            //resin
            await m.createTable(resinBankAccountsTable);
            await m.createTable(resinBanksTable);
            await m.createTable(resinPeopleTable);
            await m.createTable(resinRefundsTable);
            await m.createTable(layoutTable);
            // add condominium notificationContext
            await m.addColumn(
                condominiumTable, condominiumTable.notificationContext);
          }
          if (from == 8) {
            //resin
            await m.createTable(resinBankAccountsTable);
            await m.createTable(resinBanksTable);
            await m.createTable(resinPeopleTable);
            await m.createTable(resinRefundsTable);
            await m.createTable(layoutTable);
            // add condominium notificationContext
            await m.addColumn(
                condominiumTable, condominiumTable.notificationContext);
          }
          if (from == 9) {
            await m.createTable(layoutTable);
            //biometria
            await m.addColumn(
                condominiumTable, condominiumTable.useFacialBiometric);
            await m.addColumn(condominiumTable,
                condominiumTable.managerAccessControlBiometricStatus);
            // add condominium notificationContext
            await m.addColumn(
                condominiumTable, condominiumTable.notificationContext);
          }
          if (from == 10) {
            await m.deleteTable(unitTable.actualTableName);
            await m.createTable(unitTable);
            await m.createTable(layoutTable);
            // add condominium notificationContext
            await m.addColumn(
                condominiumTable, condominiumTable.notificationContext);
          }
          if (from == 11) {
            await m.createTable(layoutTable);
            // add condominium notificationContext
            await m.addColumn(
                condominiumTable, condominiumTable.notificationContext);
          }
          if (from == 12) {
            // add condominium notificationContext
            await m.addColumn(
                condominiumTable, condominiumTable.notificationContext);
          }
        },
        beforeOpen: (details) async {
          // your existing beforeOpen callback, enable foreign keys, etc.

          // if (kDebugBuild) {
          //   // This check pulls in a fair amount of code that's not needed
          //   // anywhere else, so we recommend only doing it in debug builds.
          //   await validateDatabaseSchema();
          // }
        },
      );

  Future<Try<Nothing>> resetDb() async {
    for (var table in allTables) {
      await table.deleteAll();
    }
    await createAllTablesAgain();
    return Success(Nothing());
  }

  Future createAllTablesAgain() async {
    final migrator = Migrator(this);
    for (var table in allTables) {
      await customStatement('DROP TABLE ${table.actualTableName};');
      await migrator.createTable(table);
    }
  }
}
