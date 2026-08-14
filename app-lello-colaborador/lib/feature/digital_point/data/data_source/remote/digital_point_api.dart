import 'package:chopper/chopper.dart';
import 'package:colaborador/feature/digital_point/data/model/digital_point_model.dart';

part 'digital_point_api.chopper.dart';

@ChopperApi()
abstract class DigitalPointApi extends ChopperService {
  @Post(path: "condominiums/{id}/digital_point/register")
  Future<Response> registerPoint(
    @Body() DigitalPointModel model,
    @Path("id") String id,
  );

  @Post(
      path: "condominiums/{id}/digital_point/requestService/{imageHash}",
      optionalBody: true)
  Future<Response> requestDigitalPointService(
    @Path("id") String id,
    @Path("imageHash") String imageHash,
  );

  @Get(path: "condominiums/{id}/digital_point/urlUploadImage")
  Future<Response> getAwsUrl(
    @Path("id") String id,
  );

  @Get(path: "condominiums/{id}/digital_point/CheckDigitalPointByDate")
  Future<Response> checkDigitalPoint(
    @Path("id") String id,
    @Query("date") DateTime date,
  );

  @Post(path: "condominiums/{id}/digital_point/sync_digital_points")
  Future<Response> syncDigitalPointWithoutLogin(
    @Body() DigitalPointModel model,
  );

  static DigitalPointApi create(ChopperClient client) {
    return _$DigitalPointApi(client);
  }
}
