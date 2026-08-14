import 'package:chopper/chopper.dart';

part 'home_api.chopper.dart';

@ChopperApi()
abstract class HomeApi extends ChopperService {
  static HomeApi create(ChopperClient client) {
    return _$HomeApi(client);
  }
}
