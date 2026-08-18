import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/me/domain/entity/me.dart';
import 'package:lello/feature/me/domain/repository/me_repository.dart';
import 'package:lello/feature/me/domain/use_case/get_me/get_me_impl.dart';
import 'package:lello/feature/me/domain/use_case/save_me/save_me.dart';
import 'package:lello/feature/me/domain/use_case/save_me/save_me_failure.dart';
import 'package:lello/feature/me/domain/use_case/save_me/save_me_impl.dart';
import 'package:lello/feature/me/domain/use_case/update_password_me/update_password_me.dart';
import 'package:lello/feature/me/domain/use_case/update_password_me/update_password_me_impl.dart';
import 'package:shared_features/shared_features.dart';

class _FakeMeRepo extends Fake implements MeRepository {
  Object? last;
  final Me stored = Me(id: '1', name: 'Ana', phone: '11');

  @override
  Future<Try<Me?>> select() async {
    last = 'remote';
    return Success(stored);
  }

  @override
  Future<Try<Me?>> selectFromCache() async {
    last = 'local';
    return Success(stored);
  }

  @override
  Future<Try<Me?>> save(Me? me, String code) async {
    last = code;
    return Success(me);
  }

  @override
  Future<Try<Me?>> updatePassword(
      String cpf, String originPassword, String password) async {
    last = cpf;
    return Success(stored);
  }
}

void main() {
  late _FakeMeRepo repo;

  setUp(() => repo = _FakeMeRepo());

  group('GetMeImpl', () {
    test('usa cache local e rede remota', () async {
      final local = await GetMeImpl(repository: repo)(DataOrigin.local);
      expect(local, isA<Success<Me?>>());
      expect(repo.last, 'local');

      final remote = await GetMeImpl(repository: repo)(DataOrigin.remote);
      expect(remote, isA<Success<Me?>>());
      expect(repo.last, 'remote');
    });
  });

  group('SaveMeImpl', () {
    test('rejeita me nulo', () async {
      final result = await SaveMeImpl(repository: repo)(SaveMeParam());
      expect(result, isA<Rejection<Me?>>());
    });

    test('exige código quando o telefone muda', () async {
      final result = await SaveMeImpl(repository: repo)(
        SaveMeParam(
          me: Me(phone: '22'),
          originalMe: Me(phone: '11'),
        ),
      );
      expect(
        (result as Rejection<Me?>).get(),
        isA<SaveMeInvalidCodeValidationFailure>(),
      );
    });

    test('salva quando o telefone muda com código', () async {
      final result = await SaveMeImpl(repository: repo)(
        SaveMeParam(
          me: Me(phone: '22'),
          originalMe: Me(phone: '11'),
          codeValidation: CodeValidation(id: 'cv-1', code: '1234'),
        ),
      );
      expect(result, isA<Success<Me?>>());
      expect(repo.last, 'cv-1');
    });
  });

  group('UpdatePasswordMeImpl', () {
    test('rejeita campos vazios', () async {
      final result = await UpdatePasswordMeImpl(repository: repo)(
        UpdatePasswordMeParam(cpf: '', originPassword: 'a', password: 'b'),
      );
      expect(result, isA<Rejection<Me?>>());
    });

    test('atualiza senha válida', () async {
      final result = await UpdatePasswordMeImpl(repository: repo)(
        UpdatePasswordMeParam(
          cpf: '123',
          originPassword: 'old',
          password: 'new',
        ),
      );
      expect(result, isA<Success<Me?>>());
      expect(repo.last, '123');
    });
  });

  test('Me.clone copia os campos', () {
    final original = Me(id: '1', name: 'Ana', phone: '11');
    final cloned = Me.clone(original);
    expect(cloned.id, '1');
    expect(cloned.name, 'Ana');
  });
}
