import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/account/domain/entity/account.dart';
import 'package:lello/feature/account/domain/repository/account_repository.dart';
import 'package:lello/feature/account/domain/use_case/list/list_accounts.dart';
import 'package:lello/feature/account/domain/use_case/list/list_accounts_impl.dart';
import 'package:lello/feature/consultant_lello/domain/entity/consultant_lello.dart';
import 'package:lello/feature/consultant_lello/domain/repository/consultant_lello_repository.dart';
import 'package:lello/feature/consultant_lello/domain/use_case/list/consultant_lello_use_case.dart';
import 'package:lello/feature/consultant_lello/domain/use_case/list/consultant_lello_use_case_impl.dart';

class _FakeConsultantRepo extends Fake implements ConsultantRepository {
  @override
  Future<Try<ConsultantEntity>> consultant(String condominiumId) async {
    return Success(ConsultantEntity()..number = '0800');
  }
}

class _FakeAccountRepo extends Fake implements AccountRepository {
  @override
  Future<Try<List<Account>>> list(
      DataOrigin origin, String condominiumId) async {
    return Success([Account()..id = 'acc1'..name = 'Conta corrente']);
  }
}

void main() {
  test('ConsultantUseCaseImpl rejeita condomínio vazio', () async {
    final repo = _FakeConsultantRepo();
    expect(
      await ConsultantUseCaseImpl(repository: repo)(
        ConsultantParms(condominiumId: ''),
      ),
      isA<Rejection<ConsultantEntity>>(),
    );
    final result = await ConsultantUseCaseImpl(repository: repo)(
      ConsultantParms(condominiumId: 'c1'),
    );
    expect(result, isA<Success<ConsultantEntity>>());
    expect((result as Success<ConsultantEntity>).get().number, '0800');
  });

  test('ListAccountsImpl lista contas do condomínio', () async {
    final repo = _FakeAccountRepo();
    expect(
      await ListAccountsImpl(repository: repo)(
        ListAccountsParms(origin: DataOrigin.remote, condominiumId: ''),
      ),
      isA<Rejection<List<Account>>>(),
    );
    expect(
      await ListAccountsImpl(repository: repo)(
        ListAccountsParms(origin: DataOrigin.remote, condominiumId: 'c1'),
      ),
      isA<Success<List<Account>>>(),
    );
  });
}
