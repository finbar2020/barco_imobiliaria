import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/resin/domain/entity/resin_bank.dart';
import 'package:lello/feature/resin/domain/entity/resin_bank_account.dart';
import 'package:lello/feature/resin/domain/entity/resin_bank_account_type.dart';
import 'package:lello/feature/resin/domain/entity/resin_check_max_value_param.dart';
import 'package:lello/feature/resin/domain/entity/resin_params.dart';
import 'package:lello/feature/resin/domain/entity/resin_person.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_filter.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_status.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_type.dart';
import 'package:lello/feature/resin/domain/repository/resin_bank_repository.dart';
import 'package:lello/feature/resin/domain/repository/resin_repository.dart';
import 'package:lello/feature/resin/domain/use_case/create_resin_bank_account/create_resin_bank_account.dart';
import 'package:lello/feature/resin/domain/use_case/create_resin_bank_account/create_resin_bank_account_impl.dart';
import 'package:lello/feature/resin/domain/use_case/create_resin_refund/create_resin_refund.dart';
import 'package:lello/feature/resin/domain/use_case/create_resin_refund/create_resin_refund_impl.dart';
import 'package:lello/feature/resin/domain/use_case/delete_resin_bank_account/delete_resin_bank_account.dart';
import 'package:lello/feature/resin/domain/use_case/delete_resin_bank_account/delete_resin_bank_account_impl.dart';
import 'package:lello/feature/resin/domain/use_case/delete_resin_refund/delete_resin_refund.dart';
import 'package:lello/feature/resin/domain/use_case/delete_resin_refund/delete_resin_refund_impl.dart';
import 'package:lello/feature/resin/domain/use_case/edit_resin_refund/edit_resin_refund.dart';
import 'package:lello/feature/resin/domain/use_case/edit_resin_refund/edit_resin_refund_impl.dart';
import 'package:lello/feature/resin/domain/use_case/get_resin_bank_accounts/get_resin_bank_accounts.dart';
import 'package:lello/feature/resin/domain/use_case/get_resin_bank_accounts/get_resin_bank_accounts_impl.dart';
import 'package:lello/feature/resin/domain/use_case/get_resin_banks/get_resin_banks.dart';
import 'package:lello/feature/resin/domain/use_case/get_resin_banks/get_resin_banks_impl.dart';
import 'package:lello/feature/resin/domain/use_case/get_resin_check_max_value/get_resin_check_max_value.dart';
import 'package:lello/feature/resin/domain/use_case/get_resin_check_max_value/get_resin_check_max_value_impl.dart';
import 'package:lello/feature/resin/domain/use_case/get_resin_params/get_resin_params.dart';
import 'package:lello/feature/resin/domain/use_case/get_resin_params/get_resin_params_impl.dart';
import 'package:lello/feature/resin/domain/use_case/get_resin_people/get_resin_people.dart';
import 'package:lello/feature/resin/domain/use_case/get_resin_people/get_resin_people_impl.dart';
import 'package:lello/feature/resin/domain/use_case/get_resin_refund_details/get_resin_refund_details.dart';
import 'package:lello/feature/resin/domain/use_case/get_resin_refund_details/get_resin_refund_details_impl.dart';
import 'package:lello/feature/resin/domain/use_case/get_resin_refunds/get_resin_refunds.dart';
import 'package:lello/feature/resin/domain/use_case/get_resin_refunds/get_resin_refunds_impl.dart';

ResinRefund _refund() => ResinRefund(
      requestDate: DateTime(2026, 1, 1),
      requester: 'Ana',
      status: ResinRefundStatus.sended,
      type: ResinRefundType.refund,
      value: 10,
    );

ResinBankAccount _account() => ResinBankAccount(
      bank: ResinBank(id: '1', bankCode: '001', bankName: 'BB'),
      agency: '1',
      accountNumber: '2',
      document: '123',
      supplierName: 'Fornecedor',
      accountType: ResinBankAccountType.current,
    );

class _FakeResinRepo extends Fake implements ResinRepository {
  Object? last;

  @override
  Future<Try<ResinParams>> getResinParams(String condominiumId) async =>
      Success(ResinParams(avaliableValue: 40, requestMaxValue: 100));

  @override
  Future<Try<List<ResinPerson>>> getResinPeople(String condominiumId) async {
    last = 'remote';
    return Success([
      ResinPerson(id: 'p1', document: '1', name: 'Ana', role: 'síndico'),
    ]);
  }

  @override
  Future<Try<List<ResinPerson>>> getResinPeopleFromCache(
      String condominiumId) async {
    last = 'local';
    return Success(const []);
  }

  @override
  Future<Try<List<ResinRefund>>> getResinRefunds(
      String condominiumId, ResinRefundFilter filter) async {
    last = 'remote';
    return Success([_refund()]);
  }

  @override
  Future<Try<List<ResinRefund>>> getResinRefundsFromCache(
      String condominiumId) async {
    last = 'local';
    return Success(const []);
  }

  @override
  Future<Try<ResinRefund>> createResinRefund(
      String condominiumId, ResinRefund refund) async =>
      Success(refund);

  @override
  Future<Try<ResinRefund>> getResinRefundDetails(
      String condominiumId, String refundId) async {
    last = refundId;
    return Success(_refund()..id = refundId);
  }

