part of shared_features;

abstract class SendPushCallback extends UseCase<bool, SendPushCallbackParams> {}

class SendPushCallbackParams {
  final String notificationId;
  final NotificationCallbackType type;

  SendPushCallbackParams({required this.notificationId, required this.type});
}
