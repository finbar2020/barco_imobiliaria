import 'package:morar/feature/vehicles/data/models/vehicles_model.dart';
import 'package:chopper/chopper.dart';

part 'vehicles_api.chopper.dart';

@ChopperApi()
abstract class VehicleApi extends ChopperService {
  @Get(path: '/concierge/vehicle/{unit_id}')
  Future<Response> getVehiclesList(@Path('unit_id') String unitId);

  @Post(path: '/concierge/vehicle')
  Future<Response> post(@Body() VehicleModel vehicleModel);

  @Put(path: '/concierge/vehicle')
  Future<Response> put(@Body() VehicleModel vehicleModel);

  @Delete(path: '/concierge/vehicle/{vehicle_id}')
  Future<Response> delete(@Path('vehicle_id') String id);

  static VehicleApi create(ChopperClient client) {
    return _$VehicleApi(client);
  }
}
