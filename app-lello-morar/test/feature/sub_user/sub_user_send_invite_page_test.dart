import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/sub_user/domain/use_cases/insert_sub_user/insert_sub_user_failures.dart';
import 'package:morar/feature/sub_user/presentation/bloc/sub_users_bloc.dart';
import 'package:morar/feature/sub_user/presentation/controllers/sub_user_controller.dart';
import 'package:morar/feature/sub_user/presentation/pages/send_invite/sub_user_send_invite_error.dart';
import 'package:morar/feature/sub_user/presentation/pages/send_invite/sub_user_send_invite_page.dart';
import 'package:morar/feature/sub_user/presentation/pages/send_invite/sub_user_send_invite_success.dart.dart';
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
    registerSubUserRoutes(harness.http);
  });

  Iterable<String> paths() => harness.http.requests.map((r) => '${r.method} ${r.url.path}');

  Future<void> pumpInvite(WidgetTester tester, {required SubUserSendInviteParams params}) =>
      pumpPage(tester, SubUserSendInvitePage(), observer: observer, arguments: params, surface: const Size(400, 1000));

  testWidgets('mostra os dados do usuário para revisão', (tester) async {
    await pumpInvite(
      tester,
      params: SubUserSendInviteParams(
        subUser: subUser(cpf: '529.982.247-25', expiresAt: DateTime(2027, 5, 6)),
      ),
    );

    expect(find.text('resident_send_invite'), findsOneWidget);
    expect(find.text('Edifício Lello - 101'), findsOneWidget);
    expect(find.text('resident_review_info'), findsOneWidget);
    expect(find.text('Bia Souza'), findsOneWidget);
    expect(find.text('email'), findsOneWidget);
    expect(find.text('529.982.247-25'), findsOneWidget);
    expect(find.text('bia@lello.com'), findsOneWidget);
    expect(find.text('(11) 99999-8888'), findsOneWidget);
    expect(find.text('Morador'), findsOneWidget);
    expect(find.text('06/05/2027'), findsOneWidget);
    expect(find.text('conclude'), findsOneWidget);

    await expectLater(find.byType(SubUserSendInvitePage), matchesGoldenFile('goldens/sub_user_send_invite_page.png'));
  });

  testWidgets('cnpj e campos vazios usam os textos padrão', (tester) async {
    await pumpInvite(
      tester,
      params: SubUserSendInviteParams(
        subUser: subUser(cpf: '12.345.678/0001-90', email: null, phone: null, roleDescription: 'Morador'),
      ),
    );

    expect(find.text('cnpj'), findsOneWidget);
    expect(find.text('not_informed'), findsNWidgets(3));
  });

  testWidgets('cpf nulo não quebra a página e mostra não informado', (tester) async {
    /// Corrigido: sub_user_send_invite_page.dart usava `cpf!` e quebrava com
    /// CPF nulo; o rótulo e o valor agora são nulo-seguros.
    await pumpInvite(tester, params: SubUserSendInviteParams(subUser: subUser(cpf: null)));

    expect(tester.takeException(), isNull);
    expect(find.text('email'), findsOneWidget);
    expect(find.text('not_informed'), findsNWidgets(2));
  });

  testWidgets('concluir convida o morador e mostra sucesso', (tester) async {
    // link da loja no remote config para montar o texto de compartilhamento
    harness.remoteConfig.values = {'link_app_store': '{"link":"http://loja","name":"Lello Morar"}'};
    await pumpInvite(tester, params: SubUserSendInviteParams(subUser: subUser(cpf: '529.982.247-25')));

    await tester.tap(find.text('conclude'));
    await tester.pumpAndSettle();

    expect(paths(), contains('POST /concierge/subUser'));
    expect(find.byType(SendInviteSuccessPage), findsOneWidget);
    expect(find.text('residents_invite_success_title'), findsOneWidget);
    expect(find.text('Edifício Lello - 101'), findsOneWidget);
  });

  testWidgets('falha genérica no convite mostra a página de erro', (tester) async {
    harness.http.on('POST', '/concierge/subUser', status: 500, body: {'message': 'x'});
    await pumpInvite(tester, params: SubUserSendInviteParams(subUser: subUser(cpf: '529.982.247-25')));

    await tester.tap(find.text('conclude'));
    await tester.pumpAndSettle();

    expect(find.byType(SendInviteErrorPage), findsOneWidget);
    expect(find.text('residents_invite_error_subtitle'), findsOneWidget);

    await tester.tap(find.text('close'));
    await tester.pumpAndSettle();
    expect(find.byType(SendInviteErrorPage), findsNothing);
  });

  testWidgets('conflito de cadastro mostra a mensagem de já cadastrado', (tester) async {
    harness.http.on('POST', '/concierge/subUser', status: 409, body: {
      'failure': 'insert_sub_user_conflict_failure',
      'title': 'Conflito',
    });
    await pumpInvite(tester, params: SubUserSendInviteParams(subUser: subUser(cpf: '529.982.247-25')));

    await tester.tap(find.text('conclude'));
    await tester.pumpAndSettle();

    expect(find.byType(SendInviteErrorPage), findsOneWidget);
    expect(find.text(S.current.subUserAlreadyRegistered), findsOneWidget);
    final state = harness.resolve<SubUserController>().bloc.state;
    expect(state, isA<InsertSubUserErrorState>());
    expect((state as InsertSubUserErrorState).failure, isA<InsertSubUserConflictFailure>());
  });

  testWidgets('estado de loading mostra o indicador', (tester) async {
    await pumpInvite(tester, params: SubUserSendInviteParams(subUser: subUser(cpf: '529.982.247-25')));

    await emitState(tester, harness.resolve<SubUserController>().bloc, SubUserInviteLoadingState(), settle: false);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });

  testWidgets('voltar fecha a página', (tester) async {
    await pumpInvite(tester, params: SubUserSendInviteParams(subUser: subUser(cpf: '529.982.247-25')));
    await tester.tap(find.byIcon(Icons.arrow_back_ios));
    await tester.pumpAndSettle();
    expect(observer.popped, isNotEmpty);
  });

  testWidgets('página de sucesso volta até a lista de moradores', (tester) async {
    await pumpPage(tester, const SizedBox(), observer: observer);
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.pushNamed(ApplicationRoute.subUser);
    await tester.pumpAndSettle();
    navigator.push(MaterialPageRoute(builder: (_) => const SendInviteSuccessPage()));
    await tester.pumpAndSettle();
    harness.http.requests.clear();

    await tester.tap(find.text('conclude'));
    await tester.pumpAndSettle();

    expect(find.byType(SendInviteSuccessPage), findsNothing);
    expect(findRoute(ApplicationRoute.subUser), findsOneWidget);
    expect(paths(), contains('GET /concierge/subUser/u1'));
  });

  testWidgets('página de erro fecha ao voltar pelo sistema', (tester) async {
    await pumpPage(tester, const SizedBox(), observer: observer);
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.push(MaterialPageRoute(builder: (_) => const SendInviteErrorPage()));
    await tester.pumpAndSettle();
    expect(find.text('facial_biometric_error_title'), findsOneWidget);

    await navigator.maybePop();
    await tester.pumpAndSettle();
    expect(find.byType(SendInviteErrorPage), findsNothing);
  });
}
