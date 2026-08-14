part of shared_features;

class PasswordResetRemoteDataSourceImpl extends PasswordResetRemoteDataSource {
  final PasswordResetApi api;

  PasswordResetRemoteDataSourceImpl({required this.api});

  @override
  Future<PasswordResetModel> post(PasswordResetModel model) async {
    final response = await api.post(model);
    if (response.isSuccessful) {
      return model;
    }
    throw response.error!;
  }
}
