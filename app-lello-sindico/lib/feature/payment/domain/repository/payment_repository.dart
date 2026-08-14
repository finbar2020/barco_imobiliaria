import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/contas_pagar.dart';
import 'package:lello/feature/payment/domain/entity/payment.dart';
import 'package:lello/feature/payment/domain/entity/payment_data.dart';
import 'package:lello/feature/payment/domain/entity/payment_history_item.dart';
import 'package:lello/feature/payment/domain/entity/payment_installment_in_approval.dart';
import 'package:lello/feature/payment/domain/entity/payment_installments.dart';
import 'package:lello/feature/payment/domain/entity/payment_list_filter.dart';
import 'package:lello/feature/payment/domain/entity/send_token_data.dart';
import 'package:lello/feature/payment/domain/entity/send_token_request_entity.dart';
import 'package:lello/feature/payment/domain/entity/supplier_data_entity.dart';
import 'package:lello/feature/payment/domain/entity/supplier_ledger_accounts.dart';
import 'package:lello/feature/payment/domain/entity/update_installment_lancamento_entity.dart';

abstract class PaymentRepository {
  Future<Try<List<Payment>>> list(String condominiumId,
      {String? lastPaymentId, PaymentListFilter? filter, String? status});

  Future<Try<Payment?>> select(String condominiumId, String id);

  Future<Try<Payment?>> find(String condominiumId,
      String supplierIdentification, String documentNumber);

  Future<Try<List<PaymentInstallments>>> findInstallments(
      String condominiumId, String paymentId);

  Future<Try<List<PaymentInstallmentInApprovalEntity>>>
      findInstallmentsInApproval(
    String condominiumId,
    String installmentId,
    String dataCadastroDe,
    String dataCadastroAte,
    String? status,
    String? filtrarAprovador,
  );

  Future<Try<SupplierLedgerAccountsEntity?>> findLedgerAccounts(
      String condominiumId, String supplierId);

  Future<Try<Payment?>> findByBarcode(String condominiumId, String barcode);

  Future<Try<Payment?>> insert(
    String condominiumId,
    Payment payment,
  );

  Future<Try<List<PaymentHistoryItem>>> listPaymentHistory(
      String condominiumId, DateTime? startDate, DateTime? endDate);

  Future<Try<List<SupplierDataEntity>>> findSupplier(
      String condominiumId, String? name, String? document);

  Future<Try<SupplierDataEntity>> getSupplier(String condominiumId, String id);

  Future<Try<int>> sendPayment(String condominiumId, PaymentDataEntity data);

  Future<Try<SendTokenData>> sendToken(
    String condominiumId,
    SendTokenRequestEntity data,
  );

  Future<Try<bool>> checkToken(
    String condominiumId,
    int tokenId,
    int value,
  );

  Future<Try<bool>> updateInstallment(
    String condominiumId,
    UpdateInstallmentLancamentoEntity body,
  );

  Future<Try<bool>> checkApprovalProfile(
    String condominiumId,
  );

  Future<Try<bool>> updateLedgerAccount(
      String condominiumId, int idLancamento, int idContaContabil);

  Future<Try<List<ContasPagarEntity>>> listContasPagar(
    String condominiumId,
    String? dataVencimentoDe,
    String? dataVencimentoAte,
  );
}
