import 'package:chopper/chopper.dart';
import 'package:lello/feature/payment/data/model/payment_data_model.dart';
import 'package:lello/feature/payment/data/model/payment_model.dart';
import 'package:lello/feature/payment/data/model/send_token_request_model.dart';
import 'package:lello/feature/payment/data/model/update_installment_request_body.dart';
import 'package:lello/feature/payment/domain/entity/payment_source.dart';

part 'payment_api.chopper.dart';

@ChopperApi()
abstract class PaymentApi extends ChopperService {
  @GET(path: "/condominiums/{id}/payments")
  Future<Response> findByBarcode(
      @Path() String id, @Query("barcode") String barcode);

  @GET(path: "/condominiums/{id}/payments/{payment_id}")
  Future<Response> select(
      @Path() String id, @Path("payment_id") String paymentId);

  @GET(path: "/condominiums/{id}/payments/installments/{payment_id}")
  Future<Response> findInstallments(
      @Path() String id, @Path("payment_id") String paymentId);

  @GET(path: "/condominiums/{id}/payments/ledger-accounts")
  Future<Response> findLedgerAccounts(
      @Path() String id, @Query("supplier_id") String type);

  @GET(path: "/condominiums/{id}/payments/installments/list")
  Future<Response> findInstallmentsInApproval(
    @Path() String id,
    @Query("installmentId") String installmentId,
    @Query("dataCadastroDe") String dataCadastroDe,
    @Query("dataCadastroAte") String dataCadastroAte,
    @Query("status") String? status,
    @Query("filtrarAprovador") String? filtrarAprovador,
  );

  @POST(path: "/condominiums/{id}/payments")
  //@Multipart()
  Future<Response> post(
    @Path() String id,
    @Body() PaymentModel model,
  );

  @GET(path: "/condominiums/{id}/payments/aws-payload")
  Future<Response> getAwsPayload(@Path() String id);

  @POST(path: '/condominiums/{condoId}/payments/process-documents')
  Future<Response> processFiles(
    @Path('condoId') String condoId,
    @Body() List<String> body,
  );

  @GET(path: "/condominiums/{id}/payments")
  Future<Response> list(
    @Path() String id,
    @Query("last_payment_id") String? lastPaymentId, {
    @Query("created_date_from") DateTime? createdDateFrom,
    @Query("created_date_to") DateTime? createdDateTo,
    @Query("source") PaymentSource? source,
    @Query("entry") String? entry,
    @Query("status") String? status,
    @Query("supplier_identification") String? supplierIdentification,
    @Query("supplier_name") String? supplierName,
    @Query("document_number") String? documentNumber,
    @Query("total_value") double? totalValue,
  });

  @GET(path: "/condominiums/{id}/payments/list-history")
  Future<Response> listPaymentHistory(
    @Path() String id,
    @Query("startDate") DateTime? startDate,
    @Query("endDate") DateTime? endDate,
  );

  @GET(path: "/condominiums/{id}/payments/supplier/find")
  Future<Response> findSupplier(
    @Path() String id,
    @Query("name") String? name,
    @Query("document") String? document,
  );

  @GET(path: "/condominiums/{id}/payments/supplier/{supplierId}")
  Future<Response> getSupplier(
    @Path() String id,
    @Path() String supplierId,
  );

  @POST(path: '/condominiums/{condoId}/payments/send-payment')
  Future<Response> sendPayment(
    @Path('condoId') String condoId,
    @Body() PaymentDataModel body,
  );

  @GET(
      path:
          '/condominiums/{condoId}/payments/ledger-account-balance/{accountId}')
  Future<Response> getLedgerAccountBalance(
    @Path('condoId') String condoId,
    @Path('accountId') String accountId,
  );

  @POST(path: '/condominiums/{condoId}/payments/send-token')
  Future<Response> sendToken(
    @Path('condoId') String condoId,
    @Body() SendTokenRequestModel body,
  );

  @GET(path: '/condominiums/{condoId}/payments/check-token')
  Future<Response> checkToken(
    @Path('condoId') String condoId,
    @Query('tokenId') int tokenId,
    @Query('value') int value,
  );

  @PUT(path: '/condominiums/{condoId}/payments/update-installments')
  Future<Response> updateInstallments(
    @Path('condoId') String condoId,
    @Body() UpdateInstallmentRequestBody body,
  );

  @GET(path: '/condominiums/{condoId}/payments/check-perfil-aprovacao')
  Future<Response> checkPerfilAprovacao(
    @Path('condoId') String condoId,
  );

  @PUT(
      path:
          '/condominiums/{condoId}/payments/{idLancamento}/update-conta-contabil/{idContaContabil}')
  Future<Response> updateContaContabil(
    @Path('condoId') String condoId,
    @Path('idLancamento') int idLancamento,
    @Path('idContaContabil') int idContaContabil,
  );

  @GET(path: '/condominiums/{condoId}/payments/contas-a-pagar')
  Future<Response> getContasPagar(
    @Path('condoId') String condoId,
    @Query('dataVencimentoDe') String? dataVencimentoDe,
    @Query('dataVencimentoAte') String? dataVencimentoAte,
  );
  static PaymentApi create(ChopperClient client) {
    return _$PaymentApi(client);
  }

  static const unknown_provider_failure = "unknown_provider_failure";
  static const payment_registered_failure = "payment_registered_failure";
}
