import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/access_control/presentation/bloc/access_control_state.dart';
import 'package:morar/feature/access_control/presentation/controllers/access_control_store.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_appointments_page.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_attention_page.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_error_page.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_excluded_error.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_excluded_success.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_insert_page.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_invite_success_page.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_page.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_send_invite_error.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_send_invite_success.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_success_page.dart';

import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';
import 'access_control_test_helpers.dart';

void main() {
  late PageHarness harness;
  late RecordingNavigatorObserver observer;
  final clipboard = <String>[];

  setUp(() async {
    harness = await installPageHarness();
    observer = RecordingNavigatorObserver();
    clipboard.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
      if (call.method == 'Clipboard.setData') {
        clipboard.add((call.arguments as Map)['text'] as String);
      }
      return null;
    });
    addTearDown(() => TestDefaultBinaryMessengerBinding
        .instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null));
  });

  AccessControlStore store() => harness.resolve<AccessControlStore>();

  AcessControlPageArgs lastAccessArgs() =>
      observer.pushed.last.settings.arguments as AcessControlPageArgs;

  group('AccessControlSuccessPage', () {
    testWidgets('variações de título e concluir volta para a aba certa (golden)',
        (tester) async {
      await pumpPage(
        tester,
        const AccessControlSuccessPage(isEdit: true, isVisitant: true, isGeneric: false),
        observer: observer,
      );
      expect(find.text('access_control_schedule_changed'), findsOneWidget);
      expect(find.text('Edifício Lello - 101'), findsOneWidget);
      await expectLater(
        find.byType(AccessControlSuccessPage),
        matchesGoldenFile('goldens/access_control_success_page.png'),
      );

      await tester.tap(find.text('conclude'));
      await tester.pumpAndSettle();
      expect(findRoute(ApplicationRoute.accessControl), findsOneWidget);
      expect(lastAccessArgs().tabIndex, 0);

      await resetApp(tester);
      await pumpPage(
        tester,
        const AccessControlSuccessPage(newVisit: true, isVisitant: false, isGeneric: true),
        observer: observer,
      );
      expect(find.text('access_control_schedule_created'), findsOneWidget);
      await tester.tap(find.text('conclude'));
      await tester.pumpAndSettle();
      expect(lastAccessArgs().tabIndex, 1);
      expect(lastAccessArgs().isGeneric, isTrue);

      await resetApp(tester);
      await pumpPage(
        tester,
        const AccessControlSuccessPage(isDeleteVisit: true, isGeneric: false),
        observer: observer,
      );
      expect(find.text('access_control_schedule_delete'), findsOneWidget);
    });
  });

  group('AccessControlErrorPage', () {
    Widget page({bool isDelete = false}) => AccessControlErrorPage(
          accessControlStore: store(),
          accessControl: gest(),
          model: auth(),
          isDelete: isDelete,
          isAppointment: false,
          isEdit: false,
          isGeneric: false,
        );

    testWidgets('erro de convite e tentar de novo abre agendamentos', (tester) async {
      setLoadedState(store());
      await pumpPage(tester, page(), observer: observer);
      expect(find.text('access_control_failed_send_invite'), findsOneWidget);
      expect(find.text('access_control_return_appointments'), findsOneWidget);

      await tester.tap(find.text('try_again'));
      await tester.pumpAndSettle();
      expect(find.byType(AccessControlAppointmentsPage), findsOneWidget);
    });

    testWidgets('erro de exclusão e voltar do sistema vai para a lista',
        (tester) async {
      await pumpPage(tester, page(isDelete: true), observer: observer);
      expect(find.text('access_control_failed_excluded_visit'), findsOneWidget);
      expect(find.text('error_unknown'), findsOneWidget);

      await systemBack(tester);
      expect(findRoute(ApplicationRoute.accessControl), findsOneWidget);
      // Corrigido: o `onWillPop` envia `AcessControlPageArgs` para a lista.
      expect(lastAccessArgs().isGeneric, isFalse);
    });
  });

  group('AccessControlExcludedErrorPage', () {
    Widget page({bool isVisitant = true}) => AccessControlExcludedErrorPage(
          accessControlStore: store(),
          accessControl: gest(),
          model: auth(),
          isVisitant: isVisitant,
          isGeneric: false,
        );

    testWidgets('tentar de novo reabre agendamentos em modo edição',
        (tester) async {
      setLoadedState(store());
      await pumpPage(tester, page(), observer: observer);
      expect(find.text('access_control_failed_excluded_visitor'), findsOneWidget);

      await tester.tap(find.text('try_again'));
      await tester.pumpAndSettle();
      expect(find.byType(AccessControlAppointmentsPage), findsOneWidget);
      expect(store().bloc.state, isA<EditVisitantState>());
    });

    testWidgets('texto de prestador e voltar do sistema', (tester) async {
      await pumpPage(tester, page(isVisitant: false), observer: observer);
      expect(find.text('access_control_failed_excluded_provider'), findsOneWidget);
      await systemBack(tester);
      expect(findRoute(ApplicationRoute.accessControl), findsOneWidget);
      // Corrigido: o `onWillPop` envia `AcessControlPageArgs` para a lista.
      expect(lastAccessArgs().isGeneric, isFalse);
    });
  });

  group('AccessControlExcludedSuccessPage', () {
    testWidgets('concluir volta para a aba certa', (tester) async {
      await pumpPage(
        tester,
        AccessControlExcludedSuccessPage(
            accessControlStore: store(), isVisitant: false, isGeneric: false),
        observer: observer,
      );
      expect(find.text('access_control_deleted_service'), findsOneWidget);
      expect(find.text('Edifício Lello - R1'), findsOneWidget);
      await tester.tap(find.text('conclude'));
      await tester.pumpAndSettle();
      expect(findRoute(ApplicationRoute.accessControl), findsOneWidget);
      expect(lastAccessArgs().tabIndex, 1);
    });

    testWidgets('voltar do sistema vai para a lista', (tester) async {
      await pumpPage(
        tester,
        AccessControlExcludedSuccessPage(
            accessControlStore: store(), isVisitant: true, isGeneric: false),
        observer: observer,
      );
      expect(find.text('access_control_deleted_visitor'), findsOneWidget);
      await systemBack(tester);
      expect(findRoute(ApplicationRoute.accessControl), findsOneWidget);
      // Corrigido: o `onWillPop` envia `AcessControlPageArgs` para a lista.
      expect(lastAccessArgs().isGeneric, isFalse);
    });
  });

  group('AccessControlSendInviteErrorPage', () {
    testWidgets('tentar de novo reabre o cadastro', (tester) async {
      final model = auth();
      await pumpPage(
        tester,
        AccessControlSendInviteErrorPage(
          accessControlStore: store(),
          accessControl: gest(),
          model: model,
          isEdit: true,
          isGeneric: false,
        ),
        observer: observer,
      );
      expect(find.text('access_control_invite_error_title'), findsOneWidget);
      expect(find.text('access_control_invite_error_subtitle'), findsOneWidget);

      await tester.tap(find.text('try_again'));
      await tester.pumpAndSettle();

      expect(findRoute(ApplicationRoute.accessControlInsert), findsOneWidget);
      final args = observer.pushed.last.settings.arguments as AccessControlInsertPageArgs;
      expect(args.isEdit, isTrue);
      expect(args.authorization, same(model));
      expect(store().bloc.state, isA<EditVisitantState>());
    });

    testWidgets('voltar do sistema vai para a lista', (tester) async {
      await pumpPage(
        tester,
        AccessControlSendInviteErrorPage(
          accessControlStore: store(),
          accessControl: gest(),
          model: auth(),
          isEdit: false,
          isGeneric: false,
        ),
        observer: observer,
      );
      await systemBack(tester);
      expect(findRoute(ApplicationRoute.accessControl), findsOneWidget);
      // Corrigido: o `onWillPop` envia `AcessControlPageArgs` para a lista.
      expect(lastAccessArgs().isGeneric, isFalse);
    });
  });

  group('AccessControlSendInviteSuccessPage', () {
    void setLink(String? link) {
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      store().bloc.emit(SaveVisitantLoadedState(
        visitants: const [],
        providers: const [],
        useFacial: true,
        isVisitant: true,
        link: link,
      ));
    }

    Widget page({bool facial = true, bool isVisitant = true}) =>
        AccessControlSendInviteSuccessPage(
          accessControlStore: store(),
          isVisitant: isVisitant,
          useFacialBiometric: facial,
          isGeneric: false,
        );

    testWidgets('sem biometria mostra só concluir (golden)', (tester) async {
      await pumpPage(tester, page(facial: false, isVisitant: false), observer: observer);
      expect(find.text('access_control_invite_provider_success_title'), findsOneWidget);
      expect(find.text('access_control_invite_provider_success_subtitle'), findsNothing);
      expect(find.text('accesss_control_copy_link'), findsNothing);
      await expectLater(
        find.byType(AccessControlSendInviteSuccessPage),
        matchesGoldenFile('goldens/access_control_send_invite_success_page.png'),
      );

      await tester.tap(find.text('conclude'));
      await tester.pumpAndSettle();
      expect(findRoute(ApplicationRoute.accessControl), findsOneWidget);
      expect(lastAccessArgs().tabIndex, 1);
    });

    testWidgets('copiar link usa a área de transferência e fecha', (tester) async {
      setLink('https://convite');
      await pumpPushed(tester, page(), observer: observer);
      expect(find.text('access_control_invite_visitant_success_title'), findsOneWidget);
      expect(find.text('access_control_invite_visitant_success_subtitle'), findsOneWidget);

      await tester.tap(find.text('accesss_control_copy_link'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(clipboard, ['https://convite']);
      expect(find.byType(Flushbar), findsOneWidget);
      expect(find.text('accesss_control_copied_link'), findsOneWidget);

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      expect(find.byType(AccessControlSendInviteSuccessPage), findsNothing);
      expect(find.byKey(launcherKey), findsOneWidget);
    });

    testWidgets('prestador com biometria mostra o subtítulo de prestador', (tester) async {
      setLink('x');
      await pumpPage(tester, page(facial: true, isVisitant: false), observer: observer);
      expect(find.text('access_control_invite_provider_success_subtitle'), findsOneWidget);
    });

    testWidgets('link nulo copia texto vazio', (tester) async {
      setLink(null);
      await pumpPushed(tester, page(), observer: observer);
      await tester.tap(find.text('accesss_control_copy_link'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      expect(clipboard, ['']);
    });

    testWidgets('compartilhar link fecha a página', (tester) async {
      setLink('https://convite');
      await pumpPushed(tester, page(), observer: observer);
      await tester.tap(find.text('accesss_control_share_link'));
      await tester.pumpAndSettle();
      expect(find.byType(AccessControlSendInviteSuccessPage), findsNothing);
      expect(find.byKey(launcherKey), findsOneWidget);
    });

    testWidgets('voltar do sistema vai para a lista', (tester) async {
      await pumpPage(tester, page(facial: false), observer: observer);
      await systemBack(tester);
      expect(findRoute(ApplicationRoute.accessControl), findsOneWidget);
      // Corrigido: o `onWillPop` envia `AcessControlPageArgs` para a lista.
      expect(lastAccessArgs().isGeneric, isFalse);
      expect(lastAccessArgs().tabIndex, 0);
    });
  });

  group('AccessControlInviteSuccessPage', () {
    const state = SaveVisitantLoadedState(
      visitants: [],
      providers: [],
      useFacial: true,
      isVisitant: true,
      link: 'https://convite2',
      sendInvite: true,
    );

    testWidgets('copiar link, compartilhar e concluir', (tester) async {
      await pumpPushed(
        tester,
        const AccessControlInviteSuccessPage(state: state, isGeneric: true),
        observer: observer,
      );
      expect(find.text('residents_invite_success_title'), findsOneWidget);
      expect(find.text('Edifício Lello - R1'), findsOneWidget);

      await tester.tap(find.text('accesss_control_copy_link'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(clipboard, ['https://convite2']);
      expect(find.text('accesss_control_copied_link'), findsOneWidget);
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      expect(find.byType(AccessControlInviteSuccessPage), findsNothing);

      await tester.tap(find.text('abrir'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('accesss_control_share_link'));
      await tester.pumpAndSettle();
      expect(find.byType(AccessControlInviteSuccessPage), findsNothing);

      await tester.tap(find.text('abrir'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('conclude'));
      await tester.pumpAndSettle();
      /// Corrigido: `AccessControlInviteSuccessPage` volta para a lista com
      /// `AcessControlPageArgs` (aba e `isGeneric`), como as demais páginas.
      expect(findRoute(ApplicationRoute.accessControl), findsOneWidget);
      expect(lastAccessArgs().isGeneric, isTrue);
      expect(lastAccessArgs().tabIndex, 0);
    });
  });

  group('AccessControlAttentionPage', () {
    testWidgets('mostra o título dos argumentos e OK volta para a lista',
        (tester) async {
      await pumpPage(
        tester,
        // ignore: prefer_const_constructors
        AccessControlAttentionPage(),
        arguments: 'access_control_deleted_visit',
        observer: observer,
      );
      expect(find.text('access_control_deleted_visit'), findsOneWidget);
      expect(find.text('Edifício Lello - 101'), findsOneWidget);

      await tester.tap(find.text('ok'));
      await tester.pumpAndSettle();
      expect(findRoute(ApplicationRoute.accessControl), findsOneWidget);
    });
  });
}
