

// Pensar em uma implementação para o authorization header interceptor e considerar se vai ser no essentials ou nao

// class AuthorizationHeaderInterceptor implements RequestInterceptor {
//   //final AccessTokenLocalDataSource dataSource;
//   AuthorizationHeaderInterceptor({@required this.dataSource})
//       : assert(dataSource != null);
//   @override
//   FutureOr<Request> onRequest(Request request) async {
//     String jwt = null;
//     try {
//       final token = await dataSource.select();
//       jwt = token?.accessToken;
//     } catch (err) {
//       jwt = null;
//     }

//     if (jwt != null) {
//       return applyHeader(request, "Authorization", "Bearer $jwt");
//     }
//     return request;
//   }
// }
