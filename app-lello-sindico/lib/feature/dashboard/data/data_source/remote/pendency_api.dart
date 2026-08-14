import 'package:chopper/chopper.dart';
import 'package:lello/feature/dashboard/data/model/read_notification_model.dart';

part 'pendency_api.chopper.dart';

@ChopperApi()
abstract class PendencyApi extends ChopperService {
  @GET(path: "/dashboard/{id}/pendencies")
  Future<Response> get(
      @Path() String id, @Query("lastPendencyId") String? lastPendencyId);

  @GET(path: "/dashboard/{id}/pendenciesPagination")
  Future<Response> getPagination(
      @Path() String id, @Query("currentSize") int? currentSize);

  @PUT(path: "/dashboard/{reference}/pendencies/{pendencyId}")
  Future<Response> update(@Path() String reference, @Path() String pendencyId,
      @Body() ReadNotificationModel body);

  static PendencyApi create(ChopperClient client) {
    return _$PendencyApi(client);
  }
}
