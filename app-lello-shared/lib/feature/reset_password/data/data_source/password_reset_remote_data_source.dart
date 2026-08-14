part of shared_features;

abstract class PasswordResetRemoteDataSource {
  Future<PasswordResetModel> post(PasswordResetModel model);
}
