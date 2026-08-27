import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/digital_meeting/domain/entity/digital_meeting.dart';
import 'package:morar/feature/digital_meeting/presentation/bloc/digital_meeting_state.dart';
import 'package:morar/feature/digital_meeting/presentation/controller/digital_meeting_controller.dart';
import 'package:morar/feature/digital_meeting/presentation/page/digital_meeting_page.dart';
import 'package:morar/feature/digital_meeting/presentation/page/digital_meeting_web_view_page.dart';
import 'package:morar/feature/digital_meeting/presentation/widget/digital_meeting_widget.dart';

import '../../helpers/fake_url_launcher.dart';
import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';

Map<String, dynamic> _meeting(
  String id, {
  String status = 'Iniciada',
  DateTime? validUntil,
  bool virtualDate = true,
}) =>
    {
      'id_meeting': id,
      'name': 'Assembleia $id',
      'date_stat': '2026-03-01T10:00:00',
      'date_finish': '2026-03-01T12:00:00',
      'date_virtual_meeting': virtualDate ? '2026-03-01T11:00:00' : null,
      'status_meeting': status,
      'token_hash': 'th$id',
      'link': 'https://zoom.us/j/$id',
      'validt_untul': validUntil?.toIso8601String(),
    };

const _inAppReviewChannel = MethodChannel('dev.britannio.in_app_review');
// Fallback nativo do UrlLauncherNative: sem plugin ele precisa responder com
// PlatformException para o openUrl devolver `false`.
const _nativeUrlChannel = MethodChannel('com.example.app/url_launcher');

