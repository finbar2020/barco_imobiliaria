import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/payment/data/model/ledger_account_balance_model.dart';
import 'package:lello/feature/payment/domain/entity/contas_pagar.dart';
import 'package:lello/feature/payment/domain/entity/ledger_account_balance.dart';
import 'package:lello/feature/payment/domain/entity/payment.dart';
import 'package:lello/feature/payment/domain/entity/payment_approval.dart';
import 'package:lello/feature/payment/domain/entity/payment_installment_in_approval.dart';
import 'package:lello/feature/payment/domain/entity/payment_installments.dart';
import 'package:lello/feature/payment/domain/entity/send_token_data.dart';
import 'package:lello/feature/payment/domain/entity/send_token_request_entity.dart';
import 'package:lello/feature/payment/domain/entity/supplier_data_entity.dart';
import 'package:lello/feature/payment/domain/entity/supplier_ledger_accounts.dart';
import 'package:lello/feature/payment/domain/entity/update_installment_lancamento_entity.dart';
import 'package:lello/feature/payment/domain/repository/payment_approval_repository.dart';
import 'package:lello/feature/payment/domain/repository/payment_ledger_account_balance_repository.dart';
import 'package:lello/feature/payment/domain/repository/payment_repository.dart';
import 'package:lello/feature/payment/domain/use_case/check_token/check_token.dart';
import 'package:lello/feature/payment/domain/use_case/check_token/check_token_impl.dart';
import 'package:lello/feature/payment/domain/use_case/contas_pagar/contas_pagar.dart';
import 'package:lello/feature/payment/domain/use_case/contas_pagar/contas_pagar_impl.dart';
import 'package:lello/feature/payment/domain/use_case/find_spupplier/find_spupplier.dart';
import 'package:lello/feature/payment/domain/use_case/find_spupplier/find_spupplier_impl.dart';
import 'package:lello/feature/payment/domain/use_case/get_installments/get_installments.dart';
import 'package:lello/feature/payment/domain/use_case/get_installments/get_installments_impl.dart';
import 'package:lello/feature/payment/domain/use_case/get_ledger_account_balance/get_ledger_account_balance.dart';
import 'package:lello/feature/payment/domain/use_case/get_ledger_account_balance/get_ledger_account_balance_impl.dart';
import 'package:lello/feature/payment/domain/use_case/get_ledger_accounts/get_ledger_accounts.dart';
import 'package:lello/feature/payment/domain/use_case/get_ledger_accounts/get_ledger_accounts_impl.dart';
import 'package:lello/feature/payment/domain/use_case/get_pendency/get_pendency.dart';
import 'package:lello/feature/payment/domain/use_case/get_pendency/get_pendency_impl.dart';
import 'package:lello/feature/payment/domain/use_case/get_spupplier/get_spupplier.dart';
import 'package:lello/feature/payment/domain/use_case/get_spupplier/get_spupplier_impl.dart';
import 'package:lello/feature/payment/domain/use_case/intallments_in_approval/get_installments_in_approval.dart';
import 'package:lello/feature/payment/domain/use_case/intallments_in_approval/get_installments_in_approval_impl.dart';
import 'package:lello/feature/payment/domain/use_case/register_payment_approval/register_payment_approval.dart';
import 'package:lello/feature/payment/domain/use_case/register_payment_approval/register_payment_approval_impl.dart';
import 'package:lello/feature/payment/domain/use_case/send_token/send_token.dart';
import 'package:lello/feature/payment/domain/use_case/send_token/send_token_impl.dart';
import 'package:lello/feature/payment/domain/use_case/update_installments/update_installments.dart';
import 'package:lello/feature/payment/domain/use_case/update_installments/update_installments_impl.dart';
import 'package:lello/feature/payment/domain/use_case/update_ledger_account/update_ledger_account.dart';
import 'package:lello/feature/payment/domain/use_case/update_ledger_account/update_ledger_account_impl.dart';

class _FakePaymentRepo extends Fake implements PaymentRepository {
  Object? last;

