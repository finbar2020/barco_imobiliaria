import 'package:colaborador/feature/employee_referral/domain/entity/city.dart';
import 'package:colaborador/feature/employee_referral/domain/entity/employee_referral.dart';
import 'package:colaborador/feature/employee_referral/domain/use_case/get_cities/get_cities_units.dart';
import 'package:colaborador/feature/employee_referral/domain/use_case/register_employee_referral/employee_referral.dart';
import 'package:colaborador/feature/employee_referral/presentation/bloc/employee_referral_bloc.dart';
import 'package:colaborador/feature/employee_referral/presentation/bloc/employee_referral_state.dart';
import 'package:colaborador/feature/manual_timesheet/domain/entity/manual_timesheet.dart';
import 'package:colaborador/feature/manual_timesheet/domain/use_case/register_manual_timesheet/manual_timesheet.dart';
import 'package:colaborador/feature/manual_timesheet/presentation/bloc/manual_timesheet_bloc.dart';
import 'package:colaborador/feature/manual_timesheet/presentation/bloc/manual_timesheet_state.dart';
import 'package:colaborador/feature/sick_note/domain/entity/sick_note.dart';
import 'package:colaborador/feature/sick_note/domain/use_case/register_sick_note/sick_note.dart';
import 'package:colaborador/feature/sick_note/presentation/bloc/sick_note_bloc.dart';
import 'package:colaborador/feature/sick_note/presentation/bloc/sick_note_state.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fixtures.dart';

class _FakeSick extends Fake implements RegisterSickNoteUsecase {
  bool fail = false;

  @override
  Future<Try<SickNoteEntity>> call(RegisterSickNoteParam params) async {
    if (fail) return Rejection(UnknownFailure('x'));
    return Success(params.sickNoteEntity);
  }
}

class _FakeManual extends Fake implements RegisterManualTimeSheetUsecase {
  bool fail = false;

  @override
  Future<Try<ManualTimeSheetEntity>> call(
      RegisterManualTimeSheetParam params) async {
    if (fail) return Rejection(UnknownFailure('x'));
    return Success(params.manualTimeSheetEntity);
  }
}

class _FakeReferral extends Fake implements RegisterEmployeeReferralUsecase {
  bool fail = false;

  @override
  Future<Try<EmployeeReferralEntity>> call(
      RegisterEmployeeReferralParam params) async {
    if (fail) return Rejection(UnknownFailure('x'));
    return Success(params.employeeReferralEntity);
  }
}

class _FakeCities extends Fake implements GetCitiesUsecase {
  bool fail = false;

  @override
  Future<Try<List<CityEntity>>> call(GetCitiesParam params) async {
    if (fail) return Rejection(KnownFailure('500', 'erro'));
    return Success([CityEntity(name: 'São Paulo', regions: const ['sul'])]);
  }
}

void main() {
  group('SickNoteBloc', () {
    test('registra atestado', () async {
      final bloc = SickNoteBloc(
        registerSickNoteUsecase: _FakeSick(),
        sessionBloc: FakeSessionBloc(),
      );
      addTearDown(bloc.close);
      bloc.sendSickNote(date: DateTime(2026, 1, 10), file: testTempFile());
      expect(
        await bloc.stream.firstWhere((s) => s is SickNoteRegisterLoadedState),
        isA<SickNoteRegisterLoadedState>(),
      );
    });

    test('emite failed', () async {
      final bloc = SickNoteBloc(
        registerSickNoteUsecase: _FakeSick()..fail = true,
        sessionBloc: FakeSessionBloc(),
      );
      addTearDown(bloc.close);
      bloc.sendSickNote(date: DateTime(2026, 1, 10), file: testTempFile());
      expect(
        await bloc.stream.firstWhere((s) => s is SickNoteRegisterFailedState),
        isA<SickNoteRegisterFailedState>(),
      );
    });
  });

  group('ManualTimeSheetBloc', () {
    test('registra folha e preenche meses', () async {
      final bloc = ManualTimeSheetBloc(
        registerManualTimeSheetUsecase: _FakeManual(),
        sessionBloc: FakeSessionBloc(),
      );
      addTearDown(bloc.close);
      expect(bloc.listOfMonths, hasLength(12));
      bloc.sendManualTimeSheet(date: DateTime(2026, 1, 1), file: testTempFile());
      expect(
        await bloc.stream.firstWhere((s) => s is ManualTimeSheetRegisterLoadedState),
        isA<ManualTimeSheetRegisterLoadedState>(),
      );
    });

    test('emite failed', () async {
      final bloc = ManualTimeSheetBloc(
        registerManualTimeSheetUsecase: _FakeManual()..fail = true,
        sessionBloc: FakeSessionBloc(),
      );
      addTearDown(bloc.close);
      bloc.sendManualTimeSheet(date: DateTime(2026, 1, 1), file: testTempFile());
      expect(
        await bloc.stream.firstWhere((s) => s is ManualTimeSheetRegisterFailedState),
        isA<ManualTimeSheetRegisterFailedState>(),
      );
    });
  });

  group('EmployeeReferralBloc', () {
    test('carrega cidades no construtor e registra indicação', () async {
      final bloc = EmployeeReferralBloc(
        registerEmployeeReferralcase: _FakeReferral(),
        getCitiesUsecase: _FakeCities(),
        sessionBloc: FakeSessionBloc(),
      );
      addTearDown(bloc.close);
      await bloc.stream.firstWhere(
        (s) => s is GetCitiesLoadedState || s is GetCitiesFailedState,
      );
      expect(bloc.cities, hasLength(1));

      bloc.registerEmployeeReferral(
        description: 'porteiro',
        city: 'São Paulo',
        file: testTempFile(),
        region: 'sul',
      );
      expect(
        await bloc.stream.firstWhere((s) => s is EmployeeReferralRegisterLoadedState),
        isA<EmployeeReferralRegisterLoadedState>(),
      );
    });

    test('falha ao listar cidades e ao registrar', () async {
      final citiesFail = EmployeeReferralBloc(
        registerEmployeeReferralcase: _FakeReferral(),
        getCitiesUsecase: _FakeCities()..fail = true,
        sessionBloc: FakeSessionBloc(),
      );
      addTearDown(citiesFail.close);
      expect(
        await citiesFail.stream.firstWhere((s) => s is GetCitiesFailedState),
        isA<GetCitiesFailedState>(),
      );

      final registerFail = EmployeeReferralBloc(
        registerEmployeeReferralcase: _FakeReferral()..fail = true,
        getCitiesUsecase: _FakeCities(),
        sessionBloc: FakeSessionBloc(),
      );
      addTearDown(registerFail.close);
      await registerFail.stream.firstWhere((s) => s is GetCitiesLoadedState);
      registerFail.registerEmployeeReferral(
        description: 'vaga',
        city: 'SP',
        file: testTempFile(),
      );
      expect(
        await registerFail.stream.firstWhere(
          (s) => s is EmployeeReferralRegisterFailedState,
        ),
        isA<EmployeeReferralRegisterFailedState>(),
      );
    });
  });
}
