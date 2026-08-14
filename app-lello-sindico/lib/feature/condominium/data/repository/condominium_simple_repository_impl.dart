import 'package:essentials/essentials.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_simple.dart';
import 'package:lello/feature/condominium/domain/repository/condominium_simple_repository.dart';
import 'package:lello/feature/condominium/domain/use_case/get_simple_condominium/get_simple_condominium.dart';

import '../data_source/remote/condominium_simple_remote_data_source.dart';

class CondominiumSimpleRepositoryImpl implements CondominiumSimpleRepository {
  final CondominiumSimpleRemoteDataSource dataSource;

  CondominiumSimpleRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<Try<CondominiumSimple>> getSimpleCondominium(
      {required GetSimpleCondominiumParams params}) async {
    try {
      final model = await dataSource.getSimple(condominiumId: params.id);

      return Success(model.toEntity());
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }
}
