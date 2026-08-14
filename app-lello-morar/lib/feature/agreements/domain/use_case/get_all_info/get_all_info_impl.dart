import 'package:essentials/essentials.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_all_info.dart';
import 'package:morar/feature/agreements/domain/repository/agreements_repository.dart';
import 'package:morar/feature/agreements/domain/use_case/get_all_info/get_all_info.dart';

class GetAvailableUseCaseImpl extends GetAvailableUseCase {
  final AgreementsRepository repository;

  GetAvailableUseCaseImpl({required this.repository});
  @override
  Future<Try<AgreementAllInfo>> call(GetAvailableParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);
    var response = await repository.getAllInfo(
      params.condoId,
      params.unitTitle,
      params.onlyQuoteAndRule,
    );
    return response;
  }

  Failure? _validate(GetAvailableParams? params) {
    if (params == null) return InvalidParamFailure();
    return null;
  }
}
