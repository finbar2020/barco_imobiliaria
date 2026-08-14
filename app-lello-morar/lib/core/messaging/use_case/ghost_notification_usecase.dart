import 'package:essentials/essentials.dart';

abstract class GhostNotificationUsecase
    implements UseCase<String?, GhostNotificationParams> {}

class GhostNotificationParams {
  final String id;
  final String type;
  GhostNotificationParams({
    required this.id,
    required this.type,
  });
}
