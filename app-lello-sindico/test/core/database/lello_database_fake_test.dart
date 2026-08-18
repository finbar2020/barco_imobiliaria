import 'package:drift/drift.dart' hide isNotNull, isNull, equals;
import 'package:drift/native.dart';
import 'package:essentials/essentials.dart' hide isNotNull, isNull, equals;
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/core/database/lello_database.dart';

void main() {
  test('data classes cobrem json, copyWith, companion e colunas', () {
    final pendencyData = PendencyData(condominiumId: 'condominiumId', id: 'id', title: 'title', message: 'message', date: DateTime(2026, 1, 10), type: 'type', senderId: 'senderId', senderName: 'senderName', senderPicture: 'senderPicture', module: 'module');
    expect(pendencyData, PendencyData.fromJson(pendencyData.toJson()));
    expect(pendencyData.copyWith(), pendencyData);
    expect(pendencyData.toCompanion(true), isNotNull);
    expect(pendencyData.toCompanion(false), isNotNull);
    expect(pendencyData.toColumns(true), isNotEmpty);
    expect(pendencyData.toColumns(false), isNotEmpty);
    expect(pendencyData.toString(), contains('PendencyData'));
    expect(pendencyData.hashCode, pendencyData.hashCode);

    final meData = MeData(name: 'name', email: 'email', cpf: 'cpf', phone: 'phone', picture: 'picture', pictureHash: 'pictureHash');
    expect(meData, MeData.fromJson(meData.toJson()));
    expect(meData.copyWith(), meData);
    expect(meData.toCompanion(true), isNotNull);
    expect(meData.toCompanion(false), isNotNull);
    expect(meData.toColumns(true), isNotEmpty);
    expect(meData.toColumns(false), isNotEmpty);
    expect(meData.toString(), contains('MeData'));
    expect(meData.hashCode, meData.hashCode);

    final condominiumData = CondominiumData(id: 'id', name: 'name', address: 'address', reference: 'reference', useFacialBiometric: true, managerAccessControlBiometricStatus: 'managerAccessControlBiometricStatus', notificationContext: 'notificationContext');
    expect(condominiumData, CondominiumData.fromJson(condominiumData.toJson()));
    expect(condominiumData.copyWith(), condominiumData);
    expect(condominiumData.toCompanion(true), isNotNull);
    expect(condominiumData.toCompanion(false), isNotNull);
    expect(condominiumData.toColumns(true), isNotEmpty);
    expect(condominiumData.toColumns(false), isNotEmpty);
    expect(condominiumData.toString(), contains('CondominiumData'));
    expect(condominiumData.hashCode, condominiumData.hashCode);

    final accountData = AccountData(id: 'id', number: 'number', name: 'name', condominiumId: 'condominiumId');
    expect(accountData, AccountData.fromJson(accountData.toJson()));
    expect(accountData.copyWith(), accountData);
    expect(accountData.toCompanion(true), isNotNull);
    expect(accountData.toCompanion(false), isNotNull);
    expect(accountData.toColumns(true), isNotEmpty);
    expect(accountData.toColumns(false), isNotEmpty);
    expect(accountData.toString(), contains('AccountData'));
    expect(accountData.hashCode, accountData.hashCode);

    final lelloHubData = LelloHubData(number: 'number');
    expect(lelloHubData, LelloHubData.fromJson(lelloHubData.toJson()));
    expect(lelloHubData.copyWith(), lelloHubData);
    expect(lelloHubData.toCompanion(true), isNotNull);
    expect(lelloHubData.toCompanion(false), isNotNull);
    expect(lelloHubData.toColumns(true), isNotEmpty);
    expect(lelloHubData.toColumns(false), isNotEmpty);
    expect(lelloHubData.toString(), contains('LelloHubData'));
    expect(lelloHubData.hashCode, lelloHubData.hashCode);

    final unitData = UnitData(id: 'id', title: 'title', group: 'group', residentCount: 1, condominiumId: 'condominiumId', vehicleCount: 1, adimplente: true, agreement: true, billingStatus: 'billingStatus', usesApp: true, fixedPhone: 'fixedPhone', mobilePhone: 'mobilePhone', lastUpdated: DateTime(2026, 1, 10));
    expect(unitData, UnitData.fromJson(unitData.toJson()));
    expect(unitData.copyWith(), unitData);
    expect(unitData.toCompanion(true), isNotNull);
    expect(unitData.toCompanion(false), isNotNull);
    expect(unitData.toColumns(true), isNotEmpty);
    expect(unitData.toColumns(false), isNotEmpty);
    expect(unitData.toString(), contains('UnitData'));
    expect(unitData.hashCode, unitData.hashCode);

    final residentData = ResidentData(id: 'id', name: 'name', cpf: 'cpf', unitId: 'unitId', unitTitle: 'unitTitle', unitGroup: 'unitGroup', unitResidentCount: 1, condominiumId: 'condominiumId');
    expect(residentData, ResidentData.fromJson(residentData.toJson()));
    expect(residentData.copyWith(), residentData);
    expect(residentData.toCompanion(true), isNotNull);
    expect(residentData.toCompanion(false), isNotNull);
    expect(residentData.toColumns(true), isNotEmpty);
    expect(residentData.toColumns(false), isNotEmpty);
    expect(residentData.toString(), contains('ResidentData'));
    expect(residentData.hashCode, residentData.hashCode);

    final incomeForecastData = IncomeForecastData(condominiumId: 'condominiumId', year: 1, month: 1, forecastPeriod: 'forecastPeriod', forecast: 1.5, value: 1.5);
    expect(incomeForecastData, IncomeForecastData.fromJson(incomeForecastData.toJson()));
    expect(incomeForecastData.copyWith(), incomeForecastData);
    expect(incomeForecastData.toCompanion(true), isNotNull);
    expect(incomeForecastData.toCompanion(false), isNotNull);
    expect(incomeForecastData.toColumns(true), isNotEmpty);
    expect(incomeForecastData.toColumns(false), isNotEmpty);
    expect(incomeForecastData.toString(), contains('IncomeForecastData'));
    expect(incomeForecastData.hashCode, incomeForecastData.hashCode);

    final incomeData = IncomeData(condominiumId: 'condominiumId', value: 1.5, year: 1, month: 1);
    expect(incomeData, IncomeData.fromJson(incomeData.toJson()));
    expect(incomeData.copyWith(), incomeData);
    expect(incomeData.toCompanion(true), isNotNull);
    expect(incomeData.toCompanion(false), isNotNull);
    expect(incomeData.toColumns(true), isNotEmpty);
    expect(incomeData.toColumns(false), isNotEmpty);
    expect(incomeData.toString(), contains('IncomeData'));
    expect(incomeData.hashCode, incomeData.hashCode);

    final incomeShareData = IncomeShareData(condominiumId: 'condominiumId', year: 1, month: 1, title: 'title', total: 1, share: 1.5, color: 'color');
    expect(incomeShareData, IncomeShareData.fromJson(incomeShareData.toJson()));
    expect(incomeShareData.copyWith(), incomeShareData);
    expect(incomeShareData.toCompanion(true), isNotNull);
    expect(incomeShareData.toCompanion(false), isNotNull);
    expect(incomeShareData.toColumns(true), isNotEmpty);
    expect(incomeShareData.toColumns(false), isNotEmpty);
    expect(incomeShareData.toString(), contains('IncomeShareData'));
    expect(incomeShareData.hashCode, incomeShareData.hashCode);

    final chatContactData = ChatContactData(id: 'id', condominiumId: 'condominiumId', unitId: 'unitId', unitTitle: 'unitTitle', unitGroup: 'unitGroup', phone: 'phone');
    expect(chatContactData, ChatContactData.fromJson(chatContactData.toJson()));
    expect(chatContactData.copyWith(), chatContactData);
    expect(chatContactData.toCompanion(true), isNotNull);
    expect(chatContactData.toCompanion(false), isNotNull);
    expect(chatContactData.toColumns(true), isNotEmpty);
    expect(chatContactData.toColumns(false), isNotEmpty);
    expect(chatContactData.toString(), contains('ChatContactData'));
    expect(chatContactData.hashCode, chatContactData.hashCode);

    final employeeData = EmployeeData(condominiumId: 'condominiumId', id: 'id', name: 'name', dob: DateTime(2026, 1, 10), role: 'role', hiringDate: DateTime(2026, 1, 10), phone: 'phone', phone2: 'phone2', address: 'address', addressNumber: 'addressNumber', addressComplement: 'addressComplement', salary: 1.5, schooling: 'schooling', status: 'status');
    expect(employeeData, EmployeeData.fromJson(employeeData.toJson()));
    expect(employeeData.copyWith(), employeeData);
    expect(employeeData.toCompanion(true), isNotNull);
    expect(employeeData.toCompanion(false), isNotNull);
    expect(employeeData.toColumns(true), isNotEmpty);
    expect(employeeData.toColumns(false), isNotEmpty);
    expect(employeeData.toString(), contains('EmployeeData'));
    expect(employeeData.hashCode, employeeData.hashCode);

    final reservationSummaryData = ReservationSummaryData(day: DateTime(2026, 1, 10), condominiumId: 'condominiumId', type: 'type');
    expect(reservationSummaryData, ReservationSummaryData.fromJson(reservationSummaryData.toJson()));
    expect(reservationSummaryData.copyWith(), reservationSummaryData);
    expect(reservationSummaryData.toCompanion(true), isNotNull);
    expect(reservationSummaryData.toCompanion(false), isNotNull);
    expect(reservationSummaryData.toColumns(true), isNotEmpty);
    expect(reservationSummaryData.toColumns(false), isNotEmpty);
    expect(reservationSummaryData.toString(), contains('ReservationSummaryData'));
    expect(reservationSummaryData.hashCode, reservationSummaryData.hashCode);

    final spaceData = SpaceData(id: 'id', name: 'name', pictureUrl: 'pictureUrl', condominiumId: 'condominiumId');
    expect(spaceData, SpaceData.fromJson(spaceData.toJson()));
    expect(spaceData.copyWith(), spaceData);
    expect(spaceData.toCompanion(true), isNotNull);
    expect(spaceData.toCompanion(false), isNotNull);
    expect(spaceData.toColumns(true), isNotEmpty);
    expect(spaceData.toColumns(false), isNotEmpty);
    expect(spaceData.toString(), contains('SpaceData'));
    expect(spaceData.hashCode, spaceData.hashCode);

    final condominiumBalanceData = CondominiumBalanceData(id: 'id', reference: 'reference', balance: 1.5, previousBalance: 1.5, forecast: 1.5, income: 1.5, expenses: 1.5, date: DateTime(2026, 1, 10), lastUpdatedAt: DateTime(2026, 1, 10));
    expect(condominiumBalanceData, CondominiumBalanceData.fromJson(condominiumBalanceData.toJson()));
    expect(condominiumBalanceData.copyWith(), condominiumBalanceData);
    expect(condominiumBalanceData.toCompanion(true), isNotNull);
    expect(condominiumBalanceData.toCompanion(false), isNotNull);
    expect(condominiumBalanceData.toColumns(true), isNotEmpty);
    expect(condominiumBalanceData.toColumns(false), isNotEmpty);
    expect(condominiumBalanceData.toString(), contains('CondominiumBalanceData'));
    expect(condominiumBalanceData.hashCode, condominiumBalanceData.hashCode);

    final condominiumBalanceDetailData = CondominiumBalanceDetailData(reference: 'reference', previousBalance: 1.5, balance: 1.5, accountBalance: 1.5, debit: 1.5, credits: 1.5, lastUpdatedAt: DateTime(2026, 1, 10));
    expect(condominiumBalanceDetailData, CondominiumBalanceDetailData.fromJson(condominiumBalanceDetailData.toJson()));
    expect(condominiumBalanceDetailData.copyWith(), condominiumBalanceDetailData);
    expect(condominiumBalanceDetailData.toCompanion(true), isNotNull);
    expect(condominiumBalanceDetailData.toCompanion(false), isNotNull);
    expect(condominiumBalanceDetailData.toColumns(true), isNotEmpty);
    expect(condominiumBalanceDetailData.toColumns(false), isNotEmpty);
    expect(condominiumBalanceDetailData.toString(), contains('CondominiumBalanceDetailData'));
    expect(condominiumBalanceDetailData.hashCode, condominiumBalanceDetailData.hashCode);

    final condominiumBalanceDebitsData = CondominiumBalanceDebitsData(reference: 'reference', id: 'id', name: 'name', type: 'type', previousBalance: 1.5, balance: 1.5, accountBalance: 1.5, debit: 1.5, credits: 1.5, period: DateTime(2026, 1, 10));
    expect(condominiumBalanceDebitsData, CondominiumBalanceDebitsData.fromJson(condominiumBalanceDebitsData.toJson()));
    expect(condominiumBalanceDebitsData.copyWith(), condominiumBalanceDebitsData);
    expect(condominiumBalanceDebitsData.toCompanion(true), isNotNull);
    expect(condominiumBalanceDebitsData.toCompanion(false), isNotNull);
    expect(condominiumBalanceDebitsData.toColumns(true), isNotEmpty);
    expect(condominiumBalanceDebitsData.toColumns(false), isNotEmpty);
    expect(condominiumBalanceDebitsData.toString(), contains('CondominiumBalanceDebitsData'));
    expect(condominiumBalanceDebitsData.hashCode, condominiumBalanceDebitsData.hashCode);

    final condominiumBalanceSummaryData = CondominiumBalanceSummaryData(reference: 'reference', name: 'name', debits: 1.5, credits: 1.5);
    expect(condominiumBalanceSummaryData, CondominiumBalanceSummaryData.fromJson(condominiumBalanceSummaryData.toJson()));
    expect(condominiumBalanceSummaryData.copyWith(), condominiumBalanceSummaryData);
    expect(condominiumBalanceSummaryData.toCompanion(true), isNotNull);
    expect(condominiumBalanceSummaryData.toCompanion(false), isNotNull);
    expect(condominiumBalanceSummaryData.toColumns(true), isNotEmpty);
    expect(condominiumBalanceSummaryData.toColumns(false), isNotEmpty);
    expect(condominiumBalanceSummaryData.toString(), contains('CondominiumBalanceSummaryData'));
    expect(condominiumBalanceSummaryData.hashCode, condominiumBalanceSummaryData.hashCode);

    final agreementsData = AgreementsData(id: 'id', condominiumId: 'condominiumId', reference: 1, unit: 'unit', unitOwner: 'unitOwner', baseValue: 1.5, fineAndCosts: 1.5, installmentQuantity: 1, paymentMethod: 'paymentMethod', status: 'status', statusMessage: 'statusMessage', expiration: DateTime(2026, 1, 10), proposaldedDate: DateTime(2026, 1, 10), approvalDate: DateTime(2026, 1, 10), dueDate: 1, lastInstallmentDate: DateTime(2026, 1, 10));
    expect(agreementsData, AgreementsData.fromJson(agreementsData.toJson()));
    expect(agreementsData.copyWith(), agreementsData);
    expect(agreementsData.toCompanion(true), isNotNull);
    expect(agreementsData.toCompanion(false), isNotNull);
    expect(agreementsData.toColumns(true), isNotEmpty);
    expect(agreementsData.toColumns(false), isNotEmpty);
    expect(agreementsData.toString(), contains('AgreementsData'));
    expect(agreementsData.hashCode, agreementsData.hashCode);

    final agreementsInstallmentsData = AgreementsInstallmentsData(installmentId: 'installmentId', condominiumId: 'condominiumId', agreementId: 'agreementId', reference: 1, value: 1.5, dueDate: DateTime(2026, 1, 10), status: 'status');
    expect(agreementsInstallmentsData, AgreementsInstallmentsData.fromJson(agreementsInstallmentsData.toJson()));
    expect(agreementsInstallmentsData.copyWith(), agreementsInstallmentsData);
    expect(agreementsInstallmentsData.toCompanion(true), isNotNull);
    expect(agreementsInstallmentsData.toCompanion(false), isNotNull);
    expect(agreementsInstallmentsData.toColumns(true), isNotEmpty);
    expect(agreementsInstallmentsData.toColumns(false), isNotEmpty);
    expect(agreementsInstallmentsData.toString(), contains('AgreementsInstallmentsData'));
    expect(agreementsInstallmentsData.hashCode, agreementsInstallmentsData.hashCode);

    final agreementsQuoteData = AgreementsQuoteData(id: 'id', condominiumId: 'condominiumId', agreementId: 'agreementId', reference: 1, dueDate: DateTime(2026, 1, 10), originValue: 1.5, fineValue: 1.5, feeValue: 1.5, honoraryValue: 1.5, overdueMessage: 'overdueMessage');
    expect(agreementsQuoteData, AgreementsQuoteData.fromJson(agreementsQuoteData.toJson()));
    expect(agreementsQuoteData.copyWith(), agreementsQuoteData);
    expect(agreementsQuoteData.toCompanion(true), isNotNull);
    expect(agreementsQuoteData.toCompanion(false), isNotNull);
    expect(agreementsQuoteData.toColumns(true), isNotEmpty);
    expect(agreementsQuoteData.toColumns(false), isNotEmpty);
    expect(agreementsQuoteData.toString(), contains('AgreementsQuoteData'));
    expect(agreementsQuoteData.hashCode, agreementsQuoteData.hashCode);

    final agreementsRulesDaysData = AgreementsRulesDaysData(condominiumId: 'condominiumId', days: 1);
    expect(agreementsRulesDaysData, AgreementsRulesDaysData.fromJson(agreementsRulesDaysData.toJson()));
    expect(agreementsRulesDaysData.copyWith(), agreementsRulesDaysData);
    expect(agreementsRulesDaysData.toCompanion(true), isNotNull);
    expect(agreementsRulesDaysData.toCompanion(false), isNotNull);
    expect(agreementsRulesDaysData.toColumns(true), isNotEmpty);
    expect(agreementsRulesDaysData.toColumns(false), isNotEmpty);
    expect(agreementsRulesDaysData.toString(), contains('AgreementsRulesDaysData'));
    expect(agreementsRulesDaysData.hashCode, agreementsRulesDaysData.hashCode);

    final agreementsRulesInstallmentsData = AgreementsRulesInstallmentsData(condominiumId: 'condominiumId', installmentQtd: 1);
    expect(agreementsRulesInstallmentsData, AgreementsRulesInstallmentsData.fromJson(agreementsRulesInstallmentsData.toJson()));
    expect(agreementsRulesInstallmentsData.copyWith(), agreementsRulesInstallmentsData);
    expect(agreementsRulesInstallmentsData.toCompanion(true), isNotNull);
    expect(agreementsRulesInstallmentsData.toCompanion(false), isNotNull);
    expect(agreementsRulesInstallmentsData.toColumns(true), isNotEmpty);
    expect(agreementsRulesInstallmentsData.toColumns(false), isNotEmpty);
    expect(agreementsRulesInstallmentsData.toString(), contains('AgreementsRulesInstallmentsData'));
    expect(agreementsRulesInstallmentsData.hashCode, agreementsRulesInstallmentsData.hashCode);

    final resinPeopleData = ResinPeopleData(condominiumId: 'condominiumId', id: 'id', document: 'document', name: 'name', role: 'role');
    expect(resinPeopleData, ResinPeopleData.fromJson(resinPeopleData.toJson()));
    expect(resinPeopleData.copyWith(), resinPeopleData);
    expect(resinPeopleData.toCompanion(true), isNotNull);
    expect(resinPeopleData.toCompanion(false), isNotNull);
    expect(resinPeopleData.toColumns(true), isNotEmpty);
    expect(resinPeopleData.toColumns(false), isNotEmpty);
    expect(resinPeopleData.toString(), contains('ResinPeopleData'));
    expect(resinPeopleData.hashCode, resinPeopleData.hashCode);

    final resinBanksData = ResinBanksData(condominiumId: 'condominiumId', id: 'id', bankCode: 'bankCode', bankName: 'bankName');
    expect(resinBanksData, ResinBanksData.fromJson(resinBanksData.toJson()));
    expect(resinBanksData.copyWith(), resinBanksData);
    expect(resinBanksData.toCompanion(true), isNotNull);
    expect(resinBanksData.toCompanion(false), isNotNull);
    expect(resinBanksData.toColumns(true), isNotEmpty);
    expect(resinBanksData.toColumns(false), isNotEmpty);
    expect(resinBanksData.toString(), contains('ResinBanksData'));
    expect(resinBanksData.hashCode, resinBanksData.hashCode);

    final resinBankAccountsData = ResinBankAccountsData(condominiumId: 'condominiumId', id: 'id', bankId: 'bankId', agency: 'agency', accountNumber: 'accountNumber', document: 'document', supplierName: 'supplierName', type: 'type');
    expect(resinBankAccountsData, ResinBankAccountsData.fromJson(resinBankAccountsData.toJson()));
    expect(resinBankAccountsData.copyWith(), resinBankAccountsData);
    expect(resinBankAccountsData.toCompanion(true), isNotNull);
    expect(resinBankAccountsData.toCompanion(false), isNotNull);
    expect(resinBankAccountsData.toColumns(true), isNotEmpty);
    expect(resinBankAccountsData.toColumns(false), isNotEmpty);
    expect(resinBankAccountsData.toString(), contains('ResinBankAccountsData'));
    expect(resinBankAccountsData.hashCode, resinBankAccountsData.hashCode);

    final resinRefundsData = ResinRefundsData(condominiumId: 'condominiumId', id: 'id', destinationAccountId: 'destinationAccountId', requestDate: DateTime(2026, 1, 10), requester: 'requester', status: 'status', type: 'type', value: 1.5, protocol: 'protocol', description: 'description', canEdit: true, canCancel: true, inconcistency: 'inconcistency');
    expect(resinRefundsData, ResinRefundsData.fromJson(resinRefundsData.toJson()));
    expect(resinRefundsData.copyWith(), resinRefundsData);
    expect(resinRefundsData.toCompanion(true), isNotNull);
    expect(resinRefundsData.toCompanion(false), isNotNull);
    expect(resinRefundsData.toColumns(true), isNotEmpty);
    expect(resinRefundsData.toColumns(false), isNotEmpty);
    expect(resinRefundsData.toString(), contains('ResinRefundsData'));
    expect(resinRefundsData.hashCode, resinRefundsData.hashCode);

    final layoutData = LayoutData(id: 'id', condoId: 'condoId', cod: 'cod', name: 'name', reference: 'reference', primary: 'primary', secondary: 'secondary', logoPath: 'logoPath');
    expect(layoutData, LayoutData.fromJson(layoutData.toJson()));
    expect(layoutData.copyWith(), layoutData);
    expect(layoutData.toCompanion(true), isNotNull);
    expect(layoutData.toCompanion(false), isNotNull);
    expect(layoutData.toColumns(true), isNotEmpty);
    expect(layoutData.toColumns(false), isNotEmpty);
    expect(layoutData.toString(), contains('LayoutData'));
    expect(layoutData.hashCode, layoutData.hashCode);

  });

  test('abre banco em memória, persiste via DAOs e reseta', () async {
    final db = LelloDatabase.forExecutor(NativeDatabase.memory());
    addTearDown(db.close);
    expect(db.schemaVersion, 13);

    Future<void> put<T extends Table, D>(
      TableInfo<T, D> table,
      Insertable<D> row,
    ) async {
      await db.into(table).insert(row, mode: InsertMode.replace);
    }

    await put(db.pendencyTable, PendencyData(condominiumId: 'condominiumId', id: 'id', title: 'title', message: 'message', date: DateTime(2026, 1, 10), type: 'type', senderId: 'senderId', senderName: 'senderName', senderPicture: 'senderPicture', module: 'module'));
    await put(db.meTable, MeData(name: 'name', email: 'email', cpf: 'cpf', phone: 'phone', picture: 'picture', pictureHash: 'pictureHash'));
    await put(db.condominiumTable, CondominiumData(id: 'id', name: 'name', address: 'address', reference: 'reference', useFacialBiometric: true, managerAccessControlBiometricStatus: 'managerAccessControlBiometricStatus', notificationContext: 'notificationContext'));
    await put(db.accountTable, AccountData(id: 'id', number: 'number', name: 'name', condominiumId: 'condominiumId'));
    await put(db.lelloHubTable, LelloHubData(number: 'number'));
    await put(db.unitTable, UnitData(id: 'id', title: 'title', group: 'group', residentCount: 1, condominiumId: 'condominiumId', vehicleCount: 1, adimplente: true, agreement: true, billingStatus: 'billingStatus', usesApp: true, fixedPhone: 'fixedPhone', mobilePhone: 'mobilePhone', lastUpdated: DateTime(2026, 1, 10)));
    await put(db.residentTable, ResidentData(id: 'id', name: 'name', cpf: 'cpf', unitId: 'unitId', unitTitle: 'unitTitle', unitGroup: 'unitGroup', unitResidentCount: 1, condominiumId: 'condominiumId'));
    await put(db.incomeForecastTable, IncomeForecastData(condominiumId: 'condominiumId', year: 1, month: 1, forecastPeriod: 'forecastPeriod', forecast: 1.5, value: 1.5));
    await put(db.incomeTable, IncomeData(condominiumId: 'condominiumId', value: 1.5, year: 1, month: 1));
    await put(db.incomeShareTable, IncomeShareData(condominiumId: 'condominiumId', year: 1, month: 1, title: 'title', total: 1, share: 1.5, color: 'color'));
    await put(db.chatContactTable, ChatContactData(id: 'id', condominiumId: 'condominiumId', unitId: 'unitId', unitTitle: 'unitTitle', unitGroup: 'unitGroup', phone: 'phone'));
    await put(db.employeeTable, EmployeeData(condominiumId: 'condominiumId', id: 'id', name: 'name', dob: DateTime(2026, 1, 10), role: 'role', hiringDate: DateTime(2026, 1, 10), phone: 'phone', phone2: 'phone2', address: 'address', addressNumber: 'addressNumber', addressComplement: 'addressComplement', salary: 1.5, schooling: 'schooling', status: 'status'));
    await put(db.reservationSummaryTable, ReservationSummaryData(day: DateTime(2026, 1, 10), condominiumId: 'condominiumId', type: 'type'));
    await put(db.spaceTable, SpaceData(id: 'id', name: 'name', pictureUrl: 'pictureUrl', condominiumId: 'condominiumId'));
    await put(db.condominiumBalanceTable, CondominiumBalanceData(id: 'id', reference: 'reference', balance: 1.5, previousBalance: 1.5, forecast: 1.5, income: 1.5, expenses: 1.5, date: DateTime(2026, 1, 10), lastUpdatedAt: DateTime(2026, 1, 10)));
    await put(db.condominiumBalanceDetailTable, CondominiumBalanceDetailData(reference: 'reference', previousBalance: 1.5, balance: 1.5, accountBalance: 1.5, debit: 1.5, credits: 1.5, lastUpdatedAt: DateTime(2026, 1, 10)));
    await put(db.condominiumBalanceDebitsTable, CondominiumBalanceDebitsData(reference: 'reference', id: 'id', name: 'name', type: 'type', previousBalance: 1.5, balance: 1.5, accountBalance: 1.5, debit: 1.5, credits: 1.5, period: DateTime(2026, 1, 10)));
    await put(db.condominiumBalanceSummaryTable, CondominiumBalanceSummaryData(reference: 'reference', name: 'name', debits: 1.5, credits: 1.5));
    await put(db.agreementsTable, AgreementsData(id: 'id', condominiumId: 'condominiumId', reference: 1, unit: 'unit', unitOwner: 'unitOwner', baseValue: 1.5, fineAndCosts: 1.5, installmentQuantity: 1, paymentMethod: 'paymentMethod', status: 'status', statusMessage: 'statusMessage', expiration: DateTime(2026, 1, 10), proposaldedDate: DateTime(2026, 1, 10), approvalDate: DateTime(2026, 1, 10), dueDate: 1, lastInstallmentDate: DateTime(2026, 1, 10)));
    await put(db.agreementsInstallmentsTable, AgreementsInstallmentsData(installmentId: 'installmentId', condominiumId: 'condominiumId', agreementId: 'agreementId', reference: 1, value: 1.5, dueDate: DateTime(2026, 1, 10), status: 'status'));
    await put(db.agreementsQuoteTable, AgreementsQuoteData(id: 'id', condominiumId: 'condominiumId', agreementId: 'agreementId', reference: 1, dueDate: DateTime(2026, 1, 10), originValue: 1.5, fineValue: 1.5, feeValue: 1.5, honoraryValue: 1.5, overdueMessage: 'overdueMessage'));
    await put(db.agreementsRulesDaysTable, AgreementsRulesDaysData(condominiumId: 'condominiumId', days: 1));
    await put(db.agreementsRulesInstallmentsTable, AgreementsRulesInstallmentsData(condominiumId: 'condominiumId', installmentQtd: 1));
    await put(db.resinPeopleTable, ResinPeopleData(condominiumId: 'condominiumId', id: 'id', document: 'document', name: 'name', role: 'role'));
    await put(db.resinBanksTable, ResinBanksData(condominiumId: 'condominiumId', id: 'id', bankCode: 'bankCode', bankName: 'bankName'));
    await put(db.resinBankAccountsTable, ResinBankAccountsData(condominiumId: 'condominiumId', id: 'id', bankId: 'bankId', agency: 'agency', accountNumber: 'accountNumber', document: 'document', supplierName: 'supplierName', type: 'type'));
    await put(db.resinRefundsTable, ResinRefundsData(condominiumId: 'condominiumId', id: 'id', destinationAccountId: 'destinationAccountId', requestDate: DateTime(2026, 1, 10), requester: 'requester', status: 'status', type: 'type', value: 1.5, protocol: 'protocol', description: 'description', canEdit: true, canCancel: true, inconcistency: 'inconcistency'));
    await put(db.layoutTable, LayoutData(id: 'id', condoId: 'condoId', cod: 'cod', name: 'name', reference: 'reference', primary: 'primary', secondary: 'secondary', logoPath: 'logoPath'));

    expect(await db.select(db.meTable).get(), isNotEmpty);
    expect(await db.select(db.pendencyTable).get(), isNotEmpty);
    expect(await db.select(db.condominiumTable).get(), isNotEmpty);
    final reset = await db.resetDb();
    expect(reset, isA<Success>());
    expect(await db.select(db.meTable).get(), isEmpty);
  });
}
