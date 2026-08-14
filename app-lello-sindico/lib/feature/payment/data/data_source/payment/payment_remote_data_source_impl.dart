import 'dart:developer';

import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/data/data_source/payment/payment_api.dart';
import 'package:lello/feature/payment/data/data_source/payment/payment_remote_data_source.dart';
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

class PaymentRemoteDataSourceImpl extends PaymentRemoteDataSource {
  final PaymentApi api;

  PaymentRemoteDataSourceImpl({required this.api});

  @override
  Future<PaymentModel?> find(String condominiumId,
      String supplierIdentification, String documentNumber) async {
    final response = await api.list(
      condominiumId,
      null,
      supplierIdentification: supplierIdentification,
      documentNumber: documentNumber,
    );
    final items =
        ApiMapper.mapList(response, (json) => PaymentModel.fromJson(json));
    if (items.isEmpty == true) return null;
    return items
        .firstWhere((element) => element.documentNumber == documentNumber);
  }

  @override
  Future<PaymentModel> insert(
    String condominiumId,
    PaymentModel registration,
  ) async {
    final response = await api.post(condominiumId, registration);
    return ApiMapper.map(response, (json) => PaymentModel.fromJson(json));
  }

  @override
  Future<List<PaymentModel>>? list(String condominiumId,
      {String? lastPaymentId,
      PaymentListFilter? filter,
      String? status}) async {
    final response = await api.list(
      condominiumId,
      lastPaymentId,
      createdDateFrom: filter?.createdDateFrom,
      status: status,
      createdDateTo: filter?.createdDateTo,
      source: filter?.source,
      entry: filter?.entry,
      supplierIdentification: filter?.supplierIdentification,
      supplierName: filter?.supplierName,
      documentNumber: filter?.documentNumber,
      totalValue: filter?.value,
    );
    return ApiMapper.mapList(response, (json) => PaymentModel.fromJson(json));
  }

  @override
  Future<PaymentModel?> select(String condominiumId, String id) async {
    final response = await api.select(condominiumId, id);
    final data =
        ApiMapper.mapList(response, (json) => PaymentModel.fromJson(json));
    if (data.isEmpty) {
      return null;
    }
    return data.first;
  }

  @override
  Future<List<PaymentInstallmentsModel>?> findInstallments(
      String condominiumId, String id) async {
    final response = await api.findInstallments(condominiumId, id);
    final data = ApiMapper.mapList(
        response, (json) => PaymentInstallmentsModel.fromJson(json));
    if (data.isEmpty) {
      return null;
    }
    return data;
  }

  @override
  Future<PaymentModel?> findByBarcode(
      String condominiumId, String barcode) async {
    final response = await api.findByBarcode(condominiumId, barcode);
    final data =
        ApiMapper.mapList(response, (json) => PaymentModel.fromJson(json));
    if (data.isEmpty) {
      return null;
    }
    return data.first;
  }

  @override
  Future<List<PaymentHistoryItemModel>> listPaymentHistory(
      String condominiumId, DateTime? startDate, DateTime? endDate) async {
    final response = await api.listPaymentHistory(
      condominiumId,
      startDate,
      endDate,
    );
    return ApiMapper.mapList(
        response, (json) => PaymentHistoryItemModel.fromJson(json));
  }

  @override
  Future<List<SupplierDataModel>> findSupplier(
      String condominiumId, String? name, String? document) async {
    final response = await api.findSupplier(
      condominiumId,
      name,
      document,
    );
    return ApiMapper.mapList(
        response, (json) => SupplierDataModel.fromJson(json));
  }

  final Map<String, SupplierDataModel> _supplierCache = {};

  @override
  Future<SupplierDataModel> getSupplier(String condominiumId, String id) async {
    final cacheKey = '$condominiumId:$id';

    if (_supplierCache.containsKey(cacheKey)) {
      return _supplierCache[cacheKey]!;
    }

    final response = await retry(
      () async {
        return api
            .getSupplier(condominiumId, id)
            .timeout(const Duration(seconds: 10));
      },
      maxAttempts: 3,
    );
    final supplier =
        ApiMapper.map(response, (json) => SupplierDataModel.fromJson(json));

    _supplierCache[cacheKey] = supplier;

    return supplier;
  }

  @override
  Future<int> sendPayment(String condominiumId, PaymentDataModel data) async {
    final response = await api.sendPayment(condominiumId, data);
    return ApiMapper.map(response, (json) => json['id']);
  }

  @override
  Future<List<PaymentInstallmentInApprovalModel>>? findInstallmentsInApproval(
    String condominiumId,
    String installmentId,
    String dataCadastroDe,
    String dataCadastroAte,
    String? status,
    String? filtrarAprovador,
  ) async {
    final response = await api.findInstallmentsInApproval(
        condominiumId,
        installmentId,
        dataCadastroDe,
        dataCadastroAte,
        status,
        filtrarAprovador);
    return ApiMapper.mapList(
        response, (json) => PaymentInstallmentInApprovalModel.fromJson(json));
  }

  @override
  Future<SupplierLedgerAccountsModel> findLedgerAccounts(
      String condominiumId, String supplierId) async {
    final response = await api.findLedgerAccounts(condominiumId, supplierId);
    return ApiMapper.map(
        response, (json) => SupplierLedgerAccountsModel.fromJson(json));
  }

  @override
  Future<SendTokenDataModel> sendToken(
    String condominiumId,
    SendTokenRequestModel data,
  ) async {
    final response = await api.sendToken(condominiumId, data);
    return ApiMapper.map(response, (json) => SendTokenDataModel.fromJson(json));
  }

  @override
  Future<CheckTokenDataModel> checkToken(
    String condominiumId,
    int tokenId,
    int value,
  ) async {
    final response = await api.checkToken(condominiumId, tokenId, value);
    return ApiMapper.map(
        response, (json) => CheckTokenDataModel.fromJson(json));
  }

  @override
  Future<UpdateInstallmentModel> updateInstallment(
    String condominiumId,
    UpdateInstallmentRequestBody body,
  ) async {
    final response = await api.updateInstallments(condominiumId, body);
    return ApiMapper.map(
        response, (json) => UpdateInstallmentModel.fromJson(json));
  }

  @override
  Future<CheckApprovalProfileModel> checkApprovalProfile(
    String condominiumId,
  ) async {
    final response = await api.checkPerfilAprovacao(condominiumId);
    return ApiMapper.map(
        response, (json) => CheckApprovalProfileModel.fromJson(json));
  }

  @override
  Future<UpdateLedgerAccountModel> updateLedgerAccount(
    String condominiumId,
    int idLancamento,
    int idContaContabil,
  ) async {
    final response = await api.updateContaContabil(
        condominiumId, idLancamento, idContaContabil);
    return ApiMapper.map(
        response, (json) => UpdateLedgerAccountModel.fromJson(json));
  }

  @override
  Future<List<ContasPagarModel>> listContasPagar(
    String condominiumId,
    String? dataVencimentoDe,
    String? dataVencimentoAte,
  ) async {
    final response = await api.getContasPagar(
        condominiumId, dataVencimentoDe, dataVencimentoAte);
    return ApiMapper.mapList(
        response, (json) => ContasPagarModel.fromJson(json));
  }
}
