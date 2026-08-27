import 'package:essentials/configs/environment.dart';
import 'package:flutter_test/flutter_test.dart';

class _Producao extends Environment {
  _Producao()
      : super(
          isProduction: true,
          apiUrl: 'https://api.lello.com.br',
          name: 'prod',
        );
}

class _Homolog extends Environment {
  _Homolog()
      : super(isProduction: false, apiUrl: 'https://hml.lello', name: 'hml');
}

void main() {
  test('ambiente de produção guarda os valores informados', () {
    final env = _Producao();
    expect(env.isProduction, isTrue);
    expect(env.apiUrl, 'https://api.lello.com.br');
    expect(env.name, 'prod');
    expect(env, isA<Environment>());
  });

  test('ambiente de homologação não é produção', () {
    final env = _Homolog();
    expect(env.isProduction, isFalse);
    expect(env.apiUrl, 'https://hml.lello');
    expect(env.name, 'hml');
  });
}
