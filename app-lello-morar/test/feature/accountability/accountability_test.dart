import 'dart:convert';

import 'package:chopper/chopper.dart' show Response;
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:morar/feature/accountability/data/data_source/accountability_api.dart';
import 'package:morar/feature/accountability/data/data_source/accountability_remote_data_source.dart';
import 'package:morar/feature/accountability/data/data_source/accountability_remote_data_source_impl.dart';
import 'package:morar/feature/accountability/data/model/account_model.dart';
import 'package:morar/feature/accountability/data/model/account_monthly_finance_model.dart';
import 'package:morar/feature/accountability/data/model/account_monthly_summary_model.dart';
import 'package:morar/feature/accountability/data/model/accountability_approval_model.dart';
import 'package:morar/feature/accountability/data/model/accountability_model.dart';
import 'package:morar/feature/accountability/data/model/accountability_period_model.dart';
import 'package:morar/feature/accountability/data/model/acountability_grouped_model.dart';
import 'package:morar/feature/accountability/data/repository/accountability_repository_impl.dart';
import 'package:morar/feature/accountability/domain/entity/account.dart';
import 'package:morar/feature/accountability/domain/entity/account_monthly_finance.dart';
import 'package:morar/feature/accountability/domain/entity/account_monthly_summary.dart';
import 'package:morar/feature/accountability/domain/entity/accountability.dart';
import 'package:morar/feature/accountability/domain/entity/accountability_approval.dart';
import 'package:morar/feature/accountability/domain/entity/accountability_grouped.dart';
import 'package:morar/feature/accountability/domain/entity/accountability_grouped_account.dart';
import 'package:morar/feature/accountability/domain/entity/accountability_grouped_account_entrie.dart';
import 'package:morar/feature/accountability/domain/entity/accountability_periods.dart';
import 'package:morar/feature/accountability/domain/repository/accountability_repository.dart';
import 'package:morar/feature/accountability/domain/use_case/get_accountability/get_accountability.dart';
import 'package:morar/feature/accountability/domain/use_case/get_accountability/get_accountability_impl.dart';
import 'package:morar/feature/accountability/domain/use_case/get_periods/get_accountability_period.dart';
import 'package:morar/feature/accountability/domain/use_case/get_periods/get_accountability_periods_impl.dart';
import 'package:morar/feature/accountability/presentation/bloc/accountabiity_bloc.dart';
import 'package:morar/feature/accountability/presentation/bloc/accountabiity_event.dart';
import 'package:morar/feature/accountability/presentation/bloc/accountabiity_state.dart';
import 'package:morar/feature/accountability/presentation/controllers/accountability_controller.dart';
import 'package:morar/feature/me/domain/entity/condominium.dart';

import '../../helpers/firebase_mocks.dart';
import '../../helpers/fixtures.dart';

class MockApi extends Mock implements AccountabilityApi {}

AccountabilityGroupedAccountEntrie _entrie({
  double credit = 0,
  double debit = 0,
}) =>
    AccountabilityGroupedAccountEntrie(
      id: 1,
      date: DateTime(2026, 1, 5),
      value: credit - debit,
      signal: credit > 0 ? '+' : '-',
      credit: credit,
      debit: debit,
      history: 'h',
    );

Accountability _accountability() => Accountability(
      condominiumId: 'c1',
      period: DateTime(2026, 1),
      initialBalance: 10,
      totalIncome: 20,
      totalExpenses: 5,
      balance: 25,
      accounts: [
        AccountMonthlyFinance()
          ..account = (Account()
            ..id = 'a'
            ..name = 'Conta'
            ..condominiumId = 'c1')
          ..income = 1
          ..expenses = 2
          ..initialBalance = 3
          ..balance = 4,
        null,
      ],
      summary: [
        AccountMonthlySummary()
          ..name = 's'
          ..debits = 1
          ..credits = 2,
        null,
      ],
      groupedEntries: [
        AccountabilityGrouped(
          type: 'T',
          description: 'd',
          id: 1,
          debits: 1,
          credits: 2,
          accounts: [
            AccountabilityGroupedAccount(
              account: 7,
              description: 'x',
              entries: [_entrie(credit: 10), _entrie(debit: 4)],
            ),
          ],
        ),
      ],
    );

