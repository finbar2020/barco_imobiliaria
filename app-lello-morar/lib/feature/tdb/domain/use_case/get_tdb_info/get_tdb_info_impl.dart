import 'package:essentials/essentials.dart';
import 'package:morar/feature/tdb/domain/entity/tdb_info.dart';
import 'package:morar/feature/tdb/domain/repository/tdb_repository.dart';
import 'package:morar/feature/tdb/domain/use_case/get_tdb_info/get_tdb_info.dart';

class GetTDBInfoUseCaseImpl extends GetTDBInfoUseCase {
  final TDBRepository repository;

  GetTDBInfoUseCaseImpl({required this.repository});

  @override
  Future<Try<TDBInfo>> call(GetTDBInfoParam params) async {
    final error = validate(params);

    if (error != null) return Rejection(error);

    final result = await repository.getTDBInfo(params.condominiumId);

    return result;
  }

  Failure? validate(GetTDBInfoParam params) {
    if (params.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
