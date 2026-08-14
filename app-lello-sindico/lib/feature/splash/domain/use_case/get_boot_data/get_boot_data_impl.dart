import 'package:essentials/essentials.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:lello/feature/splash/domain/entity/boot_data.dart';
import 'package:lello/feature/splash/domain/repository/boot_data_repository.dart';
import 'package:lello/feature/splash/domain/use_case/get_boot_data/get_boot_data.dart';

class GetBootDataImpl extends GetBootData {
  final BootDataRepository repository;

  GetBootDataImpl({required this.repository});

  @override
  Future<Try<BootData>> call() async {
    try {
      var data = await repository.select();
      var model = data.getOrElse(() => GetBootData.defaultData);
      return Success(model ?? GetBootData.defaultData);
    } catch (err, stack) {
      FirebaseCrashlytics.instance.recordError(err, stack);
      return Rejection(UnknownFailure(err));
    }
  }
}
