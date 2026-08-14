import 'package:chopper/chopper.dart';

part 'payslip_api.chopper.dart';

@ChopperApi()
abstract class PayslipApi extends ChopperService {
  @GET(path: '/digitalRepository/documents/{registrationNumber}')
  Future<Response> get(@Path('registrationNumber') String registrationNumber);

  @GET(path: '/digitalRepository/documents/{nameFile}/{registrationNumber}')
  Future<Response> getFile(@Path('nameFile') String nameFile,
      @Path('registrationNumber') String registrationNumber);

  static PayslipApi create(ChopperClient client) {
    return _$PayslipApi(client);
  }
}
