import 'package:colaborador/feature/timesheet/domain/entity/timesheet.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_element.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_element_detail.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_periods.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_point_flag_enum.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_sign_type_enum.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_status_enum.dart';
import 'package:colaborador/feature/timesheet/domain/repository/timesheet_repository.dart';
import 'package:colaborador/feature/timesheet/domain/use_case/get_timesheet/get_timesheet.dart';
import 'package:colaborador/feature/timesheet/domain/use_case/get_timesheet/get_timesheet_impl.dart';
import 'package:colaborador/feature/timesheet/domain/use_case/get_timesheet_detail/get_timesheet_detail.dart';
import 'package:colaborador/feature/timesheet/domain/use_case/get_timesheet_detail/get_timesheet_detail_impl.dart';
import 'package:colaborador/feature/timesheet/domain/use_case/get_timesheet_periods/get_timesheet_periods.dart';
import 'package:colaborador/feature/timesheet/domain/use_case/get_timesheet_periods/get_timesheet_periods_impl.dart';
import 'package:colaborador/feature/timesheet/domain/use_case/send_email/send_email.dart';
import 'package:colaborador/feature/timesheet/domain/use_case/send_email/send_email_impl.dart';
import 'package:colaborador/feature/timesheet/domain/use_case/sign_timesheet/sign_timesheet.dart';
import 'package:colaborador/feature/timesheet/domain/use_case/sign_timesheet/sign_timesheet_impl.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';

class _FakeTimesheetRepo extends Fake implements TimesheetRepository {
  Object? last;

  @override
  Future<Try<Timesheet>> getTimesheet(
      String condominiumId, DateTime period) async {
    last = condominiumId;
    return Success(Timesheet(
      dateFrom: DateTime(2026, 1, 1),
      dateTo: DateTime(2026, 1, 31),
      timesheetStatus: TimesheetStatusEnum.notAssigned,
      timesheetElements: const [],
    ));
  }

  @override
  Future<Try<List<TimesheetElementDetail>>> getTimesheetDetail(
      String condominiumId, DateTime period) async {
    last = period;
    return Success([
      TimesheetElementDetail(
        time: '08:00',
        timesheetFlag: TimesheetPointFlagEnum.inserted,
        date: DateTime(2026, 1, 10),
      ),
    ]);
  }

  @override
  Future<Try<List<TimesheetPeriods>>> getTimesheetPeriods(
      String condominiumId) async {
    last = condominiumId;
    return Success([
      TimesheetPeriods(
        periodMonth: DateTime(2026, 1),
        startDate: DateTime(2026, 1, 1),
        endDate: DateTime(2026, 1, 31),
      ),
    ]);
  }

  @override
  Future<Try<bool>> sendEmail(
      String condominiumId, String email, DateTime period) async {
    last = email;
    return Success(true);
  }

  @override
  Future<Try<bool>> signTimesheet(String condominiumId,
      TimesheetSignTypeEnum timesheetSignTypeEnum, DateTime period) async {
    last = timesheetSignTypeEnum;
    return Success(true);
  }
}

