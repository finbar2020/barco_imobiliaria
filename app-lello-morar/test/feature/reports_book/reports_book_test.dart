import 'dart:convert';
import 'dart:io';

import 'package:chopper/chopper.dart' show Response;
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:morar/core/uploader/uploader.dart';
import 'package:morar/feature/reports_book/data/data_source/reports_book_api.dart';
import 'package:morar/feature/reports_book/data/data_source/reports_book_remote_data_source.dart';
import 'package:morar/feature/reports_book/data/data_source/reports_book_remote_data_source_impl.dart';
import 'package:morar/feature/reports_book/data/model/content_send_model.dart';
import 'package:morar/feature/reports_book/data/model/report_contents_model.dart';
import 'package:morar/feature/reports_book/data/model/report_create_model.dart';
import 'package:morar/feature/reports_book/data/model/report_model.dart';
import 'package:morar/feature/reports_book/data/repository/reports_book_repository_impl.dart';
import 'package:morar/feature/reports_book/domain/entity/content_send.dart';
import 'package:morar/feature/reports_book/domain/entity/report.dart';
import 'package:morar/feature/reports_book/domain/entity/report_contents.dart';
import 'package:morar/feature/reports_book/domain/entity/report_create.dart';
import 'package:morar/feature/reports_book/domain/entity/report_message.dart';
import 'package:morar/feature/reports_book/domain/entity/report_option.dart';
import 'package:morar/feature/reports_book/domain/entity/report_type_user.dart';
import 'package:morar/feature/reports_book/domain/repository/reports_book_repository.dart';
import 'package:morar/feature/reports_book/domain/use_case/get_all_reports.dart';
import 'package:morar/feature/reports_book/domain/use_case/get_all_reports_impl.dart';
import 'package:morar/feature/reports_book/domain/use_case/get_report.dart';
import 'package:morar/feature/reports_book/domain/use_case/get_report_impl.dart';
import 'package:morar/feature/reports_book/domain/use_case/post_new_report.dart';
import 'package:morar/feature/reports_book/domain/use_case/post_new_report_impl.dart';
import 'package:morar/feature/reports_book/domain/use_case/put_report_attachment.dart';
import 'package:morar/feature/reports_book/domain/use_case/put_report_attachment_impl.dart';
import 'package:morar/feature/reports_book/domain/use_case/put_report_content.dart';
import 'package:morar/feature/reports_book/domain/use_case/put_report_content_impl.dart';
import 'package:morar/feature/reports_book/presentation/bloc/reports_bloc.dart';
import 'package:morar/feature/reports_book/presentation/bloc/reports_event.dart';
import 'package:morar/feature/reports_book/presentation/bloc/reports_state.dart';
import 'package:morar/feature/reports_book/presentation/controller/reports_controller.dart';

import '../../helpers/firebase_mocks.dart';
import '../../helpers/fixtures.dart';

class MockApi extends Mock implements ReportsBookApi {}

ReportContents _content({String id = 'c1', DateTime? date, String? attachment}) => ReportContents(
      id: id,
      numReport: 1,
      typeUser: 0,
      content: 'texto',
      attachment: attachment,
      dateContent: date ?? DateTime(2026, 2, 3, 14, 5),
    );

Report _report({String id = 'r1', DateTime? date, List<ReportContents>? contents, String type = 'COMPLAINT'}) => Report(
      idReport: id,
      typeReport: type,
      dateReport: date ?? DateTime(2026, 2, 3, 14, 5),
      reportContents: contents ?? [_content()],
      numReport: '10',
    );

File _tempFile() {
  final file = File('${Directory.systemTemp.path}/morar_report_att.txt');
  file.writeAsStringSync('x');
  return file;
}

class _FakeDataSource extends Fake implements ReportsBookRemoteDataSource {
  _FakeDataSource({this.fail = false});
  final bool fail;
  ReportCreateModel? created;
  ContentSendModel? sent;

  @override
  Future<List<ReportModel>> getAllReports(String unitId) async {
    if (fail) throw Exception('x');
    return [
      ReportModel(idReport: 'old', dateReport: DateTime(2026, 1, 1)),
      ReportModel(idReport: 'new', dateReport: DateTime(2026, 3, 1)),
    ];
  }

