import 'package:essentials/essentials.dart';
import 'package:lello/feature/accountability/domain/entity/accountability.dart';
import 'package:lello/feature/accountability/domain/repository/accountability_repository.dart';

class GetAccountabilityUsecase
    extends UseCase<Accountability, GetAccountabilityParam> {
  final AccountabilityRepository repository;

  GetAccountabilityUsecase({required this.repository});

  @override
  Future<Try<Accountability>> call(GetAccountabilityParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return repository.select(params.condominiumId, params.period);
  }

  Failure? _validate(GetAccountabilityParam? params) {
    if (params == null) return InvalidParamFailure();
    if (params.condominiumId.isEmpty) return InvalidParamFailure();

    return null;
  }
}

class GetAccountabilityParam {
  final String condominiumId;
  final DateTime period;

  GetAccountabilityParam({required this.condominiumId, required this.period});
}
