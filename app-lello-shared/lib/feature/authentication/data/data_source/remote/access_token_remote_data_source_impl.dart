part of shared_features;

class AccessTokenRemoteDataSourceImpl extends AccessTokenRemoteDataSource {
  final AuthenticationApi api;

  AccessTokenRemoteDataSourceImpl({required this.api});

  @override
  Future<AccessTokenModel?> post(AccessTokenRequestModel model) async {
    final response = await api.post(model).timeout(Duration(seconds: 30));

    return ApiMapper.map(response, (json) => AccessTokenModel.fromJson(json));
  }

  @override
  Future<AccessTokenModel?> postInvite(AccessTokenRequestModel model) async {
    final response = await api.postInvite(model).timeout(Duration(seconds: 30));

    return ApiMapper.map(response, (json) => AccessTokenModel.fromJson(json));
  }

  @override
  Future<AccessTokenModel?> switchRoles(String id) async {
    final response = await api.switchRoles(id).timeout(Duration(seconds: 30));

    return ApiMapper.map(response, (json) => AccessTokenModel.fromJson(json));
  }

  @override
  Future<String?> deleteAccount() async {
    final response = await api.deleteAccount();
    if (response.isSuccessful == true) {
      return "";
    } else {
      throw response.error!;
    }
  }
}
