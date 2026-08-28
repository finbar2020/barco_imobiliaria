import 'package:essentials/functional/failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('UnknownFailure tem código UNKNOWN e guarda o erro', () {
    final f = UnknownFailure('boom');
    expect(f.code, 'UNKNOWN');
    expect(f.error, 'boom');
  });

  test('UnknownProvider tem código UNKNOWNPROVIDER', () {
    final f = UnknownProvider(1);
    expect(f.code, 'UNKNOWNPROVIDER');
    expect(f.error, 1);
  });

  test('KnownFailure guarda código, erro e mensagem e formata toString', () {
    final f = KnownFailure('C1', 'err', message: 'msg');
    expect(f.code, 'C1');
    expect(f.error, 'err');
    expect(f.message, 'msg');
    expect(f.toString(), 'code: C1 - err: err - message: msg');
    expect(KnownFailure('C2', null).message, isNull);
  });

  test('falhas sem parâmetros têm código e erro nulos', () {
    expect(ServerConnectionFailure().code, isNull);
    expect(ServerConnectionFailure().error, isNull);
    expect(InvalidDataOriginFailure().code, isNull);
    expect(InvalidParamFailure().error, isNull);
    expect(ServerConnectionFailure(), isA<Failure>());
  });

  test('igualdade compara código e erro', () {
    expect(UnknownFailure('a') == UnknownFailure('a'), isTrue);
    expect(UnknownFailure('a') == UnknownFailure('b'), isFalse);
    expect(UnknownFailure('a') == UnknownProvider('a'), isFalse);
    // Falhas sem código nem erro são todas iguais entre si.
    expect(ServerConnectionFailure() == InvalidParamFailure(), isTrue);
    // ignore: unrelated_type_equality_checks
    expect(UnknownFailure('a') == 'a', isFalse);
  });

  /// Corrigido: `hashCode` deriva de código e erro, consistente com `==`, então
  /// falhas iguais colapsam em `Set`/`Map`.
  test('hashCode é consistente com a igualdade', () {
    expect(UnknownFailure('a').hashCode, UnknownFailure('a').hashCode);
    expect(UnknownFailure('a').hashCode == UnknownFailure('b').hashCode, isFalse);
    expect(ServerConnectionFailure().hashCode, InvalidParamFailure().hashCode);
    expect({UnknownFailure('a'), UnknownFailure('a')}.length, 1);
    expect({UnknownFailure('a'): 1}[UnknownFailure('a')], 1);
  });
}
