import 'package:chopper/chopper.dart';

part 'payslip_api.chopper.dart';

@ChopperApi()
abstract class PayslipApi extends ChopperService {
  @Get(path: '/digitalRepository/documents/{registrationNumber}')
  Future<Response> get(@Path('registrationNumber') String registrationNumber);

  @Get(path: '/digitalRepository/documents/{nameFile}/{registrationNumber}')
  Future<Response> getFile(@Path('nameFile') String nameFile, @Path('registrationNumber') String registrationNumber);

  static PayslipApi create(ChopperClient client) {
    return _$PayslipApi(client);
  }
}
