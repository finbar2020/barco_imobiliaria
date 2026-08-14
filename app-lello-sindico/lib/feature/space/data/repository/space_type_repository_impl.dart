import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/data/data_source/remote/space_type_remote_data_source.dart';
import 'package:lello/feature/space/domain/entity/space_type.dart';
import 'package:lello/feature/space/domain/repository/space_type_repository.dart';

class SpaceTypeRepositoryImpl extends SpaceTypeRepository {
  final SpaceTypeRemoteDataSource dataSource;

  SpaceTypeRepositoryImpl({required this.dataSource});
  @override
  Future<Try<List<SpaceType>>> list(String condominiumId) async {
    try {
      final models = await dataSource.list(condominiumId);
      final data = models.map((e) => e.toEntity()).toList();

      return Success(data);
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }
}
