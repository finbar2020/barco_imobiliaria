import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/gdp/domain/entity/employee.dart';
import 'package:shared_features/feature/gdp/vacation/data/model/vacation_created_model.dart';
import 'package:shared_features/feature/gdp/vacation/data/model/vacation_locked_days_model.dart';
import 'package:shared_features/feature/gdp/vacation/data/model/vacation_model.dart';
import 'package:shared_features/feature/gdp/vacation/data/model/vacation_params_model.dart';
import 'package:shared_features/feature/gdp/vacation/data/model/vacation_period_interval_model.dart';
import 'package:shared_features/feature/gdp/vacation/data/model/vacation_period_model.dart';
import 'package:shared_features/feature/gdp/vacation/data/model/vacation_request_model.dart';
import 'package:shared_features/feature/gdp/vacation/data/model/vacation_scheduled_periods_model.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_created.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_locked_days.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_period.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_period_interval.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_request.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_scheduled_periods.dart';

import 'vacation_test_helpers.dart';

void main() {
  group('VacationModel', () {
    test('fromJson lê todos os campos, o funcionário e as férias agendadas',
        () {
      final json = vacationJson(
        vacationStartDate: '10/01/2030',
        vacationEndDate: '08/02/2030',
        advance13: 'S',
        scheduledDays: 30,
        salaryAllowance: 10,
        numbersUnitVacation: 1,
        scheduledVacations: [
          vacationJson(vacationStartDate: '10/01/2030', includeEmployee: false)
        ],
      );

      final model = VacationModel.fromJson(json);

      expect(model.employee?.id, employeeId);
      expect(model.employee?.address?.address, 'Rua A');
      expect(model.employeeId, employeeId);
      expect(model.company, 7);
      expect(model.employeeType, 1);
      expect(model.employeeRegistrationNumber, 'M123');
      expect(model.reference, 'R1');
      expect(model.employeeName, 'Fulano de Tal');
      expect(model.admissionDate, '04/03/2020');
      expect(model.deadLine, '30/12/2027');
      expect(model.allowanceDays, 30.0);
      expect(model.numberAbsences, 2.0);
      expect(model.vacationStartDate, '10/01/2030');
      expect(model.vacationEndDate, '08/02/2030');
      expect(model.scheduledDays, 30);
      expect(model.salaryAllowance, 10);
      expect(model.advance13, 'S');
      expect(model.totalVacation, 1);
      expect(model.numbersUnitVacation, 1);
      expect(model.scheduledVacations, hasLength(1));
      expect(model.scheduledVacations!.first.employee, isNull);
    });

    test('fromJson vazio usa os valores padrão', () {
      final model = VacationModel.fromJson({});
      expect(model.employee, isNull);
      expect(model.allowanceDays, 0.0);
      expect(model.numberAbsences, 0.0);
      expect(model.scheduledDays, 0);
      expect(model.salaryAllowance, 0);
      expect(model.advance13, '');
      expect(model.totalVacation, 0);
      expect(model.numbersUnitVacation, 0);
      expect(model.scheduledVacations, isNull);
    });

    test('toJson serializa e sobrevive ao jsonEncode', () {
      final model = VacationModel.fromJson(vacationJson(
          scheduledVacations: [vacationJson(includeEmployee: false)]));
      final json = model.toJson();
      expect(json['employee_id'], employeeId);
      expect(json['acquisitive_period_end_date'], ddMMyyyy(hoje));
      expect(json['scheduled_vacations'], hasLength(1));
      final decoded = jsonDecode(jsonEncode(json)) as Map<String, dynamic>;
      expect(decoded['employee']['name'], 'Fulano');
      expect(decoded['scheduled_vacations'][0]['employee_name'],
          'Fulano de Tal');
    });

    test('toEntity copia os campos e converte as férias agendadas', () {
      final model = VacationModel.fromJson(vacationJson(
          advance13: 'S',
          scheduledVacations: [vacationJson(includeEmployee: false)]));

      final entity = model.toEntity();

      expect(entity, isA<Vacation>());
      expect(entity.employee?.name, 'Fulano');
      expect(entity.employeeId, employeeId);
      expect(entity.company, 7);
      expect(entity.employeeType, 1);
      expect(entity.employeeRegistrationNumber, 'M123');
      expect(entity.acquisitivePeriodStartDate, isNotEmpty);
      expect(entity.acquisitivePeriodEndDate, ddMMyyyy(hoje));
      expect(entity.reference, 'R1');
      expect(entity.employeeName, 'Fulano de Tal');
      expect(entity.admissionDate, '04/03/2020');
      expect(entity.deadLine, '30/12/2027');
      expect(entity.allowanceDays, 30.0);
      expect(entity.numberAbsences, 2.0);
      expect(entity.advance13, 'S');
      expect(entity.totalVacation, 1);
      expect(entity.scheduledVacations, hasLength(1));
      expect(entity.scheduledVacations!.first.scheduledVacations, isNull);
    });

    test('fromEntity devolve null para null e copia a entidade', () {
      expect(VacationModel.fromEntity(null), isNull);

      final entity = Vacation(
        employee: Employee()..name = 'Zé',
        employeeId: 'E9',
        company: 3,
        employeeType: 2,
        employeeRegistrationNumber: 'M9',
        acquisitivePeriodStartDate: '01/01/2029',
        acquisitivePeriodEndDate: '31/12/2029',
        reference: 'R9',
        employeeName: 'Zé',
        admissionDate: '01/01/2010',
        deadLine: '01/01/2031',
        allowanceDays: 20,
        numberAbsences: 1,
        vacationStartDate: '10/01/2030',
        vacationEndDate: '30/01/2030',
        scheduledDays: 20,
        salaryAllowance: 10,
        advance13: 'N',
        totalVacation: 2,
        numbersUnitVacation: 2,
      );

      final model = VacationModel.fromEntity(entity)!;

      expect(model.employee?.name, 'Zé');
      expect(model.employeeId, 'E9');
      expect(model.company, 3);
      expect(model.employeeType, 2);
      expect(model.employeeRegistrationNumber, 'M9');
      expect(model.acquisitivePeriodStartDate, '01/01/2029');
      expect(model.acquisitivePeriodEndDate, '31/12/2029');
      expect(model.reference, 'R9');
      expect(model.employeeName, 'Zé');
      expect(model.admissionDate, '01/01/2010');
      expect(model.deadLine, '01/01/2031');
      expect(model.allowanceDays, 20);
      expect(model.numberAbsences, 1);
      expect(model.vacationStartDate, '10/01/2030');
      expect(model.vacationEndDate, '30/01/2030');
      expect(model.scheduledDays, 20);
      expect(model.salaryAllowance, 10);
      expect(model.advance13, 'N');
      expect(model.totalVacation, 2);
      expect(model.numbersUnitVacation, 2);
      // fromEntity não copia scheduledVacations.
      expect(model.scheduledVacations, isNull);
    });

    test('map é um no-op que devolve null', () {
      expect(VacationModel().map((_) => 1), isNull);
    });
  });

  group('VacationCreatedModel', () {
    test('fromJson lê os períodos (inclusive nulos) e padrões', () {
      final json = vacationCreatedJson();
      (json['vacation_scheduled_periods'] as List).add(null);

      final model = VacationCreatedModel.fromJson(json);

      expect(model.employeeId, employeeId);
      expect(model.company, 7);
      expect(model.employeeRegistrationNumber, 'M123');
      expect(model.vacationScheduledPeriods, hasLength(2));
      expect(model.vacationScheduledPeriods.first?.startDate,
          DateTime(2030, 1, 10));
      expect(model.vacationScheduledPeriods.last, isNull);
      expect(model.salaryAllowance, 0);
      expect(model.advance13, 'N');
      expect(model.numbersUnitVacation, 1);

      final vazio = VacationCreatedModel.fromJson({});
      expect(vazio.vacationScheduledPeriods, isEmpty);
      expect(vazio.salaryAllowance, 0);
      expect(vazio.advance13, '');
      expect(vazio.numbersUnitVacation, 0);
    });

    test('toJson serializa os períodos aninhados', () {
      final model = VacationCreatedModel.fromJson(vacationCreatedJson());
      final decoded =
          jsonDecode(jsonEncode(model.toJson())) as Map<String, dynamic>;
      expect(decoded['employee_registration_number'], 'M123');
      expect(decoded['vacation_scheduled_periods'][0]['scheduled_days'], 30);
      expect(decoded['vacation_scheduled_periods'][0]['start_date'],
          startsWith('2030-01-10'));
    });

    test('toEntity converte períodos (vazio e com nulos)', () {
      final vazio = VacationCreatedModel().toEntity();
      expect(vazio.vacationScheduledPeriods, isEmpty);

      final json = vacationCreatedJson();
      (json['vacation_scheduled_periods'] as List).add(null);
      final entity = VacationCreatedModel.fromJson(json).toEntity();
      expect(entity, isA<VacationCreated>());
      expect(entity.employeeId, employeeId);
      expect(entity.company, 7);
      expect(entity.vacationScheduledPeriods, hasLength(2));
      expect(entity.vacationScheduledPeriods.first?.scheduledDays, 30);
      expect(entity.vacationScheduledPeriods.last, isNull);
      expect(entity.advance13, 'N');
      expect(entity.numbersUnitVacation, 1);
    });

    test('fromEntity: null, lista vazia e lista com períodos', () {
      expect(VacationCreatedModel.fromEntity(null), isNull);

      final semPeriodos = VacationCreatedModel.fromEntity(VacationCreated(
        employeeId: 'E2',
        company: 1,
        employeeRegistrationNumber: 'M2',
        salaryAllowance: 5,
        advance13: 'S',
        numbersUnitVacation: 0,
      ))!;
      expect(semPeriodos.employeeId, 'E2');
      expect(semPeriodos.vacationScheduledPeriods, isEmpty);
      expect(semPeriodos.salaryAllowance, 5);
      expect(semPeriodos.advance13, 'S');

      final comPeriodos = VacationCreatedModel.fromEntity(VacationCreated(
        vacationScheduledPeriods: [
          VacationScheduledPeriods(
              startDate: DateTime(2030, 2, 1),
              totalVacation: 1,
              scheduledDays: 15),
          null,
        ],
      ))!;
      expect(comPeriodos.vacationScheduledPeriods, hasLength(2));
      expect(comPeriodos.vacationScheduledPeriods.first?.scheduledDays, 15);
      expect(comPeriodos.vacationScheduledPeriods.last, isNull);
    });
  });

  group('VacationLockedDaysModel', () {
    test('fromJson/toJson/toEntity/fromEntity', () {
      final model = VacationLockedDaysModel.fromJson(lockedDaysJson(['a', 'b']));
      expect(model.locked_days, ['a', 'b']);
      expect(model.toJson(), {'locked_days': ['a', 'b']});
      expect(model.toEntity().locked_days, ['a', 'b']);
      expect(VacationLockedDaysModel.fromJson({}).locked_days, isEmpty);

      expect(VacationLockedDaysModel.fromEntity(null), isNull);
      final entity = VacationLockedDays()..locked_days = ['c'];
      expect(VacationLockedDaysModel.fromEntity(entity)!.locked_days, ['c']);
    });
  });

  group('VacationParamsModel / VacationPeriodModel / IntervalModel', () {
    test('fromJson aninhado com nulos e toEntity', () {
      final json = vacationParamsJson(initDays: 3);
      (json['gdp_vacation_periods'] as List).add(null);
      (json['gdp_vacation_periods'][0]['gdp_period_amount'] as List).add(null);

      final model = VacationParamsModel.fromJson(json);

      expect(model.gdpVacationInitDays, 3);
      expect(model.gdpVacationPeriods, hasLength(4));
      expect(model.gdpVacationPeriods.last, isNull);
      final primeiro = model.gdpVacationPeriods.first!;
      expect(primeiro.gdpPeriodVacation, 1);
      expect(primeiro.gdpPeriodAmount, hasLength(3));
      expect(primeiro.gdpPeriodAmount.last, isNull);
      expect(primeiro.gdpPeriodAmount.first!.days, [30]);
      expect(primeiro.gdpPeriodAmount[1]!.allowence, 10);

      final entity = model.toEntity();
      expect(entity.qtdInitDays, 3);
      expect(entity.periods, hasLength(4));
      expect(entity.periods.last, isNull);
      expect(entity.periods.first!.periodsNumber, 1);
      expect(entity.periods.first!.intervals.last, isNull);
      expect(entity.periods.first!.intervals.first!.intervals, [30]);

      expect(VacationParamsModel.fromJson({}).gdpVacationPeriods, isEmpty);
      expect(VacationParamsModel.fromJson({}).gdpVacationInitDays, 0);
      expect(VacationPeriodModel.fromJson({}).gdpPeriodAmount, isEmpty);
      expect(VacationPeriodIntervalModel.fromJson({}).days, isEmpty);
    });

    test('toJson dos três níveis', () {
      final model = VacationParamsModel.fromJson(vacationParamsJson());
      final decoded =
          jsonDecode(jsonEncode(model.toJson())) as Map<String, dynamic>;
      expect(decoded['gdp_vacation_init_days'], 1);
      expect(decoded['gdp_vacation_periods'][1]['gdp_period_vacation'], 2);
      expect(
          decoded['gdp_vacation_periods'][1]['gdp_period_amount'][0]['days'],
          [20, 10]);
      expect(model.gdpVacationPeriods.first!.toJson()['gdp_period_vacation'],
          1);
      expect(
          model.gdpVacationPeriods.first!.gdpPeriodAmount.first!.toJson(),
          {'days': [30], 'allowence': 0});
    });

    test('fromEntity de período e intervalo', () {
      expect(VacationPeriodModel.fromEntity(null), isNull);
      expect(VacationPeriodIntervalModel.fromEntity(null), isNull);

      final periodo = VacationPeriodModel.fromEntity(VacationPeriod(
        periodsNumber: 2,
        intervals: [
          VacationPeriodInterval(intervals: [20, 10], allowence: 5),
          null,
        ],
      ))!;
      expect(periodo.gdpPeriodVacation, 2);
      expect(periodo.gdpPeriodAmount, hasLength(2));
      expect(periodo.gdpPeriodAmount.first!.days, [20, 10]);
      expect(periodo.gdpPeriodAmount.first!.allowence, 5);
      expect(periodo.gdpPeriodAmount.last, isNull);

      final intervalo = periodo.gdpPeriodAmount.first!.toEntity();
      expect(intervalo.intervals, [20, 10]);
      expect(intervalo.allowence, 5);
    });

    test('map é no-op nos três modelos', () {
      expect(VacationParamsModel().map((_) => 1), isNull);
      expect(VacationPeriodModel().map((_) => 1), isNull);
      expect(VacationPeriodIntervalModel().map((_) => 1), isNull);
    });
  });

  group('VacationRequestModel', () {
    test('fromJson/toJson/toEntity/fromEntity', () {
      final model =
          VacationRequestModel.fromJson({'period': 2, 'number_of_days': 15});
      expect(model.period, 2);
      expect(model.numberOfDays, 15);
      expect(model.toJson(), {'period': 2, 'number_of_days': 15});

      final entity = model.toEntity();
      expect(entity, isA<VacationRequest>());
      expect(entity.period, 2);
      expect(entity.numberOfDays, 15);

      expect(VacationRequestModel.fromEntity(null), isNull);
      final volta = VacationRequestModel.fromEntity(
          VacationRequest(period: 1, numberOfDays: 30))!;
      expect(volta.period, 1);
      expect(volta.numberOfDays, 30);
      expect(VacationRequestModel.fromJson({}).period, isNull);
    });
  });

  group('VacationScheduledPeriodsModel', () {
    test('fromJson/toJson/toEntity/fromEntity', () {
      final model = VacationScheduledPeriodsModel.fromJson({
        'start_date': '2030-03-01T00:00:00.000',
        'scheduled_days': 10,
        'total_vacation': 2,
      });
      expect(model.startDate, DateTime(2030, 3, 1));
      expect(model.scheduledDays, 10);
      expect(model.totalVacation, 2);
      expect(model.toJson()['start_date'], startsWith('2030-03-01'));

      final entity = model.toEntity();
      expect(entity.startDate, DateTime(2030, 3, 1));
      expect(entity.scheduledDays, 10);
      expect(entity.totalVacation, 2);

      final nulo = VacationScheduledPeriodsModel.fromJson({});
      expect(nulo.startDate, isNull);
      expect(nulo.toJson()['start_date'], isNull);

      expect(VacationScheduledPeriodsModel.fromEntity(null), isNull);
      final volta = VacationScheduledPeriodsModel.fromEntity(
          VacationScheduledPeriods(
              startDate: DateTime(2031, 1, 1),
              totalVacation: 3,
              scheduledDays: 5))!;
      expect(volta.startDate, DateTime(2031, 1, 1));
      expect(volta.totalVacation, 3);
      expect(volta.scheduledDays, 5);
    });
  });
}
