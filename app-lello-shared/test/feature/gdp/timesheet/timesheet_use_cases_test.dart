import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/gdp/domain/entity/employee.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_event.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_filter.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_report_day.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_signature.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/repository/timesheet_repository.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/use_case/get_report_day/get_report_day.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/use_case/get_report_day/get_report_day_impl.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/use_case/insert_timesheet_event/insert_timesheet_event.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/use_case/insert_timesheet_event/insert_timesheet_event_impl.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/use_case/list_signature/list_signature.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/use_case/list_signature/list_signature_impl.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/use_case/list_timesheet/list_timesheet.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/use_case/list_timesheet/list_timesheet_impl.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/use_case/list_timesheet_employee/list_timesheet_employee.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/use_case/list_timesheet_employee/list_timesheet_employee_impl.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/use_case/request_timesheet/request_timesheet.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/use_case/request_timesheet/request_timesheet_impl.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/use_case/sign_timesheet/sign_timesheet.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/use_case/sign_timesheet/sign_timesheet_impl.dart';

/// Repositório falso que registra as chamadas e devolve o que for configurado.
class _FakeRepo implements TimesheetGDPRepository {
  final calls = <String>[];
  bool fail = false;

  Try<T> _wrap<T>(T data) =>
      fail ? Rejection<T>(UnknownFailure('x')) : Success<T>(data);

  @override
  Future<Try<List<Timesheet>>> list(String c, TimesheetFilter f) async {
    calls.add('list:$c:${f.name}');
    return _wrap([Timesheet(comments: 'a')]);
  }

  @override
  Future<Try<List<Employee>>> listEmployees(String c) async {
    calls.add('employees:$c');
    return _wrap([Employee()..name = 'A']);
  }

  @override
  Future<Try<TimesheetReportDay>> getReportDay(
      String c, TimesheetFilter f) async {
    calls.add('report:$c:${f.type}');
    return _wrap(TimesheetReportDay(totalAmount: 5));
  }

  @override
  Future<Try<List<TimesheetSignature>>> listSignature(
      String c, TimesheetFilter f) async {
    calls.add('signatures:$c');
    return _wrap([TimesheetSignature(id: 1)]);
  }

  @override
  Future<Try<List<TimesheetSignature>>> sign(
      String c, List<TimesheetSignature> s) async {
    calls.add('sign:$c:${s.length}');
    return _wrap(s);
  }

  @override
  Future<Try<TimesheetEvent>> insertTimesheetEvent(
      String c, TimesheetEvent e) async {
    calls.add('insert:$c:${e.typeEvent}');
    return _wrap(e);
  }

  @override
  Future<Try<String>> requestTimesheet(String c) async {
    calls.add('request:$c');
    return _wrap('Success');
  }
}

