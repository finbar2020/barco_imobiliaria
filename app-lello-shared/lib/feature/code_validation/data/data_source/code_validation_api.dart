import 'package:chopper/chopper.dart';
import 'package:shared_features/feature/code_validation/data/model/code_request_model.dart';
import 'package:shared_features/feature/code_validation/data/model/code_validation_model.dart';
part 'code_validation_api.chopper.dart';

@ChopperApi()
abstract class CodeValidationApi extends ChopperService {
  @Post(path: "/code_request/generated")
  Future<Response> postRequest(@Body() CodeRequestModel model);

  @Post(path: "/code_request/generated/validate")
  Future<Response> postValidation(@Body() CodeValidationModel model);

  @Get(path: "/code_request/2fa/{cpf}")
  Future<Response> getDados2faAsync(
    @Path("cpf") String cpf,
    @Query("idEmpresa") int? idEmpresa,
  );

  @Post(path: "/code_request/2fa/request", optionalBody: true)
  Future<Response> request2faAsync(
    @Query("hashToken") String hashToken,
    @Query("hashDevice") String hashDevice,
  );

  @Post(path: "/code_request/2fa/validate")
  Future<Response> validate2faAsync(
    @Query("hashToken") String hashToken,
    @Query("tokenValue") String tokenValue,
  );

  static CodeValidationApi create(ChopperClient client) {
    return _$CodeValidationApi(client);
  }

  static String max_attempts_exceeded_failure =
      "validate_code_max_failed_attempts_exceeded_failure";
  static String code_previously_validated_failure =
      "validate_code_code_previously_validated_failure";
}
