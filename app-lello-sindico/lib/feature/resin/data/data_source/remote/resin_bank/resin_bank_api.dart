import 'package:chopper/chopper.dart';
import 'package:lello/feature/resin/data/model/resin_bank_account_model.dart';

part 'resin_bank_api.chopper.dart';

@ChopperApi()
abstract class ResinBankApi extends ChopperService {
  @GET(path: "/condominiums/{id}/refunds/banks")
  Future<Response> getResinBanks(
    @Path() String id,
  );

  @GET(path: "/condominiums/{id}/refund_accounts")
  Future<Response> getAllBankAccounts(
    @Path() String id,
    // @Query("bank") String bank,
    // @Query("bank_code") String bank_code,
    // @Query("agency") String agency,
    // @Query("account_number") String account_number,
    // @Query("document") String document,
    // @Query("supplier_name") String supplier_name,
  );

  @POST(path: "/condominiums/{id}/refund_accounts")
  Future<Response> createBankAccount(
    @Path() String id,
    @Body() ResinBankAccountModel newBankAccount,
  );

  @DELETE(path: "/condominiums/{id}/refund_accounts/{accountId}")
  Future<Response> deleteBankAccount(
    @Path() String id,
    @Path() String accountId,
  );

  static ResinBankApi create(ChopperClient client) {
    return _$ResinBankApi(client);
  }
}
