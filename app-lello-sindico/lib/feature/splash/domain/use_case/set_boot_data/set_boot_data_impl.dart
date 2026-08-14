import 'package:essentials/essentials.dart';
import 'package:lello/feature/splash/domain/entity/boot_data.dart';
import 'package:lello/feature/splash/domain/repository/boot_data_repository.dart';
import 'package:lello/feature/splash/domain/use_case/set_boot_data/set_boot_data.dart';

class SetBootDataImpl extends SetBootData {
  final BootDataRepository repository;

  SetBootDataImpl({required this.repository});

  @override
  Future<Try<BootData?>> call(BootData params) async {
    try {
      return await repository.save(params);
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }
}
