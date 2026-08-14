import 'package:essentials/essentials.dart';
import 'package:lello/feature/access_management/domain/entity/access_management_send_invite.dart';

abstract class SendInviteUsecase extends UseCase<String, SendInviteParam> {}

class SendInviteParam {
  final AccessManagementSendInviteEntity entity;

  SendInviteParam({
    required this.entity,
  });
}
