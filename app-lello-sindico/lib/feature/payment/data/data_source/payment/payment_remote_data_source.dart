import 'package:lello/feature/payment/data/model/check_approval_profile_model.dart';
import 'package:lello/feature/payment/data/model/check_token_data_model.dart';
import 'package:lello/feature/payment/data/model/contas_pagar_model.dart';
import 'package:lello/feature/payment/data/model/payment_data_model.dart';
import 'package:lello/feature/payment/data/model/payment_history_item_model.dart';
import 'package:lello/feature/payment/data/model/payment_installment_in_approval_model.dart';
import 'package:lello/feature/payment/data/model/payment_installments_model.dart';
import 'package:lello/feature/payment/data/model/payment_model.dart';
import 'package:lello/feature/payment/data/model/send_token_data_model.dart';
import 'package:lello/feature/payment/data/model/send_token_request_model.dart';
import 'package:lello/feature/payment/data/model/supplier_data_model.dart';
import 'package:lello/feature/payment/data/model/supplier_ledger_accounts_model.dart';
import 'package:lello/feature/payment/data/model/update_installment_model.dart';
import 'package:lello/feature/payment/data/model/update_installment_request_body.dart';
import 'package:lello/feature/payment/data/model/update_ledger_account_model.dart';
import 'package:lello/feature/payment/domain/entity/payment_list_filter.dart';

abstract class PaymentRemoteDataSource {
  Future<List<PaymentModel>>? list(String condominiumId,
      {String? lastPaymentId, PaymentListFilter? filter, String? status});

  Future<PaymentModel?> select(String condominiumId, String id);

  Future<List<PaymentInstallmentsModel>?> findInstallments(
      String condominiumId, String id);

  Future<PaymentModel?> find(String condominiumId,
      String supplierIdentification, String documentNumber);

  Future<PaymentModel?> findByBarcode(String condominiumId, String barcode);

  Future<List<PaymentInstallmentInApprovalModel>>? findInstallmentsInApproval(
    String condominiumId,
    String installmentId,
    String dataCadastroDe,
    String dataCadastroAte,
    String? status,
    String? filtrarAprovador,
  );

  Future<SupplierLedgerAccountsModel> findLedgerAccounts(
      String condominiumId, String supplierId);

  Future<PaymentModel> insert(
    String condominiumId,
    PaymentModel registration,
  );

  Future<List<PaymentHistoryItemModel>> listPaymentHistory(
      String condominiumId, DateTime? startDate, DateTime? endDate);

  Future<List<SupplierDataModel>> findSupplier(
      String condominiumId, String? name, String? document);

  Future<SupplierDataModel> getSupplier(String condominiumId, String id);

  Future<int> sendPayment(String condominiumId, PaymentDataModel data);

  Future<SendTokenDataModel> sendToken(
    String condominiumId,
    SendTokenRequestModel data,
  );

  Future<UpdateInstallmentModel> updateInstallment(
    String condominiumId,
    UpdateInstallmentRequestBody body,
  );

  Future<CheckTokenDataModel> checkToken(
    String condominiumId,
    int tokenId,
    int value,
  );

  Future<CheckApprovalProfileModel> checkApprovalProfile(
    String condominiumId,
  );

  Future<UpdateLedgerAccountModel> updateLedgerAccount(
    String condominiumId,
    int idLancamento,
    int idContaContabil,
  );

  Future<List<ContasPagarModel>> listContasPagar(
    String condominiumId,
    String? dataVencimentoDe,
    String? dataVencimentoAte,
  );
}
