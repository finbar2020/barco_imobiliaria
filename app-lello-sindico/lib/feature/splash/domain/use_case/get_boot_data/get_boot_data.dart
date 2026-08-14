import 'package:essentials/essentials.dart';

import 'package:lello/feature/splash/domain/entity/boot_data.dart';

abstract class GetBootData implements UnitUseCase<BootData> {
  static final defaultData = BootData()..showOnBoarding = true;
}
