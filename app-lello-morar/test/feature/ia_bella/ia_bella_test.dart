import 'dart:convert';

import 'package:chopper/chopper.dart' show Response;
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/ia_bella/data/data_source/ia_bella_api.dart';
import 'package:morar/feature/ia_bella/data/data_source/ia_bella_remote_data_source.dart';
import 'package:morar/feature/ia_bella/data/data_source/ia_bella_remote_data_source_impl.dart';
import 'package:morar/feature/ia_bella/data/model/ia_bella_data_model.dart';
import 'package:morar/feature/ia_bella/data/model/ia_bella_documents_model.dart';
import 'package:morar/feature/ia_bella/data/model/ia_bella_final_evaluation_model.dart';
import 'package:morar/feature/ia_bella/data/model/ia_bella_message_response_model.dart';
import 'package:morar/feature/ia_bella/data/model/ia_bella_pdf_model.dart';
import 'package:morar/feature/ia_bella/data/model/ia_bella_rate_response_model.dart';
import 'package:morar/feature/ia_bella/data/model/ia_bella_send_message_model.dart';
import 'package:morar/feature/ia_bella/data/model/ia_start_session_model.dart';
import 'package:morar/feature/ia_bella/data/repository/ia_bella_repository_impl.dart';
import 'package:morar/feature/ia_bella/domain/entity/bella_deeplink_enum.dart';
import 'package:morar/feature/ia_bella/domain/entity/bella_message_entity.dart';
import 'package:morar/feature/ia_bella/domain/entity/ia_bella_data_entity.dart';
import 'package:morar/feature/ia_bella/domain/entity/ia_bella_documents_entity.dart';
import 'package:morar/feature/ia_bella/domain/entity/ia_bella_final_evaluation_entity.dart';
import 'package:morar/feature/ia_bella/domain/entity/ia_bella_message_response_entity.dart';
import 'package:morar/feature/ia_bella/domain/entity/ia_bella_pdf_entity.dart';
import 'package:morar/feature/ia_bella/domain/entity/ia_bella_rate_response_entity.dart';
import 'package:morar/feature/ia_bella/domain/entity/ia_bella_send_message_entity.dart';
import 'package:morar/feature/ia_bella/domain/entity/ia_bella_start_session_entity.dart';
import 'package:morar/feature/ia_bella/domain/repository/ia_bella_repository.dart';
import 'package:morar/feature/ia_bella/domain/use_case/download_pdf/ia_bella_pdf_use_case_impl.dart';
import 'package:morar/feature/ia_bella/domain/use_case/download_pdf/ia_bella_pdf_user_case.dart';
import 'package:morar/feature/ia_bella/domain/use_case/final_evaluation/ia_bella_final_evaluation_use_case.dart';
import 'package:morar/feature/ia_bella/domain/use_case/final_evaluation/ia_bella_final_evaluation_use_case_impl.dart';
import 'package:morar/feature/ia_bella/domain/use_case/rate_response/ia_bella_rate_response_use_case.dart';
import 'package:morar/feature/ia_bella/domain/use_case/rate_response/ia_bella_rate_response_use_case_impl.dart';
import 'package:morar/feature/ia_bella/domain/use_case/send_message/ia_bella_send_message_use_case.dart';
import 'package:morar/feature/ia_bella/domain/use_case/send_message/ia_bella_send_message_use_case_impl.dart';
import 'package:morar/feature/ia_bella/domain/use_case/start_session/ia_bella_start_session_use_case.dart';
import 'package:morar/feature/ia_bella/domain/use_case/start_session/ia_bella_start_session_use_case_impl.dart';
import 'package:morar/feature/ia_bella/presentation/bloc/ia_bella_bloc.dart';
import 'package:morar/feature/ia_bella/presentation/bloc/ia_bella_event.dart';
import 'package:morar/feature/ia_bella/presentation/bloc/ia_bella_state.dart';
import 'package:morar/feature/ia_bella/presentation/controllers/bella_feature_redirect_handler.dart';
import 'package:morar/feature/ia_bella/presentation/controllers/ia_bella_controller.dart';
import 'package:shared_features/feature/notifications/domain/entities/features_routes_enum.dart';

