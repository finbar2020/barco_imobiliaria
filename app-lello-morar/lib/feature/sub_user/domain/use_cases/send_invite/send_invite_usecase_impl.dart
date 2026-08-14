import 'package:essentials/essentials.dart';
import 'package:morar/feature/access_control/domain/repository/access_control_repository.dart';
import 'package:morar/feature/sub_user/domain/use_cases/send_invite/send_invite_usecase.dart';

class SendInviteUsecaseImpl extends SendInviteUsecase {
  final AccessControlRepository repository;

  SendInviteUsecaseImpl({
    required this.repository,
  });

  @override
  Future<Try<String>> call(SendInviteParam params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    return await repository.sendInvite(params.body);
  }

  Failure? validate(SendInviteParam params) {
    //if (params == null) return InvalidParamFailure();

    return null;
  }
}
