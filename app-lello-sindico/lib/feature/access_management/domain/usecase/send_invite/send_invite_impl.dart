import 'package:essentials/essentials.dart';
import 'package:lello/feature/access_management/domain/repository/access_management_repository.dart';
import 'package:lello/feature/access_management/domain/usecase/send_invite/send_invite.dart';

class SendInviteUsecaseImpl extends SendInviteUsecase {
  final AccessManagementRepository repository;

  SendInviteUsecaseImpl({required this.repository});

  @override
  Future<Try<String>> call(SendInviteParam params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    final result = await repository.sendInvite(params.entity);
    return result;
  }

  Failure? validate(SendInviteParam? params) {
    if (params == null) return InvalidParamFailure();
    return null;
  }
}
