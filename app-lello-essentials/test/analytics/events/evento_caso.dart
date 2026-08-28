import 'package:essentials/analytics/events/analytics_event.dart';
import 'package:flutter_test/flutter_test.dart';

/// Um caso da tabela de eventos: a fábrica estática chamada e os valores
/// esperados de nome, token do Adjust e tipo.
class Caso {
  const Caso(this.evento, this.nome, this.token, this.tipo);

  final AnalyticsEvent evento;
  final String nome;
  final String token;
  final String tipo;
}

/// Verifica cada caso da tabela e devolve os eventos para validações extras.
void verificaCatalogo(List<Caso> casos) {
  for (final caso in casos) {
    expect(caso.evento, isA<AnalyticsEvent>(), reason: caso.nome);
    expect(caso.evento.name, caso.nome, reason: caso.nome);
    expect(caso.evento.token, caso.token, reason: caso.nome);
    expect(caso.evento.type, caso.tipo, reason: caso.nome);
    expect(caso.evento.name, isNotEmpty);
    expect(caso.evento.token, matches(RegExp(r'^[a-z0-9]{6}$')),
        reason: '${caso.nome}: token do Adjust tem 6 caracteres');
  }
}

/// Agrupa os pares (nome, tipo) que aparecem com tokens diferentes.
Map<String, Set<String>> tokensPorNomeTipo(List<Caso> casos) {
  final mapa = <String, Set<String>>{};
  for (final caso in casos) {
    mapa.putIfAbsent('${caso.nome}|${caso.tipo}', () => {}).add(caso.token);
  }
  return mapa;
}
