import 'package:essentials/essentials.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_balance.dart';
import 'package:lello/feature/condominium/domain/repository/condominium_balance_repository.dart';

import 'load_condominium_balance.dart';

class LoadCondominiumBalanceImpl extends LoadCondominiumBalance {
  final CondominiumBalanceRepository repository;

  LoadCondominiumBalanceImpl({required this.repository});

  @override
  Future<Try<CondominiumBalance?>> call(CondominiumBalanceParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    final future = params.origin == DataOrigin.local
        ? repository.selectFromCache(params)
        : repository.select(params);

    return await future;
  }

  Failure? _validate(CondominiumBalanceParam? params) {
    if (params?.id == null) return InvalidParamFailure();
    if (params?.reference == null) return InvalidParamFailure();
    if (params?.origin == null) return InvalidParamFailure();
    return null;
  }
}
