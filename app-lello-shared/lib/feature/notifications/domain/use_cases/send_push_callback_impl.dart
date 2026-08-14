part of shared_features;

class SendPushCallbackImpl extends SendPushCallback {
  final NotificationsRepository repository;

  SendPushCallbackImpl({required this.repository});

  @override
  Future<Try<bool>> call(SendPushCallbackParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.sendPushCallback(
        params.notificationId, params.type);
  }

  Failure? _validate(SendPushCallbackParams param) {
    if (param.notificationId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
