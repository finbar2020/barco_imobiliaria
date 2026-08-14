import 'package:essentials/essentials.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_periods.dart';
import 'package:lello/feature/accountability/domain/repository/accountability_repository.dart';

class GetAccountabilityPeriodUsecase
    extends UseCase<List<AccountabilityPeriods>, String> {
  final AccountabilityRepository repository;

  GetAccountabilityPeriodUsecase({required this.repository});

  @override
  Future<Try<List<AccountabilityPeriods>>> call(String condominiumId) async {
    final error = _validate(condominiumId);
    if (error != null) return Rejection(error);

    return repository.getPeriod(condominiumId);
  }

  Failure? _validate(String condominiumId) {
    if (condominiumId.isEmpty) return InvalidParamFailure();

    return null;
  }
}
