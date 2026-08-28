import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/sub_user/presentation/bloc/sub_users_bloc.dart';
import 'package:morar/feature/sub_user/presentation/controllers/sub_user_controller.dart';
import 'package:morar/feature/sub_user/presentation/pages/facial_biometric/sub_user_facial_biometric_error.dart';
import 'package:morar/feature/sub_user/presentation/pages/facial_biometric/sub_user_facial_biometric_success.dart';
import 'package:morar/feature/sub_user/presentation/pages/service/sub_user_service_off_page.dart';
import 'package:morar/feature/sub_user/presentation/pages/service/sub_user_service_on_page.dart';
import 'package:morar/feature/sub_user/presentation/stores/sub_user_store.dart';

import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';
import 'sub_user_test_helpers.dart';

/// Controller com a captura facial (câmera) substituída por um contador.
class _NoCameraController extends SubUserController {
  _NoCameraController(SubUserStore store) : super(store: store);
  int facialCalls = 0;

  @override
  Future<void> getFacialBiometric() async {
    facialCalls++;
  }
}

void main() {
  late PageHarness harness;
  late RecordingNavigatorObserver observer;
  late _NoCameraController controller;

  setUp(() async {
    harness = await installPageHarness();
    observer = RecordingNavigatorObserver();
    registerSubUserRoutes(harness.http);
    controller = _NoCameraController(harness.resolve<SubUserStore>());
    await harness.override<SubUserController>(controller);
  });

  Iterable<String> paths() => harness.http.requests.map((r) => '${r.method} ${r.url.path}');

  group('SubUserServiceOnPage', () {
    Future<void> pumpOn(WidgetTester tester) => pumpPage(
          tester,
          const SubUserServiceOnPage(),
          observer: observer,
          arguments: SubUserServiceOnPageArgs(subUser: subUser()),
          surface: const Size(400, 1000),
        );

    testWidgets('precisa aceitar o aviso antes de avançar', (tester) async {
      await pumpOn(tester);

      expect(find.text('residents_facial_capture'), findsOneWidget);
      expect(find.text('residents_facial_capture_subtitle'), findsOneWidget);
      final next = find.widgetWithText(ElevatedButton, 'next');
      expect(tester.widget<ElevatedButton>(next).onPressed, isNull);

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      expect(tester.widget<ElevatedButton>(next).onPressed, isNotNull);
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      expect(tester.widget<ElevatedButton>(next).onPressed, isNull);
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      await tester.tap(find.textContaining('residents_facial_capture_attention_subtitle', findRichText: true));
      await tester.tap(next);
      await tester.pumpAndSettle();
      expect(controller.facialCalls, 1);

      await expectLater(find.byType(SubUserServiceOnPage), matchesGoldenFile('goldens/sub_user_service_on_page.png'));
    });

    testWidgets('voltar pela app bar e pelo sistema fecham a página', (tester) async {
      await pumpOn(tester);
      await tester.tap(find.byIcon(Icons.arrow_back_ios));
      await tester.pumpAndSettle();
      expect(observer.popped, hasLength(1));

      await tester.pumpWidget(const SizedBox());
      await pumpOn(tester);
      await tester.state<NavigatorState>(find.byType(Navigator)).maybePop();
      await tester.pumpAndSettle();
      expect(observer.popped, hasLength(2));
    });

    testWidgets('loading da biometria mostra o indicador', (tester) async {
      await pumpOn(tester);
      await emitState(tester, controller.bloc, FacialBiometricLoadingState(), settle: false);
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsWidgets);
      await tester.tap(find.byIcon(Icons.arrow_back_ios));
      await tester.pump();
      expect(observer.popped, isNotEmpty);
    });

    testWidgets('biometria concluída navega para sucesso', (tester) async {
      await pumpOn(tester);
      await emitState(tester, controller.bloc, FacialBiometricLoadedState());
      expect(observer.pushedNames.last, ApplicationRoute.subUserFacialBiometricSuccess);
      final args = observer.pushed.last.settings.arguments as SubUserFacialSuccessPageArgs;
      expect(args.subUser.id, 's1');
    });

    testWidgets('erro na biometria navega para a página de erro', (tester) async {
      await pumpOn(tester);
      await emitState(tester, controller.bloc, FacialBiometricErrorState(code: '42', message: 'falhou'));
      expect(observer.pushedNames.last, ApplicationRoute.subUserFacialBiometricError);
      final args = observer.pushed.last.settings.arguments as SubUserFacialBiometricErrorPageArgs;
      expect(args.code, '42');
      expect(args.message, 'falhou');
    });
  });

  testWidgets('SubUserServiceOffPage fecha e recarrega a lista', (tester) async {
    await pumpPage(tester, const SubUserServiceOffPage(), observer: observer);
    expect(find.text('residents_service_off_title'), findsOneWidget);
    expect(find.text('residents_service_off_subtitle'), findsOneWidget);
    harness.http.requests.clear();

    await tester.tap(find.text('ok'));
    await tester.pumpAndSettle();

    expect(paths(), contains('GET /concierge/subUser/u1'));
    expect(observer.popped, isNotEmpty);
  });

  group('SubUserFacialBiometricSuccessPage', () {
    testWidgets('mostra o condomínio e conclui indo para a edição', (tester) async {
      await pumpPage(
        tester,
        const SubUserFacialBiometricSuccessPage(),
        observer: observer,
        arguments: SubUserFacialSuccessPageArgs(controller: controller, subUser: subUser()),
      );
      expect(find.text('facial_biometric_success_title'), findsOneWidget);
      expect(find.text('Edifício Lello - 101'), findsOneWidget);
      harness.http.requests.clear();

      await tester.tap(find.text('conclude'));
      await tester.pumpAndSettle();

      expect(paths(), contains('GET /concierge/subUser/u1'));
      expect(observer.pushedNames.last, ApplicationRoute.subUserEdit);
    });
  });

  group('SubUserFacialBiometricErrorPage', () {
    Future<void> pumpError(WidgetTester tester, {String? message, String? code}) => pumpPage(
          tester,
          const SubUserFacialBiometricErrorPage(),
          observer: observer,
          arguments: SubUserFacialBiometricErrorPageArgs(
            controller: controller,
            subUser: subUser(),
            message: message,
            code: code,
          ),
        );

    testWidgets('mostra a mensagem e o código e tenta de novo', (tester) async {
      await pumpError(tester, message: 'Rosto não detectado', code: 'E1');
      expect(find.text('facial_biometric_error_title'), findsOneWidget);
      expect(find.text('Rosto não detectado'), findsOneWidget);
      expect(find.text('code: E1'), findsOneWidget);

      await tester.tap(find.text('try_again'));
      await tester.pumpAndSettle();

      expect(observer.pushedNames.last, ApplicationRoute.subUserServiceOn);
      expect(controller.facialCalls, 1);
    });

    testWidgets('sem mensagem usa o subtítulo padrão e voltar recarrega', (tester) async {
      await pumpError(tester);
      expect(find.text('facial_biometric_error_subtitle'), findsOneWidget);
      expect(find.textContaining('code:'), findsNothing);
      harness.http.requests.clear();

      await tester.state<NavigatorState>(find.byType(Navigator)).maybePop();
      await tester.pumpAndSettle();

      expect(paths(), contains('GET /concierge/subUser/u1'));
      expect(observer.pushedNames.last, ApplicationRoute.subUserServiceOn);
    });
  });
}
