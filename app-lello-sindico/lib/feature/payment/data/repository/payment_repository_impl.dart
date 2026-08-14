import 'package:essentials/essentials.dart';
import 'package:essentials/network/api_failure.dart';
import 'package:lello/feature/payment/data/data_source/payment/payment_api.dart';
import 'package:lello/feature/payment/data/data_source/payment/payment_remote_data_source.dart';
import 'package:lello/feature/payment/data/model/payment_data_model.dart';
import 'package:lello/feature/payment/data/model/payment_model.dart';
import 'package:lello/feature/payment/data/model/send_token_request_model.dart';
import 'package:lello/feature/payment/data/model/update_installment_request_body.dart';
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
import 'package:lello/feature/payment/domain/repository/payment_repository.dart';
import 'package:lello/feature/payment/domain/use_case/get_payment/get_payment_failure.dart';

class PaymentRepositoryImpl extends PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;

  PaymentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Try<Payment?>> find(String condominiumId,
      String supplierIdentification, String documentNumber) async {
    try {
      final model = await remoteDataSource.find(
          condominiumId, supplierIdentification, documentNumber);
      return Success(model?.toEntity());
    } on ApiFailure catch (ex) {
      return Rejection(_mapApiFailure(ex));
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<List<Payment>>> list(String condominiumId,
      {String? lastPaymentId,
      PaymentListFilter? filter,
      String? status}) async {
    try {
      final model = await remoteDataSource.list(condominiumId,
          lastPaymentId: lastPaymentId, filter: filter, status: status);
      return Success(model?.map((e) => e.toEntity()).toList() ?? []);
    } catch (err) {
      //todo: handle http errors
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<Payment?>> select(String condominiumId, String id) async {
    try {
      final model = await remoteDataSource.select(condominiumId, id);
      return Success(model?.toEntity());
    } catch (err) {
      //todo: handle http errors
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<List<PaymentInstallments>>> findInstallments(
      String condominiumId, String id) async {
    try {
      final model = await remoteDataSource.findInstallments(condominiumId, id);
      return Success(model?.map((e) => e.toEntity()).toList() ?? []);
    } catch (err) {
      //todo: handle http errors
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<Payment?>> insert(
    String condominiumId,
    Payment payment,
  ) async {
    try {
      final model = await remoteDataSource.insert(
          condominiumId, PaymentModel.fromEntity(payment)!);
      return Success(model.toEntity());
    } catch (err) {
      if (err is ApiFailure) {
        switch (err.status) {
          case 400:
            return Rejection(KnownFailure(
                err.failure ?? "bad_request_failure", err,
                message: err.title));
        }
      }
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<Payment?>> findByBarcode(
      String condominiumId, String barcode) async {
    try {
      final model =
          await remoteDataSource.findByBarcode(condominiumId, barcode);
      return Success(model?.toEntity());
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<List<PaymentHistoryItem>>> listPaymentHistory(
      String condominiumId, DateTime? startDate, DateTime? endDate) async {
    try {
      final model = await remoteDataSource.listPaymentHistory(
          condominiumId, startDate, endDate);
      return Success(model.map((e) => e.toEntity()).toList());
    } catch (err) {
      //todo: handle http errors
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<List<SupplierDataEntity>>> findSupplier(
      String condominiumId, String? name, String? document) async {
    try {
      final model =
          await remoteDataSource.findSupplier(condominiumId, name, document);
      return Success(model.map((e) => e.toEntity()).toList());
    } catch (err) {
      //todo: handle http errors
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<SupplierDataEntity>> getSupplier(
      String condominiumId, String id) async {
    try {
      final model = await remoteDataSource.getSupplier(condominiumId, id);
      return Success(model.toEntity());
    } catch (err) {
      //todo: handle http errors
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<int>> sendPayment(
      String condominiumId, PaymentDataEntity data) async {
    try {
      final id = await remoteDataSource.sendPayment(
          condominiumId, PaymentDataModel.fromEntity(data)!);
      return Success(id);
    } catch (err) {
      if (err is ApiFailure) {
        return Rejection(KnownFailure(err.title ?? "ERRO_GENERICO", err,
            message: err.title));
      }
      return Rejection(UnknownFailure(err));
    }
  }

  Failure _mapApiFailure(ApiFailure err) {
    if (err.title == PaymentApi.payment_registered_failure) {
      return GetPaymentAlreadyRegisteredFailure();
    }
    if (err.title == PaymentApi.unknown_provider_failure) {
      return GetPaymentUnknownProvider();
    }
    return UnknownFailure(err);
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
    try {
      final model = await remoteDataSource.findInstallmentsInApproval(
          condominiumId,
          installmentId,
          dataCadastroDe,
          dataCadastroAte,
          status,
          filtrarAprovador);
      return Success(model?.map((e) => e.toEntity()).toList() ?? []);
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<SupplierLedgerAccountsEntity>> findLedgerAccounts(
      String condominiumId, String supplierId) async {
    try {
      final model =
          await remoteDataSource.findLedgerAccounts(condominiumId, supplierId);
      return Success(model.toEntity());
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<SendTokenData>> sendToken(
      String condominiumId, SendTokenRequestEntity data) async {
    try {
      final model = await remoteDataSource.sendToken(
          condominiumId, SendTokenRequestModel.fromEntity(data)!);
      return Success(model.toEntity());
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<bool>> checkToken(
      String condominiumId, int tokenId, int value) async {
    try {
      final model =
          await remoteDataSource.checkToken(condominiumId, tokenId, value);
      return Success(model.toEntity());
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<bool>> updateInstallment(
      String condominiumId, UpdateInstallmentLancamentoEntity body) async {
    try {
      final model = await remoteDataSource.updateInstallment(
          condominiumId, UpdateInstallmentRequestBody.fromEntity(body)!);
      final entity = model.toEntity();
      return Success(entity);
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<bool>> checkApprovalProfile(String condominiumId) async {
    try {
      final model = await remoteDataSource.checkApprovalProfile(condominiumId);
      return Success(model.toEntity());
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<bool>> updateLedgerAccount(
      String condominiumId, int idLancamento, int idContaContabil) async {
    try {
      final model = await remoteDataSource.updateLedgerAccount(
          condominiumId, idLancamento, idContaContabil);
      return Success(model.toEntity());
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<List<ContasPagarEntity>>> listContasPagar(String condominiumId,
      String? dataVencimentoDe, String? dataVencimentoAte) async {
    try {
      final model = await remoteDataSource.listContasPagar(
          condominiumId, dataVencimentoDe, dataVencimentoAte);
      return Success(model.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }
}
