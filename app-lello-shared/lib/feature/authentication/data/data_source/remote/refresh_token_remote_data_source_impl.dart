part of shared_features;

class RefreshTokenRemoteDataSourceImpl extends RefreshTokenRemoteDataSource {
  static String bad_refresh_token_failure = "bad_refresh_token_failure";
  final Uri? baseUrl;
  late final dio.Dio _dio;

  RefreshTokenRemoteDataSourceImpl({
    required this.baseUrl,
  }) {
    _dio = dio.Dio();
    _dio.options.baseUrl = baseUrl.toString();
  }

  @override
  Future<AccessTokenModel?> refreshToken(RefreshTokenRequestModel model) async {
    try {
      final response = await _dio
          .post(
            '/refreshToken',
            data: model.toJson(),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        return AccessTokenModel.fromJson(response.data);
      } else {
        throw Exception('Erro ao atualizar o token');
      }
    } on dio.DioException catch (e) {
      try {
        throw ApiFailure.fromJson(e.response?.data);
      } on TypeError catch (jsonError, jsonStackTrace) {
        // Catch errors during JSON parsing to ApiFailure itself
        FirebaseCrashlytics.instance.recordError(
          jsonError,
          jsonStackTrace,
          reason: 'Failed to parse ApiFailure from DioError response data',
          fatal: false,
        );
        // If parsing fails, throw a more generic error or rethrow the original DioException
        throw e; // Re-throw the original DioException
      }
    } catch (e) {
      rethrow;
    }
  }
}
