import 'dart:convert';

import 'package:chopper/chopper.dart' show Response;
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:morar/feature/digital_meeting/data/data_source/digital_meeting_api.dart';
import 'package:morar/feature/digital_meeting/data/data_source/digital_meeting_remote_data_source.dart';
import 'package:morar/feature/digital_meeting/data/data_source/digital_meeting_remote_data_source_impl.dart';
import 'package:morar/feature/digital_meeting/data/model/digital_meeting_model.dart';
import 'package:morar/feature/digital_meeting/data/repository/digital_meeting_repository_impl.dart';
import 'package:morar/feature/digital_meeting/domain/entity/digital_meeting.dart';
import 'package:morar/feature/digital_meeting/domain/repository/digital_meeting_repository.dart';
import 'package:morar/feature/digital_meeting/domain/use_case/get_assemblies/get_assemblies.dart';
import 'package:morar/feature/digital_meeting/domain/use_case/get_assemblies/get_assemblies_impl.dart';
import 'package:morar/feature/digital_meeting/domain/use_case/get_assembly/get_assembly.dart';
import 'package:morar/feature/digital_meeting/domain/use_case/get_assembly/get_assembly_impl.dart';
import 'package:morar/feature/digital_meeting/presentation/bloc/digital_meeting_bloc.dart';
import 'package:morar/feature/digital_meeting/presentation/bloc/digital_meeting_event.dart';
import 'package:morar/feature/digital_meeting/presentation/bloc/digital_meeting_state.dart';
import 'package:morar/feature/digital_meeting/presentation/controller/digital_meeting_controller.dart';

import '../../helpers/firebase_mocks.dart';
import '../../helpers/fixtures.dart';

class MockApi extends Mock implements DigitalMeetingApi {}

DigitalMeeting _meeting({DateTime? validUntil, String? hash = 'hash'}) => DigitalMeeting()
  ..idMeeting = 'm1'
  ..name = 'Assembleia'
  ..dateStat = DateTime(2026, 1, 5, 14, 5)
  ..dateFinish = DateTime(2026, 1, 5, 16, 30)
  ..dateVirtualMeeting = DateTime(2026, 1, 6, 9)
  ..tokenHash = hash
  ..link = 'https://zoom'
  ..validtUntul = validUntil;

class _FakeDataSource extends Fake implements DigitalMeetingRemoteDataSource {
  _FakeDataSource({this.fail = false});
  final bool fail;

  @override
  Future<List<DigitalMeetingModel>> getMeetings(
      {bool showAll = false, required String unitId}) async {
    if (fail) throw Exception('x');
    return [DigitalMeetingModel()..idMeeting = '$unitId-$showAll'];
  }

  @override
  Future<DigitalMeetingModel> getMeetingData(String tokenHash) async {
    if (fail) throw Exception('x');
    return DigitalMeetingModel()..tokenHash = tokenHash;
  }
}

class _FakeRepository extends Fake implements DigitalMeetingRepository {
  final calls = <String>[];
  @override
  Future<Try<List<DigitalMeeting>>> getMeelings(
      {bool showAll = false, required String unitId}) async {
    calls.add('list:$unitId:$showAll');
    return Success([_meeting()]);
  }

  @override
  Future<Try<DigitalMeeting>> getMeetingData(String tokenHash) async {
    calls.add('data:$tokenHash');
    return Success(_meeting());
  }
}

class _FakeGetMeetings extends Fake implements GetMeetings {
  _FakeGetMeetings({this.fail = false, this.empty = false});
  final bool fail;
  final bool empty;
  @override
  Future<Try<List<DigitalMeeting>>> call(GetMeetingsParams params) async {
    if (fail) return Rejection(UnknownFailure('erro'));
    if (empty) return Success(const []);
    return Success([_meeting()]);
  }
}

class _FakeGetData extends Fake implements GetMeetingDataUseCase {
  _FakeGetData({this.fail = false});
  final bool fail;
  final calls = <String>[];
  @override
  Future<Try<DigitalMeeting>> call(GetMeetingDataParams params) async {
    calls.add(params.tokenHash);
    if (fail) return Rejection(UnknownFailure('erro'));
    return Success(_meeting());
  }
}

