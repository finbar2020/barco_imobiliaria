import 'package:essentials/essentials.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_send_invite.dart';

abstract class SendInviteUsecase extends UseCase<String, SendInviteParam> {}

class SendInviteParam {
  final AccessControlSendInviteEntity body;
  SendInviteParam({
    required this.body,
  });
}
