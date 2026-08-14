import 'package:essentials/essentials.dart';
import 'package:lello/feature/consultant_lello/data/data_source/remote/consultant_lello_remote_data_source.dart';
import 'package:lello/feature/consultant_lello/domain/entity/consultant_lello.dart';
import 'package:lello/feature/consultant_lello/domain/repository/consultant_lello_repository.dart';


class ConsultantRepositoryImpl extends ConsultantRepository {
  final ConsultantRemoteDataSource remoteDataSource;

  ConsultantRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Try<ConsultantEntity>> consultant(String condominiumId) async {
    try {
      final future = await remoteDataSource.consultant(condominiumId);
      final result = future.toEntity();
      return Success(result);
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }
}
