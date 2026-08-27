import 'dart:convert';

import 'package:chopper/chopper.dart' show Response;
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:morar/feature/tdb/data/data_source/tdb_api.dart';
import 'package:morar/feature/tdb/data/data_source/tdb_remote_data_source.dart';
import 'package:morar/feature/tdb/data/data_source/tdb_remote_data_source_impl.dart';
import 'package:morar/feature/tdb/data/model/tdb_info_model.dart';
import 'package:morar/feature/tdb/data/model/tdb_param_model.dart';
import 'package:morar/feature/tdb/data/repository/tdb_repository_impl.dart';
import 'package:morar/feature/tdb/domain/entity/tdb_info.dart';
import 'package:morar/feature/tdb/domain/entity/tdb_param.dart';
import 'package:morar/feature/tdb/domain/repository/tdb_repository.dart';
import 'package:morar/feature/tdb/domain/use_case/get_tdb_info/get_tdb_info.dart';
import 'package:morar/feature/tdb/domain/use_case/get_tdb_info/get_tdb_info_impl.dart';
import 'package:morar/feature/tdb/presentation/bloc/tdb_bloc.dart';
import 'package:morar/feature/tdb/presentation/bloc/tdb_event.dart';
import 'package:morar/feature/tdb/presentation/bloc/tdb_state.dart';
import 'package:morar/feature/tdb/presentation/controllers/tdb_controller.dart';

import '../../helpers/firebase_mocks.dart';
import '../../helpers/fixtures.dart';

class MockTDBApi extends Mock implements TDBApi {}

class _FakeDataSource extends Fake implements TDBRemoteDataSource {
  _FakeDataSource({this.fail = false});
  final bool fail;

  @override
  Future<TDBInfoModel> getTDBInfo(String condominiumId) async {
    if (fail) throw Exception('x');
    return TDBInfoModel(redirectLink: 'https://$condominiumId');
  }
}

class _FakeRepository extends Fake implements TDBRepository {
  String? id;
  @override
  Future<Try<TDBInfo>> getTDBInfo(String condominiumId) async {
    id = condominiumId;
    return Success(TDBInfo(redirectLink: 'l', information: const []));
  }
}

class _FakeUseCase extends Fake implements GetTDBInfoUseCase {
  _FakeUseCase({this.fail = false});
  final bool fail;
  GetTDBInfoParam? param;

  @override
  Future<Try<TDBInfo>> call(GetTDBInfoParam p) async {
    param = p;
    if (fail) return Rejection(UnknownFailure('x'));
    return Success(TDBInfo(redirectLink: 'https://tdb', information: const []));
  }
}

