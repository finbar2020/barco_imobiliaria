import 'dart:async';
import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:shared_features/shared_features.dart';

// ignore: must_be_immutable
class RefreshAuthenticatorInterceptor implements Authenticator {
  final AccessTokenLocalDataSource dataSource;
  final RefreshToken refreshToken;
  Completer<bool>? _refreshCompleter;

  static const String retryCountHeader = 'Retry-Count';

  RefreshAuthenticatorInterceptor({
    required this.dataSource,
    required this.refreshToken,
  });

  @override
  FutureOr<Request?> authenticate(
    Request request,
    Response response, [
    Request? originalRequest,
  ]) async {
    print('[RefreshAuthenticator] response.statusCode: ${response.statusCode}');
    print(
      '[RefreshAuthenticator] request Retry-Count: ${request.headers[retryCountHeader] ?? 0}',
    );

    if (response.statusCode == HttpStatus.unauthorized) {
      if (request.headers[retryCountHeader] != null) {
        print(
          '[RefreshAuthenticator] Unable to refresh token, retry count exceeded',
        );
        return null;
      }

      try {
        if (_refreshCompleter != null) {
          // Se já estiver sendo atualizado, espera a conclusão
          print('[RefreshAuthenticator] await _refreshCompleter!.future');
          await _refreshCompleter!.future;
        } else {
          // Caso contrário, cria um novo Completer para refresh
          print('[RefreshAuthenticator] refreshToken.call()');
          _refreshCompleter = Completer<bool>();
          var refresh = await refreshToken.call();
          var success = refresh.fold((l) => false, (r) => true);
          _refreshCompleter!.complete(success);
          _refreshCompleter = null;
          if (success == false) {
            print('[RefreshAuthenticator] Refresh failed');
            return null;
          }
        }

        var newToken = await dataSource.select(role: '');
        if (newToken?.accessToken == null) {
          print('[RefreshAuthenticator] Unable to refresh token');
          return null;
        }
        print('[RefreshAuthenticator] Refresh successful');

        String newAuthHeader = newToken!.accessToken!.startsWith('Bearer ')
            ? newToken.accessToken!
            : 'Bearer ${newToken.accessToken!}';

        return applyHeaders(
          request,
          {
            HttpHeaders.authorizationHeader: newAuthHeader,
            retryCountHeader: '1',
          },
        );
      } catch (e) {
        print('[RefreshAuthenticator] Unable to refresh token: $e');
        _refreshCompleter = null;
        return null;
      }
    }

    return null;
  }

  @override
  AuthenticationCallback? get onAuthenticationFailed {
    print('onAuthenticationFailed');
    return null;
  }

  @override
  AuthenticationCallback? get onAuthenticationSuccessful {
    print('onAuthenticationSuccessful');
    return null;
  }
}
