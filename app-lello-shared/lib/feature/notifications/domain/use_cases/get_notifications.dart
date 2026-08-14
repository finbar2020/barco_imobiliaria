part of shared_features;

abstract class GetNotifications
    extends UseCase<Paginator, GetNotificationParams> {}

class GetNotificationParams {
  final String reference;
  final int limit;
  final int page;

  GetNotificationParams({
    required this.reference,
    required this.limit,
    required this.page,
  });
}
