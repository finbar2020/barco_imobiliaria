part of shared_features;

abstract class GhostNotificationRepository {
  Future<Try<String?>> send(
      GhostNotificationModel model, String id, String type);
}
