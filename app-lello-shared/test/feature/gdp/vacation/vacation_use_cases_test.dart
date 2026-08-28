import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_created.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_locked_days.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_params.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_request.dart';
import 'package:shared_features/feature/gdp/vacation/domain/repository/vacation_repository.dart';
import 'package:shared_features/feature/gdp/vacation/domain/use_case/get_vacation/get_vacation.dart';
import 'package:shared_features/feature/gdp/vacation/domain/use_case/get_vacation/get_vacation_impl.dart';
import 'package:shared_features/feature/gdp/vacation/domain/use_case/get_vacation_locked_days/get_vacation_locked_days.dart';
import 'package:shared_features/feature/gdp/vacation/domain/use_case/get_vacation_locked_days/get_vacation_locked_days_impl.dart';
import 'package:shared_features/feature/gdp/vacation/domain/use_case/get_vacation_period/get_vacation_period.dart';
import 'package:shared_features/feature/gdp/vacation/domain/use_case/get_vacation_period/get_vacation_period_impl.dart';
import 'package:shared_features/feature/gdp/vacation/domain/use_case/schedule_vacation/schedule_vacation.dart';
import 'package:shared_features/feature/gdp/vacation/domain/use_case/schedule_vacation/schedule_vacation_impl.dart';

/// Repositório falso que registra as chamadas recebidas.
class _RecordingRepository extends Fake implements VacationRepository {
  final calls = <String, List<Object?>>{};
  final vacation = Vacation(employeeId: 'E1');
  final params = VacationParams(periods: [], qtdInitDays: 1);
  final locked = VacationLockedDays();
  final created = VacationCreated(employeeId: 'E1');

  @override
  Future<Try<Vacation>> getVacation(String condominiumId, String employeeId) async {
    calls['getVacation'] = [condominiumId, employeeId];
    return Success(vacation);
  }

  @override
  Future<Try<VacationParams>> getVacationPeriod(
      String condominiumId, String employeeId) async {
    calls['getVacationPeriod'] = [condominiumId, employeeId];
    return Success(params);
  }

  @override
  Future<Try<VacationLockedDays>> getLockedDays(String condominiumId,
      String employeeId, DateTime startDate, DateTime endDate) async {
    calls['getLockedDays'] = [condominiumId, employeeId, startDate, endDate];
    return Success(locked);
  }

  @override
  Future<Try<Vacation>> scheduleVacation(VacationRequest request) async {
    calls['scheduleVacation'] = [request];
    return Success(vacation);
  }

  @override
  Future<Try<VacationCreated>> createVacation(
      {required String condominiumId,
      required String employeeId,
      required VacationCreated vacationCreated}) async {
    calls['createVacation'] = [condominiumId, employeeId, vacationCreated];
    return Success(created);
  }
}

void main() {
  late _RecordingRepository repo;

  setUp(() => repo = _RecordingRepository());

  group('GetVacationImpl', () {
    test('delega ao repositório quando os parâmetros são válidos', () async {
      final result = await GetVacationImpl(repository: repo)
          .call(GetVacationParam(condominiumId: 'C1', employeeId: 'E1'));
      expect(result, isA<Success<Vacation>>());
      expect(result.getOrElse(() => Vacation()), same(repo.vacation));
      expect(repo.calls['getVacation'], ['C1', 'E1']);
    });

    test('rejeita condomínio ou funcionário vazio', () async {
      final useCase = GetVacationImpl(repository: repo);
      final semCond = await useCase
          .call(GetVacationParam(condominiumId: '', employeeId: 'E1'));
      final semFunc = await useCase
          .call(GetVacationParam(condominiumId: 'C1', employeeId: ''));
      expect(semCond, isA<Rejection<Vacation>>());
      expect(semFunc, isA<Rejection<Vacation>>());
      expect((semCond as Rejection).get(), isA<InvalidParamFailure>());
      expect(useCase.validate(null), isA<InvalidParamFailure>());
      expect(repo.calls, isEmpty);
    });
  });

  group('GetVacationPeriodImpl', () {
    test('delega ao repositório', () async {
      final result = await GetVacationPeriodImpl(repository: repo).call(
          GetVacationPeriodParam(condominiumId: 'C1', employeeId: 'E1'));
      expect(result, isA<Success<VacationParams>>());
      expect(repo.calls['getVacationPeriod'], ['C1', 'E1']);
    });

    test('rejeita parâmetros vazios', () async {
      final useCase = GetVacationPeriodImpl(repository: repo);
      expect(
          await useCase.call(
              GetVacationPeriodParam(condominiumId: '', employeeId: 'E1')),
          isA<Rejection<VacationParams>>());
      expect(
          await useCase.call(
              GetVacationPeriodParam(condominiumId: 'C1', employeeId: '')),
          isA<Rejection<VacationParams>>());
      expect(repo.calls, isEmpty);
    });
  });

  group('GetLockedDaysImpl', () {
    final inicio = DateTime(2030, 1, 1);
    final fim = DateTime(2030, 12, 31);

    test('delega ao repositório com as datas', () async {
      final result = await GetLockedDaysImpl(repository: repo).call(
          GetLockedDaysParam(
              condominiumId: 'C1',
              employeeId: 'E1',
              startDate: inicio,
              endDate: fim));
      expect(result, isA<Success<VacationLockedDays>>());
      expect(repo.calls['getLockedDays'], ['C1', 'E1', inicio, fim]);
    });

    test('rejeita condomínio, funcionário ou datas ausentes', () async {
      final useCase = GetLockedDaysImpl(repository: repo);
      final casos = [
        GetLockedDaysParam(
            condominiumId: '', employeeId: 'E1', startDate: inicio, endDate: fim),
        GetLockedDaysParam(
            condominiumId: 'C1', employeeId: '', startDate: inicio, endDate: fim),
        GetLockedDaysParam(
            condominiumId: 'C1', employeeId: 'E1', startDate: null, endDate: fim),
        GetLockedDaysParam(
            condominiumId: 'C1', employeeId: 'E1', startDate: inicio, endDate: null),
      ];
      for (final caso in casos) {
        final result = await useCase.call(caso);
        expect(result, isA<Rejection<VacationLockedDays>>());
        expect((result as Rejection).get(), isA<InvalidParamFailure>());
      }
      expect(repo.calls, isEmpty);
    });
  });

  group('ScheduleVacationImpl', () {
    final created = VacationCreated(employeeId: 'E1');

    test('delega ao repositório', () async {
      final result = await ScheduleVacationImpl(repository: repo).call(
          ScheduleVacationParam(
              condominiumId: 'C1', employeeId: 'E1', vacationCreated: created));
      expect(result, isA<Success<VacationCreated>>());
      expect(repo.calls['createVacation'], ['C1', 'E1', created]);
    });

    test('rejeita parâmetros vazios', () async {
      final useCase = ScheduleVacationImpl(repository: repo);
      expect(
          await useCase.call(ScheduleVacationParam(
              condominiumId: '', employeeId: 'E1', vacationCreated: created)),
          isA<Rejection<VacationCreated>>());
      expect(
          await useCase.call(ScheduleVacationParam(
              condominiumId: 'C1', employeeId: '', vacationCreated: created)),
          isA<Rejection<VacationCreated>>());
      expect(useCase.validate(null), isA<InvalidParamFailure>());
      expect(repo.calls, isEmpty);
    });
  });
}