void main() {
  late _FakeRepo repo;
  final filtro = TimesheetFilter(name: 'Maria');

  setUp(() => repo = _FakeRepo());

  group('ListTimesheetImpl', () {
    test('condomínio vazio devolve InvalidParamFailure sem chamar o repo',
        () async {
      final r = await ListTimesheetImpl(repository: repo)
          .call(ListTimesheetParam(condominiumId: '', filter: filtro));
      expect(r.fold((e) => e, (_) => null), isA<InvalidParamFailure>());
      expect(repo.calls, isEmpty);
    });

    test('delega ao repositório e repassa sucesso e falha', () async {
      final uc = ListTimesheetImpl(repository: repo);
      final ok = await uc
          .call(ListTimesheetParam(condominiumId: 'C1', filter: filtro));
      expect(ok.fold((_) => null, (d) => d.single.comments), 'a');
      expect(repo.calls, ['list:C1:Maria']);
      repo.fail = true;
      final erro = await uc
          .call(ListTimesheetParam(condominiumId: 'C1', filter: filtro));
      expect(erro, isA<Rejection>());
    });
  });

  group('ListTimesheetEmployeeImpl', () {
    test('valida e delega', () async {
      final uc = ListTimesheetEmployeeImpl(repository: repo);
      expect(
          (await uc.call(ListTimesheetEmployeeParam(condominiumId: '')))
              .fold((e) => e, (_) => null),
          isA<InvalidParamFailure>());
      final ok = await uc.call(ListTimesheetEmployeeParam(condominiumId: 'C1'));
      expect(ok.fold((_) => null, (d) => d.single.name), 'A');
      expect(repo.calls, ['employees:C1']);
    });
  });

  group('GetReportDayImpl', () {
    test('valida e delega', () async {
      final uc = GetReportDayImpl(repository: repo);
      expect(
          (await uc.call(GetReportDayParam(condominiumId: '', filter: filtro)))
              .fold((e) => e, (_) => null),
          isA<InvalidParamFailure>());
      final ok = await uc
          .call(GetReportDayParam(condominiumId: 'C1', filter: filtro));
      expect(ok.fold((_) => null, (d) => d.totalAmount), 5);
      expect(repo.calls, ['report:C1:null']);
    });
  });

  group('ListSignatureImpl', () {
    test('valida e delega', () async {
      final uc = ListSignatureImpl(repository: repo);
      expect(
          (await uc.call(ListSignatureParam(condominiumId: '', filter: filtro)))
              .fold((e) => e, (_) => null),
          isA<InvalidParamFailure>());
      final ok = await uc
          .call(ListSignatureParam(condominiumId: 'C1', filter: filtro));
      expect(ok.fold((_) => null, (d) => d.single.id), 1);
      expect(repo.calls, ['signatures:C1']);
    });
  });

  group('SignTimesheetImpl', () {
    test('valida condomínio e lista vazia, depois delega', () async {
      final uc = SignTimesheetImpl(repository: repo);
      expect(
          (await uc.call(SignTimesheetParam(
                  condominiumId: '', signatures: [TimesheetSignature()])))
              .fold((e) => e, (_) => null),
          isA<InvalidParamFailure>());
      expect(
          (await uc.call(
                  SignTimesheetParam(condominiumId: 'C1', signatures: [])))
              .fold((e) => e, (_) => null),
          isA<InvalidParamFailure>());
      expect(repo.calls, isEmpty);
      final ok = await uc.call(SignTimesheetParam(
          condominiumId: 'C1',
          signatures: [TimesheetSignature(id: 1), TimesheetSignature(id: 2)]));
      expect(ok.fold((_) => null, (d) => d.length), 2);
      expect(repo.calls, ['sign:C1:2']);
    });
  });

  group('InsertTimesheetEventImpl', () {
    test('valida e delega', () async {
      final uc = InsertTimesheetEventImpl(repository: repo);
      expect(
          (await uc.call(InsertTimesheetEventParam(
                  condominiumId: '', events: TimesheetEvent())))
              .fold((e) => e, (_) => null),
          isA<InvalidParamFailure>());
      final ok = await uc.call(InsertTimesheetEventParam(
          condominiumId: 'C1', events: TimesheetEvent(typeEvent: 'ABONO')));
      expect(ok.fold((_) => null, (d) => d.typeEvent), 'ABONO');
      expect(repo.calls, ['insert:C1:ABONO']);
    });
  });

  group('RequestTimesheetImpl', () {
    test('valida e delega', () async {
      final uc = RequestTimesheetImpl(repository: repo);
      expect(
          (await uc.call(RequestTimesheetParam(condominiumId: '')))
              .fold((e) => e, (_) => null),
          isA<InvalidParamFailure>());
      final ok = await uc.call(RequestTimesheetParam(condominiumId: 'C1'));
      expect(ok.fold((_) => null, (d) => d), 'Success');
      expect(repo.calls, ['request:C1']);
      repo.fail = true;
      expect(await uc.call(RequestTimesheetParam(condominiumId: 'C1')),
          isA<Rejection>());
    });
  });
}
