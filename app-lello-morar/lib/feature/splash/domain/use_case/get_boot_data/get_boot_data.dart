import 'package:morar/feature/splash/domain/entity/boot_data.dart';
import 'package:essentials/essentials.dart';

abstract class GetBootData implements UnitUseCase<BootData> {
  static final defaultData = BootData()..showOnBoarding = true;
}
