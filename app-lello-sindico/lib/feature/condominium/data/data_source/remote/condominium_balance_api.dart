import 'package:chopper/chopper.dart';

part 'condominium_balance_api.chopper.dart';

@ChopperApi()
abstract class CondominiumBalanceApi extends ChopperService {
  @GET(path: "/condominiums/{id}/balance")
  Future<Response> get(@Path() String id);

  @GET(path: "/condominiums/{id}/balance/details")
  Future<Response> getDetail(@Path() String id,
      {@Query("start_date") DateTime? startDate,
      @Query("end_date") DateTime? endDate,
      @Query("order_by_date") bool? orderByDate,
      @Query("order_by_count") bool? orderByCount,
      @Query("only_receita") bool? onlyReceita,
      @Query("only_despesa") bool? onlyDespesa,
      @Query("select_count") String? selectCount});

  @GET(path: "/condominium/{id}/simple")
  Future<Response> getCondominiumSimple(@Path() String id);

  static CondominiumBalanceApi create(ChopperClient client) {
    return _$CondominiumBalanceApi(client);
  }
}
