import 'package:essentials/essentials.dart';
import 'package:lello/feature/consultant_lello/domain/entity/consultant_lello.dart';
import 'package:lello/feature/consultant_lello/domain/repository/consultant_lello_repository.dart';
import 'package:lello/feature/consultant_lello/domain/use_case/list/consultant_lello_use_case.dart';


class ConsultantUseCaseImpl extends ConsultantUseCase {
  final ConsultantRepository repository;

  ConsultantUseCaseImpl({required this.repository});
  @override
  Future<Try<ConsultantEntity>> call(ConsultantParms params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    return await repository.consultant(params.condominiumId);
  }

  Failure? validate(ConsultantParms params) {
    if (params.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
