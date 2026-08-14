import 'package:essentials/essentials.dart';
import 'package:lello/feature/splash/data/data_source/boot_data_source.dart';
import 'package:lello/feature/splash/data/model/boot_data_model.dart';
import 'package:lello/feature/splash/domain/entity/boot_data.dart';
import 'package:lello/feature/splash/domain/repository/boot_data_repository.dart';

class BootDataRepositoryImpl implements BootDataRepository {
  final BootDataSource dataSource;
  BootDataRepositoryImpl({required this.dataSource});

  @override
  Future<Try<BootData?>> select() async {
    try {
      var data = await dataSource.select();
      return Success(data?.toEntity());
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<BootData?>> save(BootData data) async {
    try {
      var model = BootDataModel.fromEntity(data);
      var persisted = await dataSource.save(model);
      return Success(persisted?.toEntity());
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }
}
