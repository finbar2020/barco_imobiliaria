import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/feature/sub_user/presentation/bloc/sub_users_bloc.dart';
import 'package:morar/feature/sub_user/presentation/controllers/sub_user_controller.dart';
import 'package:morar/feature/sub_user/presentation/pages/pending_requests/pending_requests_enum.dart';
import 'package:morar/feature/sub_user/presentation/pages/pending_requests/pending_requests_page.dart';
import 'package:morar/feature/sub_user/presentation/pages/pending_requests/update_access_request_status_success.dart.dart';
import 'package:morar/feature/sub_user/presentation/widget/no_expiration_date_dialog.dart';
import 'package:morar/feature/sub_user/presentation/widget/update_access_request_status_confirm_dialog.dart';
import 'package:morar/generated/l10n.dart';

import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';
import 'sub_user_test_helpers.dart';

void main() {
  late PageHarness harness;
  late RecordingNavigatorObserver observer;

  setUp(() async {
    harness = await installPageHarness();
    observer = RecordingNavigatorObserver();
  });

  SubUserController controller() => harness.resolve<SubUserController>();

  Iterable<String> paths() => harness.http.requests.map((r) => '${r.method} ${r.url.path}');

  Future<void> pumpPending(WidgetTester tester, {List<Map<String, dynamic>>? pending}) async {
    registerSubUserRoutes(
      harness.http,
      pending: pending ??
          [
            pendingJson(id: 1, name: 'Carlos Pendente'),
            pendingJson(id: 2, name: 'Dora Portaria', registrationOrigin: 'PORTARIA', linkDescription: 'Morador'),
            pendingJson(id: 3, name: 'Eva Sem Contrato', registrationOrigin: 'RESOLVA_FACIL_SEM_CONTRATO'),
            pendingJson(id: 4, name: 'Fabio Titular', registrationOrigin: 'JOB_ALTERACAO_TITULARIDADE'),
          ],
    );
    await controller().getSubUsers();
    await pumpPage(tester, const PendingRequestsPage(), observer: observer, surface: const Size(400, 1400));
  }

  /// Expande o card tocando no cabeçalho (chip da origem) e devolve um
  /// finder restrito ao painel expandido (os outros painéis mantêm o
  /// conteúdo expandido escondido na árvore).
  Future<Finder> expandCard(WidgetTester tester, RegistrationOrigin origin) async {
    await tester.tap(find.text(origin.name));
    await tester.pumpAndSettle();
    return find.ancestor(of: find.text(origin.name), matching: find.byType(ExpandablePanel));
  }

  Finder inPanel(Finder panel, Finder what) => find.descendant(of: panel, matching: what);

  testWidgets('lista as solicitações pendentes com origem e nome', (tester) async {
    await pumpPending(tester);

    expect(find.text('Edifício Lello - 101'), findsOneWidget);
    expect(find.text('Carlos Pendente'), findsWidgets);
    expect(find.text('Dora Portaria'), findsWidgets);
    expect(find.text(RegistrationOrigin.lelloRegistration.name), findsOneWidget);
    expect(find.text(RegistrationOrigin.conciergeRegistration.name), findsOneWidget);
    expect(find.text(RegistrationOrigin.registrationWithoutContract.name), findsOneWidget);
    expect(find.text(RegistrationOrigin.changeOfOwnership.name), findsOneWidget);
    expect(find.text('2 dias restantes'), findsNWidgets(4));

    await expectLater(find.byType(PendingRequestsPage), matchesGoldenFile('goldens/pending_requests_page.png'));
  });

  testWidgets('bloquear uma solicitação confirma e mostra sucesso', (tester) async {
    await pumpPending(tester);
    final panel = await expandCard(tester, RegistrationOrigin.lelloRegistration);

    await tester.tap(inPanel(panel, find.text('block')));
    await tester.pumpAndSettle();
    expect(find.byType(UpdateAccessRequestStatusConfirmDialog), findsOneWidget);
    expect(find.text('Você tem certeza que deseja bloquear'), findsOneWidget);
    await tester.tap(find.text('Não, quero voltar'));
    await tester.pumpAndSettle();
    expect(find.byType(UpdateAccessRequestStatusConfirmDialog), findsNothing);

    await tester.tap(inPanel(panel, find.text('block')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sim, bloquear'));
    await tester.pumpAndSettle();

    expect(paths(), contains('POST /concierge/subUser/pending_requests/change-status'));
    expect(find.byType(UpdateRequestStatusSuccessPage), findsOneWidget);
    expect(find.text(S.current.blockingSuccessful), findsOneWidget);

    await tester.tap(find.text('close'));
    await tester.pumpAndSettle();
    expect(find.byType(UpdateRequestStatusSuccessPage), findsNothing);
    expect(find.byType(PendingRequestsPage), findsOneWidget);
  });

  testWidgets('aprovar uma solicitação da administradora confirma e mostra sucesso', (tester) async {
    await pumpPending(tester);
    final panel = await expandCard(tester, RegistrationOrigin.lelloRegistration);

    await tester.tap(inPanel(panel, find.text(S.current.approve)));
    await tester.pumpAndSettle();
    expect(find.text('Você tem certeza que deseja aprovar'), findsOneWidget);
    expect(find.text(S.current.accessRequestApproveConfirmationMessage), findsOneWidget);
    await tester.tap(find.text('Sim, aprovar'));
    await tester.pumpAndSettle();

    expect(paths(), contains('POST /concierge/subUser/pending_requests/change-status'));
    expect(find.text(S.current.approvingSuccessfulUpperCase), findsOneWidget);
    expect(find.text(S.current.updateRequestStatusSuccessMessage), findsOneWidget);
  });

  testWidgets('troca de titularidade mostra as mensagens específicas', (tester) async {
    await pumpPending(tester);
    final panel = await expandCard(tester, RegistrationOrigin.changeOfOwnership);

    await tester.tap(inPanel(panel, find.text(S.current.approve)));
    await tester.pumpAndSettle();
    expect(find.text(S.current.changeOfOwnershipMessage), findsOneWidget);
    await tester.tap(find.text('Não, quero voltar'));
    await tester.pumpAndSettle();

    await tester.tap(inPanel(panel, find.text('block')));
    await tester.pumpAndSettle();
    expect(find.text(S.current.changeAccessRequestStatusToBlockedMessage), findsOneWidget);
  });

  testWidgets('sem contrato pede data de expiração antes de aprovar', (tester) async {
    await pumpPending(tester);
    final panel = await expandCard(tester, RegistrationOrigin.registrationWithoutContract);

    await tester.tap(inPanel(panel, find.text(S.current.approve)));
    await tester.pumpAndSettle();
    expect(find.byType(NoExpirationDateDialog), findsOneWidget);

    final approve = find.widgetWithText(PrimaryButton, 'Aprovar acesso');
    expect(tester.widget<PrimaryButton>(approve).onPressed, isNull);

    // confirmar sem trocar a data (hoje) não habilita o botão
    await tester.tap(find.byIcon(Icons.calendar_month));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(tester.widget<PrimaryButton>(approve).onPressed, isNull);

    // escolhe o dia seguinte
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    await tester.tap(find.byIcon(Icons.calendar_month));
    await tester.pumpAndSettle();
    if (tomorrow.month != DateTime.now().month) {
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text('${tomorrow.day}').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(tester.widget<PrimaryButton>(approve).onPressed, isNotNull);

    await tester.tap(approve);
    await tester.pumpAndSettle();
    expect(paths(), contains('POST /concierge/subUser/pending_requests/change-status'));
    expect(find.byType(UpdateRequestStatusSuccessPage), findsOneWidget);
  });

  testWidgets('diálogo sem data pode ser fechado', (tester) async {
    await pumpPending(tester);
    final panel = await expandCard(tester, RegistrationOrigin.registrationWithoutContract);
    await tester.tap(inPanel(panel, find.text(S.current.approve)));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Não, quero voltar'));
    await tester.pumpAndSettle();
    expect(find.byType(NoExpirationDateDialog), findsNothing);
  });

  testWidgets('ajuda abre a explicação dos tipos de solicitação', (tester) async {
    await pumpPending(tester);

    await tester.tap(find.byIcon(Icons.question_mark));
    await tester.pumpAndSettle();
    expect(find.text('Entenda os tipos de solicitações'), findsOneWidget);
    await tester.tap(find.text('Entendi'));
    await tester.pumpAndSettle();
    expect(find.text('Entenda os tipos de solicitações'), findsNothing);
  });

  testWidgets('puxar para atualizar recarrega os usuários', (tester) async {
    await pumpPending(tester);
    harness.http.requests.clear();

    await tester.drag(find.byType(RefreshIndicator), const Offset(0, 400));
    await tester.pumpAndSettle();

    /// Corrigido: pending_requests_page.dart usa AlwaysScrollableScrollPhysics
    /// no SingleChildScrollView, então o RefreshIndicator dispara o onRefresh.
    expect(paths(), contains('GET /concierge/subUser/u1'));
  });

  testWidgets('lista vazia fecha a página', (tester) async {
    await pumpPending(tester);

    await emitState(tester, controller().bloc, SubUserLoadedState(subUsers: [owner()], pendingRequests: const []), settle: false);
    await tester.pump();
    /// Corrigido: pending_requests_page.dart agenda o Navigator.pop em
    /// addPostFrameCallback (uma única vez) em vez de navegar durante o build.
    expect(tester.takeException(), isNull);
    await tester.pumpAndSettle();
    expect(observer.popped, hasLength(1));
  });

  testWidgets('estados de loading, erro e desconhecido', (tester) async {
    await pumpPending(tester);

    await emitState(tester, controller().bloc, SubUserLoadingState(), settle: false);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsWidgets);

    await emitState(tester, controller().bloc, UpdateStatusRequestLoadingState(), settle: false);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsWidgets);

    await emitState(tester, controller().bloc, SubUserErrorState(error: UnknownFailure('x')));
    expect(find.byType(ErrorHandlingWidget), findsOneWidget);
    harness.http.requests.clear();
    await tester.tap(find.text('error_handling_widget_button_reTry').first);
    await tester.pumpAndSettle();
    expect(paths(), contains('GET /concierge/subUser/u1'));

    await emitState(tester, controller().bloc, UpdateAccessStatusRequestErrorState(error: UnknownFailure('y')));
    expect(find.byType(ErrorHandlingWidget), findsOneWidget);
    await tester.tap(find.text('error_handling_widget_button_back').first);
    await tester.pumpAndSettle();
    expect(observer.popped, isNotEmpty);
    await pumpPending(tester);

    await emitState(tester, controller().bloc, CheckServiceOnlineState());
    expect(find.byType(ErrorHandlingWidget), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('falha ao mudar o status mostra erro', (tester) async {
    await pumpPending(tester);
    harness.http.on('POST', '/concierge/subUser/pending_requests/change-status', status: 500, body: {'message': 'x'});
    final panel = await expandCard(tester, RegistrationOrigin.lelloRegistration);

    await tester.tap(inPanel(panel, find.text('block')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sim, bloquear'));
    await tester.pumpAndSettle();

    /// Corrigido: sub_user_remote_data_source_impl.dart (updateAccessRequestStatus)
    /// lança quando a resposta não é sucesso, então um HTTP 500 vira estado de
    /// erro e a página de sucesso não é mostrada.
    expect(find.byType(UpdateRequestStatusSuccessPage), findsNothing);
    expect(find.byType(ErrorHandlingWidget), findsOneWidget);
  });

  group('UpdateAccessRequestStatusConfirmDialog', () {
    testWidgets('mensagens de bloqueio e aprovação', (tester) async {
      var confirmed = 0;
      await pumpApp(
        tester,
        Column(children: [
          UpdateAccessRequestStatusConfirmDialog(
            name: 'Carlos',
            type: 'Inquilino',
            origin: RegistrationOrigin.lelloRegistration,
            status: 'REPROVADA_PROPRIETARIO',
            onConfirm: () => confirmed++,
          ),
        ]),
        localized: true,
        surface: const Size(400, 900),
      );
      expect(find.text('Ele não terá acesso até que seja desbloqueado manualmente.'), findsOneWidget);
      expect(find.text('Carlos'), findsOneWidget);
      expect(find.text('Inquilino'), findsOneWidget);
    });
  });

  group('pending_requests_enum', () {
    testWidgets('nomes, valores e cores', (tester) async {
      await pumpApp(tester, const SizedBox(), localized: true);
      final theme = ThemeData.light();
      for (final origin in RegistrationOrigin.values) {
        expect(origin.name, isNotEmpty);
        expect(origin.value, isNotEmpty);
        expect(origin.color(theme), isA<Color>());
      }
      expect(RegistrationOrigin.conciergeRegistration.color(theme), const Color(0xFF0058A0));
      expect(RegistrationOrigin.changeOfOwnership.color(theme), const Color(0xFF8D3393));
      expect(PendingRequestStatus.values, hasLength(1));
      expect(pendingEntity().copyWith(name: 'x').name, 'x');
      expect(pendingEntity().props, isNotEmpty);
    });
  });
}