  @override
  Future<Try<bool>> refundCancel(String condominiumId, String refundId) async {
    last = refundId;
    return Success(true);
  }

  @override
  Future<Try<bool>> refundEdit(String condominiumId, ResinRefund refund) async =>
      Success(true);

  @override
  Future<Try<ResinCheckMaxValueParam>> checkMaxValue(
      String condominiumId, String type, double value) async {
    last = value;
    return Success(ResinCheckMaxValueParam(
      canRequest: true,
      message: 'ok',
      emailSended: false,
    ));
  }
}

class _FakeBankRepo extends Fake implements ResinBankRepository {
  Object? last;

  @override
  Future<Try<List<ResinBank>>> getResinBanks(String condominiumId) async {
    last = 'remote';
    return Success([ResinBank(id: '1', bankCode: '001', bankName: 'BB')]);
  }

  @override
  Future<Try<List<ResinBank>>> getResinBanksFromCache(
      String condominiumId) async {
    last = 'local';
    return Success(const []);
  }

  @override
  Future<Try<List<ResinBankAccount>>> getResinBankAccounts(
      String condominiumId) async {
    last = 'remote';
    return Success([_account()]);
  }

  @override
  Future<Try<List<ResinBankAccount>>> getResinBankAccountsFromCache(
      String condominiumId) async {
    last = 'local';
    return Success(const []);
  }

  @override
  Future<Try<ResinBankAccount>> createResinBankAccount(
          String condominiumId, ResinBankAccount newAccount) async =>
      Success(newAccount);

  @override
  Future<Try<bool>> deleteResinBankAccount(
      String condominiumId, String accountId) async {
    last = accountId;
    return Success(true);
  }
}

void main() {
  late _FakeResinRepo repo;
  late _FakeBankRepo banks;

  setUp(() {
    repo = _FakeResinRepo();
    banks = _FakeBankRepo();
  });

  test('GetResinParamsImpl e usedValue', () async {
    final result = await GetResinParamsImpl(repository: repo)(
      GetResinParamsParams(condominiumId: 'c1'),
    );
    expect(result, isA<Success<ResinParams>>());
    expect((result as Success<ResinParams>).get().usedValue, 60);
  });

  test('GetResinPeopleImpl e GetResinRefundsImpl usam cache ou rede', () async {
    await GetResinPeopleImpl(repository: repo)(
      GetResinPeopleParams(condominiumId: 'c1', origin: DataOrigin.local),
    );
    expect(repo.last, 'local');
    await GetResinPeopleImpl(repository: repo)(
      GetResinPeopleParams(condominiumId: 'c1', origin: DataOrigin.remote),
    );
    expect(repo.last, 'remote');

    await GetResinRefundsImpl(repository: repo)(
      GetResinRefundsParams(
        condominiumId: 'c1',
        filter: ResinRefundFilter(),
        origin: DataOrigin.local,
      ),
    );
    expect(repo.last, 'local');
  });

  test('CRUD de reembolso e teto máximo', () async {
    expect(
      await CreateResinRefundImpl(repository: repo)(
        CreateResinRefundParams(condominiumId: 'c1', refund: _refund()),
      ),
      isA<Success<ResinRefund>>(),
    );
    expect(
      await GetResinRefundDetailsImpl(repository: repo)(
        GetResinRefundDetailsParams(condominiumId: 'c1', refundId: 'rf1'),
      ),
      isA<Success<ResinRefund>>(),
    );
    expect(
      await EditResinRefundImpl(repository: repo)(
        EditResinRefundParams(condominiumId: 'c1', refund: _refund()),
      ),
      isA<Success<bool>>(),
    );
    expect(
      await DeleteResinRefundImpl(repository: repo)(
        DeleteResinRefundParams(condominiumId: 'c1', refundId: 'rf1'),
      ),
      isA<Success<bool>>(),
    );
    expect(
      await GetResinCheckMaxValueUsecaseImpl(repository: repo)(
        GetResinCheckMaxValueParams(
          condominiumId: 'c1',
          type: 'refund',
          value: 0,
        ),
      ),
      isA<Rejection<ResinCheckMaxValueParam>>(),
    );
    expect(
      await GetResinCheckMaxValueUsecaseImpl(repository: repo)(
        GetResinCheckMaxValueParams(
          condominiumId: 'c1',
          type: 'refund',
          value: 10,
        ),
      ),
      isA<Success<ResinCheckMaxValueParam>>(),
    );
  });

  test('Bancos e contas resin', () async {
    await GetResinBanksImpl(repository: banks)(
      GetResinBanksParams(condominiumId: 'c1', origin: DataOrigin.local),
    );
    expect(banks.last, 'local');
    await GetResinBankAccountsImpl(repository: banks)(
      GetResinBankAccountsParams(condominiumId: 'c1', origin: DataOrigin.remote),
    );
    expect(banks.last, 'remote');

    expect(
      await CreateResinBankAccountImpl(repository: banks)(
        CreateResinBankAccountParams(condominiumId: 'c1', newAccount: _account()),
      ),
      isA<Success<ResinBankAccount>>(),
    );
    expect(_account().isValid, isTrue);
    expect(
      await DeleteResinBankAccountImpl(repository: banks)(
        DeleteResinBankAccountParams(condominiumId: 'c1', accountId: 'a1'),
      ),
      isA<Success<bool>>(),
    );
  });
}
