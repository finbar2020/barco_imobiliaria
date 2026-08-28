import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/navigation/application_rbac.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:morar/feature/sub_user/domain/entity/sub_user_app_access_enum.dart';
import 'package:morar/feature/sub_user/presentation/bloc/sub_users_bloc.dart';
import 'package:morar/feature/sub_user/presentation/controllers/sub_user_controller.dart';
import 'package:morar/feature/sub_user/presentation/controllers/sub_user_edit_controller.dart';
import 'package:morar/feature/sub_user/presentation/widget/sub_user_bottom_button.dart';
import 'package:morar/feature/sub_user/presentation/widget/sub_user_card_widget.dart';
import 'package:morar/feature/sub_user/presentation/widget/sub_user_contacts_card_widget.dart';
import 'package:morar/feature/sub_user/presentation/widget/sub_user_owner_card_widget.dart';
import 'package:morar/feature/vehicles/domain/entity/concierge_creator.dart';

import '../../helpers/fixtures.dart';
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

  Future<void> pumpCard(WidgetTester tester, Widget child, {Size surface = const Size(400, 800)}) =>
      pumpPage(
        tester,
        Scaffold(body: Padding(padding: const EdgeInsets.all(8), child: child)),
        observer: observer,
        surface: surface,
      );

  group('SubUserCardWidget em lista', () {
    testWidgets('mostra nome formatado, perfil, acesso e seta quando tem onPressed', (tester) async {
      var pressed = false;
      await pumpCard(
        tester,
        SubUserCardWidget(
          model: subUser(name: 'Bia Maria Souza', registered: true),
          sessionBloc: harness.sessionBloc,
          isList: true,
          onPressed: () => pressed = true,
        ),
      );

      expect(find.text('Bia Souza'), findsOneWidget);
      expect(find.text('Morador'), findsOneWidget);
      expect(find.text('resident_installed_access_app'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);
      expect(find.text('send_invite'), findsOneWidget);

      await expectLater(find.byType(SubUserCardWidget), matchesGoldenFile('goldens/sub_user_card_widget.png'));

      await tester.tap(find.text('Bia Souza'));
      expect(pressed, isTrue);
    });

    testWidgets('variações de acesso ao app', (tester) async {
      await pumpCard(
        tester,
        Column(children: [
          SubUserCardWidget(model: subUser(id: '1'), sessionBloc: harness.sessionBloc, isList: true),
          SubUserCardWidget(model: subUser(id: '2', useApp: false), sessionBloc: harness.sessionBloc, isList: true),
          SubUserCardWidget(model: subUser(id: '3', blocked: true), sessionBloc: harness.sessionBloc, isList: true),
          SubUserCardWidget(model: subUser(id: '4', flagBoletoEmail: true), sessionBloc: harness.sessionBloc, isList: true),
        ]),
      );

      expect(find.text('resident_with_access_app'), findsNWidgets(2));
      expect(find.text('resident_without_access_app'), findsOneWidget);
      expect(find.text('resident_blocked_access_app'), findsOneWidget);
      expect(find.text('billet_by_email'), findsOneWidget);
      // bloqueado não mostra biometria
      expect(find.text('send_invite'), findsNWidgets(3));
      expect(find.byIcon(Icons.arrow_forward_ios), findsNothing);
    });

    testWidgets('rótulos de expiração de acesso', (tester) async {
      await pumpCard(
        tester,
        Column(children: [
          SubUserCardWidget(
            model: subUser(id: '1', expiresAt: DateTime.now().subtract(const Duration(days: 2))),
            sessionBloc: harness.sessionBloc,
            isList: true,
            showExpirationLabel: true,
          ),
          SubUserCardWidget(
            model: subUser(id: '2', expiresAt: DateTime.now().add(const Duration(days: 10))),
            sessionBloc: harness.sessionBloc,
            isList: true,
            showExpirationLabel: true,
          ),
          SubUserCardWidget(
            model: subUser(id: '3', expiresAt: DateTime.now().add(const Duration(days: 100))),
            sessionBloc: harness.sessionBloc,
            isList: true,
            showExpirationLabel: true,
          ),
          SubUserCardWidget(
            model: subUser(id: '4', expiresAt: DateTime.now().subtract(const Duration(days: 2))),
            sessionBloc: harness.sessionBloc,
            isList: true,
          ),
        ]),
      );

      expect(find.text('Acesso expirado'), findsOneWidget);
      expect(find.text('Acesso a expirar'), findsOneWidget);
    });

    testWidgets('biometria cadastrada mostra o texto de registrado', (tester) async {
      await pumpCard(
        tester,
        SubUserCardWidget(model: subUser(useFacialBiometric: true), sessionBloc: harness.sessionBloc, isList: true),
      );
      expect(find.text('residents_register_sub_user_biometric_registered'), findsOneWidget);
    });

    testWidgets('enviar convite abre o diálogo e dispara o convite por sms', (tester) async {
      await pumpCard(
        tester,
        SubUserCardWidget(model: subUser(), sessionBloc: harness.sessionBloc, isList: true),
      );

      await tester.tap(find.text('send_invite'));
      await tester.pumpAndSettle();
      expect(find.text('residents_invite_dialog_title'), findsOneWidget);

      await tester.tap(find.text('BACK'));
      await tester.pumpAndSettle();
      expect(find.text('residents_invite_dialog_title'), findsNothing);

      await tester.tap(find.text('send_invite'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(harness.http.requests.map((r) => r.url.path), contains('/concierge/accesscontrol/sendInvite'));
      final controller = harness.resolve<SubUserController>();
      expect(controller.userSelected.id, 's1');
      expect(controller.bloc.state, isA<SendInviteSuccessState>());
    });

    testWidgets('enviar convite sem telefone avisa com flushbar', (tester) async {
      await pumpCard(
        tester,
        SubUserCardWidget(model: subUser(phone: null), sessionBloc: harness.sessionBloc, isList: true),
      );

      await tester.tap(find.text('send_invite'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('residents_invite_empty_phone'), findsOneWidget);
      await tester.pump(const Duration(seconds: 6));
    });

    testWidgets('sem rbac de detalhes a coluna de acesso some', (tester) async {
      harness.sessionBloc.rbacAllowed = false;
      await pumpCard(
        tester,
        SubUserCardWidget(model: subUser(), sessionBloc: harness.sessionBloc, isList: true),
      );
      expect(find.text('resident_with_access_app'), findsNothing);
      expect(find.text('Bia Souza'), findsOneWidget);
    });

    testWidgets('condomínio sem biometria facial não mostra convite', (tester) async {
      harness.sessionBloc.session.condominium = testCondominium(useFacialBiometric: false);
      await pumpCard(
        tester,
        SubUserCardWidget(model: subUser(), sessionBloc: harness.sessionBloc, isList: true),
      );
      expect(find.text('send_invite'), findsNothing);
    });
  });

  group('SubUserCardWidget em edição', () {
    testWidgets('mostra botão de bloquear e descrição do criador', (tester) async {
      var pressed = false;
      await pumpCard(
        tester,
        SubUserCardWidget(
          model: subUser(creator: ConciergeCreator(name: 'Ana', type: ConciergeCreatorType.appmorar)),
          sessionBloc: harness.sessionBloc,
          isList: true,
          isEdit: true,
          onPressed: () => pressed = true,
        ),
      );

      expect(find.text('block'), findsOneWidget);
      expect(find.text('creator_vehicle Ana'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward_ios), findsNothing);
      await tester.tap(find.text('block'));
      expect(pressed, isTrue);
    });

    testWidgets('usuário bloqueado mostra desbloquear e opacidade', (tester) async {
      await pumpCard(
        tester,
        SubUserCardWidget(
          model: subUser(blocked: true, creator: ConciergeCreator(type: ConciergeCreatorType.appsindico)),
          sessionBloc: harness.sessionBloc,
          isEdit: true,
          isBlocked: true,
        ),
      );
      expect(find.text('resident_unlock'), findsOneWidget);
      expect(find.text('creator_vehicle_sindico'), findsOneWidget);
      expect(tester.widgetList<Opacity>(find.byType(Opacity)).any((o) => o.opacity == 0.5), isTrue);
    });

    testWidgets('usuário principal em edição mostra a foto e nenhum botão', (tester) async {
      await pumpCard(
        tester,
        SubUserCardWidget(
          model: owner().copyWith(creator: ConciergeCreator(type: ConciergeCreatorType.portaria)),
          sessionBloc: harness.sessionBloc,
          isEdit: true,
        ),
      );
      expect(find.text('block'), findsNothing);
      expect(find.text('creator_vehicle_concierge'), findsOneWidget);
    });

    testWidgets('criador de outro tipo não tem descrição', (tester) async {
      await pumpCard(
        tester,
        SubUserCardWidget(
          model: subUser(creator: ConciergeCreator(type: ConciergeCreatorType.resolvafacil)),
          sessionBloc: harness.sessionBloc,
          isEdit: true,
        ),
      );
      expect(find.text(''), findsOneWidget);
    });
  });

  testWidgets('AppAccessWidget cobre todos os estados', (tester) async {
    await pumpCard(
      tester,
      const Column(children: [
        AppAccessWidget(appAccess: SubUserAppAccessEnum.blockedAccess),
        AppAccessWidget(appAccess: SubUserAppAccessEnum.withoutAccess),
        AppAccessWidget(appAccess: SubUserAppAccessEnum.registered),
        AppAccessWidget(appAccess: SubUserAppAccessEnum.withAccess),
        AppAccessWidget(appAccess: SubUserAppAccessEnum.available),
      ]),
    );
    expect(find.text('resident_blocked_access_app'), findsOneWidget);
    expect(find.text('resident_without_access_app'), findsOneWidget);
    expect(find.text('resident_installed_access_app'), findsOneWidget);
    expect(find.text('resident_with_access_app'), findsNWidgets(2));
    expect(SubUserAppAccessEnum.available.available, isTrue);
    expect(SubUserAppAccessEnum.registered.registered, isTrue);
    expect(SubUserAppAccessEnum.withAccess.withAccess, isTrue);
    expect(SubUserAppAccessEnum.withoutAccess.withoutAccess, isTrue);
    expect(SubUserAppAccessEnum.blockedAccess.blockedAccess, isTrue);
  });

  group('SubUserOwnerCardWidget', () {
    testWidgets('proprietário sem biometria pode cadastrar e abre a edição ao tocar', (tester) async {
      await pumpCard(tester, SubUserOwnerCardWidget(model: owner()));

      expect(find.text('Ana Silva'), findsOneWidget);
      expect(find.text('Proprietário'), findsOneWidget);
      expect(find.text('residents_register_sub_user_biometric_not_registered'), findsOneWidget);

      await tester.tap(find.text('Ana Silva'));
      await tester.pumpAndSettle();
      expect(observer.pushedNames.last, ApplicationRoute.subUserEdit);
      expect(harness.resolve<SubUserEditController>().userSelected?.id, mainUserId);
    });

    testWidgets('cadastrar biometria checa o serviço', (tester) async {
      await pumpCard(tester, SubUserOwnerCardWidget(model: owner()));
      await tester.tap(find.text('residents_register_sub_user_biometric_not_registered'));
      await tester.pumpAndSettle();
      expect(harness.http.requests.map((r) => r.url.path), contains('/concierge/accesscontrol/getServiceSeventh'));
      expect(harness.resolve<SubUserController>().bloc.state, isA<SubUserLoadedState>());
    });

    testWidgets('biometria cadastrada permite enviar nova foto', (tester) async {
      await pumpCard(tester, SubUserOwnerCardWidget(model: owner(useFacialBiometric: true)));
      /// Corrigido: sub_user_owner_card_widget.dart usa Flexible/ellipsis na
      /// coluna da biometria e na linha "enviar nova foto"; sem overflow em
      /// telas de 400px.
      expect(tester.takeException(), isNull);
      expect(find.text('residents_register_sub_user_biometric_registered'), findsOneWidget);

      await tester.tap(find.text('residents_send_new_photo'));
      await tester.pumpAndSettle();
      expect(harness.http.requests.map((r) => r.url.path), contains('/concierge/accesscontrol/getServiceSeventh'));
    });

    testWidgets('sem biometria no condomínio e usuário não principal', (tester) async {
      harness.sessionBloc.session.condominium = testCondominium(useFacialBiometric: false);
      await pumpCard(tester, SubUserOwnerCardWidget(model: subUser()));
      expect(find.text('residents_register_sub_user_biometric_not_registered'), findsNothing);
      expect(find.text('Bia Souza'), findsOneWidget);
    });
  });

  group('SubUserContactsCardWidget', () {
    testWidgets('mostra nome, telefone e seta', (tester) async {
      var pressed = false;
      await pumpCard(
        tester,
        Column(children: [
          SubUserContactsCardWidget(
            model: subUser(),
            sessionBloc: harness.sessionBloc,
            onPressed: () => pressed = true,
          ),
          SubUserContactsCardWidget(model: owner(), sessionBloc: harness.sessionBloc, isEdit: true),
          SubUserContactsCardWidget(model: owner(), sessionBloc: harness.sessionBloc),
        ]),
      );
      expect(find.text('Bia Souza'), findsOneWidget);
      expect(find.text('(11) 99999-8888'), findsNWidgets(3));
      expect(find.byIcon(Icons.arrow_forward_ios), findsNWidgets(2));
      await tester.tap(find.byIcon(Icons.arrow_forward_ios).first);
      expect(pressed, isTrue);
    });
  });

  testWidgets('SubUserBottomButton mostra o título e chama onTap', (tester) async {
    var tapped = false;
    await pumpCard(tester, SubUserBottomButton(title: 'Adicionar', onTap: () => tapped = true));
    expect(find.text('Adicionar'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
    await tester.tap(find.text('Adicionar'));
    expect(tapped, isTrue);
  });

  testWidgets('rbac checado no card vem do sessionBloc', (tester) async {
    await pumpCard(
      tester,
      SubUserCardWidget(model: subUser(), sessionBloc: harness.sessionBloc, isList: true),
    );
    expect(harness.sessionBloc.rbacChecked, contains(ApplicationRbac.morarMoradoresSubmoradoresDetalhes));
    expect(harness.resolve<SessionBloc>(), same(harness.sessionBloc));
  });
}
