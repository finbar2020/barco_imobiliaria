
import 'package:chopper/chopper.dart';
part 'consultant_lello_api.chopper.dart';

@ChopperApi()
abstract class ConsultantApi extends ChopperService  {
	@Get(path: "/consultant")
	Future<Response> get(@Path() String number);

	static ConsultantApi create(ChopperClient client) {
		return _$ConsultantApi(client);
	}
}
