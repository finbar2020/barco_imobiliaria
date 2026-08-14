import 'package:chopper/chopper.dart';
import 'package:shared_features/feature/registration/data/model/registation_model.dart';
import 'package:shared_features/feature/registration/data/model/register_fcm_token_model.dart';

part 'registration_api.chopper.dart';

@ChopperApi()
abstract class RegistrationApi extends ChopperService {
  @Post(path: "/registration")
  Future<Response> post(
    @Body() RegistrationModel model,
    @Query("idEmpresa") int? idEmpresa,
  );

  @Get(path: "/registration/sindico/{cpf}")
  Future<Response> get(@Path() String cpf);

  @Post(path: "/dashboard/register_fcm_token")
  Future<Response> registerFcmToken(@Body() RegisterFcmTokenModel model);

  @Put(path: "/dashboard/disable_fcm_token")
  Future<Response> disableFcmToken(@Body() RegisterFcmTokenModel model);

  static RegistrationApi create(ChopperClient client) {
    return _$RegistrationApi(client);
  }

  static final user_not_found_failure = "user_not_found_failure";
  static final user_already_registerd_failure =
      "user_already_registerd_failure";
}
