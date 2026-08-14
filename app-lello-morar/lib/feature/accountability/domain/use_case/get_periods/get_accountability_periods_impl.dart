import 'package:essentials/essentials.dart';
import 'package:morar/feature/accountability/domain/entity/accountability_periods.dart';
import 'package:morar/feature/accountability/domain/repository/accountability_repository.dart';
import 'package:morar/feature/accountability/domain/use_case/get_periods/get_accountability_period.dart';

class GetAccountabilityPeriodImpl extends GetAccountabilityPeriod {
  final AccountabilityRepository repository;

  GetAccountabilityPeriodImpl({required this.repository});

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
