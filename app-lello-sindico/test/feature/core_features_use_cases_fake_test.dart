import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/dashboard/domain/entity/pendency.dart';
import 'package:lello/feature/dashboard/domain/repository/pendency_repository.dart';
import 'package:lello/feature/dashboard/domain/use_case/list_pendency/list_pendency.dart';
import 'package:lello/feature/dashboard/domain/use_case/list_pendency/list_pendency_failure.dart';
import 'package:lello/feature/dashboard/domain/use_case/list_pendency/list_pendency_impl.dart';
import 'package:lello/feature/income/data/repository/billets_repository.dart';
import 'package:lello/feature/income/domain/entity/billet_filter_parameters.dart';
import 'package:lello/feature/income/domain/entity/income.dart';
import 'package:lello/feature/income/domain/repository/income_repository.dart';
import 'package:lello/feature/income/domain/use_case/get_monthly_income/get_income.dart';
import 'package:lello/feature/income/domain/use_case/get_monthly_income/get_monthly_income_impl.dart';
import 'package:lello/feature/income/domain/use_case/get_units_by_billets/get_units_by_billets.dart';
import 'package:lello/feature/income/domain/use_case/get_units_by_billets/get_units_by_billets_impl.dart';
import 'package:lello/feature/payroll/domain/entity/payroll.dart';
import 'package:lello/feature/payroll/domain/repository/payroll_repository.dart';
import 'package:lello/feature/payroll/domain/use_case/get_payroll/get_payroll.dart';
import 'package:lello/feature/payroll/domain/use_case/get_payroll/get_payroll_impl.dart';
import 'package:lello/feature/payroll/domain/use_case/list_payroll/list_payroll.dart';
import 'package:lello/feature/payroll/domain/use_case/list_payroll/list_payroll_impl.dart';
import 'package:lello/feature/resident/domain/entity/resident.dart';
import 'package:lello/feature/resident/domain/repository/resident_repository.dart';
import 'package:lello/feature/resident/domain/use_case/list_residents.dart';
import 'package:lello/feature/resident/domain/use_case/list_residents_impl.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';

class _FakeResidentRepo extends Fake implements ResidentRepository {
  Object? last;

  @override
  Future<Try<List<Resident>>> list(DataOrigin origin, String condominiumId,
      {String? lastResidentId, String? query, bool loadAll = false}) async {
    last = condominiumId;
    return Success([Resident(id: 'r1', name: 'Maria')]);
  }
}

class _FakeIncomeRepo extends Fake implements IncomeRepository {
  @override
  Future<Try<Income?>> select(
      DataOrigin origin, String condominiumId, DateTime period) async {
    return Success(Income(value: 100, period: period));
  }
}

class _FakeBilletsRepo extends Fake implements BilletsRepository {
  @override
  Future<Try<List<Unit>>> getUnitsByBillets(
      String condominiumId, BilletFilter filter) async {
    return Success([Unit(id: 'u1', title: '101')]);
  }
}

class _FakePayrollRepo extends Fake implements PayrollRepository {
  Object? last;

  @override
  Future<Try<List<Payroll>>> list(String condominiumId) async {
    last = condominiumId;
    return Success([Payroll()..value = 10]);
  }

  @override
  Future<Try<Payroll>> select(String condominiumId, DateTime period) async {
    last = period;
    return Success(Payroll()..period = period);
  }
}

class _FakePendencyRepo extends Fake implements PendencyRepository {
  Object? last;

  @override
  Future<Try<List<Pendency>>> selectCache(String condominiumId) async {
    last = 'cache';
    return Success([Pendency(id: 'p1')]);
  }

  @override
  Future<Try<List<Pendency>>> selectPagination(String condominiumId,
      {int? currentSize}) async {
    last = currentSize;
    return Success([Pendency(id: 'p2')]);
  }
}