Future<List<DigitalMeetingState>> _collect(
    DigitalMeetingBloc bloc, Future<void> Function() run) async {
  final states = <DigitalMeetingState>[];
  final sub = bloc.stream.listen(states.add);
  await run();
  await Future<void>.delayed(Duration.zero);
  await sub.cancel();
  return states;
}

void main() {
  setUpAll(() async {
    await setUpFakeFirebase();
  });

  test('DigitalMeeting formata datas', () {
    final meeting = _meeting();
    final inicio = DateFormat.yMd().format(meeting.dateStat!);
    final hora = DateFormat.jm().format(meeting.dateStat!);
    expect(meeting.inicio, '$inicio às $hora');
    expect(meeting.fim, contains(DateFormat.yMd().format(meeting.dateFinish!)));
    expect(meeting.reuniao, contains(DateFormat.yMd().format(meeting.dateVirtualMeeting!)));
    expect(meeting.validandoAcesso, isFalse);
    expect(_meeting(validUntil: DateTime(2026)).validandoAcesso, isTrue);
    meeting.dateVirtualMeeting = DateTime.fromMillisecondsSinceEpoch(0);
    expect(meeting.reuniao, '');
    meeting.dateVirtualMeeting = null;
    expect(meeting.reuniao, '');
  });

  test('DigitalMeetingModel round trip', () {
    final model = DigitalMeetingModel.fromEntity(_meeting(validUntil: DateTime(2026, 2)))!
      ..idMeetingUser = 'mu'
      ..cNPJ = '1';
    final json = jsonDecode(jsonEncode(model.toJson())) as Map<String, dynamic>;
    expect(json['id_meeting'], 'm1');
    expect(json['c_n_p_j'], '1');
    final back = DigitalMeetingModel.fromJson(json);
    final entity = back.toEntity();
    expect(entity.name, 'Assembleia');
    expect(entity.validtUntul, DateTime(2026, 2));
    expect(entity.idMeetingUser, isNull);
    expect(back.toString(), contains('idMeeting: m1'));
    expect(DigitalMeetingModel.fromEntity(null), isNull);
  });

  test('use cases', () async {
    final repo = _FakeRepository();
    final list = GetMeetingsImpl(repository: repo);
    expect((await list(GetMeetingsParams(unitId: ''))).fold((f) => f, (_) => null),
        isA<InvalidParamFailure>());
    await list(GetMeetingsParams(unitId: 'u', showAll: true));
    final data = GetMeetingDataImpl(repository: repo);
    expect((await data(GetMeetingDataParams(''))).fold((f) => f, (_) => null),
        isA<InvalidParamFailure>());
    await data(GetMeetingDataParams('h'));
    expect(repo.calls, ['list:u:true', 'data:h']);
    expect(GetMeetingsParams(unitId: 'u').toString(), contains('showAll: false'));
  });

  test('repository', () async {
    final ok = DigitalMeetingRepositoryImpl(dataSource: _FakeDataSource());
    expect((await ok.getMeelings(unitId: 'u', showAll: true)).fold((_) => null, (l) => l.single.idMeeting),
        'u-true');
    expect((await ok.getMeetingData('h')).fold((_) => null, (m) => m.tokenHash), 'h');
    final bad = DigitalMeetingRepositoryImpl(dataSource: _FakeDataSource(fail: true));
    expect((await bad.getMeelings(unitId: 'u')).fold((f) => f, (_) => null), isA<UnknownFailure>());
    expect((await bad.getMeetingData('h')).fold((f) => f, (_) => null), isA<UnknownFailure>());
  });

  test('data source', () async {
    final api = MockApi();
    final ds = DigitalMeetingRemoteDataSourceImpl(api: api);
    when(() => api.getMeetings(false, 'u')).thenAnswer(
      (_) async => Response<dynamic>(http.Response(jsonEncode([{'id_meeting': '1'}]), 200), null),
    );
    when(() => api.getMeetingData('h')).thenAnswer(
      (_) async => Response<dynamic>(http.Response(jsonEncode({'token_hash': 'h'}), 200), null),
    );
    expect((await ds.getMeetings(unitId: 'u')).single.idMeeting, '1');
    expect((await ds.getMeetingData('h')).tokenHash, 'h');
  });

  test('bloc', () async {
    final bloc = DigitalMeetingBloc();
    expect(bloc.state, const DigitalMeetingInitialState());
    final meeting = _meeting();
    final states = await _collect(bloc, () async {
      bloc
        ..add(const DigitalMeetingLoadingEvent())
        ..add(DigitalMeetingLoadedEvent(meetings: [meeting]))
        ..add(DigitalMeetingShowAllEvent(meetings: [meeting]))
        ..add(DigitalMeetingWebViewEvent(meeting: meeting))
        ..add(const DigitalMeetingFailureAssembliesEvent(message: 'a'))
        ..add(const DigitalMeetingFailureEvent(message: 'b'))
        ..add(const DigitalMeetingEmptyEvent());
    });
    await bloc.close();
    expect(states, [
      const DigitalMeetingLoadingState(),
      DigitalMeetingLoadedState(meetings: [meeting]),
      DigitalMeetingShowAllState(meetings: [meeting]),
      DigitalMeetingWebViewState(meeting: meeting),
      const DigitalMeetingFailureAssembliesState(message: 'a'),
      const DigitalMeetingFailureState(message: 'b'),
      const DigitalMeetingInitialState(),
    ]);
    expect(DigitalMeetingWebViewEvent(meeting: meeting).props, [meeting]);
    expect(const DigitalMeetingFailureAssembliesEvent(message: 'a').props, ['a']);
  });

  group('controller', () {
    late DigitalMeetingBloc bloc;
    setUp(() => bloc = DigitalMeetingBloc());
    tearDown(() => bloc.close());

    DigitalMeetingController build({_FakeGetMeetings? list, _FakeGetData? data}) =>
        DigitalMeetingController(
          getMeetingsUsecase: list ?? _FakeGetMeetings(),
          getMeetingDataUsecase: data ?? _FakeGetData(),
          sessionBloc: FakeSessionBloc(),
          bloc: bloc,
        );

    test('getMeetings', () async {
      fakeAnalytics.reset();
      var states = await _collect(bloc, build().getMeetings);
      expect(states.last, isA<DigitalMeetingLoadedState>());
      expect(fakeAnalytics.eventNames, contains('resolva_facil_assembleia_acessar'));
      states = await _collect(bloc, build(list: _FakeGetMeetings(empty: true)).getMeetings);
      expect(states.last, const DigitalMeetingInitialState());
      states = await _collect(bloc, build(list: _FakeGetMeetings(fail: true)).getMeetings);
      expect(states.last, isA<DigitalMeetingFailureState>());
    });

    test('getAllMeetings', () async {
      var states = await _collect(bloc, build().getAllMeetings);
      expect(states.last, isA<DigitalMeetingShowAllState>());
      states = await _collect(bloc, build(list: _FakeGetMeetings(empty: true)).getAllMeetings);
      expect(states.last, const DigitalMeetingFailureState(message: ''));
      states = await _collect(bloc, build(list: _FakeGetMeetings(fail: true)).getAllMeetings);
      expect(states.last, isA<DigitalMeetingFailureState>());
    });

    test('getWebView usa token válido ou busca novo', () async {
      final data = _FakeGetData();
      final soon = _meeting(validUntil: DateTime.now().add(const Duration(minutes: 5)));
      var states = await _collect(bloc, () => build(data: data).getWebView(meeting: soon));
      expect(states.last, DigitalMeetingWebViewState(meeting: soon));
      expect(data.calls, isEmpty);

      final later = _meeting(validUntil: DateTime.now().add(const Duration(hours: 2)));
      fakeAnalytics.reset();
      states = await _collect(bloc, () => build(data: data).getWebView(meeting: later));
      expect(states.last, DigitalMeetingWebViewState(meeting: later));
      expect(data.calls, ['hash']);
      expect(fakeAnalytics.eventNames, contains('resolva_facil_assembleia_participarzoom'));

      states = await _collect(
          bloc, () => build(data: _FakeGetData(fail: true)).getWebView(meeting: later));
      expect(states.last, isA<DigitalMeetingFailureState>());
    });
  });
}
