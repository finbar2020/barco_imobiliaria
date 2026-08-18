import 'package:colaborador/feature/me/domain/entity/me.dart';
import 'package:colaborador/feature/me/domain/repository/me_repository.dart';
import 'package:colaborador/feature/me/domain/use_case/get_me/get_me_impl.dart';
import 'package:colaborador/feature/me/domain/use_case/update_password_me/update_password_me.dart';
import 'package:colaborador/feature/me/domain/use_case/update_password_me/update_password_me_impl.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fixtures.dart';

class _FakeMeRepo extends Fake implements MeRepository {
  Object? lastOrigin;

  @override
  Future<Try<Me?>> select() async {
    lastOrigin = 'remote';
    return Success(Me(id: '1', name: 'ana silva'));
  }

  @override
  Future<Try<Me?>> selectFromCache() async {
    lastOrigin = 'local';
    return Success(Me(id: '1', name: 'cache'));
  }

  @override
  Future<Try<Me?>> updatePassword(
      String cpf, String originPassword, String password) async {
    lastOrigin = cpf;
    return Success(Me(id: '1', cpf: cpf));
  }
}

void main() {
  group('GetMeImpl', () {
    test('busca remoto', () async {
      final repo = _FakeMeRepo();
      final result = await GetMeImpl(repository: repo)(DataOrigin.remote);
      expect(result, isA<Success<Me?>>());
      expect(repo.lastOrigin, 'remote');
    });

    test('busca cache', () async {
      final repo = _FakeMeRepo();
      final result = await GetMeImpl(repository: repo)(DataOrigin.local);
      expect(result, isA<Success<Me?>>());
      expect(repo.lastOrigin, 'local');
    });
  });

  group('UpdatePasswordMeImpl', () {
    test('rejeita senha vazia', () async {
      final result = await UpdatePasswordMeImpl(repository: _FakeMeRepo())(
        UpdatePasswordMeParam(
          cpf: '123',
          originPassword: 'old',
          password: '',
        ),
      );
      expect(result, isA<Rejection>());
    });

    test('rejeita senha de origem vazia', () async {
      final result = await UpdatePasswordMeImpl(repository: _FakeMeRepo())(
        UpdatePasswordMeParam(
          cpf: '123',
          originPassword: '',
          password: 'new',
        ),
      );
      expect(result, isA<Rejection>());
    });

    test('atualiza senha', () async {
      final repo = _FakeMeRepo();
      final result = await UpdatePasswordMeImpl(repository: repo)(
        UpdatePasswordMeParam(
          cpf: '123',
          originPassword: 'old',
          password: 'new',
        ),
      );
      expect(result, isA<Success>());
      expect(repo.lastOrigin, '123');
    });
  });

  group('Me', () {
    test('firstNameFormatted capitaliza', () {
      expect(Me(name: 'ana silva').firstNameFormatted, 'Ana');
    });

    test('clone copia campos', () {
      final me = Me(id: '1', name: 'Ana', email: 'a@b.com');
      final clone = Me.clone(me);
      expect(clone.id, '1');
      expect(clone.name, 'Ana');
      expect(clone.email, 'a@b.com');
    });

    test('compareStr lista alterações', () {
      final original = Me(name: 'Ana', email: 'a@b.com', phone: '1');
      final edited = Me(name: 'Ana', email: 'c@d.com', phone: '2');
      expect(edited.compareStr(original), contains('email'));
      expect(edited.compareStr(original), contains('telefone'));
    });

    test('setPictureLink monta o path', () {
      final me = Me(pictureHash: 'abc');
      me.setPictureLink();
      expect(me.pictureLink, '/me/pictures/file/abc');
    });

    test('firstNameFormatted com nome vazio', () {
      expect(Me(name: '').firstNameFormatted, '');
      expect(Me(name: '   ').firstNameFormatted, '');
    });

    test('compareStr sem alterações retorna vazio', () {
      final me = Me(name: 'Ana', email: 'a@b.com', phone: '1');
      expect(me.compareStr(me), isEmpty);
    });

    test('nameFormatted capitaliza todas as palavras', () {
      expect(Me(name: 'ANA SILVA').nameFormatted, 'Ana Silva');
    });

    test('hasToUpdate após mais de um minuto', () {
      final me = Me(
        lastUpdatedAt: DateTime.now().subtract(const Duration(minutes: 2)),
      );
      expect(me.hasToUpdate, isTrue);
    });

    test('hasToUpdate false sem lastUpdatedAt', () {
      expect(Me().hasToUpdate, isFalse);
    });

    test('isValid exige condomínios', () {
      expect(Me().isValid, isFalse);
      expect(Me(condominiums: [testCondominium()]).isValid, isTrue);
    });
  });
}