void main() {
  late PageHarness harness;
  late FakeUrlLauncherPlatform launcher;
  late RecordingNavigatorObserver observer;

  setUp(() async {
    harness = await installPageHarness();
    launcher = installFakeUrlLauncher();
    observer = RecordingNavigatorObserver();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_inAppReviewChannel, (call) async => false);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_nativeUrlChannel,
            (call) async => throw PlatformException(code: 'sem-plugin'));
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_inAppReviewChannel, null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_nativeUrlChannel, null);
  });

  final routes = <String, WidgetBuilder>{
    ApplicationRoute.digitalMeetingWebView: (_) =>
        const DigitalMeetingWebViewPage(),
    ApplicationRoute.digitalMeeting: (_) => const DigitalMeetingPage(),
  };

  void mockList(List<Map<String, dynamic>> items) =>
      harness.http.on('GET', '/meeting/unit/*', body: items);

  DigitalMeetingController controller() =>
      harness.resolve<DigitalMeetingController>();

  testWidgets('lista as assembleias da unidade', (tester) async {
    final far = DateTime.now().add(const Duration(hours: 5));
    mockList([_meeting('1', validUntil: far), _meeting('2', status: 'Encerrada', virtualDate: false)]);

    await pumpPage(tester, const DigitalMeetingPage(), observer: observer);

    expect(find.byType(DigitalMeetingWidget), findsNWidgets(2));
    expect(find.text('Assembleia 1'), findsOneWidget);
    expect(find.text('Iniciada'), findsOneWidget);
    expect(find.text('Encerrada'), findsOneWidget);
    expect(find.byIcon(Icons.keyboard_arrow_right), findsOneWidget);
    expect(find.textContaining('meeting:'), findsOneWidget);
    expect(find.text('mailing_all_records'), findsOneWidget);
    await expectLater(
      find.byType(DigitalMeetingPage),
      matchesGoldenFile('goldens/digital_meeting_page.png'),
    );
  });

  testWidgets('sem assembleias mostra a mensagem de vazio', (tester) async {
    mockList([]);

    await pumpPage(tester, const DigitalMeetingPage());

    expect(find.text('digital_meeting_failure'), findsOneWidget);
  });

  testWidgets('erro mostra o widget de erro e o retry busca todas',
      (tester) async {
    harness.http.failAll();

    await pumpPage(tester, const DigitalMeetingPage());
    expect(find.byType(ErrorHandlingWidget), findsOneWidget);

    mockList([_meeting('1'), _meeting('2', validUntil: DateTime.now().add(const Duration(days: 1)))]);
    await tester.tap(find.text('error_handling_widget_button_reTry').first);
    await tester.pumpAndSettle();

    expect(controller().bloc.state, isA<DigitalMeetingShowAllState>());
    expect(find.byType(DigitalMeetingWidget), findsNWidgets(2));

    // Sem validação de acesso o item é ignorado; com ela abre o link.
    await tester.tap(find.text('Assembleia 1'), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(launcher.launched, isEmpty);
    await tester.tap(find.text('Assembleia 2'));
    await tester.pumpAndSettle();
    expect(launcher.launched, ['https://zoom.us/j/2']);
  });

  testWidgets('"ver todos" mostra todas as assembleias', (tester) async {
    mockList([_meeting('1')]);
    await pumpPage(tester, const DigitalMeetingPage());

    await tester.tap(find.text('mailing_all_records'));
    await tester.pumpAndSettle();

    expect(controller().bloc.state, isA<DigitalMeetingShowAllState>());
  });

  testWidgets('"ver todos" sem retorno vira erro', (tester) async {
    mockList([_meeting('1')]);
    await pumpPage(tester, const DigitalMeetingPage());
    mockList([]);

    await tester.tap(find.text('mailing_all_records'));
    await tester.pumpAndSettle();

    expect(find.byType(ErrorHandlingWidget), findsOneWidget);
  });

  testWidgets('tocar em uma assembeia válida busca o token e abre o zoom',
      (tester) async {
    final far = DateTime.now().add(const Duration(hours: 5));
    mockList([_meeting('1', validUntil: far)]);
    harness.http.on('GET', '/meeting/hash/th1', body: _meeting('1', validUntil: far));
    await pumpPage(tester, const DigitalMeetingPage(), observer: observer, routes: routes);

    await tester.tap(find.text('Assembleia 1'));
    await tester.pumpAndSettle();

    expect(harness.http.requests.map((r) => r.url.path), contains('/meeting/hash/th1'));
    expect(launcher.launched, ['https://zoom.us/j/1']);
    // Depois de abrir o link volta para a lista pedindo avaliação do app.
    expect(find.byType(DigitalMeetingPage), findsOneWidget);
    final args = ModalRoute.of(tester.element(find.byType(DigitalMeetingPage)))!
        .settings
        .arguments as DigitalMeetingPageArgs;
    expect(args.reviewApp, isTrue);
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    tester.takeException();
  });

  testWidgets('assembleia prestes a expirar abre direto sem buscar o token',
      (tester) async {
    final soon = DateTime.now().add(const Duration(minutes: 5));
    mockList([_meeting('1', validUntil: soon)]);
    await pumpPage(tester, const DigitalMeetingPage(), routes: routes);

    await tester.tap(find.text('Assembleia 1'));
    await tester.pumpAndSettle();

    expect(harness.http.requests.map((r) => r.url.path), isNot(contains('/meeting/hash/th1')));
    expect(launcher.launched, ['https://zoom.us/j/1']);
    // A lista volta pedindo avaliação (Future.delayed de 1s).
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    tester.takeException();
  });

  testWidgets('falha ao abrir o link mostra o aviso e volta para a lista',
      (tester) async {
    launcher.result = false;
    final soon = DateTime.now().add(const Duration(minutes: 5));
    mockList([_meeting('1', validUntil: soon)]);
    await pumpPage(tester, const DigitalMeetingPage(), routes: routes);

    await tester.tap(find.text('Assembleia 1'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('warning_failed_message'), findsOneWidget);
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(seconds: 1));
    }
    await tester.pumpAndSettle();

    expect(find.byType(DigitalMeetingPage), findsOneWidget);
    final args = ModalRoute.of(tester.element(find.byType(DigitalMeetingPage)))!
        .settings
        .arguments as DigitalMeetingPageArgs;
    expect(args.reviewApp, isFalse);
  });

  testWidgets('falha ao buscar o token mostra o erro na tela do zoom',
      (tester) async {
    final far = DateTime.now().add(const Duration(hours: 5));
    mockList([_meeting('1', validUntil: far)]);
    harness.http.on('GET', '/meeting/hash/th1', status: 500, body: {'message': 'x'});
    await pumpPage(tester, const DigitalMeetingPage(), routes: routes);

    await tester.tap(find.text('Assembleia 1'));
    await tester.pumpAndSettle();

    expect(find.byType(DigitalMeetingWebViewPage), findsOneWidget);
    expect(find.text('digital_meeting_failure_access_profile'), findsOneWidget);

    // Voltar recarrega a lista de assembleias.
    await tester.tap(find.byType(IconButton).first);
    await tester.pumpAndSettle();
    expect(find.byType(DigitalMeetingPage), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    tester.takeException();
  });

  testWidgets('tela do zoom em loading mostra as mensagens de espera',
      (tester) async {
    mockList([]);
    await pumpPage(tester, const DigitalMeetingWebViewPage(), routes: routes);
    await emitState(tester, controller().bloc, const DigitalMeetingLoadingState(), settle: false);
    await tester.pump();

    expect(find.text('digital_accessing'), findsOneWidget);
    expect(find.text('please_wait'), findsOneWidget);
  });

  testWidgets('cores do status da assembleia', (tester) async {
    final theme = LelloTheme.light;
    final model = DigitalMeeting()
      ..name = 'X'
      ..dateStat = DateTime(2026, 3, 1, 10)
      ..dateFinish = DateTime(2026, 3, 1, 12)
      ..statusMeeting = 'Aguardando';
    await pumpApp(tester, DigitalMeetingWidget(model: model, onTap: () {}), localized: true);

    final widget = tester.widget<DigitalMeetingWidget>(find.byType(DigitalMeetingWidget));
    expect(widget.getColor('Iniciada', theme), LelloTheme.palleteOf(theme).success());
    expect(widget.getColor('Aguardando', theme), LelloTheme.palleteOf(theme).warning());
    expect(widget.getColor('Encerrada', theme), LelloTheme.palleteOf(theme).textOpaque());
    expect(widget.getColor('?', theme), LelloTheme.palleteOf(theme).text());
    expect(model.reuniao, '');
    expect(model.validandoAcesso, isFalse);
  });
}
