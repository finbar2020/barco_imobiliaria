import 'dart:convert';
import 'dart:typed_data';

import 'package:chopper/chopper.dart' show Response;
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:essentials/paginator/meta.dart';
import 'package:essentials/paginator/meta_model.dart';
import 'package:essentials/paginator/paginator.dart';
import 'package:essentials/paginator/paginator_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:morar/feature/mailing/data/data_source/mailing_api.dart';
import 'package:morar/feature/mailing/data/data_source/mailing_remote_data_source.dart';
import 'package:morar/feature/mailing/data/data_source/mailing_remote_data_source_impl.dart';
import 'package:morar/feature/mailing/data/model/mailing_model.dart';
import 'package:morar/feature/mailing/data/repository/mailing_repository_impl.dart';
import 'package:morar/feature/mailing/domain/entity/mailing.dart';
import 'package:morar/feature/mailing/domain/repository/mailing_repository.dart';
import 'package:morar/feature/mailing/domain/use_case/get_mailing_picture_impl.dart';
import 'package:morar/feature/mailing/domain/use_case/mailings.dart';
import 'package:morar/feature/mailing/domain/use_case/mailings_impl.dart';
import 'package:morar/feature/mailing/presentation/bloc/mailing_bloc.dart';
import 'package:morar/feature/mailing/presentation/bloc/mailing_event.dart';
import 'package:morar/feature/mailing/presentation/bloc/mailing_state.dart';
import 'package:morar/feature/mailing/presentation/controllers/mailing_controller.dart';
import 'package:morar/feature/me/domain/entity/condominium.dart';

import '../../helpers/firebase_mocks.dart';
import '../../helpers/fixtures.dart';

class MockMailingApi extends Mock implements MailingApi {}

class _FakeDataSource extends Fake implements MailingRemoteDataSource {
  _FakeDataSource({this.fail = false});
  final bool fail;

  @override
  Future<PaginatorModel> getMailings(String unitId,
      {bool showAll = false}) async {
    if (fail) throw Exception('x');
    return PaginatorModel(meta: MetaModel(totalItems: 1), data: [
      {'id': unitId, 'status': showAll ? 'RETIRADA' : 'PENDENTE'}
    ]);
  }

  @override
  Future<Uint8List?> getPicture(String hash) async {
    if (fail) throw Exception('x');
    return Uint8List.fromList([1, 2, 3]);
  }
}

class _FakeRepository extends Fake implements MailingRepository {
  final calls = <Object?>[];

  @override
  Future<Try<Paginator>> getMailings(String unityId,
      {bool showAll = false}) async {
    calls.add([unityId, showAll]);
    return Success(Paginator(data: const []));
  }

  @override
  Future<Try<Uint8List?>> getPicture(String hash) async {
    calls.add(hash);
    return Success(Uint8List(2));
  }
}

class _FakeMailingUseCase extends Fake implements MailingUseCase {
  _FakeMailingUseCase({this.paginator, this.fail = false});
  final Paginator? paginator;
  final bool fail;
  MailingParams? params;

  @override
  Future<Try<Paginator>> call(MailingParams p) async {
    params = p;
    if (fail) return Rejection(UnknownFailure('x'));
    return Success(paginator ?? Paginator(data: const [], meta: Meta()));
  }
}

class _FakePicture extends Fake implements GetMailingPictureUseCase {
  _FakePicture({this.bytes, this.fail = false});
  final Uint8List? bytes;
  final bool fail;

  @override
  Future<Try<Uint8List?>> call(GetMailingPictureParams p) async {
    if (fail) return Rejection(UnknownFailure('x'));
    return Success(bytes);
  }
}

