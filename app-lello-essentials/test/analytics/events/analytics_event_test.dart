import 'package:essentials/analytics/events/analytics_event.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AnalyticsEvent guarda nome, token e tipo', () {
    final evento = AnalyticsEvent('meu_evento', 'abc123', Type.read);
    expect(evento.name, 'meu_evento');
    expect(evento.token, 'abc123');
    expect(evento.type, 'read');
  });

  test('campos são mutáveis', () {
    final evento = AnalyticsEvent('a', 'b', Type.write)
      ..name = 'novo'
      ..token = ''
      ..type = Type.delete;
    expect(evento.name, 'novo');
    expect(evento.token, isEmpty);
    expect(evento.type, 'delete');
  });

  test('Type expõe os três tipos textuais', () {
    expect(Type.read, 'read');
    expect(Type.write, 'write');
    expect(Type.delete, 'delete');
  });
}
