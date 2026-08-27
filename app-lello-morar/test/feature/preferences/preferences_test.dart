import 'dart:convert';

import 'package:chopper/chopper.dart' show Response;
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:morar/feature/me/domain/entity/condominium.dart';
import 'package:morar/feature/preferences/data/data_source/preferences_api.dart';
import 'package:morar/feature/preferences/data/data_source/preferences_data_source.dart';
import 'package:morar/feature/preferences/data/data_source/preferences_data_source_impl.dart';
import 'package:morar/feature/preferences/data/model/preferences_model.dart';
import 'package:morar/feature/preferences/data/model/preferences_notification_model.dart';
import 'package:morar/feature/preferences/data/model/preferences_zero_paper_model.dart';
import 'package:morar/feature/preferences/data/repository/preferences_repository_impl.dart';
import 'package:morar/feature/preferences/domain/entity/preferences_entity.dart';
import 'package:morar/feature/preferences/domain/entity/preferences_notification_entity.dart';
import 'package:morar/feature/preferences/domain/entity/preferences_notification_enum.dart';
import 'package:morar/feature/preferences/domain/entity/preferences_zero_paper_entity.dart';
import 'package:morar/feature/preferences/domain/entity/preferences_zero_paper_enum.dart';
import 'package:morar/feature/preferences/domain/repository/preferences_repository.dart';
import 'package:morar/feature/preferences/domain/use_case/get_preferences_notification/get_preferences_notification.dart';
import 'package:morar/feature/preferences/domain/use_case/get_preferences_notification/get_preferences_notification_impl.dart';
import 'package:morar/feature/preferences/domain/use_case/get_preferences_zero_paper/get_preferences_zero_paper.dart';
import 'package:morar/feature/preferences/domain/use_case/get_preferences_zero_paper/get_preferences_zero_paper_impl.dart';
import 'package:morar/feature/preferences/domain/use_case/put_preferences_notification/put_preferences_notification.dart';
import 'package:morar/feature/preferences/domain/use_case/put_preferences_notification/put_preferences_notification_impl.dart';
import 'package:morar/feature/preferences/domain/use_case/put_preferences_zero_paper/put_preferences_zero_paper.dart';
import 'package:morar/feature/preferences/domain/use_case/put_preferences_zero_paper/put_preferences_zero_paper_impl.dart';
import 'package:morar/feature/preferences/presentation/pages/notification/bloc/preferences_notification_bloc.dart';
import 'package:morar/feature/preferences/presentation/pages/notification/bloc/preferences_notification_event.dart';
import 'package:morar/feature/preferences/presentation/pages/notification/bloc/preferences_notification_state.dart';
import 'package:morar/feature/preferences/presentation/pages/notification/controller/preferences_notification_controller.dart';
import 'package:morar/feature/preferences/presentation/pages/zero_paper/bloc/preferences_zero_paper_bloc.dart';
import 'package:morar/feature/preferences/presentation/pages/zero_paper/bloc/preferences_zero_paper_event.dart';
import 'package:morar/feature/preferences/presentation/pages/zero_paper/bloc/preferences_zero_paper_state.dart';
import 'package:morar/feature/preferences/presentation/pages/zero_paper/controllers/preferences_zero_paper_controller.dart';

import '../../helpers/fixtures.dart';

class MockApi extends Mock implements PreferencesApi {}

class _FakeDataSource extends Fake implements PreferencesDataSource {
  _FakeDataSource({this.fail = false});
  final bool fail;
  PreferencesModel? putZero;
  List<PreferencesNotificationModel>? putNotification;

  @override
  Future<PreferencesZeroPaperModel> getPreferencesZeroPaper() async {
    if (fail) throw Exception('x');
    return PreferencesZeroPaperModel(deliverySlips: PreferencesZeroPaperEnum.printed);
  }

  @override
  Future<String> putPreferencesZeroPaper(PreferencesModel model) async {
    if (fail) throw Exception('x');
    putZero = model;
    return '';
  }

  @override
  Future<List<PreferencesNotificationModel>> getPreferencesNotification() async {
    if (fail) throw Exception('x');
    return [PreferencesNotificationModel(active: true, module: 'boletos')];
  }

