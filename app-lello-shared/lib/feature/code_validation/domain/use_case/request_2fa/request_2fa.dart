part of shared_features;

abstract class Request2fa extends UseCase<bool, Tequest2faParam> {}

class Tequest2faParam {
  String id;
  String appSignature;
  Tequest2faParam({
    required this.id,
    required this.appSignature,
  });
}
