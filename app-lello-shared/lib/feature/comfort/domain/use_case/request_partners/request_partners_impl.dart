import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/comfort/domain/repository/comfort_repository.dart';
import 'package:shared_features/feature/comfort/domain/use_case/request_partners/request_partners.dart';

class RequestPartnersUseCaseImpl extends RequestPartnersUseCase {
  final ComfortRepository repository;

  RequestPartnersUseCaseImpl({required this.repository});

  @override
  Future<Try<bool>> call(RequestPartnersUseCaseParam params) async {
    final error = validate(params);

    if (error != null) return Rejection(error);

    final result =
        await repository.requestPartners(params.condominiumId, params.request);

    return result;
  }

  Failure? validate(RequestPartnersUseCaseParam params) {
    if (params.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