void main() {
  group('ListResidentsImpl', () {
    test('rejeita condomínio vazio', () async {
      final result = await ListResidentsImpl(repository: _FakeResidentRepo())(
        ListResidentsParam(condominiumId: '', origin: DataOrigin.remote),
      );
      expect(result, isA<Rejection<List<Resident>>>());
    });

    test('lista moradores', () async {
      final repo = _FakeResidentRepo();
      final result = await ListResidentsImpl(repository: repo)(
        ListResidentsParam(condominiumId: 'c1', origin: DataOrigin.remote),
      );
      expect(result, isA<Success<List<Resident>>>());
      expect(repo.last, 'c1');
    });
  });

  group('GetIncomeImpl', () {
    test('rejeita condomínio vazio', () async {
      final result = await GetIncomeImpl(repository: _FakeIncomeRepo())(
        GetIncomeParam(
          condominiumId: '',
          origin: DataOrigin.remote,
          period: DateTime(2026, 1),
        ),
      );
      expect(result, isA<Rejection<Income?>>());
    });

    test('busca a arrecadação', () async {
      final result = await GetIncomeImpl(repository: _FakeIncomeRepo())(
        GetIncomeParam(
          condominiumId: 'c1',
          origin: DataOrigin.remote,
          period: DateTime(2026, 1),
        ),
      );
      expect(result, isA<Success<Income?>>());
    });
  });

  group('GetUnitsByBilletsUseCaseImpl', () {
    test('rejeita condomínio vazio', () async {
      final result = await GetUnitsByBilletsUseCaseImpl(
        repository: _FakeBilletsRepo(),
      )(GetUnitsByBilletsParam(condominiumId: '', filter: BilletFilter()));
      expect(result, isA<Rejection<List<Unit>>>());
    });

    test('lista unidades', () async {
      final result = await GetUnitsByBilletsUseCaseImpl(
        repository: _FakeBilletsRepo(),
      )(GetUnitsByBilletsParam(condominiumId: 'c1', filter: BilletFilter()));
      expect(result, isA<Success<List<Unit>>>());
    });
  });

  group('Payroll', () {
    late _FakePayrollRepo repo;

    setUp(() => repo = _FakePayrollRepo());

    test('ListPayrollImpl rejeita condomínio vazio', () async {
      final result = await ListPayrollImpl(repository: repo)(
        ListPayrollParam(condominiumId: ''),
      );
      expect(result, isA<Rejection<List<Payroll>>>());
    });

    test('ListPayrollImpl lista a folha', () async {
      final result = await ListPayrollImpl(repository: repo)(
        ListPayrollParam(condominiumId: 'c1'),
      );
      expect(result, isA<Success<List<Payroll>>>());
    });

    test('GetPayrollImpl encaminha o período', () async {
      final period = DateTime(2026, 2);
      final result = await GetPayrollImpl(repository: repo)(
        GetPayrollParam(condominiumId: 'c1', period: period),
      );
      expect(result, isA<Success<Payroll>>());
      expect(repo.last, period);
    });
  });

  group('ListPendencyImpl', () {
    late _FakePendencyRepo repo;

    setUp(() => repo = _FakePendencyRepo());

    test('usa cache local', () async {
      final result = await ListPendencyImpl(repository: repo)(
        ListPendencyParam('ref', dataOrigin: DataOrigin.local),
      );
      expect(result, isA<Success<List<Pendency>>>());
      expect(repo.last, 'cache');
    });

    test('usa paginação remota', () async {
      final result = await ListPendencyImpl(repository: repo)(
        ListPendencyParam('ref', currentSize: 10),
      );
      expect(result, isA<Success<List<Pendency>>>());
      expect(repo.last, 10);
    });

    test('validate rejeita referência vazia', () {
      final error = ListPendencyImpl(repository: repo).validate(
        ListPendencyParam(''),
      );
      expect(error, isA<InvalidListPendencyCondominiumFailure>());
    });
  });
}
