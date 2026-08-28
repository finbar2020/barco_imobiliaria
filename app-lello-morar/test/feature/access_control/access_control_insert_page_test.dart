import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/access_control/domain/entity/access_control.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_authorizations.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_gest_units.dart';
import 'package:morar/feature/access_control/presentation/bloc/access_control_state.dart';
import 'package:morar/feature/access_control/presentation/controllers/access_control_store.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_appointments_page.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_error_page.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_insert_page.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_page.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_send_invite_error.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_send_invite_success.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_success_page.dart';
import 'package:morar/feature/access_control/presentation/widget/access_control_cpf_dialog.dart';
import 'package:morar/feature/access_control/presentation/widget/access_control_day_selector_widget.dart';
import 'package:morar/feature/access_control/presentation/widget/access_control_delete_visit_dialog.dart';
import 'package:morar/feature/access_control/presentation/widget/access_control_visitant_info_widget.dart';

import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';
import 'access_control_test_helpers.dart';

const savePath = '/concierge/accesscontrol';
const visitPath = '/concierge/accesscontrol/recurrence';
const invitePath = '/concierge/accesscontrol/sendInvite';
const validCpf = '52998224725';
const validCpfMasked = '529.982.247-25';

/// Visitante em branco, como as abas criam ao tocar em "novo".
AccessControl blank({String type = 'GEST'}) => AccessControl(
      type: type,
      gestUnits: [AccessControlGestUnits(authorizations: [])],
    );

