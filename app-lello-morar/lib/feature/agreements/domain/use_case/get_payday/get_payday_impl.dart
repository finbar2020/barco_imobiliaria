import 'package:essentials/essentials.dart';
import 'package:morar/feature/agreements/domain/repository/agreements_repository.dart';
import 'package:morar/feature/agreements/domain/use_case/get_payday/get_payday.dart';

class GetPaydayUseCaseImpl extends GetPaydayUseCase {
  final AgreementsRepository repository;

  GetPaydayUseCaseImpl({required this.repository});
  @override
  Future<Try<List<String>>> call(GetPaydayParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);
    var response = await repository.getPayday(params.condoId);
    return response;
  }

  Failure? _validate(GetPaydayParams? params) {
    if (params == null) return InvalidParamFailure();
    return null;
  }
}
