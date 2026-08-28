import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_created.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_locked_days.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_params.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_period.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_period_interval.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_periods_vacation_schedule.dart'
    as schedule;
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_request.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_scheduled_periods.dart';

void main() {
  group('Vacation', () {
    test('valores padrão do construtor', () {
      final v = Vacation();
      expect(v.deadLine, '');
      expect(v.allowanceDays, 0.0);
      expect(v.numberAbsences, 0.0);
      expect(v.scheduledDays, 0);
      expect(v.salaryAllowance, 0);
      expect(v.advance13, '');
      expect(v.totalVacation, 0);
      expect(v.numbersUnitVacation, 0);
      expect(v.scheduledVacations, isNull);
    });

    test('getAdvance13 traduz S em yes e qualquer outra coisa em no', () {
      expect(Vacation(advance13: 'S').getAdvance13, 'yes');
      expect(Vacation(advance13: 'N').getAdvance13, 'no');
      expect(Vacation(advance13: '').getAdvance13, 'no');
      expect(Vacation(advance13: null).getAdvance13, 'no');
    });

    test('getNumbersUnitVacation devolve null para zero', () {
      expect(Vacation(numbersUnitVacation: 0).getNumbersUnitVacation, isNull);
      expect(Vacation(numbersUnitVacation: 2).getNumbersUnitVacation, 2);
    });

    test('getScheduledDays devolve os dias em lista separada por "d"', () {
      expect(Vacation(scheduledDays: 0).getScheduledDays, ['0']);
      expect(Vacation(scheduledDays: 30).getScheduledDays, ['30']);
    });

    test('getPeriodVacation concatena início e fim do período aquisitivo', () {
      final v = Vacation(
          acquisitivePeriodStartDate: '01/01/2029',
          acquisitivePeriodEndDate: '31/12/2029');
      expect(v.getPeriodVacation, '01/01/2029 a 31/12/2029 ');
      expect(Vacation().getPeriodVacation, 'null a null ');
    });
  });

  group('VacationPeriod.getIntervals', () {
    test('formata cada intervalo com "d - " entre os dias', () {
      final periodo = VacationPeriod(periodsNumber: 2, intervals: [
        VacationPeriodInterval(intervals: [20, 10], allowence: 0),
        VacationPeriodInterval(intervals: [15, 15], allowence: 0),
        VacationPeriodInterval(intervals: [10, 10], allowence: 10),
      ]);
      expect(periodo.getIntervals, ['20d - 10d', '15d - 15d', '10d - 10d']);
    });

    test('um período com um único dia por intervalo', () {
      final periodo = VacationPeriod(periodsNumber: 1, intervals: [
        VacationPeriodInterval(intervals: [30], allowence: 0),
        VacationPeriodInterval(intervals: [20], allowence: 10),
      ]);
      expect(periodo.getIntervals, ['30d', '20d']);
    });

    /// Corrigido: a guarda `periodsNumber >= intervals.length` foi removida,
    /// então as opções continuam disponíveis quando o número de períodos é
    /// igual ou maior que a quantidade de intervalos (ex.: 1 período com 1
    /// opção de dias).
    test('mantém as opções quando periodsNumber >= intervals.length', () {
      final periodo = VacationPeriod(periodsNumber: 1, intervals: [
        VacationPeriodInterval(intervals: [30], allowence: 0),
      ]);
      expect(periodo.getIntervals, ['30d']);
      expect(VacationPeriod(periodsNumber: 0, intervals: []).getIntervals,
          isEmpty);
    });

    /// Corrigido: um intervalo nulo (ou sem dias) é ignorado em vez de estourar
    /// com `RangeError` no `substring`.
    test('intervalo nulo na lista é ignorado', () {
      final periodo = VacationPeriod(periodsNumber: 0, intervals: [
        null,
        VacationPeriodInterval(intervals: [], allowence: 0),
        VacationPeriodInterval(intervals: [30], allowence: 0),
      ]);
      expect(periodo.getIntervals, ['30d']);
    });
  });

  group('VacationLockedDays', () {
    test('add acrescenta e forEach é no-op', () {
      final locked = VacationLockedDays();
      expect(locked.locked_days, isEmpty);
      locked.add('2030-01-01');
      expect(locked.locked_days, ['2030-01-01']);
      var chamadas = 0;
      locked.forEach((_) {
        chamadas++;
      });
      expect(chamadas, 0);
    });
  });

  group('entidades simples', () {
    test('VacationCreated padrões', () {
      final c = VacationCreated();
      expect(c.vacationScheduledPeriods, isEmpty);
      expect(c.salaryAllowance, 0);
      expect(c.advance13, '');
      expect(c.numbersUnitVacation, 0);
      final cheio = VacationCreated(
          employeeId: 'E',
          company: 1,
          employeeRegistrationNumber: 'M',
          vacationScheduledPeriods: [
            VacationScheduledPeriods(
                startDate: DateTime(2030), totalVacation: 1, scheduledDays: 30)
          ],
          salaryAllowance: 10,
          advance13: 'S',
          numbersUnitVacation: 1);
      expect(cheio.employeeId, 'E');
      expect(cheio.vacationScheduledPeriods.single!.scheduledDays, 30);
    });

    test('VacationParams, VacationRequest e VacationPeriodInterval', () {
      final params = VacationParams(periods: [null], qtdInitDays: 2);
      expect(params.periods, [null]);
      expect(params.qtdInitDays, 2);

      final req = VacationRequest(
          condominiumId: 'C', employeeId: 'E', period: 1, numberOfDays: 30);
      expect(req.condominiumId, 'C');
      expect(req.employeeId, 'E');
      expect(req.period, 1);
      expect(req.numberOfDays, 30);

      final interval = VacationPeriodInterval(intervals: [1], allowence: 2);
      expect(interval.intervals, [1]);
      expect(interval.allowence, 2);

      // Cópia duplicada da classe em vacation_periods_vacation_schedule.dart.
      final dup =
          schedule.VacationPeriodInterval(intervals: [3, 4], allowence: 0);
      expect(dup.intervals, [3, 4]);
      expect(dup.allowence, 0);
    });
  });
}
