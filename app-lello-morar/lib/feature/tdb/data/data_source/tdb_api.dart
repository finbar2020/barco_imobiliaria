import 'package:chopper/chopper.dart';

part 'tdb_api.chopper.dart';

@ChopperApi()
abstract class TDBApi extends ChopperService {
  @Get(path: "/condominiums/{condo_id}/tdb")
  Future<Response> getTDBInfo(
    @Path("condo_id") String condominiumId,
  );

  static TDBApi create(ChopperClient client) {
    return _$TDBApi(client);
  }
}