  @override
  Future<Try<List<SupplierDataEntity>>> findSupplier(
      String condominiumId, String? name, String? document) async {
    last = name;
    return Success([SupplierDataEntity(id: 1, name: name)]);
  }

  @override
  Future<Try<SupplierDataEntity>> getSupplier(
      String condominiumId, String id) async {
    last = id;
    return Success(SupplierDataEntity(id: int.tryParse(id), name: 'Fornecedor'));
  }

  @override
  Future<Try<List<PaymentInstallments>>> findInstallments(
      String condominiumId, String paymentId) async {
    last = paymentId;
    return Success([PaymentInstallments(value: 10)]);
  }

  @override
  Future<Try<SendTokenData>> sendToken(
      String condominiumId, SendTokenRequestEntity data) async {
    last = data.method;
    return Success(SendTokenData(id: 7));
  }

  @override
  Future<Try<bool>> checkToken(
      String condominiumId, int tokenId, int value) async {
    last = tokenId;
    return Success(true);
  }

  @override
  Future<Try<bool>> updateInstallment(
      String condominiumId, UpdateInstallmentLancamentoEntity body) async {
    last = body.status;
    return Success(true);
  }

  @override
  Future<Try<bool>> updateLedgerAccount(
      String condominiumId, int idLancamento, int idContaContabil) async {
    last = idLancamento;
    return Success(true);
  }

  @override
  Future<Try<List<ContasPagarEntity>>> listContasPagar(String condominiumId,
      String? dataVencimentoDe, String? dataVencimentoAte) async {
    last = condominiumId;
    return Success([ContasPagarEntity(supplierName: 'A')]);
  }

  @override
  Future<Try<SupplierLedgerAccountsEntity?>> findLedgerAccounts(
      String condominiumId, String supplierId) async {
    last = supplierId;
    return Success(SupplierLedgerAccountsEntity());
  }

  @override
  Future<Try<List<PaymentInstallmentInApprovalEntity>>>
      findInstallmentsInApproval(
    String condominiumId,
    String installmentId,
    String dataCadastroDe,
    String dataCadastroAte,
    String? status,
    String? filtrarAprovador,
  ) async {
    last = installmentId;
    return Success([PaymentInstallmentInApprovalEntity(installmentId: 1)]);
  }

  @override
  Future<Try<Payment?>> select(String condominiumId, String id) async {
    last = id;
    return Success(Payment(documentNumber: id));
  }
}

class _FakeBalanceRepo extends Fake
    implements PaymentLedgerAccountBalanceRepository {
  @override
  Future<Try<LedgerAccountBalanceModel>> getLedgerAccountBalance(
      String condoId, String accountId) async {
    return Success(LedgerAccountBalanceModel(balance: 99));
  }
}

class _FakeApprovalRepo extends Fake implements PaymentApprovalRepository {
  @override
  Future<Try<PaymentApproval>> insert(
      String condominiumId, PaymentApproval approval) async {
    return Success(approval);
  }
}

