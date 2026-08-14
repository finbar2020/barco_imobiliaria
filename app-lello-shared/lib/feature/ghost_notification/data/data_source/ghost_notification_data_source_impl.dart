part of shared_features;

class GhostNotificationDataSourceImpl extends GhostNotificationDatasource {
  final GhostNotificationApi api;

  GhostNotificationDataSourceImpl({required this.api});

  @override
  Future<String?> send(
    GhostNotificationModel model,
    String id,
    String type,
  ) async {
    final response = await api.sendGhostNotification(model, id, type);
    if (response.isSuccessful == false) {
      throw response.error!;
    } else {
      return "";
    }
  }
}
