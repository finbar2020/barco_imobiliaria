part of shared_features;

abstract class GetToken extends UseCase<AccessToken?, GetTokenParams?> {}

class GetTokenParams {
  final String? role;
  GetTokenParams({this.role});
}