class _FakeDataSource extends Fake implements AccountabilityRemoteDataSource {
  _FakeDataSource({this.fail = false});
  final bool fail;

  @override
  Future<List<AccountabilityPeriodModel>> getPeriod(String condominiumId) async {
    if (fail) throw Exception('x');
    return [AccountabilityPeriodModel()..period = DateTime(2026, 2)];
  }

  @override
  Future<AccountabilityModel> select(String condominiumId, DateTime period) async {
    if (fail) throw Exception('x');
    return AccountabilityModel(condominiumId: condominiumId, period: period);
  }
}

class _FakeRepository extends Fake implements AccountabilityRepository {
  final calls = <Object?>[];

  @override
  Future<Try<Accountability>> select(String condominiumId, DateTime period) async {
    calls.add([condominiumId, period]);
    return Success(Accountability(condominiumId: condominiumId));
  }

  @override
  Future<Try<List<AccountabilityPeriods>>> getPeriod(String condominiumId) async {
    calls.add(condominiumId);
    return Success([AccountabilityPeriods()..period = DateTime(2026, 3)]);
  }
}

class _FakeGet extends Fake implements GetAccountability {
  _FakeGet({this.fail = false, this.throws = false});
  final bool fail;
  final bool throws;
  GetAccountabilityParam? param;

  @override
  Future<Try<Accountability>> call(GetAccountabilityParam p) async {
    param = p;
    if (throws) throw StateError('boom');
    if (fail) return Rejection(UnknownFailure('x'));
    return Success(_accountability());
  }
}

class _FakePeriods extends Fake implements GetAccountabilityPeriod {
  _FakePeriods({this.fail = false, this.empty = false});
  final bool fail;
  final bool empty;

  @override
  Future<Try<List<AccountabilityPeriods>>> call(String id) async {
    if (fail) return Rejection(UnknownFailure('x'));
    if (empty) return Success(const []);
    return Success([
      AccountabilityPeriods()..period = DateTime(2026, 1),
      AccountabilityPeriods()..period = DateTime(2025, 12),
    ]);
  }
}

Future<List<dynamic>> _collect(
    AccountabilityBloc bloc, Future<void> Function() run) async {
  final states = <dynamic>[];
  final sub = bloc.stream.listen(states.add);
  await run();
  await Future<void>.delayed(Duration.zero);
  await sub.cancel();
  return states;
}

