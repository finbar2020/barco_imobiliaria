import 'package:chopper/chopper.dart';
import 'package:shared_features/feature/authentication/data/model/access_token_request_model.dart';

part 'authentication_api.chopper.dart';

@ChopperApi()
abstract class AuthenticationApi extends ChopperService {
  @Post(path: "/tokenrbac")
  Future<Response> post(@Body() AccessTokenRequestModel model);

  @Post(path: "/tokenConvite")
  Future<Response> postInvite(@Body() AccessTokenRequestModel model);

  @Post(path: "/token/{ref}")
  Future<Response> switchRoles(@Path() String ref);

  @Delete(path: "/me/deleteAccount")
  Future<Response> deleteAccount();

  static AuthenticationApi create(ChopperClient client) {
    return _$AuthenticationApi(client);
  }

  static String invalid_credentials_failure = "invalid_credentials_failure";

  static String unknow_credentials_failure = "unknow_credentials_failure";

  static String not_registered_credentials_failure =
      "not_registered_credentials_failure";

  static String no_role_for_credentials_failure =
      "no_role_for_credentials_failure";
}