Future<List<MailingState>> _collect(
    MailingBloc bloc, Future<void> Function() run) async {
  final states = <MailingState>[];
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

  group('Mailing entity', () {
    test('status e datas', () {
      final mailing = Mailing(
        status: 'PENDENTE',
        arrivalDate: DateTime(2026, 2, 3, 14, 5),
        pickUpDate: DateTime(2026, 2, 4, 9, 30),
      );
      expect(mailing.statusMailing, 'mailing_available');
      expect(mailing.retirado, isFalse);
      expect(mailing.arrivalFullDate,
          DateFormat.yMd().format(DateTime(2026, 2, 3)));
      expect(mailing.arrivalHourMinute, '14:05');
      expect(mailing.pickUpFullDate,
          DateFormat.yMd().format(DateTime(2026, 2, 4)));
      expect(mailing.pickUpHourMinute, '09:30');
      expect(mailing.highlight, isFalse);

      expect(Mailing(status: 'RETIRADA').statusMailing, 'mailing_withdrawn');
      expect(Mailing(status: 'RETIRADA').retirado, isTrue);
      expect(Mailing(status: 'x').statusMailing, '');
      // Sem data de retirada usa o momento atual.
      expect(Mailing().pickUpFullDate, DateFormat.yMd().format(DateTime.now()));
    });
  });

  group('MailingModel', () {
    test('round trip', () {
      final json = {
        'id': 'm1',
        'pick_up_date': '2026-02-04T09:30:00.000',
        'arrival_date': '2026-02-03T14:05:00.000',
        'addressee': 'Ana',
        'category': 'Carta',
        'size': 'P',
        'status': 'PENDENTE',
        'pick_up_resident': 'Bia',
        'notification_parameter': 'np',
        'photo': 'hash',
        'tracking_code': 'BR1',
        'description': 'd',
        'observation': 'o',
      };
      final entity = MailingModel.fromJson(json).toEntity();
      expect(entity.id, 'm1');
      expect(entity.addressee, 'Ana');
      expect(entity.trackingCode, 'BR1');
      expect(entity.pickUpDate, DateTime(2026, 2, 4, 9, 30));
      final back = MailingModel.fromEntity(entity)!.toJson();
      expect(back['photo'], 'hash');
      expect(back['observation'], 'o');
      expect(MailingModel.fromEntity(null), isNull);
    });
  });

  group('use cases', () {
    test('MailingUseCaseImpl valida unityId', () async {
      final repo = _FakeRepository();
      final useCase = MailingUseCaseImpl(repository: repo);
      final invalid = await useCase(MailingParams(unityId: ''));
      expect(invalid.fold((f) => f, (_) => null), isA<InvalidParamFailure>());
      final ok = await useCase(MailingParams(unityId: 'u', showAll: true));
      expect(ok.fold((_) => null, (p) => p.data), isEmpty);
      expect(repo.calls.single, ['u', true]);
    });

    test('GetMailingPictureUseCase valida hash', () async {
      final repo = _FakeRepository();
      final useCase = GetMailingPictureUseCase(repository: repo);
      final invalid = await useCase(GetMailingPictureParams(hash: ''));
      expect(invalid.fold((f) => f, (_) => null), isA<InvalidParamFailure>());
      final ok = await useCase(GetMailingPictureParams(hash: 'h'));
      expect(ok.fold((_) => null, (b) => b!.length), 2);
      expect(repo.calls.single, 'h');
    });
  });

  group('MailingRepositoryImpl', () {
    test('sucesso', () async {
      final repo = MailingRepositoryImpl(dataSource: _FakeDataSource());
      final list = await repo.getMailings('u', showAll: true);
      expect(list.fold((_) => null, (p) => p.data.first['status']), 'RETIRADA');
      final pic = await repo.getPicture('h');
      expect(pic.fold((_) => null, (b) => b), [1, 2, 3]);
    });

    test('falha', () async {
      final repo = MailingRepositoryImpl(dataSource: _FakeDataSource(fail: true));
      final list = await repo.getMailings('u');
      expect(list.fold((f) => f, (_) => null), isA<UnknownFailure>());
      final pic = await repo.getPicture('h');
      expect(pic.fold((f) => f, (_) => null), isA<UnknownFailure>());
    });
  });

  group('MailingRemoteDataSourceImpl', () {
    test('getMailings e getPicture', () async {
      final api = MockMailingApi();
      final ds = MailingRemoteDataSourceImpl(api: api);
      when(() => api.fetchMailings('u', false)).thenAnswer(
        (_) async => Response<dynamic>(
          http.Response(jsonEncode({'meta': {'totalItems': 2}, 'data': []}), 200),
          null,
        ),
      );
      when(() => api.getPicture('h')).thenAnswer(
        (_) async => Response<dynamic>(http.Response.bytes([9, 8], 200), null),
      );
      final result = await ds.getMailings('u');
      expect(result.meta!.totalItems, 2);
      expect(await ds.getPicture('h'), [9, 8]);

      when(() => api.fetchMailings('u', true)).thenAnswer(
        (_) async => Response<dynamic>(http.Response('', 500), null, error: 'e'),
      );
      expect(() => ds.getMailings('u', showAll: true), throwsA('e'));
    });
  });

  group('MailingBloc', () {
    test('mapeia eventos', () async {
      final bloc = MailingBloc();
      expect(bloc.state, const MailingInitialState());
      final states = <MailingState>[];
      final sub = bloc.stream.listen(states.add);
      final mailing = Mailing(id: '1');
      bloc
        ..add(const MailingLoadingEvent())
        ..add(MailingSuccessEvent(mailings: [mailing]))
        ..add(const MailingFailureEvent())
        ..add(const MailingEmptyEvent());
      await Future<void>.delayed(Duration.zero);
      await sub.cancel();
      await bloc.close();
      expect(states, [
        const MailingLoadingState(),
        MailingSuccessState(mailings: [mailing]),
        const MailingFailureState(),
        const MailingInitialState(),
      ]);
      expect(MailingSuccessEvent(mailings: [mailing]).props, [
        [mailing]
      ]);
    });
  });

  group('MailingController', () {
    late MailingBloc bloc;

    setUp(() => bloc = MailingBloc());
    tearDown(() => bloc.close());

    MailingController build({
      FakeSessionBloc? session,
      _FakeMailingUseCase? useCase,
      _FakePicture? picture,
    }) =>
        MailingController(
          mailingUseCase: useCase ?? _FakeMailingUseCase(),
          sessionBloc: session ?? FakeSessionBloc(),
          getMailingPictureUseCase: picture ?? _FakePicture(),
          bloc: bloc,
        );

    test('getPicture guarda os bytes', () async {
      final bytes = Uint8List.fromList([1]);
      final controller = build(picture: _FakePicture(bytes: bytes));
      expect(await controller.getPicture(hash: 'h'), bytes);
      expect(controller.picture, bytes);
      expect(await build(picture: _FakePicture()).getPicture(hash: 'h'), isNull);
      expect(await build(picture: _FakePicture(fail: true)).getPicture(hash: 'h'),
          isNull);
    });

    test('getMailings sem condomínio falha', () async {
      final me = testMe(condominiums: [Condominium(blocks: [testBlock()])]);
      final controller = build(session: FakeSessionBloc(session: testSession(me: me)));
      final states = await _collect(bloc, controller.getMailings);
      expect(states, [const MailingLoadingState(), const MailingFailureState()]);
    });

    test('getMailings carrega e loga analytics', () async {
      final useCase = _FakeMailingUseCase(
        paginator: Paginator(meta: Meta(totalItems: 5), data: [
          {'id': 'a', 'status': 'PENDENTE'},
        ]),
      );
      final controller = build(useCase: useCase);
      fakeAnalytics.reset();
      final states = await _collect(bloc, () => controller.getMailings(showAll: true));
      expect(states.last, isA<MailingSuccessState>());
      expect(controller.totalItems, 5);
      expect(controller.mailings.single.id, 'a');
      expect(useCase.params!.unityId, 'u1');
      expect(useCase.params!.showAll, isTrue);
      expect(controller.session.condominium!.id, 'c1');
      expect(fakeAnalytics.eventNames, contains('correspondencia_acessar'));
    });

    test('getMailings vazio, falha e payload inválido', () async {
      var states = await _collect(bloc, build().getMailings);
      expect(states.last, const MailingInitialState());

      states = await _collect(
          bloc, build(useCase: _FakeMailingUseCase(fail: true)).getMailings);
      expect(states.last, const MailingFailureState());

      states = await _collect(
        bloc,
        build(useCase: _FakeMailingUseCase(paginator: Paginator(data: [1])))
            .getMailings,
      );
      expect(states.last, const MailingFailureState());
    });
  });
}
