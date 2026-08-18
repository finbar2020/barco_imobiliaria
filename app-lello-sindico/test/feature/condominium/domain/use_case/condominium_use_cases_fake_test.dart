import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_balance.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_balance_detail.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_simple.dart';
import 'package:lello/feature/condominium/domain/repository/condominium_balance_detail_repository.dart';
import 'package:lello/feature/condominium/domain/repository/condominium_balance_repository.dart';
import 'package:lello/feature/condominium/domain/repository/condominium_simple_repository.dart';
import 'package:lello/feature/condominium/domain/use_case/get_simple_condominium/get_simple_condominium.dart';
import 'package:lello/feature/condominium/domain/use_case/get_simple_condominium/get_simple_condominium_impl.dart';
import 'package:lello/feature/condominium/domain/use_case/load_condominium_balance/load_condominium_balance.dart';
import 'package:lello/feature/condominium/domain/use_case/load_condominium_balance/load_condominium_balance_impl.dart';
import 'package:lello/feature/condominium/domain/use_case/load_condominium_balance_detail/load_condominium_balance_detail.dart';
import 'package:lello/feature/condominium/domain/use_case/load_condominium_balance_detail/load_condominium_balance_detail_impl.dart';

class _FakeBalanceRepo extends Fake implements CondominiumBalanceRepository {
  Object? last;

  @override
  Future<Try<CondominiumBalance?>> select(CondominiumBalanceParam params) async {
    last = 'remote';
    return Success(CondominiumBalance(id: params.id, balance: 10));
  }

  @override
  Future<Try<CondominiumBalance?>> selectFromCache(
      CondominiumBalanceParam params) async {
    last = 'local';
    return Success(CondominiumBalance(id: params.id, balance: 1));
  }
}

class _FakeDetailRepo extends Fake
    implements CondominiumBalanceDetailRepository {
  Object? last;

  @override
  Future<Try<CondominiumBalanceDetail>> select(
      LoadCondominiumBalanceDetailParam params) async {
    last = 'remote';
    return Success(CondominiumBalanceDetail()..balance = 20);
  }

  @override
  Future<Try<CondominiumBalanceDetail?>> selectFromCache(
      LoadCondominiumBalanceDetailParam params) async {
    last = 'local';
    return Success(CondominiumBalanceDetail()..balance = 2);
  }
}

class _FakeSimpleRepo extends Fake implements CondominiumSimpleRepository {
  @override
  Future<Try<CondominiumSimple>> getSimpleCondominium({
    required GetSimpleCondominiumParams params,
  }) async {
    return Success(CondominiumSimple(
      id: params.id,
      name: 'Edifício',
      reference: 'ref',
      blocks: const [],
    ));
  }
}

void main() {
  group('LoadCondominiumBalanceImpl', () {
    late _FakeBalanceRepo repo;

    setUp(() => repo = _FakeBalanceRepo());

    test('usa cache quando origin é local', () async {
      final result = await LoadCondominiumBalanceImpl(repository: repo)(
        CondominiumBalanceParam(
          id: 'c1',
          reference: 'ref',
          origin: DataOrigin.local,
        ),
      );
      expect(result, isA<Success<CondominiumBalance?>>());
      expect(repo.last, 'local');
    });

    test('usa rede quando origin é remote', () async {
      final result = await LoadCondominiumBalanceImpl(repository: repo)(
        CondominiumBalanceParam(
          id: 'c1',
          reference: 'ref',
          origin: DataOrigin.remote,
        ),
      );
      expect(result, isA<Success<CondominiumBalance?>>());
      expect(repo.last, 'remote');
    });
  });

  group('LoadCondominiumBalanceDetailImpl', () {
    late _FakeDetailRepo repo;

    setUp(() => repo = _FakeDetailRepo());

    test('rejeita condomínio vazio', () async {
      final result = await LoadCondominiumBalanceDetailImpl(repository: repo)(
        LoadCondominiumBalanceDetailParam(
          condominiumId: '',
          reference: 'ref',
          origin: DataOrigin.remote,
        ),
      );
      expect(result, isA<Rejection<CondominiumBalanceDetail?>>());
    });

    test('usa cache local e rede remota', () async {
      final local = await LoadCondominiumBalanceDetailImpl(repository: repo)(
        LoadCondominiumBalanceDetailParam(
          condominiumId: 'c1',
          reference: 'ref',
          origin: DataOrigin.local,
        ),
      );
      expect(local, isA<Success<CondominiumBalanceDetail?>>());
      expect(repo.last, 'local');

      final remote = await LoadCondominiumBalanceDetailImpl(repository: repo)(
        LoadCondominiumBalanceDetailParam(
          condominiumId: 'c1',
          reference: 'ref',
          origin: DataOrigin.remote,
        ),
      );
      expect(remote, isA<Success<CondominiumBalanceDetail?>>());
      expect(repo.last, 'remote');
    });
  });

  test('GetSimpleCondominiumUsecaseImpl encaminha o id', () async {
    final result = await GetSimpleCondominiumUsecaseImpl(
      repository: _FakeSimpleRepo(),
    )(GetSimpleCondominiumParams(id: 'c1'));
    expect(result, isA<Success<CondominiumSimple?>>());
    expect(
      (result as Success<CondominiumSimple?>).get()?.copyWith(name: 'Novo').name,
      'Novo',
    );
  });
}
