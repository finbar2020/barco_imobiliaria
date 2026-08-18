import 'package:colaborador/core/stores/session_store.dart';
import 'package:colaborador/feature/home/presentation/bloc/home_bloc.dart';
import 'package:colaborador/feature/home/presentation/bloc/home_event.dart';
import 'package:colaborador/feature/home/presentation/bloc/home_state.dart';
import 'package:colaborador/feature/home/presentation/bloc/register_point_bloc.dart';
import 'package:colaborador/feature/home_cards_preferences/bloc/preferences_home_cards_bloc.dart';
import 'package:colaborador/feature/home_cards_preferences/bloc/preferences_home_cards_events.dart';
import 'package:colaborador/feature/home_cards_preferences/bloc/preferences_home_cards_state.dart';
import 'package:colaborador/feature/home/domain/entity/home_item_enum.dart';
import 'package:colaborador/feature/preferences/domain/entity/preferences_notification_entity.dart';
import 'package:colaborador/feature/preferences/presentation/bloc/preferences_notification_bloc.dart';
import 'package:colaborador/feature/preferences/presentation/bloc/preferences_notification_event.dart';
import 'package:colaborador/feature/preferences/presentation/bloc/preferences_notification_state.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_state.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_element_detail.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_periods.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_point_flag_enum.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_status_enum.dart';
import 'package:colaborador/feature/timesheet/domain/use_case/get_timesheet/get_timesheet.dart';
import 'package:colaborador/feature/timesheet/domain/use_case/get_timesheet_detail/get_timesheet_detail.dart';
import 'package:colaborador/feature/timesheet/domain/use_case/get_timesheet_periods/get_timesheet_periods.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_detail_page/bloc/timesheet_detail_bloc.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_detail_page/bloc/timesheet_detail_state.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_page/bloc/timesheet_bloc.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_page/bloc/timesheet_state.dart';
import 'package:essentials/essentials.dart' hide isNotNull, isNull, equals;
import 'package:essentials/methods/device/device_identifier_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/shared_features.dart';

import '../../../../helpers/fixtures.dart';

class _FakeRegisterFcm extends Fake implements RegisterFcm {}

class _FakeGetTimesheet extends Fake implements GetTimesheetUsecase {
  bool fail = false;

  @override
  Future<Try<Timesheet>> call(GetTimesheetParam params) async {
    if (fail) return Rejection(KnownFailure('500', 'erro'));
    return Success(Timesheet(
      dateFrom: DateTime(2026, 1, 1),
      dateTo: DateTime(2026, 1, 31),
      timesheetStatus: TimesheetStatusEnum.notAssigned,
      timesheetElements: const [],
    ));
  }
}

class _FakeGetPeriods extends Fake implements GetTimesheetPeriodsUsecase {
  bool fail = false;
  bool empty = false;

  @override
  Future<Try<List<TimesheetPeriods>>> call(GetTimesheetPeriodsParam params) async {
    if (fail) return Rejection(KnownFailure('500', 'erro'));
    if (empty) return Success(const []);
    return Success([
      TimesheetPeriods(
        periodMonth: DateTime(2026, 1),
        startDate: DateTime(2026, 1, 1),
        endDate: DateTime(2026, 1, 31),
      ),
    ]);
  }
}

class _FakeGetDetail extends Fake implements GetTimesheetDetailUsecase {
  bool fail = false;

  @override
  Future<Try<List<TimesheetElementDetail>>> call(
      GetTimesheetDetailParam params) async {
    if (fail) return Rejection(UnknownFailure('x'));
    return Success([
      TimesheetElementDetail(
        time: '08:00',
        timesheetFlag: TimesheetPointFlagEnum.inserted,
        date: DateTime(2026, 1, 10),
      ),
    ]);
  }
}

