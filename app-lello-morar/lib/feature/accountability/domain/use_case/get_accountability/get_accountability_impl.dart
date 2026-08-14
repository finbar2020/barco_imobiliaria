import 'package:essentials/essentials.dart';
import 'package:morar/feature/accountability/domain/entity/accountability.dart';
import 'package:morar/feature/accountability/domain/repository/accountability_repository.dart';
import 'package:morar/feature/accountability/domain/use_case/get_accountability/get_accountability.dart';

class GetAccountabilityImpl extends GetAccountability {
  final AccountabilityRepository repository;

  GetAccountabilityImpl({required this.repository});

  @override
  Future<Try<Accountability>> call(GetAccountabilityParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return repository.select(params.condominiumId, params.period);
  }

  Failure? _validate(GetAccountabilityParam params) {
    if (params.condominiumId.isEmpty) return InvalidParamFailure();

    return null;
  }
}
