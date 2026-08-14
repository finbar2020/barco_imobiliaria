import 'package:flutter_test/flutter_test.dart';

import 'package:lello/feature/account/domain/entity/account.dart';
import 'package:lello/feature/account/domain/repository/account_repository.dart';
import 'package:lello/feature/account/domain/use_case/list/list_accounts.dart';
import 'package:lello/feature/account/domain/use_case/list/list_accounts_impl.dart';
import 'package:mockito/mockito.dart';
import 'package:essentials/essentials.dart';
import '../../../../../matcher/is_and_matcher.dart';

void main() {
  AccountRepository repository;
  ListAccounts listAccounts;

  final _data = [Account()];
  final _param =
      ListAccountsParms(origin: DataOrigin.local, condominiumId: "123");

  setUp(() {
    repository = AccountRepositoryMock();
    listAccounts = ListAccountsImpl(repository: repository);
  });

  group('call', () {
    test('Should return invalid param failure if params is null', () async {
      final result = await listAccounts(null);
      expect(
          result,
          IsAnd<Rejection<List<Account>>>(
              (it) => it.get() is InvalidParamFailure));
    });

    test('Should return invalid data origin failure if data origin is null',
        () async {
      final result =
          await listAccounts(ListAccountsParms(condominiumId: "123"));
      expect(
          result,
          IsAnd<Rejection<List<Account>>>(
              (it) => it.get() is InvalidDataOriginFailure));
    });

    test('Should return invalid param failure if condominium origin is null',
        () async {
      final result =
          await listAccounts(ListAccountsParms(origin: DataOrigin.local));
      expect(
          result,
          IsAnd<Rejection<List<Account>>>(
              (it) => it.get() is InvalidParamFailure));
    });

    test('Should return invalid param failure if condominium origin is empty',
        () async {
      final result = await listAccounts(
          ListAccountsParms(origin: DataOrigin.local, condominiumId: ""));
      expect(
          result,
          IsAnd<Rejection<List<Account>>>(
              (it) => it.get() is InvalidParamFailure));
    });

    test('Should call repository list', () async {
      await listAccounts(_param);
      verify(repository.list(_param.origin, _param.condominiumId));
    });

    test('Should return success if repository succeeds', () async {
      when(repository.list(_param.origin, _param.condominiumId))
          .thenAnswer((_) async => Success(_data));
      final result = await listAccounts(_param);
      expect(result, IsAnd<Success<List<Account>>>((it) => it.get() == _data));
    });

    test('Should return success if repository succeeds', () async {
      final condoId = "123";
      when(repository.list(_param.origin, _param.condominiumId))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      final result = await listAccounts(_param);
      expect(result, isA<Rejection<List<Account>>>());
    });
  });
}

class AccountRepositoryMock extends Mock implements AccountRepository {}
