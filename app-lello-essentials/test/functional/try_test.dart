import 'package:essentials/functional/failure.dart';
import 'package:essentials/functional/try.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Success', () {
    test('fold chama o ramo direito e get devolve o dado', () {
      final s = Success<int>(1);
      expect(s.fold((l) => 'erro', (r) => 'ok $r'), 'ok 1');
      expect(s.get(), 1);
      expect(s.isRight(), isTrue);
    });

    test('igualdade e hashCode dependem do dado', () {
      expect(Success<int>(1), Success<int>(1));
      expect(Success<int>(1) == Success<int>(2), isFalse);
      expect(Success<int>(1).hashCode, 1.hashCode);
    });

    test('Try.success cria um Success', () {
      expect(Try.success<int>(5), isA<Success<int>>());
      expect(Try.success<int>(5), Success<int>(5));
    });
  });

  group('Rejection', () {
    test('fold chama o ramo esquerdo e get devolve a falha', () {
      final falha = UnknownFailure('x');
      final r = Rejection<int>(falha);
      expect(r.fold((l) => 'erro ${l.code}', (r) => 'ok'), 'erro UNKNOWN');
      expect(r.get(), falha);
      expect(r.isLeft(), isTrue);
    });

    test('igualdade e hashCode dependem da falha', () {
      final falha = UnknownFailure('x');
      expect(Rejection<int>(falha), Rejection<int>(UnknownFailure('x')));
      expect(Rejection<int>(falha) == Rejection<int>(UnknownProvider('x')),
          isFalse);
      expect(Rejection<int>(falha).hashCode, falha.hashCode);
    });

    test('Try.reject cria um Rejection', () {
      expect(Try.reject<int>(UnknownFailure('a')), isA<Rejection<int>>());
    });
  });

  group('foldAlong', () {
    test('dois sucessos combinam os dados', () {
      final a = Success<int>(1);
      final b = Success<String>('b');
      expect(a.foldAlong<String, String>(b, (l) => 'erro', (r, r2) => '$r$r2'),
          '1b');
    });

    test('primeiro rejeitado usa a primeira falha', () {
      final a = Rejection<int>(UnknownFailure('a'));
      final b = Success<String>('b');
      expect(a.foldAlong<String, String>(b, (l) => l.error, (r, r2) => 'ok'),
          'a');
    });

    test('segundo rejeitado usa a segunda falha', () {
      final a = Success<int>(1);
      final b = Rejection<String>(UnknownFailure('b'));
      expect(a.foldAlong<String, String>(b, (l) => l.error, (r, r2) => 'ok'),
          'b');
    });
  });

  group('transform', () {
    test('troca o dado de um Success', () {
      final t = Success<int>(1).transform<String>(data: 'novo');
      expect(t, Success<String>('novo'));
    });

    test('mantém a falha de um Rejection', () {
      final falha = UnknownFailure('x');
      final t = Rejection<int>(falha).transform<String>(data: 'novo');
      expect(t, isA<Rejection<String>>());
      expect((t as Rejection).get(), falha);
    });
  });

  group('foldAll', () {
    test('todos sucessos entrega a lista de dados', () {
      final r = Try.foldAll<String>(
        [Success<int>(1), Success<String>('b')],
        (l) => 'erro',
        (data) => data.join(','),
      );
      expect(r, '1,b');
    });

    test('primeira rejeição interrompe e entrega a falha', () {
      var chamadas = 0;
      final r = Try.foldAll<String>(
        [Success<int>(1), Rejection<int>(UnknownFailure('f')), Success(2)],
        (l) => l.error,
        (data) {
          chamadas++;
          return 'ok';
        },
      );
      expect(r, 'f');
      expect(chamadas, 0);
    });

    /// Corrigido: com lista vazia `foldAll` devolve o resultado da primeira
    /// chamada de `ifRight([])` — o callback é executado uma única vez.
    test('lista vazia chama ifRight uma única vez', () {
      var chamadas = 0;
      final r = Try.foldAll<String>([], (l) => 'erro', (data) {
        chamadas++;
        return 'vazio ${data.length}';
      });
      expect(r, 'vazio 0');
      expect(chamadas, 1);
    });
  });
}