void main() {
  setUpAll(() async {
    await setUpFakeFirebase();
  });

  group('TDBInfo', () {
    test('urlAndQueries monta query e headers', () {
      final info = TDBInfo(
        redirectLink: 'https://host.com/path/a',
        information: [
          TDBParam(type: 'QUERY', nameParam: 'token', param: 't1'),
          TDBParam(type: 'HEADER', nameParam: 'Auth', param: 'h1'),
          null,
        ],
      );
      final uri = info.urlAndQueries!;
      expect(uri.scheme, 'https');
      expect(uri.host, 'host.com');
      expect(uri.path, '/path/a');
      expect(uri.queryParameters, {'token': 't1'});
      expect(info.headers, {'Auth': 'h1'});
      expect(info.redirectLinkURL, Uri.parse('https://host.com/path/a'));
    });

    test('sem scheme assume https e sem path só host', () {
      final info = TDBInfo(redirectLink: 'host.com', information: const []);
      final uri = info.urlAndQueries!;
      expect(uri.scheme, 'https');
      expect(uri.host, 'host.com');
      expect(uri.path, '');
      expect(TDBInfo(redirectLink: '', information: const []).urlAndQueries,
          isNull);
    });
  });

  group('models', () {
    test('round trip', () {
      final json = {
        'redirect_link': 'https://x',
        'information': [
          {'type': 'QUERY', 'name_param': 'a', 'param': 'b'}
        ],
      };
      final entity = TDBInfoModel.fromJson(json).toEntity();
      expect(entity.redirectLink, 'https://x');
      expect(entity.information.single!.nameParam, 'a');
      final back = TDBInfoModel.fromEntity(entity)!;
      expect(jsonDecode(jsonEncode(back.toJson())), json);
      expect(TDBInfoModel.fromEntity(null), isNull);
      expect(TDBParamModel.fromEntity(null), isNull);
      expect(
        TDBInfoModel.fromEntity(TDBInfo(redirectLink: '', information: const []))!
            .information,
        isEmpty,
      );
      expect(TDBInfoModel().toEntity().information, isEmpty);
      expect(TDBParamModel.fromJson({'type': 'H', 'name_param': 'n', 'param': 'p'})
          .toEntity()
          .param, 'p');
    });
  });

  test('use case valida e delega', () async {
    final repo = _FakeRepository();
    final useCase = GetTDBInfoUseCaseImpl(repository: repo);
    final invalid = await useCase(GetTDBInfoParam(condominiumId: ''));
    expect(invalid.fold((f) => f, (_) => null), isA<InvalidParamFailure>());
    final ok = await useCase(GetTDBInfoParam(condominiumId: 'c'));
    expect(ok.fold((_) => null, (t) => t.redirectLink), 'l');
    expect(repo.id, 'c');
  });

  test('repository', () async {
    final ok = await TDBRepositoryImpl(remoteDataSource: _FakeDataSource())
        .getTDBInfo('c');
    expect(ok.fold((_) => null, (t) => t.redirectLink), 'https://c');
    final fail =
        await TDBRepositoryImpl(remoteDataSource: _FakeDataSource(fail: true))
            .getTDBInfo('c');
    expect(fail.fold((f) => f, (_) => null), isA<UnknownFailure>());
  });

  test('data source', () async {
    final api = MockTDBApi();
    final ds = TDBRemoteDataSourceImpl(api: api);
    when(() => api.getTDBInfo('c')).thenAnswer(
      (_) async => Response<dynamic>(
        http.Response(jsonEncode({'redirect_link': 'r', 'information': []}), 200),
        null,
      ),
    );
    expect((await ds.getTDBInfo('c')).redirectLink, 'r');
    when(() => api.getTDBInfo('e')).thenAnswer(
      (_) async => Response<dynamic>(http.Response('', 400), null, error: 'bad'),
    );
    expect(() => ds.getTDBInfo('e'), throwsA('bad'));
  });

  test('bloc', () async {
    final bloc = TDBBloc();
    expect(bloc.state, const LoadedTDBState());
    final states = <dynamic>[];
    final sub = bloc.stream.listen(states.add);
    final info = TDBInfo(redirectLink: 'x', information: const []);
    bloc
      ..add(const TDBLoadingEvent())
      ..add(TDBLoadedEvent(tdbInfo: info))
      ..add(const TDBErroEvent(errorMessageKey: 'e'));
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();
    await bloc.close();
    expect(states, [
      const LoadingTDBState(),
      LoadedTDBState(tdbInfo: info),
      const ErrorTDBState(errorMessageKey: 'e'),
    ]);
    expect(TDBLoadedEvent(tdbInfo: info).props, [info]);
  });

  group('controller', () {
    test('sucesso loga analytics', () async {
      final bloc = TDBBloc();
      final useCase = _FakeUseCase();
      final controller = TDBController(
        bloc: bloc,
        sessionBloc: FakeSessionBloc(),
        getTDBInfoUseCase: useCase,
      );
      final states = <dynamic>[];
      final sub = bloc.stream.listen(states.add);
      fakeAnalytics.reset();
      await controller.getTDB();
      await Future<void>.delayed(Duration.zero);
      await sub.cancel();
      await bloc.close();
      expect(states.first, const LoadingTDBState());
      expect((states.last as LoadedTDBState).tdbInfo!.redirectLink, 'https://tdb');
      expect(useCase.param!.condominiumId, 'c1');
      expect(fakeAnalytics.eventNames, contains('tdb_cadastrar'));
    });

    test('falha emite erro', () async {
      final bloc = TDBBloc();
      final controller = TDBController(
        bloc: bloc,
        sessionBloc: FakeSessionBloc(),
        getTDBInfoUseCase: _FakeUseCase(fail: true),
      );
      final states = <dynamic>[];
      final sub = bloc.stream.listen(states.add);
      await controller.getTDB();
      await Future<void>.delayed(Duration.zero);
      await sub.cancel();
      await bloc.close();
      expect(states.last, const ErrorTDBState(errorMessageKey: 'tdb_page_error'));
    });
  });
}
