import 'package:essentials/essentials.dart';
import 'package:morar/feature/sub_user/domain/repository/sub_user_repository.dart';
import 'package:morar/feature/sub_user/domain/use_cases/update_access_request_status/update_access_request_use_case.dart';

class UpdateAccessRequestStatusUseCaseImpl extends UpdateAccessRequestUseCase {
  final SubUserRepository repository;

  UpdateAccessRequestStatusUseCaseImpl(this.repository);

  @override
  Future<Try<bool>> call(UpdateAccessRequestStatusParams params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    return await repository.updateAccessRequestStatus(
      params.id,
      params.status,
      params.expiresAt,
    );
  }

  Failure? validate(UpdateAccessRequestStatusParams params) {
    if (params.id <= 0) return InvalidParamFailure();
    if (params.status.isEmpty) return InvalidParamFailure();
    return null;
  }
}