  @override
  Future<ReportModel> postNewReport(ReportCreateModel reportCreateModel) async {
    if (fail) throw Exception('x');
    created = reportCreateModel;
    return ReportModel(idReport: 'posted', reportContents: [ReportContentsModel(id: 'c9')]);
  }

  @override
  Future<ReportModel> getReport(String unitId, String reportId) async {
    if (fail) throw Exception('x');
    return ReportModel(idReport: reportId, reportContents: [
      ReportContentsModel(id: 'b', dateContent: DateTime(2026, 2, 2), attachment: 'file.pdf'),
      ReportContentsModel(id: 'a', dateContent: DateTime(2026, 1, 1)),
    ]);
  }

  @override
  Future<ReportModel> putReportContent(String reportId, ContentSendModel content) async {
    if (fail) throw Exception('x');
    sent = content;
    return ReportModel(idReport: reportId, reportContents: [ReportContentsModel(id: 'c2')]);
  }
}

class _FakeUploader extends Fake implements Uploader {
  _FakeUploader({this.fail = false, this.throws = false});
  final bool fail;
  final bool throws;
  String? path;
  @override
  Future<String> upload(String path, File file,
      {required Function(String) onComplete, required Function(Exception) onError}) async {
    if (throws) throw Exception('boom');
    this.path = path;
    if (fail) {
      onError(Exception('upload'));
    } else {
      onComplete('url');
    }
    return 'task';
  }
}

class _FakeRepository extends Fake implements ReportsBookRepository {
  _FakeRepository({this.failure, this.failUpload = false});
  final Failure? failure;
  final bool failUpload;
  final calls = <String>[];

  @override
  Future<Try<List<Report>>> getAllReports(String unitId) async {
    calls.add('all:$unitId');
    if (failure != null) return Rejection(failure!);
    return Success([_report()]);
  }

  @override
  Future<Try<Report>> postNewReport(ReportCreateModel reportCreateModel) async {
    calls.add('post:${reportCreateModel.typeReport}');
    if (failure != null) return Rejection(failure!);
    return Success(_report(id: 'posted'));
  }

  @override
  Future<Try<Report>> getReport(String unitId, String reportId) async {
    calls.add('get:$unitId:$reportId');
    if (failure != null) return Rejection(failure!);
    return Success(_report(id: reportId));
  }

  @override
  Future<Try<Report>> putReportContent(String reportId, ContentSendModel content) async {
    calls.add('put:$reportId:${content.content}');
    if (failure != null) return Rejection(failure!);
    return Success(_report(id: reportId));
  }

  @override
  Future<Try<String>> uploadReportAtt(String contentId, File file,
      {required Function(String) onComplete, required Function(Exception) onError}) async {
    calls.add('upload:$contentId');
    if (failUpload) {
      onError(Exception('x'));
    } else {
      onComplete('url');
    }
    return Success('task');
  }
}

Future<List<ReportsState>> _collect(ReportsBloc bloc, Future<void> Function() run) async {
  final states = <ReportsState>[];
  final sub = bloc.stream.listen(states.add);
  await run();
  await Future<void>.delayed(const Duration(milliseconds: 20));
  await sub.cancel();
  return states;
}

