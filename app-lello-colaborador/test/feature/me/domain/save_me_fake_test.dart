import 'package:colaborador/feature/me/domain/entity/me.dart';
import 'package:colaborador/feature/me/domain/repository/me_repository.dart';
import 'package:colaborador/feature/me/domain/use_case/save_me/save_me.dart';
import 'package:colaborador/feature/me/domain/use_case/save_me/save_me_failure.dart';
import 'package:colaborador/feature/me/domain/use_case/save_me/save_me_impl.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/shared_features.dart';

class _FakeMeRepo extends Fake implements MeRepository {
  String? lastCode;

  @override
  Future<Try<Me?>> save(Me? me, String code) async {
    lastCode = code;
    return Success(me);
  }
}

void main() {
  group('SaveMeImpl', () {
    test('rejeita me nulo', () async {
      final result = await SaveMeImpl(repository: _FakeMeRepo())(
        SaveMeParam(originalMe: Me(id: '1')),
      );
      expect(result, isA<Rejection<Me?>>());
    });

    test('rejeita originalMe nulo', () async {
      final result = await SaveMeImpl(repository: _FakeMeRepo())(
        SaveMeParam(me: Me(id: '1')),
      );
      expect(result, isA<Rejection<Me?>>());
    });

    test('exige codeValidation quando o telefone muda', () async {
      final result = await SaveMeImpl(repository: _FakeMeRepo())(
        SaveMeParam(
          me: Me(id: '1', phone: '2'),
          originalMe: Me(id: '1', phone: '1'),
        ),
      );
      expect(result, isA<Rejection<Me?>>());
      result.fold(
        (err) => expect(err, isA<SaveMeInvalidCodeValidationFailure>()),
        (_) => fail('esperava rejection'),
      );
    });

    test('salva quando o telefone não muda', () async {
      final repo = _FakeMeRepo();
      final me = Me(id: '1', phone: '1');
      final result = await SaveMeImpl(repository: repo)(
        SaveMeParam(me: me, originalMe: Me(id: '1', phone: '1')),
      );
      expect(result, isA<Success<Me?>>());
      expect(repo.lastCode, '');
    });

    test('salva com codeValidation quando o telefone muda', () async {
      final repo = _FakeMeRepo();
      final result = await SaveMeImpl(repository: repo)(
        SaveMeParam(
          me: Me(id: '1', phone: '2'),
          originalMe: Me(id: '1', phone: '1'),
          codeValidation: CodeValidation(id: 'cv1'),
        ),
      );
      expect(result, isA<Success<Me?>>());
      expect(repo.lastCode, 'cv1');
    });
  });
}
