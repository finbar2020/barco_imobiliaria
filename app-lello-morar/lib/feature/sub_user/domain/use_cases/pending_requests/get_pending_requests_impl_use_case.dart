import 'package:essentials/functional/failure.dart';
import 'package:essentials/functional/try.dart';
import 'package:morar/feature/sub_user/domain/entity/pending_request.dart';
import 'package:morar/feature/sub_user/domain/repository/sub_user_repository.dart';
import 'package:morar/feature/sub_user/domain/use_cases/pending_requests/get_pending_requests_use_case.dart';

class GetPendingRequestsUseCaseImpl extends GetPendingRequestsUseCase {

  final SubUserRepository repository;

  GetPendingRequestsUseCaseImpl(this.repository);

  @override
  Future<Try<List<PendingRequestEntity>>> call(String params) async {

    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.getPendingRequests(params);
  }

  Failure? _validate(String params) {
    if (params.isEmpty) return InvalidParamFailure();
    return null;
  }

}
