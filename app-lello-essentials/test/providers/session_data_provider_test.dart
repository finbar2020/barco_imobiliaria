import 'package:essentials/providers/session_data_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('começa sem valor', () {
    expect(SessionDataProvider<int>().value, isNull);
  });

  test('update guarda o valor e notifica os ouvintes', () {
    final provider = SessionDataProvider<String>();
    var notificacoes = 0;
    provider.addListener(() => notificacoes++);
    provider.update('a');
    expect(provider.value, 'a');
    expect(notificacoes, 1);
    provider.update('b');
    expect(provider.value, 'b');
    expect(notificacoes, 2);
  });
}