void main() {
  group('RegisterPointBloc', () {
    test('emite cada estado correspondente', () async {
      final bloc = RegisterPointBloc();
      addTearDown(bloc.close);

      bloc.add(const StartRegisterPointEvent());
      expect(await bloc.stream.first, isA<StartRegisterPointState>());

      bloc.add(const RegisterPointSuccessEvent());
      expect(await bloc.stream.first, isA<RegisterPointFaceCaptureState>());

      bloc.add(const RegisterPointFailureEvent(message: 'falhou'));
      expect(
        await bloc.stream.first,
        isA<RegisterPointFailureState>(),
      );

      bloc.add(const NoLocationPermissionEvent());
      expect(await bloc.stream.first, isA<NoLocationPermissionState>());

      bloc.add(const OutOfRangeEvent());
      expect(await bloc.stream.first, isA<OutOfRangeState>());

      bloc.add(const OfflineFailureEvent());
      expect(await bloc.stream.first, isA<OfflineFailureState>());

      bloc.add(const WorkLeaveEvent(description: 'afastado'));
      final leave = await bloc.stream.first;
      expect(leave, isA<WorkLeaveState>());
      expect((leave as WorkLeaveState).description, 'afastado');

      bloc.add(const DeviceTypeFailureEvent(onlyTablet: true));
      final device = await bloc.stream.first;
      expect(device, isA<DeviceTypeFailureState>());
      expect((device as DeviceTypeFailureState).onlyTablet, isTrue);
    });
  });

  group('PreferencesNotificationBloc', () {
    test('emite loading, loaded, failure e success', () async {
      final bloc = PreferencesNotificationBloc();
      addTearDown(bloc.close);

      bloc.add(const PreferencesNotificationLoadingEvent());
      expect(await bloc.stream.first, isA<PreferencesNotificationLoadingState>());

      final prefs = [PreferencesNotificationEntity(active: true, module: 'gdp')];
      bloc.add(PreferencesNotificationLoadedEvent(preferences: prefs));
      final loaded = await bloc.stream.first;
      expect(loaded, isA<PreferencesNotificationLoadedState>());

      bloc.add(PreferencesNotificationFailureEvent(failure: KnownFailure('1', 'x')));
      expect(await bloc.stream.first, isA<PreferencesNotificationFailureState>());

      bloc.add(const PreferencesNotificationSuccessEvent());
      expect(await bloc.stream.first, isA<PreferencesNotificationSuccessState>());
    });
  });

  group('HomeBloc', () {
    test('HomeLoadEvent emite loaded', () async {
      final bloc = HomeBloc(
        registerFcm: _FakeRegisterFcm(),
        sessionBloc: FakeSessionBloc(),
        deviceIdentifierService: DeviceIdentifierService(),
      );
      addTearDown(bloc.close);
      bloc.add(HomeLoadEvent(digitalPoints: [testPoint()]));
      final state = await bloc.stream.first;
      expect(state, isA<HomeLoadedState>());
      expect((state as HomeLoadedState).digitalPoints, hasLength(1));
    });
  });

  group('PreferencesHomeCardsBloc', () {
    test('emite loading, loaded e failed', () async {
      final bloc = PreferencesHomeCardsBloc();
      addTearDown(bloc.close);

      bloc.add(PreferencesHomeCardsLoadingEvent());
      expect(await bloc.stream.first, isA<PreferencesHomeCardsLoadingState>());

      bloc.add(PreferencesHomeCardsLoadedEvent(
        cards: [HomeItemEnum.digitalPoint],
        favorites: [HomeItemEnum.proof],
        success: true,
        showOnboarding: true,
      ));
      final loaded = await bloc.stream.first;
      expect(loaded, isA<PreferencesHomeCardsLoadedState>());
      expect((loaded as PreferencesHomeCardsLoadedState).success, isTrue);

      bloc.add(PreferencesHomeCardsFailedEvent());
      expect(await bloc.stream.first, isA<PreferencesHomeCardsFailedState>());
    });
  });

  group('TimesheetBloc', () {
    test('carrega períodos e espelho', () async {
      final bloc = TimesheetBloc(
        sessionBloc: FakeSessionBloc(),
        getTimesheetUsecase: _FakeGetTimesheet(),
        getTimesheetPeriodsUsecase: _FakeGetPeriods(),
        store: SessionStore(),
      );
      addTearDown(bloc.close);

      bloc.getTimesheetPeriods();
      final periods = await bloc.stream.firstWhere(
        (s) => s is TimesheetPeriodsLoadedState || s is TimesheetPeriodsFailedState,
      );
      expect(periods, isA<TimesheetPeriodsLoadedState>());
      expect(bloc.availableDates, isNotEmpty);

      bloc.getTimesheet(period: DateTime(2026, 1, 1));
      final sheet = await bloc.stream.firstWhere(
        (s) => s is TimesheetLoadedState || s is TimesheetFailedState,
      );
      expect(sheet, isA<TimesheetLoadedState>());
    });

    test('períodos vazios e falha do espelho', () async {
      final emptyBloc = TimesheetBloc(
        sessionBloc: FakeSessionBloc(),
        getTimesheetUsecase: _FakeGetTimesheet(),
        getTimesheetPeriodsUsecase: _FakeGetPeriods()..empty = true,
        store: SessionStore(),
      );
      addTearDown(emptyBloc.close);
      emptyBloc.getTimesheetPeriods();
      expect(
        await emptyBloc.stream.firstWhere((s) => s is TimesheetPeriodsEmptyState),
        isA<TimesheetPeriodsEmptyState>(),
      );

      final failBloc = TimesheetBloc(
        sessionBloc: FakeSessionBloc(),
        getTimesheetUsecase: _FakeGetTimesheet()..fail = true,
        getTimesheetPeriodsUsecase: _FakeGetPeriods()..fail = true,
        store: SessionStore(),
      );
      addTearDown(failBloc.close);
      failBloc.getTimesheetPeriods();
      expect(
        await failBloc.stream.firstWhere((s) => s is TimesheetPeriodsFailedState),
        isA<TimesheetPeriodsFailedState>(),
      );
      failBloc.getTimesheet(period: DateTime(2026, 1, 1));
      expect(
        await failBloc.stream.firstWhere((s) => s is TimesheetFailedState),
        isA<TimesheetFailedState>(),
      );
    });
  });

  group('TimesheetDetailBloc', () {
    test('agrupa detalhes por data', () async {
      final bloc = TimesheetDetailBloc(
        getTimesheetDetailUsecase: _FakeGetDetail(),
        sessionBloc: FakeSessionBloc(),
      );
      addTearDown(bloc.close);
      bloc.getTimesheetDetail(period: DateTime(2026, 1, 10));
      final state = await bloc.stream.firstWhere(
        (s) => s is TimesheetDetailLoadedState || s is TimesheetDetailFailedState,
      );
      expect(state, isA<TimesheetDetailLoadedState>());
      expect((state as TimesheetDetailLoadedState).timesheetDetail, hasLength(1));
    });

    test('emite failed', () async {
      final bloc = TimesheetDetailBloc(
        getTimesheetDetailUsecase: _FakeGetDetail()..fail = true,
        sessionBloc: FakeSessionBloc(),
      );
      addTearDown(bloc.close);
      bloc.getTimesheetDetail(period: DateTime(2026, 1, 10));
      expect(
        await bloc.stream.firstWhere((s) => s is TimesheetDetailFailedState),
        isA<TimesheetDetailFailedState>(),
      );
    });
  });

  group('SessionLoadedState', () {
    test('marca a sessão como tablet', () {
      final session = testSession();
      SessionLoadedState(session: session, isTabletSession: true);
      expect(session.me.isTabletSession, isTrue);
    });
  });

  group('SessionStore', () {
    test('guarda e limpa a sessão', () {
      final store = SessionStore();
      store.setSession(session: testSession());
      expect(store.session?.me.id, 'm1');
      store.clear();
      expect(store.session == null, isTrue);
    });
  });
}