  @override
  Future<String> putPreferencesNotification(List<PreferencesNotificationModel> model) async {
    if (fail) throw Exception('x');
    putNotification = model;
    return '';
  }
}

class _FakeRepository extends Fake implements PreferencesRepository {
  final calls = <String>[];
  @override
  Future<Try<PreferencesZeroPaperEntity>> getPreferencesZeroPaper() async {
    calls.add('getZero');
    return Success(PreferencesZeroPaperEntity(deliveryActs: 'digital'));
  }

  @override
  Future<Try<String>> putPreferencesZeroPaper(PreferencesEntity entity) async {
    calls.add('putZero:${entity.zeroPaper?.allUnits}');
    return Success('');
  }

  @override
  Future<Try<List<PreferencesNotificationEntity>>> getPreferencesNotification() async {
    calls.add('getNotif');
    return Success(const []);
  }

  @override
  Future<Try<String>> putPreferencesNotification(List<PreferencesNotificationEntity> entity) async {
    calls.add('putNotif:${entity.length}');
    return Success('');
  }
}

class _FakeGetZero extends Fake implements GetZeroPaperUseCase {
  _FakeGetZero({this.fail = false, this.entity});
  final bool fail;
  final PreferencesZeroPaperEntity? entity;
  @override
  Future<Try<PreferencesZeroPaperEntity>> call(GetZeroPaperParam params) async {
    if (fail) return Rejection(UnknownFailure('x'));
    return Success(entity ?? PreferencesZeroPaperEntity());
  }
}

class _FakePutZero extends Fake implements PutZeroPaperUseCase {
  _FakePutZero({this.fail = false});
  final bool fail;
  PreferencesEntity? entity;
  @override
  Future<Try<String>> call(PutZeroPaperParam params) async {
    entity = params.entity;
    if (fail) return Rejection(UnknownFailure('x'));
    return Success('');
  }
}

class _FakeGetNotif extends Fake implements GetNotificationUseCase {
  _FakeGetNotif({this.fail = false});
  final bool fail;
  @override
  Future<Try<List<PreferencesNotificationEntity>>> call(GetNotificationParam params) async {
    if (fail) return Rejection(UnknownFailure('x'));
    return Success([PreferencesNotificationEntity(active: true, module: 'mkt')]);
  }
}

class _FakePutNotif extends Fake implements PutNotificationUseCase {
  _FakePutNotif({this.fail = false});
  final bool fail;
  @override
  Future<Try<String>> call(PutNotificationParam params) async {
    if (fail) return Rejection(UnknownFailure('x'));
    return Success('');
  }
}

Future<List<dynamic>> _collect(Bloc bloc, Future<void> Function() run) async {
  final states = <dynamic>[];
  final sub = bloc.stream.listen(states.add);
  await run();
  await Future<void>.delayed(Duration.zero);
  await sub.cancel();
  return states;
}

