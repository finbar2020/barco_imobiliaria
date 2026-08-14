part of shared_features;

abstract class Validate2fa extends UseCase<CodeValidToken, Validate2faParam> {}

class Validate2faParam {
  String id;
  String value;
  Validate2faParam({
    required this.id,
    required this.value,
  });
}
