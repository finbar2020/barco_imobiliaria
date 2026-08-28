import 'dart:convert';

import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:firebase_crashlytics_platform_interface/firebase_crashlytics_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/gdp/vacation/data/data_source/vacation_remote_data_source_impl.dart';
import 'package:shared_features/feature/gdp/vacation/data/model/vacation_request_model.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_created.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_locked_days.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_params.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_request.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_scheduled_periods.dart';

import '../../../helpers/firebase_mocks.dart';
import 'vacation_test_helpers.dart';

/// Crashlytics falso que conta os erros registrados.
class _CountingCrashlytics extends FakeCrashlyticsPlatform {
  final reasons = <String?>[];

  @override
  Future<void> recordError({
    String? exception,
    String? information,
    String? reason,
    bool? fatal,
    List<Map<String, String>>? stackTraceElements,
    String? buildId,
    List<String>? loadingUnits,
  }) async {
    reasons.add(reason);
  }
}

void main() {
  late VacationEnv env;
  late _CountingCrashlytics crashlytics;

  setUpAll(() async {
    await setUpFakeFirebase();
    // O `FirebaseCrashlytics.instance` guarda o delegate na primeira
    // resolução: instale o falso uma única vez e só limpe entre os testes.
    crashlytics = _CountingCrashlytics();
    FirebaseCrashlyticsPlatform.instance = crashlytics;
  });

  setUp(() {
    env = VacationEnv();
    crashlytics.reasons.clear();
  });

  group('getVacation', () {
    test('sucesso devolve a entidade com a referência do condomínio', () async {
      env.http.on('GET', vacationPath, body: vacationJson());

      final result = await env.vacationRepository.getVacation(
          condominiumId, employeeId);

      expect(result, isA<Success<Vacation>>());
      final vacation = result.getOrElse(() => Vacation());
      expect(vacation.employeeName, 'Fulano de Tal');
      // O data source sobrescreve `reference` com o id do condomínio.
      expect(vacation.reference, condominiumId);
      expect(env.http.requests.single.url.path, vacationPath);
    });

    test('erro HTTP vira Rejection(UnknownFailure)', () async {
      env.http.failAll();
      final result = await env.vacationRepository.getVacation(
          condominiumId, employeeId);
      expect(result, isA<Rejection<Vacation>>());
      expect((result as Rejection).get(), isA<UnknownFailure>());
    });
  });

  group('getVacationPeriod', () {
    test('sucesso converte os parâmetros', () async {
      env.http.on('GET', periodsPath, body: vacationParamsJson(initDays: 2));

      final result = await env.vacationRepository.getVacationPeriod(
          condominiumId, employeeId);

      expect(result, isA<Success<VacationParams>>());
      final params =
          result.getOrElse(() => VacationParams(periods: [], qtdInitDays: 0));
      expect(params.qtdInitDays, 2);
      expect(params.periods, hasLength(3));
      expect(params.periods[1]!.getIntervals, ['20d - 10d', '15d - 15d', '10d - 10d']);
    });

    test('erro HTTP vira Rejection', () async {
      env.http.on('GET', periodsPath, status: 500, body: {'title': 'x'});
      final result = await env.vacationRepository.getVacationPeriod(
          condominiumId, employeeId);
      expect(result, isA<Rejection<VacationParams>>());
    });
  });

  group('getLockedDays', () {
    test('formata as datas com zero à esquerda na query', () async {
      env.http.on('GET', lockedDaysPath, body: lockedDaysJson(['05/01/2030']));

      final result = await env.vacationRepository.getLockedDays(condominiumId,
          employeeId, DateTime(2030, 1, 5), DateTime(2030, 11, 25));

      expect(result, isA<Success<VacationLockedDays>>());
      expect(result.getOrElse(() => VacationLockedDays()).locked_days,
          ['05/01/2030']);
      final query = env.http.requests.single.url.queryParameters;
      expect(query['start_date'], '2030-01-05');
      expect(query['end_date'], '2030-11-25');
    });

    test('erro HTTP vira Rejection', () async {
      env.http.failAll();
      final result = await env.vacationRepository.getLockedDays(
          condominiumId, employeeId, DateTime(2030), DateTime(2031));
      expect(result, isA<Rejection<VacationLockedDays>>());
    });
  });

  group('scheduleVacation (requestVacation)', () {
    test('envia período e dias no corpo e devolve a entidade', () async {
      env.http.on('POST', vacationPath, body: vacationJson(scheduledDays: 30));

      final result = await env.vacationRepository.scheduleVacation(
          VacationRequest(
              condominiumId: condominiumId,
              employeeId: employeeId,
              period: 1,
              numberOfDays: 30));

      expect(result, isA<Success<Vacation>>());
      expect(result.getOrElse(() => Vacation()).scheduledDays, 30);
      final request = env.http.requests.single;
      expect(request.method, 'POST');
      expect(jsonDecode(request.body), {'period': 1, 'number_of_days': 30});
    });

    test('condomínio nulo ou erro HTTP viram Rejection', () async {
      final semCond = await env.vacationRepository
          .scheduleVacation(VacationRequest(employeeId: employeeId));
      expect(semCond, isA<Rejection<Vacation>>());

      env.http.failAll();
      final erro = await env.vacationRepository.scheduleVacation(
          VacationRequest(condominiumId: condominiumId, employeeId: employeeId));
      expect(erro, isA<Rejection<Vacation>>());
    });

    test('data source requestVacation mapeia a resposta', () async {
      env.http.on('POST', vacationPath, body: vacationJson());
      final ds = VacationRemoteDataSourceImpl(api: env.vacationApi);
      final model = await ds.requestVacation(
          condominiumId, employeeId, VacationRequestModel()..period = 2);
      expect(model.employeeId, employeeId);
    });
  });

  group('createVacation', () {
    final created = VacationCreated(
      employeeId: employeeId,
      company: 7,
      employeeRegistrationNumber: 'M123',
      vacationScheduledPeriods: [
        VacationScheduledPeriods(
            startDate: DateTime(2030, 1, 10), totalVacation: 1, scheduledDays: 30)
      ],
      salaryAllowance: 0,
      advance13: 'N',
      numbersUnitVacation: 1,
    );

    test('sucesso envia o modelo e devolve a entidade criada', () async {
      env.http.on('POST', periodsPath, body: vacationCreatedJson());

      final result = await env.vacationRepository.createVacation(
          condominiumId: condominiumId,
          employeeId: employeeId,
          vacationCreated: created);

      expect(result, isA<Success<VacationCreated>>());
      expect(result.getOrElse(() => VacationCreated()).employeeRegistrationNumber,
          'M123');
      final body = jsonDecode(env.http.requests.single.body);
      expect(body['employee_registration_number'], 'M123');
      expect(body['vacation_scheduled_periods'][0]['scheduled_days'], 30);
      expect(body['advance13'], 'N');
      expect(crashlytics.reasons, isEmpty);
    });

    test('406 vira KnownFailure com o título da API sem ir ao crashlytics',
        () async {
      env.http.on('POST', periodsPath, status: 406, body: {
        'status': 406,
        'title': 'Periodo invalido',
        'detail': 'Já existe agendamento',
      });

      final result = await env.vacationRepository.createVacation(
          condominiumId: condominiumId,
          employeeId: employeeId,
          vacationCreated: created);

      expect(result, isA<Rejection<VacationCreated>>());
      final failure = (result as Rejection).get();
      expect(failure, isA<KnownFailure>());
      expect(failure.code, 'Periodo invalido');
      expect((failure.error as ApiFailure).detail, 'Já existe agendamento');
      expect(crashlytics.reasons, isEmpty);
    });

    test('406 sem título usa string vazia como código', () async {
      env.http.on('POST', periodsPath, status: 406, body: {'status': 406});
      final result = await env.vacationRepository.createVacation(
          condominiumId: condominiumId,
          employeeId: employeeId,
          vacationCreated: created);
      expect((result as Rejection).get().code, '');
    });

    test('outro status de ApiFailure registra no crashlytics e é UnknownFailure',
        () async {
      env.http.on('POST', periodsPath, status: 500, body: {
        'status': 500,
        'title': 'Erro interno',
      });

      final result = await env.vacationRepository.createVacation(
          condominiumId: condominiumId,
          employeeId: employeeId,
          vacationCreated: created);

      expect((result as Rejection).get(), isA<UnknownFailure>());
      expect(crashlytics.reasons, hasLength(1));
      expect(crashlytics.reasons.single, contains('employeeId: $employeeId'));
      expect(crashlytics.reasons.single, contains('model:'));
    });

    test('erro que não é ApiFailure também vai ao crashlytics', () async {
      // Corpo que não é JSON: o conversor devolve a resposta sem bodyError e o
      // ApiMapper lança uma string vazia.
      env.http.on('POST', periodsPath, status: 500, body: 'não é json');

      final result = await env.vacationRepository.createVacation(
          condominiumId: condominiumId,
          employeeId: employeeId,
          vacationCreated: created);

      expect((result as Rejection).get(), isA<UnknownFailure>());
      expect(crashlytics.reasons, hasLength(1));
      expect(crashlytics.reasons.single, isNot(contains('model:')));
    });
  });
}