void main() {
  final period = DateTime(2026, 1, 10);

  group('GetTimesheetUsecaseImpl', () {
    test('rejeita param nulo', () {
      expect(
        GetTimesheetUsecaseImpl(repository: _FakeTimesheetRepo()).validate(null),
        isA<InvalidParamFailure>(),
      );
    });

    test('rejeita condomínio vazio', () async {
      final result = await GetTimesheetUsecaseImpl(
        repository: _FakeTimesheetRepo(),
      )(GetTimesheetParam(condoId: '', period: period));
      expect(result, isA<Rejection<Timesheet>>());
    });

    test('busca o espelho', () async {
      final repo = _FakeTimesheetRepo();
      final result = await GetTimesheetUsecaseImpl(repository: repo)(
        GetTimesheetParam(condoId: 'c1', period: period),
      );
      expect(result, isA<Success<Timesheet>>());
      expect(repo.last, 'c1');
    });
  });

  group('GetTimesheetDetailUsecaseImpl', () {
    test('rejeita param nulo', () {
      expect(
        GetTimesheetDetailUsecaseImpl(repository: _FakeTimesheetRepo())
            .validate(null),
        isA<InvalidParamFailure>(),
      );
    });

    test('rejeita condomínio vazio', () async {
      final result = await GetTimesheetDetailUsecaseImpl(
        repository: _FakeTimesheetRepo(),
      )(GetTimesheetDetailParam(condoId: '', period: period));
      expect(result, isA<Rejection<List<TimesheetElementDetail>>>());
    });

    test('busca o detalhe', () async {
      final result = await GetTimesheetDetailUsecaseImpl(
        repository: _FakeTimesheetRepo(),
      )(GetTimesheetDetailParam(condoId: 'c1', period: period));
      expect(result, isA<Success<List<TimesheetElementDetail>>>());
      expect((result as Success<List<TimesheetElementDetail>>).get().first.time, '08:00');
    });
  });

  group('GetTimesheetPeriodsUsecaseImpl', () {
    test('rejeita param nulo', () {
      expect(
        GetTimesheetPeriodsUsecaseImpl(repository: _FakeTimesheetRepo())
            .validate(null),
        isA<InvalidParamFailure>(),
      );
    });

    test('rejeita condomínio vazio', () async {
      final result = await GetTimesheetPeriodsUsecaseImpl(
        repository: _FakeTimesheetRepo(),
      )(GetTimesheetPeriodsParam(condoId: ''));
      expect(result, isA<Rejection<List<TimesheetPeriods>>>());
    });

    test('lista períodos', () async {
      final result = await GetTimesheetPeriodsUsecaseImpl(
        repository: _FakeTimesheetRepo(),
      )(GetTimesheetPeriodsParam(condoId: 'c1'));
      expect(result, isA<Success<List<TimesheetPeriods>>>());
    });
  });

  group('TimesheetSendEmailUsecaseImpl', () {
    test('rejeita param nulo', () {
      expect(
        TimesheetSendEmailUsecaseImpl(repository: _FakeTimesheetRepo())
            .validate(null),
        isA<InvalidParamFailure>(),
      );
    });

    test('rejeita e-mail vazio', () async {
      final result = await TimesheetSendEmailUsecaseImpl(
        repository: _FakeTimesheetRepo(),
      )(TimesheetSendEmailParam(condoId: 'c1', email: '', period: period));
      expect(result, isA<Rejection<bool>>());
    });

    test('envia e-mail', () async {
      final repo = _FakeTimesheetRepo();
      final result = await TimesheetSendEmailUsecaseImpl(repository: repo)(
        TimesheetSendEmailParam(
          condoId: 'c1',
          email: 'a@b.com',
          period: period,
        ),
      );
      expect(result, isA<Success<bool>>());
      expect(repo.last, 'a@b.com');
    });
  });

  group('SignTimesheetUsecaseImpl', () {
    test('rejeita param nulo', () {
      expect(
        SignTimesheetUsecaseImpl(repository: _FakeTimesheetRepo()).validate(null),
        isA<InvalidParamFailure>(),
      );
    });

    test('rejeita condomínio vazio', () async {
      final result = await SignTimesheetUsecaseImpl(
        repository: _FakeTimesheetRepo(),
      )(SignTimesheetParam(
        condoId: '',
        timesheetSignTypeEnum: TimesheetSignTypeEnum.espelho,
        period: period,
      ));
      expect(result, isA<Rejection<bool>>());
    });

    test('assina o espelho', () async {
      final repo = _FakeTimesheetRepo();
      final result = await SignTimesheetUsecaseImpl(repository: repo)(
        SignTimesheetParam(
          condoId: 'c1',
          timesheetSignTypeEnum: TimesheetSignTypeEnum.holerite,
          period: period,
        ),
      );
      expect(result, isA<Success<bool>>());
      expect(repo.last, TimesheetSignTypeEnum.holerite);
    });
  });

  group('entidades', () {
    test('TimesheetElement formata data e pontos', () {
      final el = TimesheetElement(
        date: DateTime(2026, 1, 10),
        times: const ['08:00', '12:00'],
        journey: '8h',
        hasTreatment: false,
        dayOff: false,
      );
      expect(el.dateFormatted, '10/01');
    });

    testWidgets('TimesheetElement pointsFormatted folga e vazio', (tester) async {
      final dayOff = TimesheetElement(
        date: DateTime(2026, 1, 10),
        times: const [],
        journey: '-',
        hasTreatment: false,
        dayOff: true,
      );
      final empty = TimesheetElement(
        date: DateTime(2026, 1, 11),
        times: const [],
        journey: '-',
        hasTreatment: false,
        dayOff: false,
      );
      await pumpApp(
        tester,
        Builder(
          builder: (context) => Column(
            children: [
              Text(dayOff.pointsFormatted(context)),
              Text(empty.pointsFormatted(context)),
            ],
          ),
        ),
        localized: true,
      );
      expect(find.text('timesheet_day_off'), findsOneWidget);
      expect(find.text(' - '), findsOneWidget);
    });

    testWidgets('TimesheetElement pointsFormatted com horários', (tester) async {
      final el = TimesheetElement(
        date: DateTime(2026, 1, 12),
        times: const ['08:00', '12:00'],
        journey: '4h',
        hasTreatment: false,
        dayOff: false,
      );
      await pumpApp(
        tester,
        Builder(builder: (context) => Text(el.pointsFormatted(context))),
        localized: true,
      );
      expect(find.text('08:00 - 12:00'), findsOneWidget);
    });

    test('TimesheetPointFlag.symbol', () {
      expect(TimesheetPointFlag.symbol(TimesheetPointFlagEnum.inserted), 'I');
      expect(TimesheetPointFlag.symbol(TimesheetPointFlagEnum.preInsert), 'P');
      expect(TimesheetPointFlag.symbol(TimesheetPointFlagEnum.notInserted), 'D');
      expect(TimesheetPointFlag.symbol(TimesheetPointFlagEnum.none), '');
    });
  });
}