void main() {
  late PageHarness harness;
  late RecordingNavigatorObserver observer;

  setUp(() async {
    harness = await installPageHarness();
    observer = RecordingNavigatorObserver();
  });

  AccessControlStore store() => harness.resolve<AccessControlStore>();

  List<String> paths() =>
      harness.http.requests.map((r) => '${r.method} ${r.url.path}').toList();

  Future<EditVisitantState> pumpInsert(
    WidgetTester tester, {
    required AccessControl visitant,
    AccessControlAuthorizations? model,
    AccessControlAuthorizations? authorization,
    bool newVisit = false,
    bool isEdit = false,
    List<AccessControl> visitants = const [],
    List<AccessControl> providers = const [],
    Size surface = const Size(400, 1800),
  }) async {
    final state = setEditState(
      store(),
      visitant: visitant,
      model: model,
      visitants: visitants,
      providers: providers,
    );
    await pumpPage(
      tester,
      // ignore: prefer_const_constructors
      AccessControlInsertPage(),
      arguments: AccessControlInsertPageArgs(
        accessControlStore: store(),
        authorization: authorization ?? AccessControlAuthorizations(),
        isGeneric: false,
        newVisit: newVisit,
        isEdit: isEdit,
      ),
      observer: observer,
      surface: surface,
    );
    return state;
  }

  void stubSaveOk() {
    harness.http.on('POST', savePath, body: visitantJson(id: 'novo'));
    harness.http.on('POST', visitPath, body: {});
    harness.http.on('PUT', savePath, body: {});
    harness.http.on('PUT', '$visitPath/a1', body: {});
    harness.http.on('POST', invitePath, body: '"https://link"');
  }

  Finder nameField() => find.byType(TextFormField).at(0);
  Finder cpfField() => find.widgetWithText(TextFormField, 'Informe o CPF');
  Finder dropdown() => find.byWidgetPredicate((w) => w is DropdownButton);

  /// O `InkWell` das tiles de autorização é só o círculo à esquerda do
  /// texto; localiza o círculo pela linha que contém o texto.
  Finder tileCircle(String text) => find.descendant(
        of: find.ancestor(of: find.text(text), matching: find.byType(Row)).first,
        matching: find.byType(InkWell),
      );

  Future<void> tapDirectAccess(WidgetTester tester) async {
    await tester.tap(tileCircle('access_control_access_direct'));
    await tester.pumpAndSettle();
  }

  Future<void> selectRecorrente(WidgetTester tester) async {
    await tester.tap(dropdown());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Recorrente').last);
    await tester.pumpAndSettle();
  }

  Future<void> confirmDatePicker(WidgetTester tester, Finder field) async {
    await tester.tap(field);
    await tester.pumpAndSettle();
    expect(find.text('Confirmar'), findsOneWidget);
    await tester.tap(find.text('Confirmar'));
    await tester.pumpAndSettle();
  }

  Future<void> save(WidgetTester tester, {String text = 'save'}) async {
    await tester.tap(find.text(text));
    await tester.pumpAndSettle();
  }

  group('novo visitante', () {
    testWidgets('mostra o formulário completo (golden)', (tester) async {
      await pumpInsert(tester, visitant: blank());

      expect(find.text('access_control_register'), findsOneWidget);
      expect(find.text('Edifício Lello - 101'), findsOneWidget);
      expect(find.text('full_name'), findsOneWidget);
      expect(find.text('cpf'), findsOneWidget);
      expect(find.text('access_control_foreign'), findsOneWidget);
      expect(find.text('access_control_firm'), findsNothing);
      expect(find.text('access_control_auth'), findsOneWidget);
      expect(find.text('access_control_phone'), findsOneWidget);
      expect(find.text('access_control_access_direct'), findsOneWidget);
      expect(find.text('save'), findsOneWidget);
      expect(find.text('access_control_cancel_register'), findsOneWidget);
      expect(find.text('access_control_delete_visit'), findsNothing);

      await expectLater(
        find.byType(AccessControlInsertPage),
        matchesGoldenFile('goldens/access_control_insert_page.png'),
      );
    });

    testWidgets('valida nome e CPF antes de salvar', (tester) async {
      await pumpInsert(tester, visitant: blank());

      await save(tester);
      expect(find.text('validation_required'), findsOneWidget);
      expect(harness.http.requests, isEmpty);

      await tester.enterText(nameField(), 'Novo Visitante');
      await tester.enterText(cpfField(), '11111111111');
      await save(tester);
      expect(find.text('validation_invalid_cpf'), findsOneWidget);
      expect(harness.http.requests, isEmpty);
    });

    testWidgets('salva com interfonar e vai para a página de sucesso',
        (tester) async {
      stubSaveOk();
      final state = await pumpInsert(tester, visitant: blank());

      await tester.enterText(nameField(), 'Novo Visitante');
      await tester.enterText(cpfField(), validCpf);
      expect(find.text(validCpfMasked), findsOneWidget);
      await save(tester);

      expect(paths(), ['POST $savePath', 'POST $visitPath']);
      final body = jsonDecode(harness.http.requests.first.body) as Map;
      expect(body['gest']['name'], 'Novo Visitante');
      expect(body['gest']['document'], validCpfMasked);
      expect(body['units'], hasLength(1));
      expect(state.model.autorizationType, 'PHONE');
      expect(state.model.recurrence, isNull);
      expect(state.model.useFacialBiometric, isFalse);
      expect(state.model.start, isoDate(today));
      expect(find.byType(AccessControlSendInviteSuccessPage), findsOneWidget);
      expect(find.text('access_control_invite_visitant_success_title'), findsOneWidget);
      expect(find.text('accesss_control_copy_link'), findsNothing);
    });

    testWidgets('prestador mostra o campo de firma e salva pelo controller de prestador',
        (tester) async {
      stubSaveOk();
      await pumpInsert(tester, visitant: blank(type: 'SERVICE'));

      expect(find.text('access_control_firm'), findsOneWidget);
      expect(find.text('access_control_foreign'), findsNothing);

      await tester.enterText(nameField(), 'Pedro');
      await tester.enterText(cpfField(), validCpf);
      await tester.enterText(find.byType(TextFormField).last, 'Elétrica SA');
      await save(tester);

      final body = jsonDecode(harness.http.requests.first.body) as Map;
      expect(body['gest']['business'], 'Elétrica SA');
      expect(body['gest']['type'], 'SERVICE');
      expect(find.text('access_control_invite_provider_success_title'), findsOneWidget);
    });

    testWidgets('falha ao salvar abre a página de erro de convite e permite tentar de novo',
        (tester) async {
      harness.http.failAll();
      await pumpInsert(tester, visitant: blank());
      await tester.enterText(nameField(), 'Novo');
      await tester.enterText(cpfField(), validCpf);
      await save(tester);

      expect(find.byType(AccessControlSendInviteErrorPage), findsOneWidget);
      await tester.tap(find.text('try_again'));
      await tester.pumpAndSettle();
      expect(findRoute(ApplicationRoute.accessControlInsert), findsOneWidget);
    });

    testWidgets('falha no agendamento após o cadastro apaga o visitante e mostra erro',
        (tester) async {
      // A store não emite mais `SaveVisitantLoadedState` intermediário após
      // salvar o visitante: a página fica em loading até a falha do
      // agendamento e vai direto para a tela de erro.
      harness.http.on('POST', savePath, body: visitantJson(id: 'novo'));
      harness.http.on('POST', visitPath, status: 500, body: {'message': 'erro'});
      harness.http.on('DELETE', '$savePath/novo', body: {});
      await pumpInsert(tester, visitant: blank());
      await tester.enterText(nameField(), 'Novo');
      await tester.enterText(cpfField(), validCpf);
      await save(tester);

      expect(find.byType(AccessControlSendInviteErrorPage), findsOneWidget);
      expect(find.byType(AccessControlSendInviteSuccessPage), findsNothing);
      expect(paths(), contains('DELETE $savePath/novo'));
      expect(store().bloc.state, isA<SaveVisitantFailureState>());
    });

    testWidgets('cancelar cadastro e voltar da app bar retornam à lista',
        (tester) async {
      await pumpInsert(tester, visitant: blank(type: 'SERVICE'));
      await tester.tap(find.text('access_control_cancel_register'));
      await tester.pumpAndSettle();
      expect(findRoute(ApplicationRoute.accessControl), findsOneWidget);
      expect((observer.pushed.last.settings.arguments as AcessControlPageArgs).tabIndex, 1);

      await resetApp(tester);
      await pumpInsert(tester, visitant: blank());
      await tester.tap(find.byIcon(Icons.arrow_back_ios));
      await tester.pumpAndSettle();
      expect(findRoute(ApplicationRoute.accessControl), findsOneWidget);
    });
  });

  group('acesso direto', () {
    testWidgets('pontual exige data', (tester) async {
      await pumpInsert(tester, visitant: blank());
      await tapDirectAccess(tester);

      expect(find.text('access_control_access_type'), findsOneWidget);
      expect(find.text('Pontual'), findsOneWidget);
      expect(find.text('date'), findsOneWidget);
      expect(find.text('dd/mm/aa'), findsOneWidget);

      await save(tester);
      expect(find.byType(Flushbar), findsOneWidget);
      expect(find.text('Necessário informar uma data.'), findsOneWidget);
      expect(harness.http.requests, isEmpty);
      await tester.pump(const Duration(seconds: 6));
    });

    testWidgets('recorrente exige data de início e fim', (tester) async {
      final state = await pumpInsert(tester, visitant: blank());
      await tapDirectAccess(tester);
      await selectRecorrente(tester);

      expect(state.model.recurrence?.recurrenceType, 'DAILY');
      expect(find.text('from'), findsOneWidget);
      expect(find.text('to'), findsOneWidget);
      expect(find.text('access_control_repeat'), findsOneWidget);
      expect(find.byType(DaySelector), findsOneWidget);
      expect(find.text('dd/mm/aa'), findsNWidgets(2));

      await save(tester);
      expect(find.text('Necessário informar uma data de início e final.'), findsOneWidget);
      await tester.pump(const Duration(seconds: 4));

      // volta para pontual limpa a recorrência
      await tester.tap(dropdown());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Pontual').last);
      await tester.pumpAndSettle();
      expect(state.model.recurrence, isNull);
      expect(find.byType(DaySelector), findsNothing);
    });

    testWidgets('escolhe a data no picker e salva pontual', (tester) async {
      stubSaveOk();
      final state = await pumpInsert(tester, visitant: blank());
      await tester.enterText(nameField(), 'Novo');
      await tester.enterText(cpfField(), validCpf);
      await tapDirectAccess(tester);

      // cancelar não escolhe nada
      await tester.tap(find.text('dd/mm/aa'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();
      expect(find.text('dd/mm/aa'), findsOneWidget);

      await confirmDatePicker(tester, find.text('dd/mm/aa'));
      expect(find.text('dd/mm/aa'), findsNothing);
      expect(state.model.start, isoDate(today));

      await save(tester);
      expect(state.model.autorizationType, 'PONTUAL');
      expect(state.model.end, isoDate(today));
      expect(state.model.recurrence, isNull);
      expect(paths(), ['POST $savePath', 'POST $visitPath']);
      final body = jsonDecode(harness.http.requests.last.body) as Map;
      expect(body['autorization_type'], 'PONTUAL');
      expect(find.byType(AccessControlSendInviteSuccessPage), findsOneWidget);
    });

    testWidgets('recorrente com as duas datas iguais usa só o dia da semana escolhido',
        (tester) async {
      stubSaveOk();
      final state = await pumpInsert(tester, visitant: blank());
      await tester.enterText(nameField(), 'Novo');
      await tester.enterText(cpfField(), validCpf);
      await tapDirectAccess(tester);
      await selectRecorrente(tester);

      // a data final fica desabilitada até escolher a inicial
      final endFinder = find.text('dd/mm/aa').last;
      await tester.tap(endFinder, warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.text('Confirmar'), findsNothing);

      await confirmDatePicker(tester, find.text('dd/mm/aa').first);
      expect(find.text('dd/mm/aa'), findsOneWidget);
      await confirmDatePicker(tester, find.text('dd/mm/aa'));
      expect(find.text('dd/mm/aa'), findsNothing);
      expect(state.model.start, isoDate(today));
      expect(state.model.end, isoDate(today));

      // com as duas datas escolhidas os pickers reabrem limitados uma à outra
      final dateText = find.text(DateFormat.yMd('pt_BR').format(today));
      expect(dateText, findsNWidgets(2));
      await tester.tap(dateText.first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();
      await tester.tap(dateText.last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      await save(tester);

      expect(state.model.autorizationType, 'ACESSO_GRANTED');
      final itens = state.model.recurrence!.itens!;
      expect(itens, hasLength(1));
      expect(itens.single.recurrenceValue, today.weekday % 7 + 1);
      final body = jsonDecode(harness.http.requests.last.body) as Map;
      expect(body['recurrence']['itens'], hasLength(1));
      expect(find.byType(AccessControlSendInviteSuccessPage), findsOneWidget);
    });
  });

  group('edição de agendamento', () {
    AccessControlAuthorizations recorrente({int dias = 10}) => auth(
          id: 'a1',
          type: 'ACESSO_GRANTED',
          start: today,
          end: today.add(Duration(days: dias)),
          days: [2, 4],
          facial: false,
        );

    testWidgets('pré-preenche datas e salva as alterações', (tester) async {
      stubSaveOk();
      final a = recorrente();
      final state = await pumpInsert(
        tester,
        visitant: gest(),
        model: a,
        authorization: a,
        isEdit: true,
      );

      expect(find.text('full_name'), findsNothing);
      expect(find.text('dd/mm/aa'), findsNothing);
      expect(find.text('Recorrente'), findsOneWidget);
      expect(find.byType(DaySelector), findsOneWidget);
      expect(find.text('access_control_delete_visit'), findsOneWidget);
      expect(find.text('Descartar alterações'), findsOneWidget);

      // intervalo >= 7 dias libera todos os dias
      await tester.tap(find.text('T'));
      await tester.pump();
      expect(state.model.choices[2], isTrue);

      await save(tester);

      expect(paths(), ['PUT $savePath', 'PUT $visitPath/a1']);
      expect(state.model.recurrence!.itens!.map((i) => i.recurrenceValue), [3]);
      expect(state.model.idGest, 'g1');
      expect(find.byType(AccessControlSuccessPage), findsOneWidget);
      expect(find.text('access_control_schedule_changed'), findsOneWidget);
    });

    testWidgets('intervalo menor que 7 dias habilita só os dias do período',
        (tester) async {
      stubSaveOk();
      final a = recorrente(dias: 6);
      final state = await pumpInsert(
        tester,
        visitant: gest(type: 'SERVICE'),
        model: a,
        authorization: a,
        isEdit: true,
      );
      await save(tester);
      // sem dia escolhido, usa todos os dias liberados do período (7 dias)
      expect(state.model.recurrence!.itens, hasLength(7));
      expect(find.text('access_control_schedule_changed'), findsOneWidget);
    });

    testWidgets('dia marcado fora do período é desmarcado ao salvar', (tester) async {
      stubSaveOk();
      final a = recorrente(dias: 1);
      // marca um dia fora do intervalo (hoje e amanhã)
      final fora = (today.weekday + 3) % 7;
      a.choices[fora] = true;
      final state = await pumpInsert(
        tester,
        visitant: gest(),
        model: a,
        authorization: a,
        isEdit: true,
      );
      await save(tester);
      expect(state.model.choices[fora], isFalse);
      expect(state.model.choices, everyElement(isFalse));
      expect(state.model.recurrence!.itens, hasLength(2));
      expect(find.text('access_control_schedule_changed'), findsOneWidget);
    });

    testWidgets('sem permissão de excluir esconde o botão de exclusão',
        (tester) async {
      harness.sessionBloc.rbacAllowed = false;
      final a = recorrente();
      await pumpInsert(tester, visitant: gest(), model: a, authorization: a, isEdit: true);
      expect(find.text('access_control_delete_visit'), findsNothing);
    });

    testWidgets('excluir agendamento pede confirmação e mostra sucesso',
        (tester) async {
      harness.http.on('DELETE', '$visitPath/a1', body: {});
      final a = recorrente();
      await pumpInsert(tester, visitant: gest(), model: a, authorization: a, isEdit: true);

      await tester.tap(find.text('access_control_delete_visit'));
      await tester.pumpAndSettle();
      expect(find.byType(AccessControlDeleteVisitDialog), findsOneWidget);
      await tester.tap(find.text('CANCEL'));
      await tester.pumpAndSettle();
      expect(find.byType(AccessControlDeleteVisitDialog), findsNothing);

      await tester.tap(find.text('access_control_delete_visit'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('EXCLUDE'));
      await tester.pumpAndSettle();

      expect(paths(), ['DELETE $visitPath/a1']);
      expect(find.text('access_control_schedule_delete'), findsOneWidget);
    });

    testWidgets('falha ao excluir agendamento mostra a página de erro',
        (tester) async {
      harness.http.failAll();
      final a = recorrente();
      await pumpInsert(tester, visitant: gest(), model: a, authorization: a, isEdit: true);
      await tester.tap(find.text('access_control_delete_visit'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('EXCLUDE'));
      await tester.pumpAndSettle();
      expect(find.byType(AccessControlErrorPage), findsOneWidget);
      expect(find.text('access_control_failed_excluded_visit'), findsOneWidget);
    });

    testWidgets('falha ao editar abre a página de erro de convite', (tester) async {
      harness.http.failAll();
      final a = recorrente();
      await pumpInsert(tester, visitant: gest(), model: a, authorization: a, isEdit: true);
      await save(tester);
      expect(find.byType(AccessControlSendInviteErrorPage), findsOneWidget);
    });

    testWidgets('descartar e voltar da app bar retornam aos agendamentos',
        (tester) async {
      final a = recorrente();
      await pumpInsert(tester, visitant: gest(), model: a, authorization: a, isEdit: true);
      await tester.tap(find.text('Descartar alterações'));
      await tester.pumpAndSettle();
      expect(find.byType(AccessControlAppointmentsPage), findsOneWidget);

      await resetApp(tester);
      await pumpInsert(tester, visitant: gest(), model: a, authorization: a, isEdit: true);
      await tester.tap(find.byIcon(Icons.arrow_back_ios));
      await tester.pumpAndSettle();
      expect(find.byType(AccessControlAppointmentsPage), findsOneWidget);
    });

    testWidgets('edição pontual pré-preenche só a data inicial', (tester) async {
      final a = auth(id: 'a1', type: 'PONTUAL', start: DateTime(2099, 12, 31));
      await pumpInsert(tester, visitant: gest(), model: a, authorization: a, isEdit: true);
      expect(find.text('Pontual'), findsOneWidget);
      expect(find.text('31/12/2099'), findsOneWidget);
      expect(find.text('dd/mm/aa'), findsNothing);
    });
  });

  group('nova visita', () {
    testWidgets('esconde nome/CPF, salva e mostra agendamento criado', (tester) async {
      stubSaveOk();
      final state = await pumpInsert(tester, visitant: gest(), newVisit: true);

      expect(find.text('full_name'), findsNothing);
      expect(find.text('cpf'), findsNothing);
      expect(find.text('access_control_foreign'), findsNothing);

      await save(tester);

      expect(paths(), ['PUT $savePath', 'POST $visitPath']);
      expect(state.model.idGest, 'g1');
      expect(state.model.idUnit, 'u1');
      expect(find.byType(AccessControlSuccessPage), findsOneWidget);
      expect(find.text('access_control_schedule_created'), findsOneWidget);

      await tester.tap(find.text('conclude'));
      await tester.pumpAndSettle();
      expect(findRoute(ApplicationRoute.accessControl), findsOneWidget);
    });

    testWidgets('prestador salva pelo controller de prestador', (tester) async {
      stubSaveOk();
      await pumpInsert(tester, visitant: gest(type: 'SERVICE'), newVisit: true);
      expect(find.text('access_control_firm'), findsNothing);
      await save(tester);
      expect(paths(), ['PUT $savePath', 'POST $visitPath']);
      expect(find.text('access_control_schedule_created'), findsOneWidget);
    });

    testWidgets('voltar da app bar retorna aos agendamentos', (tester) async {
      await pumpInsert(tester, visitant: gest(), newVisit: true);
      await tester.tap(find.byIcon(Icons.arrow_back_ios));
      await tester.pumpAndSettle();
      expect(find.byType(AccessControlAppointmentsPage), findsOneWidget);
    });
  });

  group('biometria', () {
    testWidgets('opção só aparece com acesso direto e condomínio com biometria',
        (tester) async {
      await pumpInsert(tester, visitant: blank());
      expect(find.text('access_control_access_biometric'), findsNothing);
      await tapDirectAccess(tester);
      expect(find.text('access_control_access_biometric'), findsOneWidget);

      await resetApp(tester);
      harness.sessionBloc.session.condominium!.useFacialBiometric = false;
      await pumpInsert(tester, visitant: blank());
      await tapDirectAccess(tester);
      expect(find.text('access_control_access_biometric'), findsNothing);
    });

    testWidgets('selecionar biometria mostra telefone, CPF faltante e o diálogo de informação',
        (tester) async {
      await pumpInsert(
        tester,
        visitant: gest(document: null, phone: null),
        newVisit: true,
      );
      await tapDirectAccess(tester);
      expect(find.text('registration_lello_user_phone_title'), findsNothing);

      await tester.tap(find.text('access_control_access_biometric'));
      await tester.pumpAndSettle();

      expect(find.text('registration_lello_user_phone_title'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, '00'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, '00000.0000'), findsOneWidget);
      expect(find.text('cpf'), findsOneWidget);
      expect(find.text('access_control_foreign'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.info_outline_rounded));
      await tester.pumpAndSettle();
      expect(find.text('access_control_info_dialog'), findsOneWidget);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(find.text('access_control_info_dialog'), findsNothing);

      // desmarca de novo
      await tester.tap(find.text('access_control_access_biometric'));
      await tester.pumpAndSettle();
      expect(find.text('registration_lello_user_phone_title'), findsNothing);
    });

    testWidgets('telefone é obrigatório com biometria', (tester) async {
      await pumpInsert(tester, visitant: gest(phone: null), newVisit: true);
      await tapDirectAccess(tester);
      await tester.tap(find.text('access_control_access_biometric'));
      await tester.pumpAndSettle();
      await confirmDatePicker(tester, find.text('dd/mm/aa'));
      await save(tester);
      expect(find.text('validation_required'), findsNWidgets(2));
      expect(harness.http.requests, isEmpty);
    });

    testWidgets('novo cadastro com biometria envia convite e mostra o link',
        (tester) async {
      stubSaveOk();
      final state = await pumpInsert(tester, visitant: blank());
      await tester.enterText(nameField(), 'Novo');
      await tester.enterText(cpfField(), validCpf);
      await tapDirectAccess(tester);
      await tester.tap(find.text('access_control_access_biometric'));
      await tester.pumpAndSettle();
      expect(find.text('access_control_save_send_button'), findsOneWidget);

      await tester.enterText(find.widgetWithText(TextFormField, '00'), '11');
      await tester.enterText(find.widgetWithText(TextFormField, '00000.0000'), '999998888');
      await confirmDatePicker(tester, find.text('dd/mm/aa'));
      await save(tester, text: 'access_control_save_send_button');

      expect(paths(), ['POST $savePath', 'POST $visitPath', 'POST $invitePath']);
      expect(state.model.useFacialBiometric, isTrue);
      // a store normaliza o telefone (só dígitos) no próprio objeto do estado
      expect(state.visitant.phone, '11999998888');
      final invite = jsonDecode(harness.http.requests.last.body) as Map;
      expect(invite['phone'], '11999998888');
      expect(invite['cpf'], validCpf);
      expect(invite['user_type'], 'gest');
      expect(find.byType(AccessControlSendInviteSuccessPage), findsOneWidget);
      expect(find.text('accesss_control_copy_link'), findsOneWidget);
      expect((store().bloc.state as SaveVisitantLoadedState).link, 'https://link');
    });

    testWidgets('nova visita com biometria reaproveita o telefone e envia convite',
        (tester) async {
      stubSaveOk();
      final state = await pumpInsert(tester, visitant: gest(), newVisit: true);
      await tapDirectAccess(tester);
      await tester.tap(find.text('access_control_access_biometric'));
      await tester.pumpAndSettle();

      expect(find.text('cpf'), findsNothing);
      final ddd = tester.widget<TextFormField>(find.widgetWithText(TextFormField, '00'));
      expect(ddd.initialValue, '11');
      final phone = tester.widget<TextFormField>(find.widgetWithText(TextFormField, '00000.0000'));
      expect(phone.initialValue, '999998888');

      await confirmDatePicker(tester, find.text('dd/mm/aa'));
      await save(tester);

      /// Corrigido: `AccessControlStore.saveVisit` com biometria devolve o
      /// resultado do convite e não emite mais a falha final; a store também
      /// deixou de emitir `SaveVisitantLoadedState` intermediários, então a
      /// página só navega quando o fluxo inteiro terminou, na tela de sucesso
      /// do convite.
      expect(paths(), ['PUT $savePath', 'POST $visitPath', 'POST $invitePath']);
      expect(state.model.useFacialBiometric, isTrue);
      expect(store().bloc.state, isA<SaveVisitantLoadedState>());
      expect((store().bloc.state as SaveVisitantLoadedState).link, 'https://link');
      expect(find.byType(AccessControlSendInviteSuccessPage), findsOneWidget);
      expect(find.byType(AccessControlSendInviteErrorPage), findsNothing);
      expect(find.byType(AccessControlSuccessPage), findsNothing);
      expect(find.text('accesss_control_copy_link'), findsOneWidget);
    });

    testWidgets('telefone com 10 dígitos e telefone curto são separados corretamente',
        (tester) async {
      await pumpInsert(tester, visitant: gest(phone: '1133334444'), newVisit: true);
      await tapDirectAccess(tester);
      await tester.tap(find.text('access_control_access_biometric'));
      await tester.pumpAndSettle();
      expect(tester.widget<TextFormField>(find.widgetWithText(TextFormField, '00')).initialValue, '11');
      expect(tester.widget<TextFormField>(find.widgetWithText(TextFormField, '00000.0000')).initialValue, '33334444');

      await resetApp(tester);
      /// Corrigido: `_initialDDD`/`_initialPhone` testam o formato ("+55",
      /// "(DD)") no texto original antes de remover os não-dígitos.
      await pumpInsert(tester, visitant: gest(phone: '+55 (11) 9999'), newVisit: true);
      await tapDirectAccess(tester);
      await tester.tap(find.text('access_control_access_biometric'));
      await tester.pumpAndSettle();
      expect(tester.widget<TextFormField>(find.widgetWithText(TextFormField, '00')).initialValue, '11');
      expect(tester.widget<TextFormField>(find.widgetWithText(TextFormField, '00000.0000')).initialValue, '9999');

      await resetApp(tester);
      await pumpInsert(tester, visitant: gest(phone: '(11) 98888-7777'), newVisit: true);
      await tapDirectAccess(tester);
      await tester.tap(find.text('access_control_access_biometric'));
      await tester.pumpAndSettle();
      expect(tester.widget<TextFormField>(find.widgetWithText(TextFormField, '00')).initialValue, '11');
      expect(tester.widget<TextFormField>(find.widgetWithText(TextFormField, '00000.0000')).initialValue, '988887777');

      await resetApp(tester);
      await pumpInsert(tester, visitant: gest(phone: '+55'), newVisit: true);
      await tapDirectAccess(tester);
      await tester.tap(find.text('access_control_access_biometric'));
      await tester.pumpAndSettle();
      expect(tester.widget<TextFormField>(find.widgetWithText(TextFormField, '00')).initialValue, '');
      expect(tester.widget<TextFormField>(find.widgetWithText(TextFormField, '00000.0000')).initialValue, '');

      await resetApp(tester);
      await pumpInsert(tester, visitant: gest(phone: '99999'), newVisit: true);
      await tapDirectAccess(tester);
      await tester.tap(find.text('access_control_access_biometric'));
      await tester.pumpAndSettle();
      expect(tester.widget<TextFormField>(find.widgetWithText(TextFormField, '00')).initialValue, '');
      expect(tester.widget<TextFormField>(find.widgetWithText(TextFormField, '00000.0000')).initialValue, '99999');
    });

    testWidgets('documento estrangeiro sem tipo é obrigatório com biometria',
        (tester) async {
      await pumpInsert(tester, visitant: blank());
      await tester.enterText(nameField(), 'Novo');
      await tester.tap(find.text('access_control_foreign'));
      await tester.pumpAndSettle();
      await tapDirectAccess(tester);
      await tester.tap(find.text('access_control_access_biometric'));
      await tester.pumpAndSettle();
      await confirmDatePicker(tester, find.text('dd/mm/aa'));
      await save(tester, text: 'access_control_save_send_button');
      // documento + DDD + telefone
      expect(find.text('validation_required'), findsNWidgets(3));
      expect(harness.http.requests, isEmpty);
    });

    testWidgets('falha no convite abre a página de erro de convite',
        (tester) async {
      harness.http.on('PUT', savePath, body: {});
      harness.http.on('PUT', '$visitPath/a1', body: {});
      harness.http.on('POST', invitePath, status: 500, body: {'message': 'x'});
      final a = auth(id: 'a1', type: 'PONTUAL', start: DateTime(2099, 12, 31), facial: true);
      await pumpInsert(tester, visitant: gest(), model: a, authorization: a, isEdit: true);
      expect(find.text('registration_lello_user_phone_title'), findsOneWidget);

      await save(tester, text: 'access_control_save_send_button');

      expect(paths(), ['PUT $savePath', 'PUT $visitPath/a1', 'POST $invitePath']);
      expect(find.byType(AccessControlErrorPage), findsOneWidget);
      expect(find.text('access_control_failed_send_invite'), findsOneWidget);
    });
  });

  group('CPF duplicado', () {
    testWidgets('ao digitar abre o diálogo; "vamos lá" abre os agendamentos do outro',
        (tester) async {
      final existing = gest(id: 'g9', name: 'Já Existe', document: validCpf);
      await pumpInsert(tester, visitant: blank(), visitants: [existing]);

      await tester.enterText(cpfField(), validCpf);
      await tester.pumpAndSettle();
      expect(find.byType(AccessControlCpfDialog), findsOneWidget);
      expect(find.text('access_control_cpf_visitant_title'), findsOneWidget);

      await tester.tap(find.text('CANCEL'));
      await tester.pumpAndSettle();
      expect(find.byType(AccessControlCpfDialog), findsNothing);

      // ao salvar o diálogo volta a aparecer
      await tester.enterText(nameField(), 'Novo');
      await save(tester);
      expect(find.byType(AccessControlCpfDialog), findsOneWidget);
      expect(harness.http.requests, isEmpty);

      await tester.tap(find.text('VAMOS LÁ'));
      await tester.pumpAndSettle();
      expect(find.byType(AccessControlAppointmentsPage), findsOneWidget);
      expect(find.text('Já Existe'), findsOneWidget);
    });

    testWidgets('prestador duplicado usa o texto de prestador', (tester) async {
      final existing = gest(id: 'p9', type: 'SERVICE', document: validCpf);
      await pumpInsert(tester, visitant: blank(), providers: [existing]);
      await tester.enterText(cpfField(), validCpf);
      await tester.pumpAndSettle();
      expect(find.text('access_control_cpf_provider_title'), findsOneWidget);
    });

    testWidgets('o próprio visitante não conta como duplicado', (tester) async {
      stubSaveOk();
      final me = gest(document: validCpf);
      await pumpInsert(tester, visitant: me, visitants: [me]);
      await save(tester);
      expect(find.byType(AccessControlCpfDialog), findsNothing);
      expect(paths(), isNotEmpty);
    });
  });

  group('estrangeiro', () {
    testWidgets('RNE: escolhe o tipo, valida e salva o documento', (tester) async {
      stubSaveOk();
      final state = await pumpInsert(tester, visitant: blank());

      await tester.tap(find.text('access_control_foreign'));
      await tester.pumpAndSettle();
      expect(find.text('cpf'), findsNothing);
      expect(find.text('access_control_document'), findsOneWidget);
      expect(find.text('access_control_document_number'), findsOneWidget);
      expect(find.text('access_control_choose_option'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, '0000000'), findsOneWidget);

      await tester.tap(dropdown());
      await tester.pumpAndSettle();
      await tester.tap(find.text('RNE').last);
      await tester.pumpAndSettle();
      expect(find.widgetWithText(TextFormField, '0000000-0'), findsOneWidget);

      await tester.enterText(nameField(), 'Estrangeiro');
      await tester.enterText(find.widgetWithText(TextFormField, '0000000-0'), '1234567');
      await save(tester);
      expect(find.text('validation_invalid_length'), findsWidgets);
      expect(harness.http.requests, isEmpty);

      await tester.enterText(find.widgetWithText(TextFormField, '0000000-0'), '12345678');
      await save(tester);

      expect(state.visitant.typeDocument, 'RNE');
      expect(state.visitant.foreignDocument, '12345678');
      expect(state.visitant.document, '');
      expect(find.byType(AccessControlSendInviteSuccessPage), findsOneWidget);
    });

    testWidgets('passaporte valida o tamanho', (tester) async {
      stubSaveOk();
      final state = await pumpInsert(tester, visitant: blank());
      await tester.tap(find.text('access_control_foreign'));
      await tester.pumpAndSettle();
      await tester.tap(dropdown());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Passaporte').last);
      await tester.pumpAndSettle();

      await tester.enterText(nameField(), 'Estrangeiro');
      await tester.enterText(find.widgetWithText(TextFormField, '0000000'), 'AB12');
      await save(tester);
      expect(harness.http.requests, isEmpty);

      await tester.enterText(find.widgetWithText(TextFormField, '0000000'), 'AB123456');
      await save(tester);
      expect(state.visitant.typeDocument, 'PASSAPORTE');
      expect(find.byType(AccessControlSendInviteSuccessPage), findsOneWidget);
    });

    testWidgets('documento estrangeiro já cadastrado abre o diálogo', (tester) async {
      final existing = gest(
        id: 'g9',
        document: null,
        foreignDocument: '12345678',
        typeDocument: 'RNE',
      );
      await pumpInsert(tester, visitant: blank(), visitants: [existing]);
      await tester.tap(find.text('access_control_foreign'));
      await tester.pumpAndSettle();
      await tester.tap(dropdown());
      await tester.pumpAndSettle();
      await tester.tap(find.text('RNE').last);
      await tester.pumpAndSettle();

      await tester.enterText(find.widgetWithText(TextFormField, '0000000-0'), '12345678');
      await tester.pumpAndSettle();
      expect(find.byType(AccessControlCpfDialog), findsOneWidget);
    });

    testWidgets('visitante estrangeiro existente pré-preenche o documento',
        (tester) async {
      final a = auth(id: 'a1', type: 'PONTUAL', start: DateTime(2099, 12, 31), facial: true);
      await pumpInsert(
        tester,
        visitant: gest(document: null, foreignDocument: 'AB123456', typeDocument: 'PASSAPORTE'),
        model: a,
        authorization: a,
        isEdit: true,
      );
      // em edição o bloco de estrangeiro só aparece com biometria e sem
      // documento estrangeiro; aqui o documento existe, então fica oculto
      expect(find.text('access_control_document'), findsNothing);
      expect(find.text('cpf'), findsNothing);
    });

    testWidgets('em edição com biometria e sem documento mostra o bloco de estrangeiro',
        (tester) async {
      final a = auth(id: 'a1', type: 'PONTUAL', start: DateTime(2099, 12, 31), facial: true);
      await pumpInsert(
        tester,
        visitant: gest(document: null, foreignDocument: null),
        model: a,
        authorization: a,
        isEdit: true,
      );
      expect(find.text('access_control_foreign'), findsOneWidget);
      expect(find.text('cpf'), findsOneWidget);
      await tester.tap(find.text('access_control_foreign'));
      await tester.pumpAndSettle();
      expect(find.text('access_control_document'), findsOneWidget);
    });
  });

  group('estados do bloc', () {
    testWidgets('loading mostra o indicador e estados desconhecidos ficam vazios',
        (tester) async {
      await pumpInsert(tester, visitant: blank());
      expect(find.byType(AccessControlVisitantInfoWidget), findsOneWidget);

      await emitAndPump(tester, store().bloc, const AccessControlLoadingState());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(AccessControlVisitantInfoWidget), findsNothing);

      await emitState(tester, store().bloc, const AccessControlLoadedState(visitants: [], providers: []));
      expect(find.byType(AccessControlVisitantInfoWidget), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // fora do estado de edição o voltar vai para a lista mesmo em newVisit
      await tester.tap(find.byIcon(Icons.arrow_back_ios));
      await tester.pumpAndSettle();
      expect(findRoute(ApplicationRoute.accessControl), findsOneWidget);
    });

    testWidgets('falha de convite e falha de exclusão navegam para a página de erro',
        (tester) async {
      await pumpInsert(tester, visitant: blank());
      await emitState(
        tester,
        store().bloc,
        SaveVisitantFailureState(
          visitants: const [],
          providers: const [],
          visitant: gest(),
          model: auth(),
          failureInvite: true,
        ),
      );
      expect(find.text('access_control_failed_send_invite'), findsOneWidget);

      await resetApp(tester);
      await pumpInsert(tester, visitant: blank());
      await emitState(
        tester,
        store().bloc,
        DeleteFailureVisitState(
          visitants: const [],
          providers: const [],
          visitant: gest(),
          model: auth(),
        ),
      );
      expect(find.text('access_control_failed_excluded_visit'), findsOneWidget);
    });

    testWidgets('exclusão de agendamento vinda do bloc mostra sucesso', (tester) async {
      await pumpInsert(tester, visitant: blank());
      await emitState(tester, store().bloc, const DeleteVisitState(isVisitant: false));
      expect(find.text('access_control_schedule_delete'), findsOneWidget);
    });
  });
}
