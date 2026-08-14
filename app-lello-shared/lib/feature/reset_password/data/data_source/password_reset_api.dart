import 'package:chopper/chopper.dart';
import 'package:shared_features/feature/reset_password/data/model/password_reset_model.dart';

part 'password_reset_api.chopper.dart';

@ChopperApi()
abstract class PasswordResetApi extends ChopperService {
  @Post(path: "/change_password")
  Future<Response> post(@Body() PasswordResetModel model);

  static PasswordResetApi create(ChopperClient client) {
    return _$PasswordResetApi(client);
  }
}
