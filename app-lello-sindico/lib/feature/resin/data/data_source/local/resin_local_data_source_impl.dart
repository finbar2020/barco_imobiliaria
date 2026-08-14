import 'package:drift/drift.dart';
import 'package:lello/core/database/lello_database.dart';
import 'package:lello/core/database/resin/resin_bank_accounts/resin_bank_accounts_dao.dart';
import 'package:lello/core/database/resin/resin_banks/resin_banks_dao.dart';
import 'package:lello/core/database/resin/resin_people/resin_people_dao.dart';
import 'package:lello/core/database/resin/resin_refunds/resin_refunds_dao.dart';
import 'package:lello/feature/resin/data/data_source/local/resin_local_data_source.dart';
import 'package:lello/feature/resin/data/model/resin_bank_account_model.dart';
import 'package:lello/feature/resin/data/model/resin_bank_model.dart';
import 'package:lello/feature/resin/data/model/resin_person_model.dart';
import 'package:lello/feature/resin/data/model/resin_refund_model.dart';

class ResinLocalDataSourceImpl extends ResinLocalDataSource {
  final ResinBanksDao resinBanksDao;
  final ResinBankAccountsDao resinBankAccountsDao;
  final ResinPeopleDao resinPeopleDao;
  final ResinRefundsDao resinRefundsDao;

  ResinLocalDataSourceImpl({
    required this.resinBanksDao,
    required this.resinBankAccountsDao,
    required this.resinPeopleDao,
    required this.resinRefundsDao,
  });

  @override
  Future<List<ResinPersonModel>> selectAllPeople(String condominiumId) async {
    List<ResinPeopleData> peopleDataList =
        await resinPeopleDao.getResinPeople(condominiumId) ?? [];

    List<ResinPersonModel> people = peopleDataList
        .map((e) => ResinPersonModel(
              id: e.id,
              document: e.document,
              name: e.name,
              role: e.role,
            ))
        .toList();

    return people;
  }

  @override
  Future<void> saveAllPeople(
      String condominiumId, List<ResinPersonModel> people) async {
    resinPeopleDao.deleteCondominiumResinPeople(condominiumId);
    people.forEach((e) {
      final personData = ResinPeopleTableCompanion(
        condominiumId: Value(condominiumId),
        id: Value(e.id),
        document: Value(e.document),
        name: Value(e.name),
        role: Value(e.role),
      );
      resinPeopleDao.insert(personData);
    });
  }

  @override
  Future<List<ResinBankModel>> selectAllBanks(String condominiumId) async {
    List<ResinBanksData> banksDataList =
        await resinBanksDao.getResinBanks(condominiumId) ?? [];

    List<ResinBankModel> banks = banksDataList
        .map((e) => ResinBankModel(
              id: e.id,
              bankCode: e.bankCode,
              bankName: e.bankName,
            ))
        .toList();

    return banks;
  }

  @override
  Future<void> saveSingleBank(String condominiumId, ResinBankModel bank) async {
    final bankData = ResinBanksTableCompanion(
      condominiumId: Value(condominiumId),
      id: Value(bank.id),
      bankCode: Value(bank.bankCode),
      bankName: Value(bank.bankName),
    );
    resinBanksDao.insert(bankData);
  }

  @override
  Future<void> saveAllBanks(
      String condominiumId, List<ResinBankModel> banks) async {
    resinBanksDao.deleteCondominiumResinBanks(condominiumId);
    banks.forEach((e) {
      final bankData = ResinBanksTableCompanion(
        condominiumId: Value(condominiumId),
        id: Value(e.id),
        bankCode: Value(e.bankCode),
        bankName: Value(e.bankName),
      );
      resinBanksDao.insert(bankData);
    });
  }

  @override
  Future<List<ResinBankAccountModel>> selectAllBankAccounts(
      String condominiumId) async {
    List<ResinBankAccountsData> bankAccountsDataList =
        await resinBankAccountsDao.getResinBankAccounts(condominiumId);
    if (bankAccountsDataList.isEmpty) return [];

    List<ResinBankModel> banks = await selectAllBanks(condominiumId);

    if (banks.isEmpty) return [];

    List<ResinBankAccountModel> bankAccounts = bankAccountsDataList
        .map((e) => _bankAccountModelFromData(e, banks))
        .whereType<ResinBankAccountModel>()
        .toList();

    return bankAccounts;
  }

