import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/access_control/domain/entity/access_control.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_stauts_biometric_enum.dart';
import 'package:morar/feature/access_control/presentation/bloc/access_control_state.dart';
import 'package:morar/feature/access_control/presentation/controllers/access_control_store.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_appointments_page.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_error_page.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_excluded_error.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_excluded_success.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_insert_page.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_invite_success_page.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_page.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_send_invite_success.dart';
import 'package:morar/feature/access_control/presentation/widget/access_control_appointments_card.dart';
import 'package:morar/feature/access_control/presentation/widget/access_control_delete_visitant_dialog.dart';

import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';
import 'access_control_test_helpers.dart';

void main() {
  late PageHarness harness;
  late RecordingNavigatorObserver observer;

  setUp(() async {
    harness = await installPageHarness();
    observer = RecordingNavigatorObserver();
  });

  AccessControlStore store() => harness.resolve<AccessControlStore>();

  Future<void> pumpAppointments(
    WidgetTester tester,
    AccessControl visitant, {
    bool settle = true,
    Size surface = const Size(400, 900),
  }) async {
    setLoadedState(store(), visitants: [visitant]);
    await pumpPage(
      tester,
      AccessControlAppointmentsPage(
        accessControl: visitant,
        accessControlStore: store(),
        isGeneric: false,
      ),
      observer: observer,
      settle: settle,
      surface: surface,
    );
  }

  testWidgets('lista agendamentos ativos e histórico (golden)', (tester) async {
    final visitant = gest(
      authorizations: [
        auth(id: 'a1', type: 'PHONE', start: DateTime(2020, 1, 10)),
        auth(id: 'a2', type: 'PONTUAL', start: DateTime(2099, 12, 31)),
        auth(
          id: 'a3',
          type: 'ACESSO_GRANTED',
          start: DateTime(2099, 1, 1),
          end: DateTime(2099, 12, 31),
          days: [2, 4],
        ),
        auth(id: 'a4', type: 'PONTUAL', start: DateTime(2020, 5, 5)),
      ],
    );
    await pumpAppointments(tester, visitant);

    expect(find.text('Carlos Souza'), findsOneWidget);
    expect(find.text('12345678909'), findsOneWidget);
    expect(find.text('access_control_active_appointment'), findsOneWidget);
    expect(find.text('access_control_history_appointment'), findsOneWidget);
    expect(find.byType(AccessControlAppointmentsCard), findsNWidgets(4));
    // Interfonar nunca expira, mesmo com data antiga
    expect(find.text('access_control_phone_approved'), findsOneWidget);
    expect(find.text('accountability_date: 31/12/2099'), findsOneWidget);
    expect(find.text('from: 01/01/2099'), findsOneWidget);
    expect(find.text('payment_filter_to: 31/12/2099'), findsOneWidget);
    expect(find.text('access_control_days: Seg, Qua'), findsOneWidget);
    expect(find.text('accountability_date: 05/05/2020'), findsOneWidget);
    // só os ativos podem ser editados
    expect(find.byIcon(Icons.edit), findsNWidgets(3));

    await expectLater(
      find.byType(AccessControlAppointmentsPage),
      matchesGoldenFile('goldens/access_control_appointments_page.png'),
    );
  });

  testWidgets('uma segunda instância da página não acumula os agendamentos',
      (tester) async {
    /// Corrigido: `expiredsAuth`/`activesAuth` eram listas globais, limpas
    /// só no `dispose`; uma segunda instância viva somava os itens da
    /// primeira. Agora são estado da página.
    final visitant = gest(
      authorizations: [
        auth(id: 'a1', type: 'PONTUAL', start: DateTime(2099, 12, 31)),
        auth(id: 'a2', type: 'PONTUAL', start: DateTime(2020, 5, 5)),
      ],
    );
    await pumpAppointments(tester, visitant);
    expect(find.byType(AccessControlAppointmentsCard), findsNWidgets(2));

    final navigator = Navigator.of(
      tester.element(find.byType(AccessControlAppointmentsPage)),
    );
    navigator.push(MaterialPageRoute(
      builder: (_) => AccessControlAppointmentsPage(
        accessControl: visitant,
        accessControlStore: store(),
        isGeneric: false,
      ),
    ));
    await tester.pumpAndSettle();
    expect(find.byType(AccessControlAppointmentsPage), findsOneWidget);
    expect(find.byType(AccessControlAppointmentsCard), findsNWidgets(2));
  });

  testWidgets('prestador mostra a firma (ou o texto padrão)', (tester) async {
    await pumpAppointments(tester, gest(type: 'SERVICE', business: 'Elétrica SA'));
    expect(find.text('Elétrica SA'), findsOneWidget);

    await resetApp(tester);
    await pumpAppointments(tester, gest(type: 'SERVICE', business: null, document: null));
    expect(find.text('access_control_provider'), findsOneWidget);
    expect(find.text('12345678909'), findsNothing);
  });

  testWidgets('editar um agendamento abre o cadastro em modo edição',
      (tester) async {
    final a = auth(id: 'a2', type: 'PONTUAL', start: DateTime(2099, 12, 31));
    final visitant = gest(authorizations: [a]);
    await pumpAppointments(tester, visitant);

    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();

    expect(observer.pushedNames.last, ApplicationRoute.accessControlInsert);
    final route = observer.pushed.last;
    final args = route.settings.arguments as AccessControlInsertPageArgs;
    expect(args.isEdit, isTrue);
    expect(args.authorization, same(a));
    final state = store().bloc.state as EditVisitantState;
    expect(state.visitant, same(visitant));
    expect(state.model, same(a));
  });

  testWidgets('sem permissão de editar/excluir/cadastrar esconde os controles',
      (tester) async {
    harness.sessionBloc.rbacAllowed = false;
    await pumpAppointments(
      tester,
      gest(authorizations: [auth(type: 'PONTUAL', start: DateTime(2099, 12, 31))]),
    );
    expect(find.byIcon(Icons.edit), findsNothing);
    expect(find.byIcon(Icons.delete_forever_outlined), findsNothing);
    expect(find.text('access_control_new_appointment'), findsNothing);
  });

  testWidgets('"novo agendamento" abre o cadastro com newVisit', (tester) async {
    final visitant = gest();
    await pumpAppointments(tester, visitant);

    await tester.tap(find.text('access_control_new_appointment'));
    await tester.pumpAndSettle();

    expect(findRoute(ApplicationRoute.accessControlInsert), findsOneWidget);
    final args = observer.pushed.last.settings.arguments as AccessControlInsertPageArgs;
    expect(args.newVisit, isTrue);
    expect((store().bloc.state as EditVisitantState).visitant, same(visitant));
  });

  group('biometria', () {
    testWidgets('mostra selo de biometria cadastrada', (tester) async {
      await pumpAppointments(
        tester,
        gest(
          statusBiometric: StatusBiometric.CADASTRADA,
          authorizations: [auth(type: 'PONTUAL', start: DateTime(2099, 12, 31), facial: true)],
        ),
      );
      expect(find.text('access_control_biometric_registered'), findsOneWidget);
      expect(find.text('access_control_send_biometric_invide'), findsNothing);
    });

    testWidgets('não mostra nada de biometria quando o condomínio não usa',
        (tester) async {
      harness.sessionBloc.session.condominium!.useFacialBiometric = false;
      await pumpAppointments(
        tester,
        gest(
          statusBiometric: StatusBiometric.NAO_CADASTRADA,
          authorizations: [auth(type: 'PONTUAL', start: DateTime(2099, 12, 31), facial: true)],
        ),
      );
      expect(find.text('access_control_biometric_registered'), findsNothing);
      expect(find.text('access_control_send_biometric_invide'), findsNothing);
    });

    testWidgets('enviar convite com sucesso abre a página de link', (tester) async {
      harness.http.on('POST', '/concierge/accesscontrol/sendInvite', body: '"https://link"');
      await pumpAppointments(
        tester,
        gest(
          statusBiometric: StatusBiometric.NAO_CADASTRADA,
          authorizations: [auth(type: 'PONTUAL', start: DateTime(2099, 12, 31), facial: true)],
        ),
      );

      await tester.tap(find.text('access_control_send_biometric_invide'));
      await tester.pumpAndSettle();

      expect(find.byType(AccessControlSendInviteSuccessPage), findsOneWidget);
      expect(find.text('accesss_control_copy_link'), findsOneWidget);
      final state = store().bloc.state as SaveVisitantLoadedState;
      expect(state.link, 'https://link');
      expect(harness.http.requests.single.url.path, '/concierge/accesscontrol/sendInvite');
    });

    testWidgets('falha ao enviar convite abre a página de erro', (tester) async {
      harness.http.failAll();
      await pumpAppointments(
        tester,
        gest(
          type: 'SERVICE',
          statusBiometric: StatusBiometric.NAO_CADASTRADA,
          authorizations: [auth(type: 'PONTUAL', start: DateTime(2099, 12, 31), facial: true)],
        ),
      );

      await tester.tap(find.text('access_control_send_biometric_invide'));
      await tester.pumpAndSettle();

      expect(find.byType(AccessControlErrorPage), findsOneWidget);
      expect(find.text('access_control_failed_send_invite'), findsOneWidget);
    });

    testWidgets('estado sendInvite abre a página de convite', (tester) async {
      await pumpAppointments(tester, gest());
      await emitState(
        tester,
        store().bloc,
        const SaveVisitantLoadedState(
          visitants: [],
          providers: [],
          useFacial: true,
          isVisitant: true,
          link: 'https://x',
          sendInvite: true,
        ),
      );
      expect(find.byType(AccessControlInviteSuccessPage), findsOneWidget);
    });
  });

  group('excluir visitante', () {
    testWidgets('confirmar exclusão leva à página de sucesso', (tester) async {
      harness.http.on('DELETE', '/concierge/accesscontrol/g1', body: {});
      await pumpAppointments(tester, gest());

      await tester.tap(find.byIcon(Icons.delete_forever_outlined));
      await tester.pumpAndSettle();
      expect(find.byType(AccessControlDeleteVisitantDialog), findsOneWidget);
      expect(find.text('access_control_delete_visitor'), findsOneWidget);

      await tester.tap(find.text('EXCLUDE'));
      await tester.pumpAndSettle();

      expect(find.byType(AccessControlExcludedSuccessPage), findsOneWidget);
      expect(find.text('access_control_deleted_visitor'), findsOneWidget);
      expect(harness.http.requests.single.method, 'DELETE');
    });

    testWidgets('cancelar fecha o diálogo sem excluir', (tester) async {
      await pumpAppointments(tester, gest(type: 'SERVICE'));

      await tester.tap(find.byIcon(Icons.delete_forever_outlined));
      await tester.pumpAndSettle();
      expect(find.text('access_control_delete_provider'), findsOneWidget);

      await tester.tap(find.text('CANCEL'));
      await tester.pumpAndSettle();

      expect(find.byType(AccessControlDeleteVisitantDialog), findsNothing);
      expect(harness.http.requests, isEmpty);
      expect(find.byType(AccessControlAppointmentsPage), findsOneWidget);
    });

    testWidgets('falha na exclusão leva à página de erro de exclusão',
        (tester) async {
      harness.http.failAll();
      await pumpAppointments(tester, gest(type: 'SERVICE'));

      await tester.tap(find.byIcon(Icons.delete_forever_outlined));
      await tester.pumpAndSettle();
      await tester.tap(find.text('EXCLUDE'));
      await tester.pumpAndSettle();

      expect(find.byType(AccessControlExcludedErrorPage), findsOneWidget);
      expect(find.text('access_control_failed_excluded_provider'), findsOneWidget);
    });

    testWidgets('falha genérica (não exclusão) leva à página de erro comum',
        (tester) async {
      await pumpAppointments(tester, gest());
      await emitState(
        tester,
        store().bloc,
        SaveVisitantFailureState(
          visitants: const [],
          providers: const [],
          visitant: gest(),
          model: auth(),
          failureInvite: false,
        ),
      );
      expect(find.byType(AccessControlErrorPage), findsOneWidget);
    });
  });

  group('voltar', () {
    testWidgets('botão da app bar volta para a aba do tipo do usuário',
        (tester) async {
      await pumpAppointments(tester, gest(type: 'SERVICE'));
      await tester.tap(find.byIcon(Icons.arrow_back_ios));
      await tester.pumpAndSettle();

      expect(findRoute(ApplicationRoute.accessControl), findsOneWidget);
      final args = observer.pushed.last.settings.arguments as AcessControlPageArgs;
      expect(args.tabIndex, 1);
    });

    testWidgets('voltar do sistema faz o mesmo (aba de visitantes)',
        (tester) async {
      await pumpAppointments(tester, gest());
      await systemBack(tester);

      expect(findRoute(ApplicationRoute.accessControl), findsOneWidget);
      final args = observer.pushed.last.settings.arguments as AcessControlPageArgs;
      expect(args.tabIndex, 0);
    });
  });

  testWidgets('estado de loading mostra o indicador', (tester) async {
    await pumpAppointments(tester, gest());
    await emitAndPump(tester, store().bloc, const AccessControlLoadingState());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
