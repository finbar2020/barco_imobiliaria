part of shared_features;

class GhostNotificationRepositoryImpl extends GhostNotificationRepository {
  final GhostNotificationDatasource datasource;

  GhostNotificationRepositoryImpl({required this.datasource});

  @override
  Future<Try<String?>> send(
      GhostNotificationModel model, String id, String type) async {
    try {
      final response = await datasource.send(model, id, type);
      return Success(response);
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }
}
