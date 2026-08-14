import 'package:essentials/base/use_case.dart';
import 'package:essentials/functional/failure.dart';
import 'package:essentials/functional/try.dart';

import '../repository/sub_user_repository.dart';

abstract class SendAccessRenewRequestUseCase extends UseCase<String, String> {}

class SendAccessRenewRequestUseCaseImpl extends SendAccessRenewRequestUseCase {
  final SubUserRepository repository;

  SendAccessRenewRequestUseCaseImpl({
    required this.repository,
  });

  @override
  Future<Try<String>> call(String params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);
    return await repository.sendAccessRenewRequest(params);
  }

  Failure? _validate(String params) {
    if (params.isEmpty) return InvalidParamFailure();
    return null;
  }
}