import '../../helpers/firebase_mocks.dart';
import '../../helpers/fixtures.dart';
import '../../helpers/pump_app.dart';

class MockApi extends Mock implements IaBellaApi {}

IaBellaDataEntity _data({String? uuid = 'sess', String? response = 'resposta', List<IaBellaDocumentsEntity?> docs = const []}) =>
    IaBellaDataEntity(responseId: 'r1', uuidSession: uuid, welcomeMessage: 'olá', response: response, documents: docs);

class _FakeDataSource extends Fake implements IaBellaRemoteDataSource {
  _FakeDataSource({this.fail = false});
  final bool fail;
  @override
  Future<IaBellaDataModel> startSession(String condoId) async {
    if (fail) throw Exception('x');
    return IaBellaDataModel(uuidSession: condoId);
  }

  @override
  Future<IaBellaDataModel> sendMessage(String condoId, IaBellaSendMessageModel userInput) async {
    if (fail) throw Exception('x');
    return IaBellaDataModel(response: 'eco ${userInput.question}');
  }

  @override
  Future<IaBellaPdfModel> downloadPdf(String condoId, String documentId, String serviceType) async {
    if (fail) throw Exception('x');
    return IaBellaPdfModel(fileName: '$documentId.pdf', content: 'YQ==');
  }

  @override
  Future<IaBellaRateResponseModel> evaluate(String condoId, IaBellaRateResponseModel userRate) async {
    if (fail) throw Exception('x');
    return userRate;
  }

  @override
  Future<IaBellaFinalEvaluationModel> finalEvaluation(String condoId, IaBellaFinalEvaluationModel messageEvaluation) async {
    if (fail) throw Exception('x');
    return messageEvaluation;
  }
}

class _FakeRepository extends Fake implements IaBellaRepository {
  _FakeRepository({this.failure, this.startData, this.sendData, this.pdf, this.failSend = false});
  final Failure? failure;
  final bool failSend;
  final IaBellaDataEntity? startData;
  final IaBellaDataEntity? sendData;
  final IaBellaPdfEntity? pdf;
  final calls = <String>[];

  @override
  Future<Try<IaBellaDataEntity>> startSession(String condoId) async {
    calls.add('start:$condoId');
    if (failure != null) return Rejection(failure!);
    return Success(startData ?? _data());
  }

  @override
  Future<Try<IaBellaDataEntity>> sendMessage(String condoId, IaBellaSendMessageModel userInput) async {
    calls.add('send:${userInput.question}:${userInput.uuidSession}');
    if (failure != null || failSend) return Rejection(failure ?? UnknownFailure('send'));
    return Success(sendData ?? _data());
  }

  @override
  Future<Try<IaBellaPdfEntity>> downloadPdf(String condoId, String documentId, String serviceType) async {
    calls.add('pdf:$documentId:$serviceType');
    if (failure != null) return Rejection(failure!);
    return Success(pdf ?? IaBellaPdfEntity(fileName: 'f.pdf', content: 'YQ=='));
  }

  @override
  Future<Try<IaBellaRateResponseEntity>> evaluate(String condoId, IaBellaRateResponseModel userRate) async {
    calls.add('rate:${userRate.responseId}:${userRate.evaluationType}');
    if (failure != null) return Rejection(failure!);
    return Success(userRate.toEntity());
  }

  @override
  Future<Try<IaBellaFinalEvaluationEntity>> finalEvaluation(String condoId, IaBellaFinalEvaluationModel messageEvaluation) async {
    calls.add('final:${messageEvaluation.evaluation}');
    if (failure != null) return Rejection(failure!);
    return Success(messageEvaluation.toEntity());
  }
}

Future<List<IaBellaState>> _collect(IaBellaBloc bloc, Future<void> Function() run) async {
  final states = <IaBellaState>[];
  final sub = bloc.stream.listen(states.add);
  await run();
  await Future<void>.delayed(const Duration(milliseconds: 20));
  await sub.cancel();
  return states;
}

