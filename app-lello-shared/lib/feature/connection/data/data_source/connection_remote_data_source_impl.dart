part of shared_features;

class ConnectionRemoteDataSourceImpl extends ConnectionRemoteDataSource {
  final String baseUrl;
  ConnectionRemoteDataSourceImpl({required this.baseUrl});

  @override
  Future<bool> healthCheck() async {
    //remove subroutes from baseUrl if it exists
    final uri = Uri.parse(baseUrl);
    final cleanedBaseUrl = uri.origin;

    //use dio to make a request to the health check endpoint
    final api = dio.Dio(
      dio.BaseOptions(
        baseUrl: cleanedBaseUrl,
        connectTimeout: Duration(seconds: 60),
        receiveTimeout: Duration(seconds: 60),
      ),
    );

    final response = await api.get('/_health');

    if (response.statusCode == 200) {
      return true;
    } else {
      throw response;
    }
  }
}
