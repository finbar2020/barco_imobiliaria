import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/shared_features.dart' hide isNull, isNotNull;

class _Session extends SharedSession {
  @override
  String get condominiumReference => 'REF';
  @override
  String get condominiumId => 'C1';
  @override
  String get userId => 'U1';
  @override
  String get unitId => 'A1';
}

void main() {
  test('SharedSession expõe os identificadores da sessão', () {
    final SharedSession session = _Session();
    expect(session.condominiumReference, 'REF');
    expect(session.condominiumId, 'C1');
    expect(session.userId, 'U1');
    expect(session.unitId, 'A1');
  });

  test('SharedSessionState pode ser instanciado', () {
    expect(SharedSessionState(), isA<SharedSessionState>());
  });
}
