part of shared_features;

abstract class GhostNotificationDatasource {
  Future<String?> send(
    GhostNotificationModel model,
    String id,
    String type,
  );
}
