import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/change_ownership/presentation/widget/change_ownership_generic_input.dart';
import 'package:morar/feature/sub_user/domain/entity/sub_user_role.dart';
import 'package:morar/feature/sub_user/presentation/bloc/sub_user_add_bloc.dart';
import 'package:morar/feature/sub_user/presentation/controllers/sub_user_add_controller.dart';
import 'package:morar/feature/sub_user/presentation/controllers/sub_user_controller.dart';
import 'package:morar/feature/sub_user/presentation/pages/contacts/sub_user_contact_info_page.dart';
import 'package:morar/feature/sub_user/presentation/pages/contacts/sub_user_contacts_page.dart';
import 'package:morar/feature/sub_user/presentation/pages/send_invite/sub_user_send_invite_page.dart';
import 'package:morar/feature/sub_user/presentation/widget/sub_user_contacts_card_widget.dart';
import 'package:morar/feature/sub_user/presentation/widget/sub_user_dialog_info.dart';
import 'package:morar/generated/l10n.dart';

import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';
import 'sub_user_test_helpers.dart';

const validCpf = '52998224725';

void main() {
  late PageHarness harness;
  late RecordingNavigatorObserver observer;

  setUp(() async {
    harness = await installPageHarness();
    observer = RecordingNavigatorObserver();
    registerSubUserRoutes(harness.http);
    mockFlutterContacts([
      {'displayName': 'Zeca Contato', 'phones': [{'number': '(11) 91111-2222'}]},
      {'displayName': 'Yara Sem Fone', 'phones': []},
    ]);
  });

  SubUserAddController add() => harness.resolve<SubUserAddController>();

  void mainUser(String role, String description) =>
      harness.resolve<SubUserController>().mainUser = owner(role: role, roleDescription: description);

  Future<void> pumpInfo(WidgetTester tester, {bool isConfirm = false}) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
    await pumpPage(
      tester,
      SubUserContactInfoPage(isConfirm: isConfirm),
      observer: observer,
      surface: const Size(500, 1500),
    );
  }

  Future<void> fillForm(WidgetTester tester) async {
    await tester.enterText(find.byType(TextFormField).at(0), 'Novo Morador');
    await tester.enterText(find.byType(TextFormField).at(1), validCpf);
    await tester.enterText(find.byType(TextFormField).at(2), 'novo@lello.com');
    await tester.enterText(find.byType(TextFormField).at(3), '11988887777');
    await tester.pump();
  }

  Future<void> chooseRole(WidgetTester tester, String description) async {
    await tester.tap(find.byType(DropdownButton<SubUserRole>));
    await tester.pumpAndSettle();
    await tester.tap(find.text(description).last);
    await tester.pumpAndSettle();
  }

  testWidgets('proprietário vê o formulário completo com o aviso', (tester) async {
    mainUser('morar.proprietario', 'Proprietário');
    await pumpInfo(tester);

    expect(find.text('add_user'), findsOneWidget);
    expect(find.text('Edifício Lello - 101'), findsOneWidget);
    expect(find.textContaining('Os moradores que forem cadastrados'), findsOneWidget);
    expect(find.byType(SubUserDialogInfo), findsOneWidget);
    expect(find.byType(ChangeOwnershipGenericInput), findsOneWidget);
    expect(find.text('residents_can_receive_billet_by_email'), findsOneWidget);
    expect(find.text('receive_billet_by_email'), findsOneWidget);
    expect(find.text('allow_app_access'), findsOneWidget);
    expect(find.text('add_from_contact_list'), findsOneWidget);
    expect(tester.widget<PrimaryButton>(find.widgetWithText(PrimaryButton, 'save')).onPressed, isNull);
    expect(add().roles.map((r) => r.role), isNot(contains('morar.proprietario')));

    expect(tester.getSize(find.byType(AnimatedContainer)).height, 80);
    await tester.tap(find.byIcon(Icons.close).first);
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(AnimatedContainer)).height, 0);

    await expectLater(find.byType(SubUserContactInfoPage), matchesGoldenFile('goldens/sub_user_contact_info_page.png'));
  });

  testWidgets('título de confirmação e voltar', (tester) async {
    mainUser('morar.proprietario', 'Proprietário');
    await pumpInfo(tester, isConfirm: true);
    expect(find.text('resident_confirm'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back_ios));
    await tester.pumpAndSettle();
    expect(observer.popped, isNotEmpty);
  });

  testWidgets('preencher tudo habilita salvar e navega para o convite', (tester) async {
    mainUser('morar.proprietario', 'Proprietário');
    await pumpInfo(tester);

    await fillForm(tester);
    expect(add().creationUser!.name, 'Novo Morador');
    expect(add().creationUser!.email, 'novo@lello.com');
    expect(add().creationUser!.phone, isNotEmpty);
    expect(tester.widget<PrimaryButton>(find.widgetWithText(PrimaryButton, 'save')).onPressed, isNull);

    await chooseRole(tester, 'Morador');
    expect(add().itemSelecionado!.role, 'morar.morador');
    expect(add().creationUser!.roleDescription, 'Morador');

    await tester.tap(find.text('receive_billet_by_email'));
    await tester.pump();
    expect(add().creationUser!.flagBoletoEmail, isTrue);
    await tester.tap(find.text('allow_app_access'));
    await tester.pump();
    expect(add().creationUser!.useApp, isFalse);

    await tester.tap(find.widgetWithText(PrimaryButton, 'save'));
    await tester.pumpAndSettle();

    expect(observer.pushedNames.last, ApplicationRoute.subUserInvitation);
    final args = observer.pushed.last.settings.arguments as SubUserSendInviteParams;
    expect(args.subUser.name, 'Novo Morador');
    expect(args.subUser.cpf, '529.982.247-25');
  });

  testWidgets('cpf inválido não navega', (tester) async {
    mainUser('morar.proprietario', 'Proprietário');
    await pumpInfo(tester);

    await tester.enterText(find.byType(TextFormField).at(0), 'Novo Morador');
    await tester.enterText(find.byType(TextFormField).at(1), '12345678901');
    await tester.enterText(find.byType(TextFormField).at(2), 'novo@lello.com');
    await tester.enterText(find.byType(TextFormField).at(3), '11988887777');
    await tester.pump();
    await chooseRole(tester, 'Parcial');

    await tester.tap(find.widgetWithText(PrimaryButton, 'save'));
    await tester.pumpAndSettle();

    expect(observer.pushedNames, isNot(contains(ApplicationRoute.subUserInvitation)));
  });

  testWidgets('email vazio e depois preenchido alterna o validador', (tester) async {
    mainUser('morar.proprietario', 'Proprietário');
    await pumpInfo(tester);

    await tester.enterText(find.byType(TextFormField).at(2), 'x');
    await tester.pump();
    await tester.enterText(find.byType(TextFormField).at(2), '');
    await tester.pump();
    expect(add().creationUser!.email, '');
  });

  testWidgets('data de expiração pode ser escolhida e limpa', (tester) async {
    mainUser('morar.proprietario', 'Proprietário');
    await pumpInfo(tester);

    await tester.tap(find.byIcon(Icons.calendar_month));
    await tester.pumpAndSettle();
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    if (tomorrow.month != DateTime.now().month) {
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text('${tomorrow.day}').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(add().creationUser!.expiresAt, isNotNull);
    expect(add().expirationDateController.text, DateFormat('dd/MM/yyyy').format(tomorrow));

    await tester.tap(find.descendant(of: find.byType(ChangeOwnershipGenericInput), matching: find.byIcon(Icons.close)));
    await tester.pumpAndSettle();
    expect(add().creationUser!.expiresAt, isNull);
    expect(add().expirationDateController.text, isEmpty);
  });

  testWidgets('contador de boletos mostra o aviso e bloqueia a troca no limite', (tester) async {
    mainUser('morar.proprietario', 'Proprietário');
    registerSubUserRoutes(harness.http, users: [
      ownerJson(),
      subUserJson(id: 'a', flagBoletoEmail: true),
      subUserJson(id: 'b', flagBoletoEmail: true),
    ]);
    await pumpInfo(tester);
    expect(add().billetByEmailCounter, 2);
    expect(find.text(S.current.billetByEmailCounterMessage(2, 1)), findsOneWidget);

    registerSubUserRoutes(harness.http, users: [
      ownerJson(),
      subUserJson(id: 'a', flagBoletoEmail: true),
      subUserJson(id: 'b', flagBoletoEmail: true),
      subUserJson(id: 'c', flagBoletoEmail: true),
    ]);
    await pumpInfo(tester);
    expect(find.text('max_residents_with_billet_by_email'), findsOneWidget);
    final switches = tester.widgetList<SwitchListTile>(find.byType(SwitchListTile)).toList();
    expect(switches.first.onChanged, isNull);
  });

  testWidgets('inquilino principal vê o aviso de morador e sem boleto por email', (tester) async {
    mainUser('morar.inquilino', 'Inquilino');
    await pumpInfo(tester);

    expect(tester.getSize(find.byType(AnimatedContainer)).height, 0);
    expect(find.text(S.current.addResidentDisclaimer), findsOneWidget);
    expect(find.text('receive_billet_by_email'), findsNothing);
    expect(find.byType(ChangeOwnershipGenericInput), findsNothing);
    expect(add().roles.map((r) => r.role), ['morar.morador', 'morar.parcial']);
  });

  testWidgets('adicionar da lista de contatos preenche o formulário', (tester) async {
    mainUser('morar.proprietario', 'Proprietário');
    await pumpInfo(tester);

    await tester.tap(find.text('add_from_contact_list'));
    await tester.pumpAndSettle();

    expect(find.byType(SubUserContactsPage), findsOneWidget);
    expect(find.text('resident_select_contact'), findsOneWidget);
    expect(find.byType(SubUserContactsCardWidget), findsNWidgets(2));

    await tester.enterText(find.widgetWithText(TextFormField, 'find'), 'zeca');
    await tester.pumpAndSettle();
    expect(find.byType(SubUserContactsCardWidget), findsWidgets);

    await tester.enterText(find.widgetWithText(TextFormField, 'find'), 'ninguem');
    await tester.pumpAndSettle();
    expect(find.text('resident_not_found'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.cancel));
    await tester.pumpAndSettle();
    expect(find.byType(SubUserContactsCardWidget), findsNWidgets(2));

    await tester.tap(find.text('Zeca Contato'));
    await tester.pumpAndSettle();

    expect(find.byType(SubUserContactsPage), findsNothing);
    expect(add().userSelected!.name, 'Zeca Contato');
    expect(add().nameController.text, 'Zeca Contato');
    expect(add().phoneController.text, isNotEmpty);
  });

  testWidgets('sem contatos mostra não encontrado', (tester) async {
    mockFlutterContacts([]);
    mainUser('morar.proprietario', 'Proprietário');
    await pumpInfo(tester);

    await tester.tap(find.text('add_from_contact_list'));
    await tester.pumpAndSettle();

    expect(add().bloc.state, isA<SubUserAddErrorState>());
    expect(find.text('resident_not_found'), findsOneWidget);
  });

  testWidgets('página de contatos mostra loading enquanto carrega', (tester) async {
    mainUser('morar.proprietario', 'Proprietário');
    await pumpPage(tester, const Scaffold(body: SubUserContactsPage()), settle: false);
    await emitState(tester, add().bloc, SubUserAddLoadingState(), settle: false);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsWidgets);
    await emitState(tester, add().bloc, SubUserAddSuccessState(subUsers: [subUser()]), settle: false);
    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.byType(SubUserContactsCardWidget), findsWidgets);
  });

  testWidgets('sair da página limpa a seleção', (tester) async {
    mainUser('morar.proprietario', 'Proprietário');
    await pumpInfo(tester);
    add().userSelected = subUser();
    await tester.pumpWidget(const SizedBox());
    expect(add().userSelected, isNull);
    expect(add().itemSelecionado, isNull);
  });

  testWidgets('usuário pré-selecionado com data preenche os campos', (tester) async {
    mainUser('morar.proprietario', 'Proprietário');
    add().userSelected = subUser(expiresAt: DateTime(2027, 3, 4));
    await pumpInfo(tester);
    expect(add().expirationDateController.text, '04/03/2027');
    expect(find.text('Bia Souza'), findsOneWidget);
  });
}