void main() {
  late _FakePaymentRepo repo;

  setUp(() => repo = _FakePaymentRepo());

  test('FindSupplierImpl e GetSupplierImpl', () async {
    expect(
      await FindSupplierImpl(repository: repo)(
        FindSupplierParam(condominiumId: ''),
      ),
      isA<Rejection<List<SupplierDataEntity>>>(),
    );
    final found = await FindSupplierImpl(repository: repo)(
      FindSupplierParam(condominiumId: 'c1', name: 'Acme'),
    );
    expect(found, isA<Success<List<SupplierDataEntity>>>());

    final got = await GetSupplierImpl(repository: repo)(
      GetSupplierParam(condominiumId: 'c1', id: '9'),
    );
    expect(got, isA<Success<SupplierDataEntity>>());
    expect(repo.last, '9');
  });

  test('GetInstallmentsImpl rejeita ids vazios e encaminha o válido', () async {
    expect(
      await GetInstallmentsImpl(repository: repo)(
        GetInstallmentsParam(condominiumId: 'c1', paymentId: ''),
      ),
      isA<Rejection<List<PaymentInstallments>>>(),
    );
    final result = await GetInstallmentsImpl(repository: repo)(
      GetInstallmentsParam(condominiumId: 'c1', paymentId: 'p1'),
    );
    expect(result, isA<Success<List<PaymentInstallments>>>());
  });

  test('SendTokenImpl e CheckTokenImpl', () async {
    final sent = await SendTokenImpl(repository: repo)(
      SendTokenParam(
        condominiumId: 'c1',
        data: SendTokenRequestEntity(method: 'sms'),
      ),
    );
    expect(sent, isA<Success<SendTokenData>>());

    expect(
      await CheckTokenImpl(repository: repo)(
        CheckTokenParam(condominiumId: 'c1', tokenId: 0, value: 1),
      ),
      isA<Rejection<bool>>(),
    );
    final checked = await CheckTokenImpl(repository: repo)(
      CheckTokenParam(condominiumId: 'c1', tokenId: 7, value: 123),
    );
    expect(checked, isA<Success<bool>>());
  });

  test('UpdateInstallmentsImpl e UpdateLedgerAccountImpl', () async {
    final updated = await UpdateInstallmentsImpl(repository: repo)(
      UpdateInstallmentsParam(
        condominiumId: 'c1',
        body: UpdateInstallmentLancamentoEntity(
          status: 'OK',
          motivo: 'm',
          canal: 'app',
          lancamentos: const [],
        ),
      ),
    );
    expect(updated, isA<Success<bool>>());

    final ledger = await UpdateLedgerAccountImpl(repository: repo)(
      UpdateLedgerAccountParam(
        condominiumId: 'c1',
        idLancamento: 3,
        idContaContabil: 8,
      ),
    );
    expect(ledger, isA<Success<bool>>());
    expect(repo.last, 3);
  });

  test('ContasPagar, ledger accounts, pendency e approval', () async {
    expect(
      await ContasPagarImpl(repository: repo)(
        ContasPagarParam(condominiumId: ''),
      ),
      isA<Rejection<List<ContasPagarEntity>>>(),
    );
    expect(
      await ContasPagarImpl(repository: repo)(
        ContasPagarParam(condominiumId: 'c1'),
      ),
      isA<Success<List<ContasPagarEntity>>>(),
    );

    expect(
      await GetLedgerAccountsImpl(repository: repo)(
        GetLedgerAccountsParam(condominiumId: 'c1', supplierId: 's1'),
      ),
      isA<Success<SupplierLedgerAccountsEntity?>>(),
    );

    expect(
      await GetInstallmentsInApprovalImpl(repository: repo)(
        GetInstallmentsInApprovalParam(
          condominiumId: 'c1',
          installmentId: 'i1',
          dataCadastroDe: '01/01/2026',
          dataCadastroAte: '31/01/2026',
        ),
      ),
      isA<Success<List<PaymentInstallmentInApprovalEntity>>>(),
    );

    expect(
      await GetPendencyImpl(repository: repo)(GetPendencyParam('', 'p1')),
      isA<Rejection<Payment?>>(),
    );
    expect(
      await GetPendencyImpl(repository: repo)(GetPendencyParam('c1', 'p1')),
      isA<Success<Payment?>>(),
    );

    expect(
      await GetLedgerAccountBalanceImpl(_FakeBalanceRepo())(
        GetLedgerAccountBalanceParam(condominiumId: 'c1', accountId: 'a1'),
      ),
      isA<Success<LedgerAccountBalanceModel>>(),
    );

    expect(
      await RegisterPaymentApprovalImpl(repository: _FakeApprovalRepo())(
        RegisterPaymentApprovalParam(
          condominiumId: 'c1',
          approval: PaymentApproval(paymentId: 'p1'),
        ),
      ),
      isA<Success<PaymentApproval>>(),
    );
  });

  test('LedgerAccountBalanceModel fromJson/toEntity/fromEntity', () {
    final parsed = LedgerAccountBalanceModel.fromJson({'balance': 12.5});
    expect(parsed.balance, 12.5);
    expect(parsed.toEntity().balance, 12.5);
    expect(
      LedgerAccountBalanceModel.fromEntity(LedgerAccountBalance(balance: 3))
          ?.balance,
      3,
    );
  });
}
