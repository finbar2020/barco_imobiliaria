part of shared_features;

class SharedApplicationRedirectRoute {
  final String rote;
  final String? context;
  final String? objectId;
  final String? notificationId;
  final bool inApp;
  final String uuidGroup;
  bool didRedirect = false;
  final uuid = Uuid().v1();

  SharedApplicationRedirectRoute({
    required this.rote,
    required this.context,
    required this.notificationId,
    this.inApp = false,
    this.uuidGroup = "",
    this.objectId,
  });

  @override
  String toString() {
    return "Rote: $rote, Context: $context, ObjectId: $objectId";
  }
}
