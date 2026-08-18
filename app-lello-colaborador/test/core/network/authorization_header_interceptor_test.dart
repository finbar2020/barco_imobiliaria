import 'package:chopper/chopper.dart';
import 'package:colaborador/core/network/authorization_header_interceptor.dart';
import 'package:essentials/configs/flavor_config.dart';
import 'package:essentials/configs/lello_configuration.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus_platform_interface/package_info_data.dart';
import 'package:package_info_plus_platform_interface/package_info_platform_interface.dart';
import 'package:shared_features/feature/authentication/data/model/access_token_model.dart';
import 'package:shared_features/shared_features.dart';

class _FakeTokenSource extends Fake implements AccessTokenLocalDataSource {
  bool fail = false;
  String? token;

  @override
  Future<AccessTokenModel?> select({required String role}) async {
    if (fail) throw Exception('token error');
    if (token == null) return null;
    return AccessTokenModel()..accessToken = token;
  }
}

class _FakeChain extends Fake implements Chain<dynamic> {
  _FakeChain(this._request);

  final Request _request;
  Request? proceeded;

  @override
  Request get request => _request;

  @override
  Future<Response<dynamic>> proceed(Request request) async {
    proceeded = request;
    return Response(http.Response('', 200), '');
  }
}

class _FakePackageInfo extends PackageInfoPlatform {
  @override
  Future<PackageInfoData> getAll({String? baseUrl}) async => PackageInfoData(
        appName: 'Colaborador',
        packageName: 'com.lello.colaborador',
        version: '1.2.3',
        buildNumber: '42',
        buildSignature: '',
      );
}

Request _testRequest() {
  final base = Uri.parse('https://api.lello.com');
  return Request('GET', Uri.parse('https://api.lello.com/x'), base);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  FlavorConfig.config = const LelloConfiguration();
  PackageInfoPlatform.instance = _FakePackageInfo();

  group('AuthorizationHeaderInterceptor', () {
    test('adiciona headers com jwt', () async {
      final interceptor = AuthorizationHeaderInterceptor(
        dataSource: _FakeTokenSource()..token = 'abc-jwt',
      );
      final request = _testRequest();
      final chain = _FakeChain(request);

      await interceptor.intercept(chain);

      final headers = chain.proceeded!.headers;
      expect(headers['authorization'], 'Bearer abc-jwt');
      expect(headers['app-version'], '1.2.3');
      expect(headers['X-Lello-Client-Type'], 'APPDPREP');
      expect(headers['X-Lello-Flavor'], isNotEmpty);
      expect(headers['idEmpresa'], isNotEmpty);
    });

    test('omite Authorization sem token', () async {
      final interceptor = AuthorizationHeaderInterceptor(
        dataSource: _FakeTokenSource(),
      );
      final chain = _FakeChain(_testRequest());

      await interceptor.intercept(chain);

      expect(chain.proceeded!.headers.containsKey('Authorization'), isFalse);
      expect(chain.proceeded!.headers['app-version'], '1.2.3');
    });

    test('usa valores padrão quando token falha', () async {
      final interceptor = AuthorizationHeaderInterceptor(
        dataSource: _FakeTokenSource()..fail = true,
      );
      final chain = _FakeChain(_testRequest());

      await interceptor.intercept(chain);

      expect(chain.proceeded!.headers['app-version'], 'unidentified');
      expect(chain.proceeded!.headers.containsKey('Authorization'), isFalse);
    });
  });
}
