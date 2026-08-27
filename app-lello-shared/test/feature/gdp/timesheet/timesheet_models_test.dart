import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/gdp/domain/entity/employee.dart';
import 'package:shared_features/feature/gdp/timesheet/data/model/timesheet_event_model.dart';
import 'package:shared_features/feature/gdp/timesheet/data/model/timesheet_filter_model.dart';
import 'package:shared_features/feature/gdp/timesheet/data/model/timesheet_model.dart';
import 'package:shared_features/feature/gdp/timesheet/data/model/timesheet_report_day_model.dart';
import 'package:shared_features/feature/gdp/timesheet/data/model/timesheet_signature_model.dart';
import 'package:shared_features/feature/gdp/timesheet/data/model/timesheet_signature_request_model.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_event.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_filter.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_report_day.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_signature.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_signature_request.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_type_enum.dart';

import '../../../helpers/pump_app.dart';
import 'timesheet_test_helpers.dart';

void main() {
  group('TimesheetModel', () {
    test('fromJson preenche todos os campos e toEntity copia', () {
      final model = TimesheetModel.fromJson(timesheetJson(
        events: ['Falta sem justificativa'],
        eventControl: eventJson(),
        date: DateTime(2026, 8, 10),
        monthClosing: DateTime(2026, 8, 1),
      ));

      expect(model.employee!.name, 'Maria Silva');
      expect(model.date, DateTime(2026, 8, 10));
      expect(model.time, ['08:00', '12:00', '13:00', '17:00']);
      expect(model.schedules, ['08:00', '17:00']);
      expect(model.justifications, isEmpty);
      expect(model.comments, 'ok');
      expect(model.signature, isNull);
      expect(model.events, ['Falta sem justificativa']);
      expect(model.eventControl!.typeEvent, 'ABONO');
      expect(model.lunchHours, 60);
      expect(model.workedHours, 480);
      expect(model.extraHours50, 0);
      expect(model.extraHours60, 0);
      expect(model.extraHours75, 0);
      expect(model.extraHours80, 0);
      expect(model.extraHours100, 0);
      expect(model.extraHours140, 0);
      expect(model.extraHours200, 0);
      expect(model.lateHours, 0);
      expect(model.earlyDepartureHours, 0);
      expect(model.statusDay, 'PRESENTE');
      expect(model.monthClosing, DateTime(2026, 8, 1));

      final entity = model.toEntity();
      expect(entity.employee!.name, 'Maria Silva');
      expect(entity.date, DateTime(2026, 8, 10));
      expect(entity.time, model.time);
      expect(entity.schedules, model.schedules);
      expect(entity.justifications, model.justifications);
      expect(entity.comments, 'ok');
      expect(entity.signature, isNull);
      expect(entity.events, model.events);
      expect(entity.eventControl!.typeEvent, 'ABONO');
      expect(entity.lunchHours, 60);
      expect(entity.workedHours, 480);
      expect(entity.extraHours50, 0);
      expect(entity.extraHours60, 0);
      expect(entity.extraHours75, 0);
      expect(entity.extraHours80, 0);
      expect(entity.extraHours100, 0);
      expect(entity.extraHours140, 0);
      expect(entity.extraHours200, 0);
      expect(entity.lateHours, 0);
      expect(entity.earlyDepartureHours, 0);
      expect(entity.statusDay, 'PRESENTE');
      expect(entity.monthClosing, DateTime(2026, 8, 1));
    });

    test('fromJson aceita tudo nulo', () {
      final model = TimesheetModel.fromJson({});
      expect(model.employee, isNull);
      expect(model.date, isNull);
      expect(model.time, isNull);
      expect(model.eventControl, isNull);
      expect(model.monthClosing, isNull);
      final entity = model.toEntity();
      expect(entity.employee, isNull);
      expect(entity.eventControl, isNull);
    });

    test('fromEntity e toJson fazem a ida e volta', () {
      final entity = Timesheet(
        employee: Employee()
          ..id = 'E9'
          ..name = 'Ana',
        date: DateTime(2026, 8, 1),
        time: ['08:00'],
        schedules: ['08:00', '17:00'],
        justifications: ['x'],
        comments: 'c',
        signature: 's',
        events: ['e'],
        eventControl: TimesheetEvent(id: 'EV', typeEvent: 'DESCONTO'),
        lunchHours: 1,
        workedHours: 2,
        extraHours50: 3,
        extraHours60: 4,
        extraHours75: 5,
        extraHours80: 6,
        extraHours100: 7,
        extraHours140: 8,
        extraHours200: 9,
        lateHours: 10,
        earlyDepartureHours: 11,
        statusDay: 'FALTA',
      )..monthClosing = DateTime(2026, 7, 31);

      final model = TimesheetModel.fromEntity(entity)!;
      final json = model.toJson();
      expect(json['date'], '2026-08-01T00:00:00.000');
      expect(json['extra_hours200'], 9);
      expect(json['status_day'], 'FALTA');
      expect(json['month_closing'], '2026-07-31T00:00:00.000');
      expect((json['employee'] as dynamic).name, 'Ana');
      expect((json['event_control'] as dynamic).typeEvent, 'DESCONTO');

      final back = TimesheetModel.fromJson({
        ...json,
        'employee': (json['employee'] as dynamic).toJson(),
        'event_control': (json['event_control'] as dynamic).toJson(),
      }).toEntity();
      expect(back.employee!.name, 'Ana');
      expect(back.eventControl!.id, 'EV');
      expect(back.earlyDepartureHours, 11);
      expect(TimesheetModel.fromEntity(null), isNull);
    });
  });

  group('TimesheetEventModel', () {
    test('fromJson/toJson/toEntity/fromEntity', () {
      final model = TimesheetEventModel.fromJson(eventJson(
        effectiveDate: DateTime(2026, 8, 5),
      ));
      expect(model.id, 'EV1');
      expect(model.registrationNumber, 'E1');
      expect(model.reference, 'R1');
      expect(model.minutes, 0);
      expect(model.createdBy, 'U1');
      expect(model.flagProcessed, false);
      expect(model.typeEvent, 'ABONO');
      expect(model.effectiveDate, DateTime(2026, 8, 5));
      expect(model.processDate, isNull);
      expect(model.createdDate, DateTime(2026, 8, 1, 10));
      expect(model.changedDate, isNull);

      final entity = model.toEntity();
      expect(entity.id, 'EV1');
      expect(entity.registrationNumber, 'E1');
      expect(entity.reference, 'R1');
      expect(entity.minutes, 0);
      expect(entity.createdBy, 'U1');
      expect(entity.flagProcessed, false);
      expect(entity.typeEvent, 'ABONO');
      expect(entity.effectiveDate, DateTime(2026, 8, 5));
      expect(entity.createdDate, DateTime(2026, 8, 1, 10));

      final json = TimesheetEventModel.fromEntity(entity
            ..processDate = DateTime(2026, 8, 6)
            ..changedDate = DateTime(2026, 8, 7))!
          .toJson();
      expect(json['id'], 'EV1');
      expect(json['registration_number'], 'E1');
      expect(json['type_event'], 'ABONO');
      expect(json['effective_date'], '2026-08-05T00:00:00.000');
      expect(json['process_date'], '2026-08-06T00:00:00.000');
      expect(json['changed_date'], '2026-08-07T00:00:00.000');
      expect(TimesheetEventModel.fromEntity(null), isNull);
      expect(TimesheetEventModel.fromJson({}).toEntity().id, isNull);
    });
  });

  group('TimesheetFilterModel', () {
    test('fromJson/toJson/fromEntity/toEntity', () {
      final model = TimesheetFilterModel.fromJson({
        'name': 'Maria',
        'id': 'E1',
        'type': 'present',
        'dob_from': '2026-08-01T00:00:00',
        'dob_to': '2026-08-31T00:00:00',
      });
      expect(model.name, 'Maria');
      expect(model.id, 'E1');
      expect(model.type, 'present');
      expect(model.dobFrom, DateTime(2026, 8, 1));
      expect(model.dobTo, DateTime(2026, 8, 31));

      final entity = model.toEntity();
      expect(entity.type, TimesheetTypeEnum.present);
      expect(entity.name, 'Maria');
      expect(entity.dobTo, DateTime(2026, 8, 31));

      final json = TimesheetFilterModel.fromEntity(TimesheetFilter(
        name: 'x',
        id: 'y',
        type: TimesheetTypeEnum.dayOff,
        dobFrom: DateTime(2026, 1, 1),
        dobTo: DateTime(2026, 1, 2),
      ))!
          .toJson();
      expect(json['type'], 'dayOff');
      expect(json['dob_from'], '2026-01-01T00:00:00.000');
      expect(json['dob_to'], '2026-01-02T00:00:00.000');
      expect(TimesheetFilterModel.fromEntity(null), isNull);
      expect(TimesheetFilterModel.fromEntity(TimesheetFilter())!.type, isNull);
      expect(TimesheetFilterModel.fromJson({}).dobFrom, isNull);
    });

    /// Defeito: `toEntity` usa `this.type!`, então um filtro sem tipo
    /// explode em vez de devolver `type` nulo.
    test('toEntity sem tipo lança (defeito documentado)', () {
      expect(() => TimesheetFilterModel.fromJson({}).toEntity(),
          throwsA(isA<TypeError>()));
    });

    test('toEntity com tipo desconhecido devolve tipo nulo', () {
      expect(TimesheetFilterModel.fromJson({'type': 'zzz'}).toEntity().type,
          isNull);
    });
  });

  group('TimesheetReportDayModel', () {
    test('fromJson/toJson/toEntity/fromEntity', () {
      final model = TimesheetReportDayModel.fromJson(reportDayJson());
      expect(model.totalAmount, 10);
      expect(model.presentAmount, 6);
      expect(model.dayOffAmount, 1);
      expect(model.vacationAmount, 1);
      expect(model.unmarkedAmount, 1);
      expect(model.shiftNotStartedAmount, 1);
      expect(model.attestationAmount, 0);
      expect(model.clearanceAmount, 0);
      expect(model.extraHours, 3);

      final entity = model.toEntity();
      expect(entity.totalAmount, 10);
      expect(entity.presentAmount, 6);
      expect(entity.dayOffAmount, 1);
      expect(entity.vacationAmount, 1);
      expect(entity.unmarkedAmount, 1);
      expect(entity.shiftNotStartedAmount, 1);
      expect(entity.attestationAmount, 0);
      expect(entity.clearanceAmount, 0);
      expect(entity.extraHours, 3);

      final json = TimesheetReportDayModel.fromEntity(TimesheetReportDay(
        totalAmount: 1,
        presentAmount: 2,
        dayOffAmount: 3,
        vacationAmount: 4,
        unmarkedAmount: 5,
        shiftNotStartedAmount: 6,
        attestationAmount: 7,
        clearanceAmount: 8,
        extraHours: 9,
      ))!
          .toJson();
      expect(json, {
        'total_amount': 1,
        'present_amount': 2,
        'day_off_amount': 3,
        'vacation_amount': 4,
        'unmarked_amount': 5,
        'shift_not_started_amount': 6,
        'attestation_amount': 7,
        'clearance_amount': 8,
        'extra_hours': 9,
      });
      expect(TimesheetReportDayModel.fromEntity(null), isNull);
      expect(TimesheetReportDayModel.fromJson({}).toEntity().totalAmount,
          isNull);
    });
  });

  group('TimesheetSignatureModel', () {
    test('fromJson/toJson/toEntity/fromEntity', () {
      final model = TimesheetSignatureModel.fromJson({
        ...signatureJson(id: 7, approved: true),
        'signature_date_time': '2026-08-02T09:00:00',
      });
      expect(model.id, 7);
      expect(model.employee!.name, 'Maria Silva');
      expect(model.signatureDateTime, DateTime(2026, 8, 2, 9));
      expect(model.periodDate, DateTime(2026, 8, 1));
      expect(model.approvedFlag, true);
      expect(model.typeSignature, 'MENSAL');

      final entity = model.toEntity();
      expect(entity.id, 7);
      expect(entity.employee!.name, 'Maria Silva');
      expect(entity.signatureDateTime, DateTime(2026, 8, 2, 9));
      expect(entity.periodDate, DateTime(2026, 8, 1));
      expect(entity.approvedFlag, true);
      expect(entity.typeSignature, 'MENSAL');

      final json = TimesheetSignatureModel.fromEntity(entity)!.toJson();
      expect(json['id'], 7);
      expect(json['signature_date_time'], '2026-08-02T09:00:00.000');
      expect(json['period_date'], '2026-08-01T00:00:00.000');
      expect(json['approved_flag'], true);
      expect(json['type_signature'], 'MENSAL');
      expect((json['employee'] as dynamic).name, 'Maria Silva');
      expect(TimesheetSignatureModel.fromEntity(null), isNull);
      expect(TimesheetSignatureModel.fromJson({}).toEntity().employee, isNull);
    });
  });

  group('TimesheetSignatureRequestModel', () {
    test('fromJson/toJson/toEntity/fromEntity', () {
      final model = TimesheetSignatureRequestModel.fromJson({
        'signatures_request': [signatureJson(id: 1), signatureJson(id: 2)],
      });
      expect(model.signaturesRequest!.map((e) => e.id), [1, 2]);
      final entity = model.toEntity();
      expect(entity.signaturesRequest!.length, 2);
      expect(entity.signaturesRequest!.first, isA<TimesheetSignature>());

      final json = TimesheetSignatureRequestModel.fromEntity(entity)!.toJson();
      expect((json['signatures_request'] as List).length, 2);

      expect(TimesheetSignatureRequestModel.fromEntity(null), isNull);
      expect(
          TimesheetSignatureRequestModel.fromEntity(TimesheetSignatureRequest())!
              .signaturesRequest,
          isEmpty);
      expect(TimesheetSignatureRequestModel.fromJson({}).toEntity()
          .signaturesRequest, isNull);
    });
  });

  group('Entidades', () {
    test('construtores guardam os valores', () {
      final signature = TimesheetSignature(
          id: 1,
          employee: Employee()..name = 'A',
          signatureDateTime: DateTime(2026),
          periodDate: DateTime(2026, 2),
          approvedFlag: true,
          typeSignature: 'T');
      expect(signature.id, 1);
      expect(signature.employee!.name, 'A');
      expect(signature.typeSignature, 'T');
      expect(signature.approvedFlag, true);
      expect(TimesheetSignatureRequest(signaturesRequest: [signature])
          .signaturesRequest!.single.id, 1);
      final filter = TimesheetFilter(
          name: 'n', id: 'i', type: TimesheetTypeEnum.events);
      expect(filter.name, 'n');
      expect(filter.id, 'i');
      expect(filter.type, TimesheetTypeEnum.events);
      final report = TimesheetReportDay(totalAmount: 3, extraHours: 1);
      expect(report.totalAmount, 3);
      expect(report.extraHours, 1);
      final event = TimesheetEvent(minutes: 5, flagProcessed: true);
      expect(event.minutes, 5);
      expect(event.flagProcessed, true);
      expect(Timesheet(statusDay: 'X').statusDay, 'X');
    });
  });

  group('timesheetTypeToString', () {
    testWidgets('devolve a chave de localização de cada tipo', (tester) async {
      late BuildContext ctx;
      await pumpApp(tester, Builder(builder: (c) {
        ctx = c;
        return const SizedBox();
      }));
      expect(timesheetTypeToString(ctx, TimesheetTypeEnum.present),
          'gdp_timesheet_type_present');
      expect(timesheetTypeToString(ctx, TimesheetTypeEnum.shiftNotStarted),
          'gdp_timesheet_type_shiftNotStarted');
      expect(timesheetTypeToString(ctx, TimesheetTypeEnum.dayOff),
          'gdp_timesheet_type_dayOff');
      expect(timesheetTypeToString(ctx, TimesheetTypeEnum.vacation),
          'gdp_timesheet_type_vacation');
      expect(timesheetTypeToString(ctx, TimesheetTypeEnum.unmarked),
          'gdp_timesheet_type_unmarked');
      expect(timesheetTypeToString(ctx, TimesheetTypeEnum.attestation),
          'gdp_timesheet_type_attestation');
      expect(timesheetTypeToString(ctx, TimesheetTypeEnum.events),
          'gdp_timesheet_type_events');
      expect(timesheetTypeToString(ctx, TimesheetTypeEnum.employee),
          'gdp_timesheet_type_employee');
      expect(getString(ctx, 'x'), 'x');
    });
  });
}