void main() {
  setUpAll(() async {
    await setUpFakeFirebase();
  });

  group('entities', () {
    test('AccountabilityGroupedAccount totais', () {
      final account = AccountabilityGroupedAccount(
        account: 1,
        description: 'd',
        entries: [_entrie(credit: 10), _entrie(debit: 4)],
      );
      expect(account.getTotalCredit, 10);
      expect(account.getTotalDebit, 4);
      expect(account.getTotal, 6);
      expect(account.creditOnly, isFalse);
      expect(
        AccountabilityGroupedAccount(
          account: 1,
          description: 'd',
          entries: [_entrie(credit: 1)],
        ).creditOnly,
        isTrue,
      );
      expect(_entrie().dateFormatted, '05/01/2026');
    });

    test('AccountabilityPeriods.periodo', () {
      expect((AccountabilityPeriods()..period = DateTime(2026, 1)).periodo,
          'January - 2026');
      final now = DateTime.now();
      expect(AccountabilityPeriods().periodo, endsWith('- ${now.year}'));
    });

    test('toString das entidades', () {
      expect(_accountability().toString(), contains('condominiumId: c1'));
      expect(AccountMonthlyFinance().toString(), contains('income: null'));
      expect(AccountMonthlySummary().toString(), contains('debits: null'));
    });
  });

  group('models', () {
    test('AccountabilityModel round trip', () {
      final model = AccountabilityModel.fromEntity(_accountability())!;
      final json = jsonDecode(jsonEncode(model.toJson())) as Map<String, dynamic>;
      expect(json['condominium_id'], 'c1');
      expect(json['grouped_entries'], hasLength(1));
      final entity = AccountabilityModel.fromJson(json).toEntity();
      expect(entity.balance, 25);
      expect(entity.accounts.first!.account!.name, 'Conta');
      expect(entity.accounts[1], isNull);
      expect(entity.summary.first!.credits, 2);
      expect(entity.groupedEntries.single.accounts.single.entries, hasLength(2));
      expect(entity.groupedEntries.single.accounts.single.entries.first.credit, 10);
      expect(AccountabilityModel.fromEntity(null), isNull);
    });

    test('modelos auxiliares', () {
      expect(AccountModel.fromEntity(null), isNull);
      expect(AccountMonthlyFinanceModel.fromEntity(null), isNull);
      expect(AccountMonthlySummaryModel.fromEntity(null), isNull);
      expect(AccountabilityPeriodModel.fromEntity(null), isNull);
      expect(AccountabilityApprovalModel.fromEntity(null), isNull);

      final period = AccountabilityPeriodModel.fromJson({
        'period': '2026-02-01T00:00:00.000',
        'situation': 'ok',
        'approval_date': '2026-03-01T00:00:00.000',
      });
      final entity = period.toEntity();
      expect(entity.situation, 'ok');
      expect(AccountabilityPeriodModel.fromEntity(entity)!.toJson()['situation'],
          'ok');

      final approval = AccountabilityApprovalModel.fromEntity(
        AccountabilityApproval()
          ..id = 'ap'
          ..date = DateTime(2026)
          ..accountability = _accountability(),
      )!;
      final approvalBack = AccountabilityApprovalModel.fromJson(
              jsonDecode(jsonEncode(approval.toJson())))
          .toEntity();
      expect(approvalBack.id, 'ap');
      expect(approvalBack.accountability!.condominiumId, 'c1');

      final grouped = AccountabilityGroupedModel.fromJson(jsonDecode(jsonEncode(
          AccountabilityGroupedModel.fromEntity(
                  _accountability().groupedEntries.single)
              .toJson())));
      expect(grouped.toEntity().accounts.single.account, 7);
    });
  });

  group('use cases', () {
    test('GetAccountabilityImpl', () async {
      final repo = _FakeRepository();
      final useCase = GetAccountabilityImpl(repository: repo);
      final invalid = await useCase(
          GetAccountabilityParam(condominiumId: '', period: DateTime(2026)));
      expect(invalid.fold((f) => f, (_) => null), isA<InvalidParamFailure>());
      final ok = await useCase(
          GetAccountabilityParam(condominiumId: 'c', period: DateTime(2026)));
      expect(ok.fold((_) => null, (a) => a.condominiumId), 'c');
      expect(repo.calls.single, ['c', DateTime(2026)]);
    });

    test('GetAccountabilityPeriodImpl', () async {
      final repo = _FakeRepository();
      final useCase = GetAccountabilityPeriodImpl(repository: repo);
      final invalid = await useCase('');
      expect(invalid.fold((f) => f, (_) => null), isA<InvalidParamFailure>());
      final ok = await useCase('c');
      expect(ok.fold((_) => null, (l) => l.single.periodo), 'March - 2026');
    });
  });

  group('repository', () {
    test('sucesso', () async {
      final repo = AccountabilityRepositoryImpl(dataSource: _FakeDataSource());
      final sel = await repo.select('c', DateTime(2026, 4));
      expect(sel.fold((_) => null, (a) => a.period), DateTime(2026, 4));
      final periods = await repo.getPeriod('c');
      expect(periods.fold((_) => null, (l) => l.single.period), DateTime(2026, 2));
    });

    test('falha', () async {
      final repo =
          AccountabilityRepositoryImpl(dataSource: _FakeDataSource(fail: true));
      expect((await repo.select('c', DateTime(2026))).fold((f) => f, (_) => null),
          isA<UnknownFailure>());
      expect((await repo.getPeriod('c')).fold((f) => f, (_) => null),
          isA<UnknownFailure>());
    });
  });

  test('data source formata o período', () async {
    final api = MockApi();
    final ds = AccountabilityRemoteDataSourceImpl(api: api);
    when(() => api.get('c', '2026-03')).thenAnswer(
      (_) async => Response<dynamic>(
        http.Response(jsonEncode({'condominium_id': 'c'}), 200),
        null,
      ),
    );
    when(() => api.getPeriod('c')).thenAnswer(
      (_) async => Response<dynamic>(
        http.Response(jsonEncode([{'situation': 's'}]), 200),
        null,
      ),
    );
    expect((await ds.select('c', DateTime(2026, 3, 15))).condominiumId, 'c');
    expect((await ds.getPeriod('c')).single.situation, 's');
  });

  test('bloc', () async {
    final bloc = AccountabilityBloc();
    expect(bloc.state, const AccountabilityInitialState());
    final states = <dynamic>[];
    final sub = bloc.stream.listen(states.add);
    final acc = _accountability();
    bloc
      ..add(const AccountabilityLoadingEvent())
      ..add(const AccountabilityLoadedEvent(periodos: ['a']))
      ..add(AccountabilityPeriodsLoadedEvent(accountability: acc))
      ..add(AccountabilityFailureEvent(error: UnknownFailure('e')))
      ..add(const AccountabilityEmptyEvent());
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();
    await bloc.close();
    expect(states, [
      const AccountabilityLoadingState(),
      const AccountabilityLoadedState(periodos: ['a']),
      AccountabilityPeriodsLoadedState(accountability: acc),
      AccountabilityFailureState(error: UnknownFailure('e')),
      const AccountabilityInitialState(),
    ]);
    expect(const AccountabilityLoadedEvent(periodos: ['a']).props, [
      ['a']
    ]);
    expect(AccountabilityFailureEvent(error: UnknownFailure('e')).props,
        [UnknownFailure('e')]);
  });

  group('controller', () {
    late AccountabilityBloc bloc;
    setUp(() => bloc = AccountabilityBloc());
    tearDown(() => bloc.close());

    AccountabilityController build({
      _FakeGet? get,
      _FakePeriods? periods,
      FakeSessionBloc? session,
    }) =>
        AccountabilityController(
          bloc: bloc,
          getAccountability: get ?? _FakeGet(),
          getAccountabilityPeriod: periods ?? _FakePeriods(),
          sessionBloc: session ?? FakeSessionBloc(),
        );

    FakeSessionBloc semCondominio() => FakeSessionBloc(
          session: testSession(
            me: testMe(condominiums: [Condominium(blocks: [testBlock()])]),
          ),
        );

    test('getPeriods', () async {
      var states = await _collect(bloc, build().getPeriods);
      expect(states.last,
          const AccountabilityLoadedState(periodos: ['January - 2026', 'December - 2025']));

      states = await _collect(bloc, build(periods: _FakePeriods(empty: true)).getPeriods);
      expect(states.last, const AccountabilityInitialState());

      states = await _collect(bloc, build(periods: _FakePeriods(fail: true)).getPeriods);
      expect(states.last, isA<AccountabilityFailureState>());

      states = await _collect(bloc, build(session: semCondominio()).getPeriods);
      expect(states.last, const AccountabilityFailureState(error: null));
    });

    test('getAccountabilityController', () async {
      final get = _FakeGet();
      fakeAnalytics.reset();
      var states = await _collect(
          bloc, () => build(get: get).getAccountabilityController(DateTime(2026, 5)));
      expect(states.last, isA<AccountabilityPeriodsLoadedState>());
      expect(get.param!.condominiumId, 'c1');
      expect(get.param!.period, DateTime(2026, 5));
      expect(fakeAnalytics.eventNames, contains('ppc_acessar_mes_consultar'));

      states = await _collect(bloc,
          () => build(get: _FakeGet(fail: true)).getAccountabilityController(DateTime(2026)));
      expect(states.last, isA<AccountabilityFailureState>());

      states = await _collect(bloc,
          () => build(get: _FakeGet(throws: true)).getAccountabilityController(DateTime(2026)));
      expect(states.last, const AccountabilityFailureState(error: null));

      states = await _collect(bloc,
          () => build(session: semCondominio()).getAccountabilityController(DateTime(2026)));
      expect(states.last, const AccountabilityFailureState(error: null));
    });
  });
}