  @override
  Future<void> saveBankAccounts(
      String condominiumId, List<ResinBankAccountModel> bankAccounts) async {
    resinBankAccountsDao.deleteCondominiumResinBankAccounts(condominiumId);
    bankAccounts.forEach((e) {
      saveSingleBankAccount(condominiumId, e);
    });
  }

  @override
  Future<void> saveSingleBankAccount(
      String condominiumId, ResinBankAccountModel bankAccount) async {
    if (bankAccount.bank == null) return;
    final bankAccountData = ResinBankAccountsTableCompanion(
      condominiumId: Value(condominiumId),
      id: Value(bankAccount.id),
      bankId: Value(bankAccount.bank!.id),
      agency: Value(bankAccount.agency),
      accountNumber: Value(bankAccount.accountNumber),
      document: Value(bankAccount.document),
      supplierName: Value(bankAccount.supplierName),
      type: Value(bankAccount.type),
    );
    resinBankAccountsDao.insert(bankAccountData);
  }

  @override
  Future<void> deleteBankAccounts(String accountId) async {
    resinBankAccountsDao.deleteResinBankAccount(accountId);
  }

  @override
  Future<List<ResinRefundModel>> selectAllRefunds(String condominiumId) async {
    List<ResinRefundsData> refundsDataList =
        await resinRefundsDao.getResinRefunds(condominiumId) ?? [];
    if (refundsDataList.isEmpty) return [];

    List<ResinBankModel> banks = await selectAllBanks(condominiumId);
    if (banks.isEmpty) return [];

    List<ResinRefundModel> refunds = [];
    await Future.forEach<ResinRefundsData>(refundsDataList, (e) async {
      ResinBankAccountsData? accountData = await resinBankAccountsDao
          .getSingleResinBankAccount(e.destinationAccountId);

      ResinRefundModel refund = ResinRefundModel(
        id: e.id,
        requestDate: e.requestDate,
        requester: e.requester,
        status: e.status,
        type: e.type,
        value: e.value,
        protocol: e.protocol,
        description: e.description,
        canEdit: e.canEdit,
        canCancel: e.canCancel,
        inconcistency: e.inconcistency,
        receipts: [],
        destinationAccount: _bankAccountModelFromData(accountData, banks),
      );
      refunds.add(refund);
    });

    return refunds;
  }

  Future<void> saveAllRefunds(
      String condominiumId, List<ResinRefundModel> refunds) async {
    resinRefundsDao.deleteCondominiumResinRefunds(condominiumId);
    refunds.forEach((e) {
      saveSingleRefund(condominiumId, e);
    });
  }

  Future<void> saveSingleRefund(
      String condominiumId, ResinRefundModel refund) async {
    if (refund.destinationAccount == null) return;
    final refundData = ResinRefundsTableCompanion(
      condominiumId: Value(condominiumId),
      id: Value(refund.id),
      destinationAccountId: Value(refund.destinationAccount!.id),
      requestDate: Value(refund.requestDate),
      requester: Value(refund.requester),
      status: Value(refund.status),
      type: Value(refund.type),
      value: Value(refund.value),
      protocol: Value(refund.protocol),
      description: Value(refund.description),
      canEdit: Value(refund.canEdit),
      canCancel: Value(refund.canCancel),
      inconcistency: Value(refund.inconcistency),
    );
    resinRefundsDao.insert(refundData);
  }

  ResinBankAccountModel? _bankAccountModelFromData(
      ResinBankAccountsData? bankAccountData, List<ResinBankModel> banks) {
    if (bankAccountData == null) return null;
    ResinBankModel? bank = banks
        .cast<ResinBankModel?>()
        .firstWhere((b) => b?.id == bankAccountData.bankId, orElse: () => null);
    if (bank == null) {
      return null;
    }
    return ResinBankAccountModel(
      id: bankAccountData.id,
      bank: bank,
      agency: bankAccountData.agency,
      accountNumber: bankAccountData.accountNumber,
      document: bankAccountData.document,
      supplierName: bankAccountData.supplierName,
      type: bankAccountData.type,
    );
  }
}
