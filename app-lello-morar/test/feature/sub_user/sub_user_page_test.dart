import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/navigation/application_rbac.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/home/domain/entity/unity.dart';
import 'package:morar/feature/sub_user/presentation/bloc/sub_users_bloc.dart';
import 'package:morar/feature/sub_user/presentation/controllers/sub_user_controller.dart';
import 'package:morar/feature/sub_user/presentation/controllers/sub_user_edit_controller.dart';
import 'package:morar/feature/sub_user/presentation/pages/send_invite/sub_user_send_invite_error.dart';
import 'package:morar/feature/sub_user/presentation/pages/send_invite/sub_user_send_invite_success.dart.dart';
import 'package:morar/feature/sub_user/presentation/pages/service/sub_user_service_off_page.dart';
import 'package:morar/feature/sub_user/presentation/pages/sub_user_page.dart';
import 'package:morar/feature/sub_user/presentation/widget/sub_user_bottom_button.dart';
import 'package:morar/feature/sub_user/presentation/widget/sub_user_card_widget.dart';
import 'package:morar/feature/sub_user/presentation/widget/sub_user_owner_card_widget.dart';

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

  testWidgets('lista o proprietário e os sub usuários da unidade', (tester) async {
    registerSubUserRoutes(harness.http, users: [
      ownerJson(),
      subUserJson(),
      subUserJson(id: 's2', name: 'Caio Lima', blocked: true, useApp: false),
    ]);

    await pumpPage(tester, const SubUserPage(), observer: observer, surface: const Size(400, 1200));

    expect(find.text('resident_access_app'), findsOneWidget);
    expect(find.text('Edifício Lello - 101'), findsOneWidget);
    expect(find.byType(SubUserOwnerCardWidget), findsOneWidget);
    expect(find.byType(SubUserCardWidget), findsNWidgets(2));
    expect(find.byType(SubUserBottomButton), findsOneWidget);
    expect(controller().mainUser.id, mainUserId);
    expect(
      harness.http.requests.map((r) => r.url.path),
      containsAll(['/concierge/subUser/u1', '/concierge/subUser/pending_requests/u1']),
    );
    // sem solicitações pendentes não mostra o banner
    expect(find.textContaining('solicita'), findsNothing);

    await expectLater(find.byType(SubUserPage), matchesGoldenFile('goldens/sub_user_page.png'));
  });

  testWidgets('proprietário com solicitações pendentes vê o banner e navega', (tester) async {
    registerSubUserRoutes(harness.http, pending: [pendingJson(), pendingJson(id: 2)]);

    await pumpPage(tester, const SubUserPage(), observer: observer);

    final banner = find.textContaining('2');
    expect(banner, findsWidgets);
    await tester.tap(find.byType(InkWell).first);
    await tester.pumpAndSettle();
    expect(observer.pushedNames.last, ApplicationRoute.subUserPendingRequests);
  });

  testWidgets('sem rbac de detalhes o banner não aparece e o card não navega', (tester) async {
    harness.sessionBloc.allowedRbacs = {
      ApplicationRbac.morarMoradoresSubmoradores,
      ApplicationRbac.morarMoradoresAdicionarUsuario,
    };
    registerSubUserRoutes(harness.http, pending: [pendingJson()]);

    await pumpPage(tester, const SubUserPage(), observer: observer);

    expect(find.byType(SubUserCardWidget), findsOneWidget);
    await tester.tap(find.byType(SubUserCardWidget));
    await tester.pumpAndSettle();
    expect(observer.pushedNames, isNot(contains(ApplicationRoute.subUserEdit)));
  });

  testWidgets('tocar em um sub usuário abre a edição com ele selecionado', (tester) async {
    registerSubUserRoutes(harness.http);

    await pumpPage(tester, const SubUserPage(), observer: observer);
    await tester.tap(find.byType(SubUserCardWidget));
    await tester.pumpAndSettle();

    expect(observer.pushedNames.last, ApplicationRoute.subUserEdit);
    expect(harness.resolve<SubUserEditController>().userSelected?.id, 's1');
  });

  testWidgets('tocar no proprietário abre a edição do usuário principal', (tester) async {
    registerSubUserRoutes(harness.http);

    await pumpPage(tester, const SubUserPage(), observer: observer);
    await tester.tap(find.text('Ana Silva'));
    await tester.pumpAndSettle();

    expect(observer.pushedNames.last, ApplicationRoute.subUserEdit);
    expect(harness.resolve<SubUserEditController>().userSelected?.id, mainUserId);
  });

  testWidgets('cadastrar biometria no card do proprietário checa o serviço', (tester) async {
    registerSubUserRoutes(harness.http);

    await pumpPage(tester, const SubUserPage(), observer: observer);
    await tester.tap(find.text('residents_register_sub_user_biometric_not_registered'));
    await tester.pumpAndSettle();

    expect(harness.http.requests.map((r) => r.url.path), contains('/concierge/accesscontrol/getServiceSeventh'));
    expect(observer.pushedNames.last, ApplicationRoute.subUserServiceOn);
  });

  testWidgets('botão adicionar usuário navega para novo contato', (tester) async {
    registerSubUserRoutes(harness.http);

    await pumpPage(tester, const SubUserPage(), observer: observer);
    await tester.tap(find.byType(SubUserBottomButton));
    await tester.pumpAndSettle();

    expect(observer.pushedNames.last, ApplicationRoute.subUserNewContact);
  });

  testWidgets('voltar pela app bar fecha a página', (tester) async {
    registerSubUserRoutes(harness.http);

    await pumpPage(tester, const SubUserPage(), observer: observer);
    await tester.tap(find.byIcon(Icons.arrow_back_ios).first);
    await tester.pumpAndSettle();

    expect(observer.popped, isNotEmpty);
  });

  testWidgets('erro na api mostra o widget de erro com retry e voltar', (tester) async {
    harness.http.failAll();

    await pumpPage(tester, const SubUserPage(), observer: observer);
    expect(find.byType(ErrorHandlingWidget), findsOneWidget);

    registerSubUserRoutes(harness.http);
    await tester.tap(find.text('error_handling_widget_button_reTry').first);
    await tester.pumpAndSettle();
    expect(find.byType(SubUserCardWidget), findsOneWidget);

    harness.http.failAll();
    await tester.drag(find.byType(RefreshIndicator), const Offset(0, 300));
    await tester.pumpAndSettle();
    expect(find.byType(ErrorHandlingWidget), findsOneWidget);

    await tester.tap(find.text('error_handling_widget_button_back').first, warnIfMissed: false);
    await tester.pumpAndSettle();
  });

  testWidgets('usuário logado fora da lista vira erro de usuário não encontrado', (tester) async {
    registerSubUserRoutes(harness.http, users: [subUserJson()]);

    await pumpPage(tester, const SubUserPage());

    expect(find.byType(ErrorHandlingWidget), findsOneWidget);
    expect(controller().bloc.state, isA<SubUserErrorState>());
  });

  testWidgets('estado de loading mostra o indicador', (tester) async {
    registerSubUserRoutes(harness.http);
    await pumpPage(tester, const SubUserPage(), settle: false);
    expect(find.byType(CircularProgressIndicator), findsWidgets);
    await tester.pumpAndSettle();

    await emitState(tester, controller().bloc, SubUserLoadingState(), settle: false);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsWidgets);
    await emitState(tester, controller().bloc, SubUserEmptyState(), settle: false);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });

  testWidgets('estado desconhecido cai no widget de erro genérico', (tester) async {
    registerSubUserRoutes(harness.http);
    await pumpPage(tester, const SubUserPage());

    await emitState(tester, controller().bloc, FacialBiometricLoadedState());
    expect(find.byType(ErrorHandlingWidget), findsOneWidget);
  });

  testWidgets('contexto de notificação abre a edição do usuário automaticamente', (tester) async {
    registerSubUserRoutes(harness.http);

    await pumpPage(
      tester,
      const SubUserPage(),
      observer: observer,
      arguments: SubUserPageArgs(subUserNotificationContext: 'np-s1'),
    );

    expect(observer.pushedNames, contains(ApplicationRoute.subUserEdit));
    expect(harness.resolve<SubUserEditController>().userSelected?.id, 's1');
  });

  testWidgets('contexto de notificação desconhecido não navega', (tester) async {
    registerSubUserRoutes(harness.http);

    await pumpPage(
      tester,
      const SubUserPage(),
      observer: observer,
      arguments: SubUserPageArgs(subUserNotificationContext: 'nao-existe'),
    );

    expect(observer.pushedNames, isNot(contains(ApplicationRoute.subUserEdit)));
  });

  testWidgets('convite enviado com sucesso abre a página de sucesso', (tester) async {
    registerSubUserRoutes(harness.http);
    await pumpPage(tester, const SubUserPage(), observer: observer);
    controller().userSelected = subUser();

    await emitState(tester, controller().bloc, SendInviteSuccessState());

    expect(find.byType(SendInviteSuccessPage), findsOneWidget);
    expect(controller().userSelected.useFacialBiometric, isTrue);
  });

  testWidgets('falha no convite abre a página de erro', (tester) async {
    registerSubUserRoutes(harness.http);
    await pumpPage(tester, const SubUserPage(), observer: observer);

    await emitState(tester, controller().bloc, SendInviteFailedState());

    expect(find.byType(SendInviteErrorPage), findsOneWidget);
  });

  testWidgets('loaded com sucesso abre a página de sucesso do convite', (tester) async {
    registerSubUserRoutes(harness.http);
    await pumpPage(tester, const SubUserPage(), observer: observer);

    await emitState(
      tester,
      controller().bloc,
      SubUserLoadedState(subUsers: [owner(), subUser()], pendingRequests: const [], sucess: true),
    );

    expect(find.byType(SendInviteSuccessPage), findsOneWidget);
  });

  testWidgets('serviço online navega para captura facial e recarrega ao voltar', (tester) async {
    registerSubUserRoutes(harness.http);
    await pumpPage(tester, const SubUserPage(), observer: observer);
    harness.http.requests.clear();

    await emitState(tester, controller().bloc, CheckServiceOnlineState());
    expect(observer.pushedNames.last, ApplicationRoute.subUserServiceOn);

    tester.state<NavigatorState>(find.byType(Navigator)).pop();
    await tester.pumpAndSettle();
    expect(harness.http.requests.map((r) => r.url.path), contains('/concierge/subUser/u1'));
  });

  testWidgets('serviço offline abre a página de serviço indisponível', (tester) async {
    registerSubUserRoutes(harness.http);
    await pumpPage(tester, const SubUserPage(), observer: observer);

    await emitState(tester, controller().bloc, CheckServiceOfflineState());
    expect(find.byType(SubUserServiceOffPage), findsOneWidget);

    await tester.tap(find.text('ok'));
    await tester.pumpAndSettle();
    expect(find.byType(SubUserServiceOffPage), findsNothing);
  });

  testWidgets('usuário principal inquilino não vê banner de pendências', (tester) async {
    registerSubUserRoutes(
      harness.http,
      users: [ownerJson(role: 'morar.inquilino', roleDescription: 'Inquilino'), subUserJson()],
      pending: [pendingJson()],
    );

    await pumpPage(tester, const SubUserPage(), observer: observer);

    expect(find.byType(SubUserCardWidget), findsOneWidget);
    expect(find.textContaining('pendente'), findsNothing);
  });

  testWidgets('sessão sem unidade cai em erro', (tester) async {
    harness.sessionBloc.session.unity = Unity();
    registerSubUserRoutes(harness.http);

    await pumpPage(tester, const SubUserPage());

    expect(find.byType(ErrorHandlingWidget), findsOneWidget);
  });
}