void main() {
  setUpAll(() async {
    await setUpFakeFirebase();
  });

  test('entidades', () {
    final report = _report();
    expect(report.getDate, '03/02/2026 14h:05m');
    expect(report.getTypesReport, hasLength(5));
    expect(report.getTypeReport, 'reports_type_complaint');
    expect(_report(type: 'SUGGESTION').getTypeReport, 'reports_type_suggestion');
    expect(_report(type: 'VIOLENCE_NO').getTypeReport, 'reports_type_violence_no');
    expect(_report(type: 'COMPLIMENT').getTypeReport, 'reports_type_compliment');
    expect(_report(type: 'OTHERS').getTypeReport, 'reports_type_others');
    expect(_report(type: 'x').getTypeReport, '');
    expect(report.getSituation, 'reports_situation_open');
    expect((report..closed = true).getSituation, 'reports_situation_closed');
    expect((report..closed = null).getSituation, '');
    for (final entry in {
      'Sugestões': 'SUGGESTION', 'Suggestion': 'SUGGESTION',
      'Reclamações': 'COMPLAINT', 'Complaint': 'COMPLAINT',
      'Elogios': 'COMPLIMENT', 'Compliment': 'COMPLIMENT',
      'Violência não': 'VIOLENCE_NO', 'Violence no': 'VIOLENCE_NO',
      'Outros': 'OTHERS', 'Others': 'OTHERS',
    }.entries) {
      report.setTypeReport(entry.key);
      expect(report.typeReport, entry.value, reason: entry.key);
    }
    report.setTypeReport('desconhecido');
    expect(report.typeReport, 'OTHERS');
    expect(report.toString(), contains('idReport: r1'));

    expect(_content().getDate(), '03/02/2026 - 14h:05m');
    expect(_content().toString(), contains('content: texto'));
    expect(ReportMessage(message: 'm', date: DateTime(2026, 2, 3, 14, 5)).getDate, '03/02/2026 - 14:05h');
    expect(ReportMessage(message: 'm').toString(), contains('message: m'));
    expect(ContentSend(idReport: 'r', content: 'c').toString(), contains('idReport: r'));
    expect(ReportOption(title: 't', assetImage: 'a', onTap: () {}).newMessages, isFalse);
    expect(TypeUser.morador.index, 0);
    expect(ReportCreate(idUnit: 'u').idUnit, 'u');
  });

  test('models', () {
    final model = ReportModel.fromEntity(_report(contents: [_content(attachment: 'f')]))!;
    final json = jsonDecode(jsonEncode(model.toJson())) as Map<String, dynamic>;
    expect(json['report_contents'][0]['attachment'], 'f');
    final back = ReportModel.fromJson(json).toEntity();
    expect(back.reportContents!.single.content, 'texto');
    expect(back.public, isTrue);
    expect(ReportModel.fromEntity(null), isNull);
    expect(ReportModel().toEntity().reportContents, isEmpty);
    expect(ReportModel.fromEntity(Report())!.reportContents, isEmpty);

    final create = ReportCreateModel.fromEntity(ReportCreate(idUnit: 'u', typeReport: 'OTHERS', content: 'c', public: false))!;
    expect(ReportCreateModel.fromJson(jsonDecode(jsonEncode(create.toJson()))).toEntity().public, isFalse);
    expect(create.toString(), contains('typeReport: OTHERS'));
    expect(ReportCreateModel.fromEntity(null), isNull);

    final send = ContentSendModel.fromEntity(ContentSend(idReport: 'r', content: 'c'))!;
    expect(ContentSendModel.fromJson(send.toJson()).toEntity().content, 'c');
    expect(ContentSendModel.fromEntity(null), isNull);
    expect(ReportContentsModel.fromEntity(null), isNull);
    expect(ReportContentsModel.fromJson({'id': 'x', 'type_user': 1}).toEntity().typeUser, 1);
  });

  test('use cases', () async {
    final repo = _FakeRepository();
    Failure? f(Try r) => r.fold((e) => e, (_) => null);
    expect(f(await GetAllReportsUseCaseImpl(repository: repo)(GetAllReportsParams(unitId: ''))), isA<InvalidParamFailure>());
    expect(f(await GetReportUseCaseImpl(repository: repo)(GetReportParams(unitId: '', reportId: 'r'))), isA<InvalidParamFailure>());
    expect(f(await GetReportUseCaseImpl(repository: repo)(GetReportParams(unitId: 'u', reportId: ''))), isA<InvalidParamFailure>());
    expect(f(await PutReportAttachmentUseCaseImpl(repository: repo)(PutReportAttachmentParams(contentId: '', file: _tempFile()))), isA<InvalidParamFailure>());
    expect(f(await PutReportContentUseCaseImpl(repository: repo)(PutReportContentParams(reportId: '', content: ContentSendModel(idReport: 'r', content: 'c')))), isA<InvalidParamFailure>());
    expect(f(await PutReportContentUseCaseImpl(repository: repo)(PutReportContentParams(reportId: 'r', content: ContentSendModel(content: 'c')))), isA<InvalidParamFailure>());
    expect(f(await PutReportContentUseCaseImpl(repository: repo)(PutReportContentParams(reportId: 'r', content: ContentSendModel(idReport: 'r')))), isA<InvalidParamFailure>());
    expect(repo.calls, isEmpty);

    await GetAllReportsUseCaseImpl(repository: repo)(GetAllReportsParams(unitId: 'u'));
    await GetReportUseCaseImpl(repository: repo)(GetReportParams(unitId: 'u', reportId: 'r'));
    await PostNewReportUseCaseImpl(repository: repo)(PostNewReportParams(reportCreateModel: ReportCreateModel(typeReport: 'OTHERS')));
    await PutReportContentUseCaseImpl(repository: repo)(PutReportContentParams(reportId: 'r', content: ContentSendModel(idReport: 'r', content: 'c')));
    final upload = await PutReportAttachmentUseCaseImpl(repository: repo)(PutReportAttachmentParams(contentId: 'c', file: _tempFile()));
    expect(upload.fold((_) => null, (u) => u), 'url');
    expect(repo.calls, ['all:u', 'get:u:r', 'post:OTHERS', 'put:r:c', 'upload:c']);
    final failedUpload = await PutReportAttachmentUseCaseImpl(repository: _FakeRepository(failUpload: true))(
        PutReportAttachmentParams(contentId: 'c', file: _tempFile()));
    expect(failedUpload.fold((f) => f, (_) => null), isA<UnknownFailure>());
  });

  group('ReportsBookRepositoryImpl', () {
    test('ordena, monta links e delega', () async {
      final ds = _FakeDataSource();
      final uploader = _FakeUploader();
      final repo = ReportsBookRepositoryImpl(dataSource: ds, uploader: uploader, baseUrl: 'http://api');
      final all = (await repo.getAllReports('u')).fold((_) => null, (l) => l)!;
      expect(all.map((r) => r.idReport), ['new', 'old']);
      final report = (await repo.getReport('u', 'r1')).fold((_) => null, (r) => r)!;
      expect(report.reportContents!.map((c) => c.id), ['a', 'b']);
      expect(report.reportContents!.last.attachmentLink, 'http://api/concierge/reportbook/b/file/file.pdf');
      expect(report.reportContents!.first.attachmentLink, isNull);
      final posted = await repo.postNewReport(ReportCreateModel(idUnit: 'u', typeReport: 'OTHERS'));
      expect(posted.fold((_) => null, (r) => r.idReport), 'posted');
      expect(ds.created!.typeReport, 'OTHERS');
      final put = await repo.putReportContent('r1', ContentSendModel(idReport: 'r1', content: 'oi'));
      expect(put.fold((_) => null, (r) => r.reportContents!.single.id), 'c2');
      var completed = '';
      final upload = await repo.uploadReportAtt('c1', _tempFile(), onComplete: (v) => completed = v, onError: (_) {});
      expect(upload.fold((_) => null, (t) => t), 'task');
      expect(uploader.path, 'concierge/reportbook/c1/upload');
      expect(completed, 'url');
    });

    test('falhas', () async {
      final repo = ReportsBookRepositoryImpl(dataSource: _FakeDataSource(fail: true), uploader: _FakeUploader(throws: true), baseUrl: '');
      expect((await repo.getAllReports('u')).fold((f) => f, (_) => null), isA<UnknownFailure>());
      expect((await repo.getReport('u', 'r')).fold((f) => f, (_) => null), isA<UnknownFailure>());
      expect((await repo.postNewReport(ReportCreateModel())).fold((f) => f, (_) => null), isA<UnknownFailure>());
      expect((await repo.putReportContent('r', ContentSendModel())).fold((f) => f, (_) => null), isA<UnknownFailure>());
      expect((await repo.uploadReportAtt('c', _tempFile(), onComplete: (_) {}, onError: (_) {})).fold((f) => f, (_) => null),
          isA<UnknownFailure>());
    });
  });

  test('data source', () async {
    final api = MockApi();
    registerFallbackValue(ReportCreateModel());
    registerFallbackValue(ContentSendModel());
    final ds = ReportsBookRemoteDataSourceImpl(api: api);
    Response<dynamic> ok(Object body) => Response<dynamic>(http.Response(jsonEncode(body), 200), null);
    when(() => api.getAllReports('u', 1000)).thenAnswer((_) async => ok([{'id_report': '1'}]));
    when(() => api.postNewReport(any())).thenAnswer((_) async => ok({'id_report': '2'}));
    when(() => api.getReport('u', 'r')).thenAnswer((_) async => ok({'id_report': 'r'}));
    when(() => api.putReportContent('r', any())).thenAnswer((_) async => ok({'id_report': 'r', 'closed': true}));
    expect((await ds.getAllReports('u')).single.idReport, '1');
    expect((await ds.postNewReport(ReportCreateModel())).idReport, '2');
    expect((await ds.getReport('u', 'r')).idReport, 'r');
    expect((await ds.putReportContent('r', ContentSendModel())).closed, isTrue);
  });

  test('bloc mapeia eventos', () async {
    final bloc = ReportsBloc();
    expect(bloc.state, const ReportsLoadingState());
    final report = _report();
    final content = _content();
    final file = _tempFile();
    final states = await _collect(bloc, () async {
      bloc
        ..add(AttachmentReportsFailureEvent(report: report, content: content, attachment: file, failure: UnknownFailure('e')))
        ..add(ReportFileLoadedEvent(report: report, content: content, attachment: file))
        ..add(ReportPostedEvent(report: report))
        ..add(NewReplyReportsFailureEvent(CurrentReport: report, content: content, failure: null))
        ..add(NewReportsFailureEvent(report: report, content: content, failure: null))
        ..add(PreviewReportEvent(report: report, content: content))
        ..add(ReportSendSuccessEvent(report: report, content: content))
        ..add(const ReportsBookFirstEvent())
        ..add(const ReportsFailureEvent())
        ..add(ReportsGetReportFailureEvent(allReports: [report], failure: null))
        ..add(ReportsLoadedEvent(allReports: [report]))
        ..add(ReportsLoadingEvent(report: report))
        ..add(SeeReportDetailsEvent(report: report))
        ..add(SendReportEvent(report: report, content: content, flushbarMessage: 'm'));
    });
    await bloc.close();
    final types = states.map((s) => s.runtimeType).toList();
    // Corrigido: os eventos de falha herdam de `ReportsFailureEvent`, mas o
    // handler genérico só responde ao evento exato; cada falha específica
    // gera um único estado (e `NewReportsFailureEvent` tem handler próprio).
    expect(types, [
      AttachmentReportsFailureState,
      ReportFileLoadedState,
      ReportPostedState,
      NewReplyReportsFailureState,
      NewReportsFailureState,
      PreviewReportState,
      ReportSendSuccessState,
      ReportsBookFirstState,
      ReportsFailureState,
      ReportsGetReportFailureState,
      ReportsLoadedState,
      ReportsLoadingState,
      SeeReportDetailsState,
      SendReportState,
    ]);
    expect(types.where((t) => t == ReportsFailureState).length, 1);
    expect((states[4] as NewReportsFailureState).report, report);
    expect((states[9] as ReportsGetReportFailureState).report, isNull);
    expect((states.last as SendReportState).flushbarMessage, 'm');
    expect(const ReportsEmptyEvent().props, [null]);
    expect(NewReportsFailureEvent(report: report, content: content, failure: null).props.length, 4);
    expect(NewReportsFailureState(report: report, content: content, failure: null).props.length, 4);
    expect(const ReportsInitialState().props, [null]);
  });

  group('ReportsController', () {
    late ReportsBloc bloc;
    setUp(() => bloc = ReportsBloc());
    tearDown(() => bloc.close());

    ReportsController build({Failure? failure, bool failUpload = false}) {
      final repo = _FakeRepository(failure: failure, failUpload: failUpload);
      return ReportsController(
        sessionBloc: FakeSessionBloc(),
        reportsBloc: bloc,
        getAllReportsUseCase: GetAllReportsUseCaseImpl(repository: repo),
        getReportUseCase: GetReportUseCaseImpl(repository: repo),
        postNewReportUseCase: PostNewReportUseCaseImpl(repository: repo),
        putReportContentUseCase: PutReportContentUseCaseImpl(repository: repo),
        putReportAttachmentUseCase: PutReportAttachmentUseCaseImpl(repository: repo),
      );
    }

    test('getAllReports e getReport', () async {
      fakeAnalytics.reset();
      final controller = build();
      var states = await _collect(bloc, controller.getAllReports);
      expect(states.last, isA<ReportsLoadedState>());
      expect(fakeAnalytics.eventNames, contains('ocorrencias_minhas_ocorrencias'));

      states = await _collect(bloc, () => controller.getReport(report: _report()..newMessage = true));
      expect(states.first, isA<ReportsLoadingState>());
      expect((states.last as SeeReportDetailsState).report!.newMessage, isTrue);

      states = await _collect(bloc, () => controller.getReport(report: _report()));
      expect(states, isEmpty, reason: 'só busca a partir da lista carregada');

      final failing = build(failure: UnknownFailure('x'));
      states = await _collect(bloc, failing.getAllReports);
      expect(states.last, const ReportsFailureState());
      bloc.add(ReportsLoadedEvent(allReports: [_report()]));
      await Future<void>.delayed(Duration.zero);
      states = await _collect(bloc, () => failing.getReport(report: _report()));
      expect(states.last, isA<ReportsGetReportFailureState>());
      expect(states.last.report!.idReport, 'r1');
      expect(states, isNot(contains(const ReportsFailureState())));

      // Corrigido: a partir da falha o "tentar novamente" refaz a busca
      // (`getReport` aceita `ReportsGetReportFailureState`, que guarda a
      // ocorrência e a lista).
      states = await _collect(bloc, () => failing.getReport(report: _report()));
      expect(states.first, isA<ReportsLoadingState>());
      expect(states.last, isA<ReportsGetReportFailureState>());
      expect((states.last as ReportsGetReportFailureState).allReports, hasLength(1));
    });

    test('eventos simples', () async {
      final controller = build();
      var states = await _collect(bloc, controller.createNewReport);
      expect((states.single as SendReportState).content.typeUser, TypeUser.morador.index);
      states = await _collect(bloc, () => controller.createNewReport(report: _report(), content: _content()));
      expect((states.single as SendReportState).report!.idReport, 'r1');
      states = await _collect(bloc, () => controller.seeReportDetails(_report()));
      expect(states.single, isA<SeeReportDetailsState>());
      states = await _collect(bloc, () => controller.previewReport(report: _report(), content: _content(), attachment: _tempFile()));
      expect((states.single as PreviewReportState).attachment, isNotNull);
      states = await _collect(bloc, controller.showFirstEvent);
      expect(states.single, const ReportsBookFirstState());
      states = await _collect(bloc, () => controller.replyReport(_report()));
      expect((states.single as SendReportState).content.typeUser, 0);
      states = await _collect(bloc, () => controller.replyReport(_report(), _content(id: 'x')));
      expect((states.single as SendReportState).content.id, 'x');
    });

    test('sendReplyReport e postNewReport', () async {
      fakeAnalytics.reset();
      final controller = build();
      var states = await _collect(bloc, () => controller.sendReplyReport(_report(), _content()));
      expect(states.last, isA<ReportPostedState>());

      final withFile = _content()..attachmentFile = _tempFile();
      states = await _collect(bloc, () => controller.sendReplyReport(_report(), withFile));
      expect(states.last, isA<ReportPostedState>());

      states = await _collect(bloc, () => controller.postNewReport(_report(), _content()..public = false));
      expect(states.last, isA<ReportPostedState>());
      expect(fakeAnalytics.eventNames, contains('ocorrencias_registrar_nova_ocorrencia_sucesso'));

      states = await _collect(bloc, () => controller.postNewReport(_report(), withFile));
      expect(states.last, isA<ReportPostedState>());

      final failing = build(failure: UnknownFailure('x'));
      states = await _collect(bloc, () => failing.sendReplyReport(_report(), _content()));
      expect(states.last, isA<NewReplyReportsFailureState>());
      expect(states.last.report!.idReport, 'r1');
      states = await _collect(bloc, () => failing.postNewReport(_report(), _content()));
      // Corrigido: `NewReportsFailureEvent` tem handler próprio e a tela
      // recebe `NewReportsFailureState` (com o rascunho), sem o genérico.
      expect(states.last, isA<NewReportsFailureState>());
      expect((states.last as NewReportsFailureState).content.content, 'texto');
      expect(states, isNot(contains(const ReportsFailureState())));

      final failingUpload = build(failUpload: true);
      states = await _collect(bloc, () => failingUpload.putAttachment(_report(), _content(), _tempFile(), true));
      expect(states.first, isA<ReportsLoadingState>());
      expect(states, contains(isA<AttachmentReportsFailureState>()));
    });
  });
}
