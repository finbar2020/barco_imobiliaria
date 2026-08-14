import 'package:essentials/essentials.dart';
import 'package:morar/feature/splash/domain/entity/boot_data.dart';

abstract class BootDataRepository {
  Future<Try<BootData?>> select();
  Future<Try<BootData?>> save(BootData? data);
}
