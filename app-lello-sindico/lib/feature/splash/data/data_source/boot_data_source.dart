import 'package:lello/feature/splash/data/model/boot_data_model.dart';

abstract class BootDataSource {
  Future<BootDataModel?> select();
  Future<BootDataModel?> save(BootDataModel? model);
}