void main() {
  setUpAll(() async {
    await setUpFakeFirebase();
    FlavorConfig.init();
    await initializeDateFormatting('pt_BR');
  });

  test('entidades copyWith', () {
    expect(_data().copyWith(response: 'x').response, 'x');
    expect(_data().copyWith().uuidSession, 'sess');
    expect(IaBellaDocumentsEntity(id: '1').copyWith(description: 'd').description, 'd');
    expect(IaBellaFinalEvaluationEntity(evaluation: 1).copyWith(comment: 'c').comment, 'c');
    expect(IaBellaMessageResponseEntity(statusCode: 1).copyWith(errorMessage: 'e').errorMessage, 'e');
    expect(IaBellaPdfEntity(content: 'c').copyWith(fileName: 'f').fileName, 'f');
    expect(IaBellaRateResponseEntity(responseId: 'r').copyWith(justification: 'j').justification, 'j');
    expect(IaBellaSendMessageEntity(message: 'm').copyWith(sessionId: 's').sessionId, 's');
    expect(IaBellaStartSessionEntity(statusCode: 200).copyWith(timestamp: 't').timestamp, 't');
    expect(BellaMessageEntity(text: 't').isUser, isFalse);
    expect(BellaMessageEntity(text: 't').documents, isEmpty);
    expect(BellaDeeplinkEnum.boletos.featuresRoute, FeaturesRoutesEnum.BOLETOS);
    expect(BellaDeeplinkEnum.acordos.featuresRoute, FeaturesRoutesEnum.ACORDO_PROPOSTA);
    expect(BellaDeeplinkEnum.moradoresCadastrados.featuresRoute, FeaturesRoutesEnum.MORADORES_ACESSOU);
    expect(BellaDeeplinkEnum.minhaConta.featuresRoute, FeaturesRoutesEnum.MINHA_CONTA);
    expect(BellaDeeplinkEnum.trocaTitularidade.featuresRoute, FeaturesRoutesEnum.TROCA_TITULARIDADE);
    expect(BellaDeeplinkEnum.assembleia.featuresRoute, FeaturesRoutesEnum.ASSEMBLEIA);
  });

  test('models round trip', () {
    final data = IaBellaDataModel.fromEntity(_data(docs: [IaBellaDocumentsEntity(id: 'd', description: 'x', serviceType: 'ATA')]))!;
    final json = jsonDecode(jsonEncode(data.toJson())) as Map<String, dynamic>;
    expect(json['documents'][0]['service_type'], 'ATA');
    final back = IaBellaDataModel.fromJson(json).toEntity();
    expect(back.documents.single!.id, 'd');
    expect(IaBellaDataModel.fromEntity(null), isNull);
    expect(IaBellaDataModel().toEntity().documents, isEmpty);
    expect(IaBellaDocumentsModel.fromEntity(null), isNull);
    expect(IaBellaDocumentsModel.fromJson({'id': '1'}).toEntity().id, '1');

    final finalEval = IaBellaFinalEvaluationModel.fromEntity(IaBellaFinalEvaluationEntity(uuidSession: 's', evaluation: 5, comment: 'c', requestResolved: true))!;
    expect(IaBellaFinalEvaluationModel.fromJson(finalEval.toJson()).toEntity().evaluation, 5);
    expect(IaBellaFinalEvaluationModel.fromEntity(null), isNull);

    final msg = IaBellaMessageResponseModel.fromEntity(IaBellaMessageResponseEntity(statusCode: 200, data: _data()))!;
    expect(IaBellaMessageResponseModel.fromJson(jsonDecode(jsonEncode(msg.toJson()))).toEntity().data!.uuidSession, 'sess');
    expect(IaBellaMessageResponseModel.fromEntity(IaBellaMessageResponseEntity())!.data, isNull);
    expect(IaBellaMessageResponseModel.fromEntity(null), isNull);

    final pdf = IaBellaPdfModel.fromEntity(IaBellaPdfEntity(fileName: 'f', content: 'c'))!;
    expect(IaBellaPdfModel.fromJson(pdf.toJson()).toEntity().fileName, 'f');
    expect(IaBellaPdfModel.fromEntity(null), isNull);

    final rate = IaBellaRateResponseModel.fromEntity(IaBellaRateResponseEntity(responseId: 'r', evaluationType: 'POSITIVE'))!;
    expect(IaBellaRateResponseModel.fromJson(rate.toJson()).toEntity().evaluationType, 'POSITIVE');
    expect(IaBellaRateResponseModel.fromEntity(null), isNull);

    final send = IaBellaSendMessageModel.fromEntity(IaBellaSendMessageEntity(message: 'oi', sessionId: 's'))!;
    expect(send.question, 'oi');
    expect(IaBellaSendMessageModel.fromJson(send.toJson()).toEntity().sessionId, 's');
    expect(IaBellaSendMessageModel.fromEntity(null), isNull);

    final start = IaStartSessionModel.fromEntity(IaBellaStartSessionEntity(statusCode: 200, data: _data()))!;
    expect(IaStartSessionModel.fromJson(jsonDecode(jsonEncode(start.toJson()))).toEntity().data!.responseId, 'r1');
    expect(IaStartSessionModel.fromEntity(IaBellaStartSessionEntity())!.data, isNull);
    expect(IaStartSessionModel.fromEntity(null), isNull);
  });

  test('use cases validam', () async {
    final repo = _FakeRepository();
    Failure? f(Try r) => r.fold((e) => e, (_) => null);
    final pdf = IaBellaPdfUseCaseImpl(repository: repo);
    expect(f(await pdf(IaBellaPdfParam(condominiumId: '', documentId: 'd', serviceType: 's'))), isA<InvalidParamFailure>());
    expect(f(await pdf(IaBellaPdfParam(condominiumId: 'c', documentId: '', serviceType: 's'))), isA<InvalidParamFailure>());
    expect(f(await pdf(IaBellaPdfParam(condominiumId: 'c', documentId: 'd', serviceType: ''))), isA<InvalidParamFailure>());
    final finalEval = IaBellaFinalEvaluationUseCaseImpl(repository: repo);
    expect(f(await finalEval(IaBellaFinalEvaluationUseCaseParam(condominiumId: '', messageEvaluation: IaBellaFinalEvaluationModel()))), isA<InvalidParamFailure>());
    expect(f(await finalEval(IaBellaFinalEvaluationUseCaseParam(condominiumId: 'c', messageEvaluation: IaBellaFinalEvaluationModel()))), isA<InvalidParamFailure>());
    expect(f(await finalEval(IaBellaFinalEvaluationUseCaseParam(condominiumId: 'c', messageEvaluation: IaBellaFinalEvaluationModel(uuidSession: 's', evaluation: 0)))), isA<InvalidParamFailure>());
    expect(f(await finalEval(IaBellaFinalEvaluationUseCaseParam(condominiumId: 'c', messageEvaluation: IaBellaFinalEvaluationModel(uuidSession: 's', evaluation: 6)))), isA<InvalidParamFailure>());
    expect(f(await finalEval(IaBellaFinalEvaluationUseCaseParam(condominiumId: 'c', messageEvaluation: IaBellaFinalEvaluationModel(uuidSession: 's', evaluation: 3)))), isA<InvalidParamFailure>());
    final rate = IaBellaRateResponseUseCaseImpl(repository: repo);
    expect(f(await rate(IaBellaRateResponseParam(condominiumId: '', userRate: IaBellaRateResponseModel(responseId: 'r')))), isA<InvalidParamFailure>());
    expect(f(await rate(IaBellaRateResponseParam(condominiumId: 'c', userRate: IaBellaRateResponseModel()))), isA<InvalidParamFailure>());
    final send = IaBellaSendMessageUseCaseImpl(repository: repo);
    expect(f(await send(IaBellaSendMessageParam(condominiumId: '', userInput: IaBellaSendMessageModel(question: 'q')))), isA<InvalidParamFailure>());
    expect(f(await send(IaBellaSendMessageParam(condominiumId: 'c', userInput: IaBellaSendMessageModel()))), isA<InvalidParamFailure>());
    expect(f(await send(IaBellaSendMessageParam(condominiumId: 'c', userInput: IaBellaSendMessageModel(question: '')))), isA<InvalidParamFailure>());
    final start = IaBellaStartSessionUseCaseImpl(repository: repo);
    expect(f(await start(IaBellaStartSessionParam(condominiumId: ''))), isA<InvalidParamFailure>());
    expect(repo.calls, isEmpty);

    await pdf(IaBellaPdfParam(condominiumId: 'c', documentId: 'd', serviceType: 's'));
    await finalEval(IaBellaFinalEvaluationUseCaseParam(condominiumId: 'c', messageEvaluation: IaBellaFinalEvaluationModel(uuidSession: 's', evaluation: 4, requestResolved: true)));
    await rate(IaBellaRateResponseParam(condominiumId: 'c', userRate: IaBellaRateResponseModel(responseId: 'r', evaluationType: 'POSITIVE')));
    await send(IaBellaSendMessageParam(condominiumId: 'c', userInput: IaBellaSendMessageModel(question: 'q', uuidSession: 's')));
    await start(IaBellaStartSessionParam(condominiumId: 'c'));
    expect(repo.calls, ['pdf:d:s', 'final:4', 'rate:r:POSITIVE', 'send:q:s', 'start:c']);
  });

  test('repository', () async {
    final repo = IaBellaRepositoryImpl(remoteDataSource: _FakeDataSource());
    expect((await repo.startSession('c')).fold((_) => null, (d) => d.uuidSession), 'c');
    expect((await repo.sendMessage('c', IaBellaSendMessageModel(question: 'oi'))).fold((_) => null, (d) => d.response), 'eco oi');
    expect((await repo.downloadPdf('c', 'd', 's')).fold((_) => null, (p) => p.fileName), 'd.pdf');
    expect((await repo.evaluate('c', IaBellaRateResponseModel(responseId: 'r'))).fold((_) => null, (e) => e.responseId), 'r');
    expect((await repo.finalEvaluation('c', IaBellaFinalEvaluationModel(evaluation: 2))).fold((_) => null, (e) => e.evaluation), 2);
    final bad = IaBellaRepositoryImpl(remoteDataSource: _FakeDataSource(fail: true));
    expect((await bad.startSession('c')).fold((f) => f, (_) => null), isA<UnknownFailure>());
    expect((await bad.sendMessage('c', IaBellaSendMessageModel())).fold((f) => f, (_) => null), isA<UnknownFailure>());
    expect((await bad.downloadPdf('c', 'd', 's')).fold((f) => f, (_) => null), isA<UnknownFailure>());
    expect((await bad.evaluate('c', IaBellaRateResponseModel())).fold((f) => f, (_) => null), isA<UnknownFailure>());
    expect((await bad.finalEvaluation('c', IaBellaFinalEvaluationModel())).fold((f) => f, (_) => null), isA<UnknownFailure>());
  });

  test('data source', () async {
    final api = MockApi();
    registerFallbackValue(IaBellaSendMessageModel());
    registerFallbackValue(IaBellaRateResponseModel());
    registerFallbackValue(IaBellaFinalEvaluationModel());
    final ds = IaBellaRemoteDataSourceImpl(api: api);
    Response<dynamic> ok(Object body) => Response<dynamic>(http.Response(jsonEncode(body), 200), null);
    when(() => api.startSession('c')).thenAnswer((_) async => ok({'uuid_session': 's'}));
    when(() => api.sendMessage('c', any())).thenAnswer((_) async => ok({'response': 'r'}));
    when(() => api.downloadPdf('c', 'd', 's')).thenAnswer((_) async => ok({'file_name': 'f'}));
    when(() => api.evaluate('c', any())).thenAnswer((_) async => ok({'response_id': 'r'}));
    when(() => api.finalEvaluation('c', any())).thenAnswer((_) async => ok({'evaluation': 5}));
    expect((await ds.startSession('c')).uuidSession, 's');
    expect((await ds.sendMessage('c', IaBellaSendMessageModel())).response, 'r');
    expect((await ds.downloadPdf('c', 'd', 's')).fileName, 'f');
    expect((await ds.evaluate('c', IaBellaRateResponseModel())).responseId, 'r');
    expect((await ds.finalEvaluation('c', IaBellaFinalEvaluationModel())).evaluation, 5);
  });

  test('bloc', () async {
    final bloc = IaBellaBloc();
    expect(bloc.state, const IaBellaInitialState());
    final states = await _collect(bloc, () async {
      bloc
        ..add(const IaBellaStartSessionEvent())
        ..add(const IaBellaSessionStartedEvent('s'))
        ..add(const IaBellaStartSessionErrorEvent())
        ..add(const IaBellaFinalEvaluationEvent())
        ..add(const IaBellaFinalEvaluationErrorEvent())
        ..add(const IaBellaFinalEvaluationSuccessEvent())
        ..add(const IaBellaSendMessageEvent('m'))
        ..add(const IaBellaReceiveMessageEvent('r'))
        ..add(const IaBellaErrorEvent('e'))
        ..add(const IaBellaLoadingEvent())
        ..add(const IaBellaLoadedEvent(['a']))
        ..add(const IaBellaRateMessageEvent('r'))
        ..add(const IaBellaRateMessageSuccessEvent('r'))
        ..add(const IaBellaDownloadPdfEvent('d'))
        ..add(const IaBellaDownloadPdfSuccessEvent('d'))
        ..add(const IaBellaRenderPdfEvent('d'))
        ..add(const IaBellaRenderPdfSuccessEvent('d'));
    });
    await bloc.close();
    expect(states, [
      const IaBellaStartSessionState(),
      const IaBellaLoadedState(['Sessão iniciada! ID: s']),
      const IaBellaStartSessionErrorState(),
      const IaBellaFinalEvaluationState(),
      const IaBellaFinalEvaluationErrorState(),
      const IaBellaFinalEvaluationSuccessState(),
      const IaBellaLoadingState(),
      const IaBellaLoadedState(['r']),
      const IaBellaErrorState('e'),
      const IaBellaLoadingState(),
      const IaBellaLoadedState(['a']),
      const IaBellaLoadingState(),
      const IaBellaRateMessageSuccessState('r'),
      const IaBellaDownloadingState('d'),
      const IaBellaDownloadPdfSuccessState(),
      const IaBellaRenderingPdfState('d'),
      const IaBellaRenderPdfSuccessState('d'),
    ]);
    expect(const IaBellaEmptyEvent().props, isEmpty);
    expect(const IaBellaDownloadingEvent('d').props, ['d']);
    expect(const IaBellaRenderingPdfEvent('d').props, ['d']);
    expect(const IaBellaSessionStartedState('s').props, ['s']);
    expect(const IaBellaSendMessageState('m').props, ['m']);
    expect(const IaBellaReceiveMessageState('r').props, ['r']);
    expect(const IaBellaDownloadPdfState('d').props, ['d']);
    expect(const IaBellaRenderPdfState('d').props, ['d']);
    expect(const IaBellaRateMessageState('r').props, ['r']);
  });

  group('IaBellaController', () {
    late IaBellaBloc bloc;
    setUp(() => bloc = IaBellaBloc());
    tearDown(() => bloc.close());

    IaBellaController build({_FakeRepository? repo}) {
      final r = repo ?? _FakeRepository();
      return IaBellaController(
        sendMessageUseCase: IaBellaSendMessageUseCaseImpl(repository: r),
        startSessionUseCase: IaBellaStartSessionUseCaseImpl(repository: r),
        finalEvaluationUseCase: IaBellaFinalEvaluationUseCaseImpl(repository: r),
        downloadPdfUseCase: IaBellaPdfUseCaseImpl(repository: r),
        rateResponseUseCase: IaBellaRateResponseUseCaseImpl(repository: r),
        sessionBloc: FakeSessionBloc(),
        bloc: bloc,
      );
    }

    test('startSession e helpers', () async {
      final controller = build();
      expect(controller.condoId, 'c1');
      expect(controller.isSessionStartedToday(), isFalse);
      expect(controller.getSessionStartDate(), '');
      var states = await _collect(bloc, controller.startSession);
      expect(states.last, const IaBellaLoadedState(['Sessão iniciada! ID: sess']));
      expect(controller.isSessionStarted, isTrue);
      expect(controller.messages.single.text, 'olá');
      expect(controller.isSessionStartedToday(), isTrue);
      expect(controller.getSessionStartDate(), contains(' de '));
      controller.setSelectedFeedbackRating(4);
      controller.selectedRequestResolved = true;
      controller.resetChat();
      expect(controller.messages, isEmpty);
      expect(controller.isSessionStarted, isFalse);
      expect(controller.selectedFeedbackRating, 0);
      expect(controller.selectedRequestResolved, isNull);

      final semUuid = build(repo: _FakeRepository(startData: _data(uuid: null)));
      states = await _collect(bloc, semUuid.startSession);
      expect(states.last, const IaBellaErrorState('Erro desconhecido'));
      expect(semUuid.messages.single.text, 'Erro desconhecido');

      final failing = build(repo: _FakeRepository(failure: UnknownFailure('x')));
      states = await _collect(bloc, failing.startSession);
      expect(states.last, const IaBellaStartSessionErrorState());
    });

    test('rateResponse', () async {
      final repo = _FakeRepository();
      final controller = build(repo: repo);
      controller.negativeFeedbackController.text = 'ruim';
      expect(await controller.rateResponse('r1', 'ruim', false), isTrue);
      expect(repo.calls.last, 'rate:r1:NEGATIVE');
      expect(controller.negativeFeedbackController.text, '');
      expect(controller.isLoading('r1'), isFalse);
      expect(await controller.rateResponse('r1', null, true), isTrue);
      expect(repo.calls.last, 'rate:r1:POSITIVE');
      expect(await controller.rateResponse('r1', null, null), isTrue);
      expect(repo.calls.last, 'rate:r1:null');
      await waitForState(bloc, (s) => s is IaBellaRateMessageSuccessState);

      final failing = build(repo: _FakeRepository(failure: UnknownFailure('x')));
      expect(await failing.rateResponse('r1', null, true), isFalse);
      await waitForState(bloc, (s) => s is IaBellaErrorState);
    });

    test('finalEvaluation', () async {
      final controller = build();
      await controller.startSession();
      expect(await controller.finalEvaluation(5, 'ótimo', true), isTrue);
      await waitForState(bloc, (s) => s is IaBellaFinalEvaluationSuccessState);
      expect(await controller.finalEvaluation(0, '', true), isFalse);
      await waitForState(bloc, (s) => s is IaBellaErrorState);
    });

    testWidgets('sendMessage substitui a mensagem temporária', (tester) async {
      await pumpApp(tester, const Text('x'));
      final context = tester.element(find.text('x'));
      await tester.runAsync(() async {
        final repo = _FakeRepository(sendData: _data(response: 'oi humano', docs: [IaBellaDocumentsEntity(id: 'd')]));
        final controller = build(repo: repo);
        await controller.startSession();
        controller.messageController.text = 'pergunta';
        await controller.sendMessage(context, BellaMessageEntity(text: 'pergunta', displayText: 'Pergunta', isUser: true));
        expect(controller.messages.map((m) => m.text), ['olá', 'Pergunta', 'oi humano']);
        expect(controller.messages.last.documents, hasLength(1));
        expect(controller.messageController.text, '');
        expect(controller.checkSendMessage, isTrue);
        expect(repo.calls.last, 'send:pergunta:sess');

        await controller.sendMessage(context, BellaMessageEntity(text: ''));
        expect(controller.messages, hasLength(3));

        final failing = build(repo: _FakeRepository(failSend: true));
        await failing.startSession();
        await failing.sendMessage(context, BellaMessageEntity(text: 'q', isUser: true));
        expect(failing.messages.last.text, contains('instabilidade'));
        await waitForState(bloc, (s) => s is IaBellaErrorState);
      });
    });

    test('downloadPdf e renderPdf tratam conteúdo inválido', () async {
      var controller = build(repo: _FakeRepository(pdf: IaBellaPdfEntity(fileName: 'f')));
      var states = await _collect(bloc, () => controller.downloadPdf('d', 's'));
      expect(states.last, const IaBellaErrorState('Erro: O conteúdo do PDF é nulo!'));
      controller = build(repo: _FakeRepository(pdf: IaBellaPdfEntity(fileName: 'f', content: '')));
      states = await _collect(bloc, () => controller.downloadPdf('d', 's'));
      expect(states.last, const IaBellaErrorState('Erro: O conteúdo do PDF está vazio!'));
      controller = build(repo: _FakeRepository(failure: UnknownFailure('x')));
      states = await _collect(bloc, () => controller.downloadPdf('d', 's'));
      expect(states.first, const IaBellaDownloadingState('d'));
      expect(states.last, isA<IaBellaErrorState>());
    });

    testWidgets('renderPdf com falha e conteúdo nulo', (tester) async {
      await pumpApp(tester, const Text('x'));
      final context = tester.element(find.text('x'));
      await tester.runAsync(() async {
        var controller = build(repo: _FakeRepository(failure: UnknownFailure('x')));
        var states = await _collect(bloc, () => controller.renderPdf(context, 'd', 's'));
        expect(states.first, const IaBellaRenderingPdfState('d'));
        expect(states.last, isA<IaBellaErrorState>());
        controller = build(repo: _FakeRepository(pdf: IaBellaPdfEntity(fileName: 'f')));
        states = await _collect(bloc, () => controller.renderPdf(context, 'd', 's'));
        expect(states.last, const IaBellaErrorState('Erro: O conteúdo do PDF é nulo!'));
        controller = build(repo: _FakeRepository(pdf: IaBellaPdfEntity(fileName: 'f', content: '')));
        states = await _collect(bloc, () => controller.renderPdf(context, 'd', 's'));
        expect(states.last, const IaBellaErrorState('Erro: O conteúdo do PDF está vazio!'));
      });
    });
  });

  group('BellaFeatureRedirectHandler', () {
    testWidgets('navega para a rota resolvida', (tester) async {
      final observer = RecordingNavigatorObserver();
      await pumpApp(
        tester,
        const Text('x'),
        navigatorObserver: observer,
        routes: {
          ApplicationRoute.billets: (_) => const Text('boletos'),
          ApplicationRoute.subUser: (_) => const Text('moradores'),
        },
      );
      final context = tester.element(find.text('x'));
      final sessionBloc = FakeSessionBloc();
      expect(BellaFeatureRedirectHandler.redirect(context: context, href: 'boletos', sessionBloc: sessionBloc), isTrue);
      await tester.pumpAndSettle();
      expect(find.text('boletos'), findsOneWidget);
      expect(BellaFeatureRedirectHandler.redirect(context: context, href: 'Moradores-Acessou', sessionBloc: sessionBloc), isTrue);
      await tester.pumpAndSettle();
      expect(find.text('moradores'), findsOneWidget);
      expect(BellaFeatureRedirectHandler.redirect(context: context, href: 'notificacoes_nao_lidas', sessionBloc: sessionBloc), isFalse);
      expect(BellaFeatureRedirectHandler.redirect(context: context, href: 'nada', sessionBloc: sessionBloc), isFalse);
      sessionBloc.rbacAllowed = false;
      expect(BellaFeatureRedirectHandler.redirect(context: context, href: 'boletos', sessionBloc: sessionBloc), isFalse);
    });
  });
}

Future<void> waitForState(IaBellaBloc bloc, bool Function(IaBellaState) test) async {
  for (var i = 0; i < 50; i++) {
    if (test(bloc.state)) return;
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
  fail('estado esperado não emitido: ${bloc.state}');
}
