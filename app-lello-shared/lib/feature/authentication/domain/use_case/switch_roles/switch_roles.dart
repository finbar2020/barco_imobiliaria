part of shared_features;

abstract class SwitchRoles implements UseCase<AccessToken?, SwitchParams> {}

class SwitchParams {
  final String role;
  final String name;
  SwitchParams({required this.role, required this.name});
}
