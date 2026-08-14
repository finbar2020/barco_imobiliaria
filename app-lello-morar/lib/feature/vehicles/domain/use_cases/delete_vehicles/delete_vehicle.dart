import 'package:essentials/essentials.dart';

abstract class DeleteVehicle extends UseCase<String, DeleteVehicleParam> {}

class DeleteVehicleParam {
  String id;
  DeleteVehicleParam(this.id);
}