void main() {
  test('PreferencesNotificationEntity.title', () {
    const expected = {
      'acordos': 'notification_module_agreements',
      'ocorrencia': 'notification_module_reports_report',
      'prestacao_contas': 'notification_module_accountability_title',
      'controle_acesso': 'notification_module_access_title',
      'reserva_area': 'notification_module_condominium_hub_manage_space',
      'mkt': 'notification_module_mkt',
      'correspondencia': 'notification_module_mailing_title',
      'boletos': 'notification_module_income_control_billets',
      'comunicados': 'notification_module_announcements',
      'sistema': 'notification_module_others',
      'outro': '',
    };
    expected.forEach((module, title) {
      expect(PreferencesNotificationEntity(module: module).title, title);
    });
    expect(PreferencesNotificationEnum.values.length, 10);
  });

  test('models', () {
    final zero = PreferencesZeroPaperModel.fromEntity(PreferencesZeroPaperEntity(
      deliveryAnnouncements: 'printed',
      deliveryActs: 'printed_digital',
      deliverySlips: 'qualquer',
      allUnits: true,
    ))!;
    expect(zero.deliveryAnnouncements, PreferencesZeroPaperEnum.printed);
    expect(zero.deliveryActs, PreferencesZeroPaperEnum.printed_digital);
    expect(zero.deliverySlips, PreferencesZeroPaperEnum.digital);
    expect(zero.deliveryStatements, PreferencesZeroPaperEnum.digital);
    final json = zero.toJson();
    expect(json['delivery_acts'], 'printed_digital');
    final entity = PreferencesZeroPaperModel.fromJson(json).toEntity();
    expect(entity.deliveryAnnouncements, 'printed');
    expect(entity.allUnits, isTrue);
    expect(PreferencesZeroPaperModel().toEntity().allUnits, isFalse);
    expect(PreferencesZeroPaperModel.fromEntity(null), isNull);

    final prefs = PreferencesModel.fromEntity(PreferencesEntity(zeroPaper: entity))!;
    expect(jsonDecode(jsonEncode(prefs.toJson()))['zero_paper']['all_units'], isTrue);
    expect(PreferencesModel.fromJson({'zero_paper': null}).toEntity().zeroPaper, isNull);
    expect(PreferencesModel.fromEntity(null), isNull);

    final notif = PreferencesNotificationModel.fromEntity(
        PreferencesNotificationEntity(active: false, module: 'mkt'));
    expect(notif.toJson(), {'active': false, 'module': 'mkt'});
    expect(PreferencesNotificationModel.fromJson(notif.toJson()).toEntity().title,
        'notification_module_mkt');
  });

  test('use cases', () async {
    final repo = _FakeRepository();
    expect((await GetZeroPaperUseCaseImpl(repository: repo)(GetZeroPaperParam(unityId: '')))
        .fold((f) => f, (_) => null), isA<InvalidParamFailure>());
    expect((await GetNotificationUseCaseImpl(repository: repo)(GetNotificationParam(unityId: '')))
        .fold((f) => f, (_) => null), isA<InvalidParamFailure>());
    await GetZeroPaperUseCaseImpl(repository: repo)(GetZeroPaperParam(unityId: 'u'));
    await GetNotificationUseCaseImpl(repository: repo)(GetNotificationParam(unityId: 'u'));
    await PutZeroPaperUseCaseImpl(repository: repo)(PutZeroPaperParam(
        entity: PreferencesEntity(zeroPaper: PreferencesZeroPaperEntity(allUnits: true))));
    await PutNotificationUseCaseImpl(repository: repo)(PutNotificationParam(entity: [
      PreferencesNotificationEntity(module: 'a'),
      PreferencesNotificationEntity(module: 'b'),
    ]));
    expect(repo.calls, ['getZero', 'getNotif', 'putZero:true', 'putNotif:2']);
  });

  test('repository', () async {
    final ds = _FakeDataSource();
    final repo = PreferencesRepositoryImpl(dataSource: ds);
    expect((await repo.getPreferencesZeroPaper()).fold((_) => null, (e) => e.deliverySlips), 'printed');
    expect((await repo.putPreferencesZeroPaper(PreferencesEntity(
            zeroPaper: PreferencesZeroPaperEntity(deliveryActs: 'printed'))))
        .fold((_) => null, (r) => r), '');
    expect(ds.putZero!.zeroPaper!.deliveryActs, PreferencesZeroPaperEnum.printed);
    expect((await repo.getPreferencesNotification()).fold((_) => null, (l) => l.single.module), 'boletos');
    expect((await repo.putPreferencesNotification([PreferencesNotificationEntity(module: 'x')]))
        .fold((_) => null, (r) => r), '');
    expect(ds.putNotification!.single.module, 'x');

    final bad = PreferencesRepositoryImpl(dataSource: _FakeDataSource(fail: true));
    expect((await bad.getPreferencesZeroPaper()).fold((f) => f, (_) => null), isA<UnknownFailure>());
    expect((await bad.putPreferencesZeroPaper(PreferencesEntity())).fold((f) => f, (_) => null), isA<UnknownFailure>());
    expect((await bad.getPreferencesNotification()).fold((f) => f, (_) => null), isA<UnknownFailure>());
    expect((await bad.putPreferencesNotification(const [])).fold((f) => f, (_) => null), isA<UnknownFailure>());
  });

  test('data source', () async {
    final api = MockApi();
    registerFallbackValue(PreferencesModel());
    registerFallbackValue(<PreferencesNotificationModel>[]);
    final ds = PreferencesDataSourceImpl(api: api);
    when(() => api.getPreferencesZeroPaper()).thenAnswer(
      (_) async => Response<dynamic>(http.Response(jsonEncode({'delivery_slips': 'digital'}), 200), null),
    );
    when(() => api.getPreferencesNotification()).thenAnswer(
      (_) async => Response<dynamic>(http.Response(jsonEncode([{'module': 'mkt', 'active': true}]), 200), null),
    );
    final okResponse = Response<dynamic>(http.Response('', 200), null);
    final errResponse = Response<dynamic>(http.Response('', 500), null, error: 'err');
    when(() => api.putPreferencesZeroPaper(any())).thenAnswer((_) async => okResponse);
    when(() => api.putPreferencesNotification(any())).thenAnswer((_) async => okResponse);
    expect((await ds.getPreferencesZeroPaper()).deliverySlips, PreferencesZeroPaperEnum.digital);
    expect((await ds.getPreferencesNotification()).single.module, 'mkt');
    expect(await ds.putPreferencesZeroPaper(PreferencesModel()), '');
    expect(await ds.putPreferencesNotification(const []), '');

    when(() => api.putPreferencesZeroPaper(any())).thenAnswer((_) async => errResponse);
    when(() => api.putPreferencesNotification(any())).thenAnswer((_) async => errResponse);
    expect(() => ds.putPreferencesZeroPaper(PreferencesModel()), throwsA('err'));
    expect(() => ds.putPreferencesNotification(const []), throwsA('err'));
  });

  test('blocs', () async {
    final zero = PreferencesZeroPaperBloc();
    final entity = PreferencesZeroPaperEntity();
    var states = await _collect(zero, () async {
      zero
        ..add(const PreferencesZeroPaperLoadingEvent())
        ..add(PreferencesZeroPaperLoadedEvent(preferences: entity, printedActs: true))
        ..add(const PreferencesZeroPaperFailureEvent(error: 'e'))
        ..add(const PreferencesZeroPaperSuccessEvent());
    });
    await zero.close();
    expect(states[0], const PreferencesZeroPaperLoadingState());
    expect((states[1] as PreferencesZeroPaperLoadedState).printedActs, isTrue);
    expect(states[2], const PreferencesZeroPaperFailureState(error: 'e'));
    expect(states[3], const PreferencesZeroPaperSuccessState());
    expect(PreferencesZeroPaperLoadedEvent(preferences: entity).props.length, 9);

    final notif = PreferencesNotificationBloc();
    states = await _collect(notif, () async {
      notif
        ..add(const PreferencesNotificationLoadingEvent())
        ..add(const PreferencesNotificationLoadedEvent(preferences: []))
        ..add(const PreferencesNotificationFailureEvent(error: 'e'))
        ..add(const PreferencesNotificationSuccessEvent());
    });
    await notif.close();
    expect(states, [
      const PreferencesNotificationLoadingState(),
      const PreferencesNotificationLoadedState(preferences: []),
      const PreferencesNotificationFailureState(error: 'e'),
      const PreferencesNotificationSuccessState(),
    ]);
  });

  group('PreferencesZeroPaperController', () {
    late PreferencesZeroPaperBloc bloc;
    setUp(() => bloc = PreferencesZeroPaperBloc());
    tearDown(() => bloc.close());

    PreferencesZeroPaperController build({
      _FakeGetZero? get,
      _FakePutZero? put,
      FakeSessionBloc? session,
    }) =>
        PreferencesZeroPaperController(
          bloc: bloc,
          getZeroPaperUseCase: get ?? _FakeGetZero(),
          putZeroPaperUseCase: put ?? _FakePutZero(),
          sessionBloc: session ?? FakeSessionBloc(),
        );

    test('conversões', () {
      final c = build();
      expect(c.setValueDigitalPreferences('digital'), isTrue);
      expect(c.setValueDigitalPreferences('printed'), isFalse);
      expect(c.setValueDigitalPreferences('printed_digital'), isTrue);
      expect(c.setValuePrintedPreferences('digital'), isFalse);
      expect(c.setValuePrintedPreferences('printed'), isTrue);
      expect(c.setValuePrintedPreferences(null), isTrue);
      expect(c.setValueEntityFromBooleans(true, false), 'digital');
      expect(c.setValueEntityFromBooleans(false, true), 'printed');
      expect(c.setValueEntityFromBooleans(true, true), 'printed_digital');
    });

    test('getZeroPaper', () async {
      var states = await _collect(
        bloc,
        build(
          get: _FakeGetZero(
            entity: PreferencesZeroPaperEntity(
              deliveryAnnouncements: 'printed',
              deliveryActs: 'digital',
              deliverySlips: 'printed_digital',
            ),
          ),
        ).getZeroPaper,
      );
      final loaded = states.last as PreferencesZeroPaperLoadedState;
      expect(loaded.printedAnnouncements, isTrue);
      expect(loaded.digitalAnnouncements, isFalse);
      expect(loaded.digitalActs, isTrue);
      expect(loaded.printedSlips, isTrue);
      expect(loaded.digitalSlips, isTrue);

      states = await _collect(bloc, build(get: _FakeGetZero(fail: true)).getZeroPaper);
      expect(states.last, const PreferencesZeroPaperFailureState(error: ''));

      final semCondo = FakeSessionBloc(
        session: testSession(me: testMe(condominiums: [Condominium(blocks: [testBlock()])])),
      );
      states = await _collect(bloc, build(session: semCondo).getZeroPaper);
      expect(states.last, const PreferencesZeroPaperFailureState(error: ''));
    });

    test('putZeroPaper', () async {
      final put = _FakePutZero();
      final loaded = PreferencesZeroPaperLoadedState(
        preferences: PreferencesZeroPaperEntity(),
        digitalAnnouncements: false,
        printedAnnouncements: true,
        digitalStatements: true,
        printedStatements: true,
      );
      var states = await _collect(bloc, () => build(put: put).putZeroPaper(loaded, true));
      expect(states.last, const PreferencesZeroPaperSuccessState());
      final zero = put.entity!.zeroPaper!;
      expect(zero.deliveryAnnouncements, 'printed');
      expect(zero.deliveryActs, 'digital');
      expect(zero.deliveryStatements, 'printed_digital');
      expect(zero.allUnits, isTrue);

      states = await _collect(bloc, () => build(put: _FakePutZero(fail: true)).putZeroPaper(loaded, false));
      expect(states.last, const PreferencesZeroPaperFailureState(error: ''));
    });
  });

  group('PreferencesNotificationController', () {
    late PreferencesNotificationBloc bloc;
    setUp(() => bloc = PreferencesNotificationBloc());
    tearDown(() => bloc.close());

    PreferencesNotificationController build({bool failGet = false, bool failPut = false, FakeSessionBloc? session}) =>
        PreferencesNotificationController(
          bloc: bloc,
          getNotificationUseCase: _FakeGetNotif(fail: failGet),
          putNotificationUseCase: _FakePutNotif(fail: failPut),
          sessionBloc: session ?? FakeSessionBloc(),
        );

    test('getPreferences', () async {
      var states = await _collect(bloc, build().getPreferences);
      expect((states.last as PreferencesNotificationLoadedState).preferences.single.module, 'mkt');
      states = await _collect(bloc, build(failGet: true).getPreferences);
      expect(states.last, const PreferencesNotificationFailureState(error: ''));
      final semCondo = FakeSessionBloc(
        session: testSession(me: testMe(condominiums: [Condominium(blocks: [testBlock()])])),
      );
      states = await _collect(bloc, build(session: semCondo).getPreferences);
      expect(states.last, const PreferencesNotificationFailureState(error: ''));
    });

    test('putPreferences', () async {
      const loaded = PreferencesNotificationLoadedState(preferences: []);
      var states = await _collect(bloc, () => build().putPreferences(loaded));
      expect(states.last, const PreferencesNotificationSuccessState());
      states = await _collect(bloc, () => build(failPut: true).putPreferences(loaded));
      expect(states.last, const PreferencesNotificationFailureState(error: ''));
    });
  });
}
