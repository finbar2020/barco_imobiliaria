import 'dart:convert';

import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/gdp/domain/entity/employee.dart';
import 'package:shared_features/feature/gdp/timesheet/data/model/timesheet_event_model.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_event.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_filter.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_signature.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_type_enum.dart';

import 'timesheet_test_helpers.dart';

void main() {
  late TimesheetStack stack;

  setUp(() {
    stack = TimesheetStack();
  });

  final filtro = TimesheetFilter(
    name: 'Maria',
    id: 'E1',
    type: TimesheetTypeEnum.present,
    dobFrom: DateTime(2026, 8, 1),
    dobTo: DateTime(2026, 8, 31),
  );

  group('TimesheetGDPRemoteDataSourceImpl (api chopper real + http falso)',
      () {
    test('list envia o filtro na query e mapeia a lista', () async {
      stack.http.on('GET', '/timesheet/references/C1',
          body: [timesheetJson(), timesheetJson(events: ['x'])]);

      final result = await stack.dataSource.list('C1', filtro);

      expect(result.length, 2);
      expect(result.first.employee!.name, 'Maria Silva');
      expect(result.last.events, ['x']);
      final req = stack.http.requests.single;
      expect(req.method, 'GET');
      expect(req.url.path, '/timesheet/references/C1');
      expect(req.url.queryParameters['name'], 'Maria');
      expect(req.url.queryParameters['id_Employee'], 'E1');
      expect(req.url.queryParameters['type'], 'present');
      expect(req.url.queryParameters['dob_from'], startsWith('2026-08-01'));
      expect(req.url.queryParameters['dob_to'], startsWith('2026-08-31'));
    });

    test('list sem filtro não envia query', () async {
      stack.http.on('GET', '/timesheet/references/C1', body: []);
      final result = await stack.dataSource.list('C1', null);
      expect(result, isEmpty);
      expect(stack.http.requests.single.url.queryParameters, isEmpty);
    });

    test('list com erro http lança', () async {
      stack.http.on('GET', '/timesheet/references/C1',
          status: 500, body: {'message': 'erro'});
      expect(() => stack.dataSource.list('C1', filtro), throwsA(anything));
    });

    test('listEmployees mapeia os funcionários', () async {
      stack.http.on('GET', '/timesheet/employees/C1',
          body: [employeeJson(), employeeJson(id: 'E2', name: 'Joao')]);
      final result = await stack.dataSource.listEmployees('C1');
      expect(result.map((e) => e.name), ['Maria Silva', 'Joao']);
      expect(stack.http.requests.single.url.path, '/timesheet/employees/C1');
    });

    test('getReportDay mapeia o relatório com filtro e sem filtro', () async {
      stack.http.on('GET', '/timesheet/report/day/C1',
          body: reportDayJson(total: 12));
      final result = await stack.dataSource.getReportDay('C1', filtro);
      expect(result.totalAmount, 12);
      expect(stack.http.requests.single.url.queryParameters['type'],
          'present');

      final semFiltro = await stack.dataSource.getReportDay('C1', null);
      expect(semFiltro.presentAmount, 6);
      expect(stack.http.requests.last.url.queryParameters, isEmpty);
    });

    test('getReportDay com erro lança', () async {
      stack.http.on('GET', '/timesheet/report/day/C1', status: 404);
      expect(() => stack.dataSource.getReportDay('C1', filtro),
          throwsA(anything));
    });

    test('listSignature mapeia as assinaturas', () async {
      stack.http.on('GET', '/timesheet/signatures/C1',
          body: [signatureJson(id: 3)]);
      final result = await stack.dataSource.listSignature('C1', filtro);
      expect(result.single.id, 3);
      expect(stack.http.requests.single.url.queryParameters['name'], 'Maria');

      final semFiltro = await stack.dataSource.listSignature('C1', null);
      expect(semFiltro.single.id, 3);
      expect(stack.http.requests.last.url.queryParameters, isEmpty);
    });

    test('sign envia as assinaturas no corpo (PUT) e mapeia a resposta',
        () async {
      stack.http.on('PUT', '/timesheet/signatures/C1',
          body: [signatureJson(id: 1, approved: true)]);
      final result = await stack.dataSource.sign('C1', [
        TimesheetSignature(id: 1, employee: Employee()..name = 'Maria'),
        TimesheetSignature(id: 2),
      ]);
      expect(result.single.approvedFlag, true);
      final req = stack.http.requests.single;
      expect(req.method, 'PUT');
      final body = jsonDecode(req.body) as Map<String, dynamic>;
      final list = body['signatures_request'] as List;
      expect(list.length, 2);
      expect(list.first['id'], 1);
      expect(list.first['employee']['name'], 'Maria');
    });

    test('insertTimesheetEvent envia o evento (POST) e mapeia a resposta',
        () async {
      stack.http.on('POST', '/timesheet/event/C1',
          body: eventJson(id: 'NOVO'));
      final model = TimesheetEventModel()
        ..typeEvent = 'ABONO'
        ..registrationNumber = 'E1'
        ..effectiveDate = DateTime(2026, 8, 3);
      final result = await stack.dataSource.insertTimesheetEvent('C1', model);
      expect(result.id, 'NOVO');
      final req = stack.http.requests.single;
      expect(req.method, 'POST');
      final body = jsonDecode(req.body) as Map<String, dynamic>;
      expect(body['type_event'], 'ABONO');
      expect(body['registration_number'], 'E1');
      expect(body['effective_date'], '2026-08-03T00:00:00.000');
    });

    test('insertTimesheetEvent com erro lança', () async {
      stack.http.on('POST', '/timesheet/event/C1', status: 400);
      expect(
          () => stack.dataSource.insertTimesheetEvent(
              'C1', TimesheetEventModel()),
          throwsA(anything));
    });

    test('requestTimesheet devolve Success em 200 e lança em erro', () async {
      stack.http.on('POST', '/timesheet/request/C1', body: {});
      expect(await stack.dataSource.requestTimesheet('C1'), 'Success');
      expect(stack.http.requests.single.method, 'POST');
      expect(stack.http.requests.single.url.path, '/timesheet/request/C1');

      stack.http.on('POST', '/timesheet/request/C1', status: 500);
      expect(() => stack.dataSource.requestTimesheet('C1'),
          throwsA(isA<Exception>()));
    });
  });

  group('TimesheetGDPRepositoryImpl', () {
    test('list: sucesso vira Success de entidades e erro vira Rejection',
        () async {
      stack.http.on('GET', '/timesheet/references/C1', body: [timesheetJson()]);
      final ok = await stack.repository.list('C1', filtro);
      expect(ok, isA<Success>());
      expect(ok.fold((_) => null, (d) => d.single.employee!.name),
          'Maria Silva');

      stack.http.failAll();
      final erro = await stack.repository.list('C1', filtro);
      expect(erro, isA<Rejection>());
      expect(erro.fold((e) => e, (_) => null), isA<UnknownFailure>());
    });

    test('listEmployees', () async {
      stack.http.on('GET', '/timesheet/employees/C1', body: [employeeJson()]);
      final ok = await stack.repository.listEmployees('C1');
      expect(ok.fold((_) => null, (d) => d.single.name), 'Maria Silva');

      stack.http.failAll();
      expect(await stack.repository.listEmployees('C1'), isA<Rejection>());
    });

    test('getReportDay', () async {
      stack.http.on('GET', '/timesheet/report/day/C1', body: reportDayJson());
      final ok = await stack.repository.getReportDay('C1', filtro);
      expect(ok.fold((_) => null, (d) => d.totalAmount), 10);

      stack.http.failAll();
      expect(await stack.repository.getReportDay('C1', filtro),
          isA<Rejection>());
    });

    test('listSignature', () async {
      stack.http.on('GET', '/timesheet/signatures/C1', body: [signatureJson()]);
      final ok = await stack.repository.listSignature('C1', filtro);
      expect(ok.fold((_) => null, (d) => d.single.id), 1);

      stack.http.failAll();
      expect(await stack.repository.listSignature('C1', filtro),
          isA<Rejection>());
    });

    test('sign', () async {
      stack.http.on('PUT', '/timesheet/signatures/C1',
          body: [signatureJson(approved: true)]);
      final ok =
          await stack.repository.sign('C1', [TimesheetSignature(id: 1)]);
      expect(ok.fold((_) => null, (d) => d.single.approvedFlag), true);

      stack.http.failAll();
      expect(await stack.repository.sign('C1', [TimesheetSignature(id: 1)]),
          isA<Rejection>());
    });

    test('insertTimesheetEvent', () async {
      stack.http.on('POST', '/timesheet/event/C1', body: eventJson(id: 'N'));
      final ok = await stack.repository.insertTimesheetEvent(
          'C1', TimesheetEvent(typeEvent: 'ABONO'));
      expect(ok.fold((_) => null, (d) => d.id), 'N');
      expect(jsonDecode(stack.http.requests.single.body)['type_event'],
          'ABONO');

      stack.http.failAll();
      expect(
          await stack.repository.insertTimesheetEvent(
              'C1', TimesheetEvent(typeEvent: 'ABONO')),
          isA<Rejection>());
    });

    test('requestTimesheet', () async {
      stack.http.on('POST', '/timesheet/request/C1', body: {});
      final ok = await stack.repository.requestTimesheet('C1');
      expect(ok.fold((_) => null, (d) => d), 'Success');

      stack.http.failAll();
      expect(await stack.repository.requestTimesheet('C1'), isA<Rejection>());
    });
  });
}
