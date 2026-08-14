import 'package:chopper/chopper.dart';

import '../../domain/entities/access_data_entity.dart';

part 'my_preferences_api.chopper.dart';

@ChopperApi()
abstract class MyPreferencesApi extends ChopperService {
  @Get(path: "me/preferences/unit-personal-data")
  Future<Response> getPreferencesZeroPaper(@Query("idUnidade") int unitId);

  @Put(path: "me/preferences/unit-personal-data")
  Future<Response> putPreferencesZeroPaper(
    @Body() AccessData body,
  );

  @Get(path: "me/preferences/street-type-list")
  Future<Response> getStreetTypesList();

  static MyPreferencesApi create(ChopperClient client) {
    return _$MyPreferencesApi(client);
  }
}
