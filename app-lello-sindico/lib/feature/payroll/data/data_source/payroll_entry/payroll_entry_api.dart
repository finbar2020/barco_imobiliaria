import 'package:chopper/chopper.dart';
part 'payroll_entry_api.chopper.dart';

@ChopperApi()
abstract class PayrollEntryApi extends ChopperService {
  @GET(path: "/condominiums/{id}/payrolls/{payroll_id}/entries")
  Future<Response> get(
      @Path("id") String condominiumId, @Path("payroll_id") String payrollId);

  static PayrollEntryApi create(ChopperClient client) {
    return _$PayrollEntryApi(client);
  }
}
