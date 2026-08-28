
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/change_ownership/presentation/widget/change_ownership_generic_input.dart';
import 'package:morar/feature/me/presentation/bloc/me_state.dart';
import 'package:morar/feature/me/presentation/widgets/me_edit_phone.dart';
import 'package:morar/feature/sub_user/domain/entity/sub_user.dart';
import 'package:morar/feature/sub_user/domain/entity/sub_user_role.dart';
import 'package:morar/feature/sub_user/presentation/bloc/sub_user_edit_bloc.dart';
import 'package:morar/feature/sub_user/presentation/bloc/sub_users_bloc.dart';
import 'package:morar/feature/sub_user/presentation/controllers/sub_user_controller.dart';
import 'package:morar/feature/sub_user/presentation/controllers/sub_user_edit_controller.dart';
import 'package:morar/feature/sub_user/presentation/pages/edit/sub_user_edit_blocked_page.dart';
import 'package:morar/feature/sub_user/presentation/pages/edit/sub_user_edit_conclude_page.dart';
import 'package:morar/feature/sub_user/presentation/pages/edit/sub_user_edit_page.dart';
import 'package:morar/feature/sub_user/presentation/pages/edit/sub_user_edit_registered_page.dart';
import 'package:morar/feature/sub_user/presentation/pages/edit/sub_user_edit_unregistered_page.dart';
import 'package:morar/feature/sub_user/presentation/pages/edit/sub_user_remove_success.dart';
import 'package:morar/feature/sub_user/presentation/pages/send_invite/sub_user_send_invite_error.dart';
import 'package:morar/feature/sub_user/presentation/pages/send_invite/sub_user_send_invite_success.dart.dart';
import 'package:morar/feature/sub_user/presentation/pages/sub_user_success.dart';
import 'package:morar/feature/sub_user/presentation/widget/sub_user_dialog_info.dart';
import 'package:morar/feature/vehicles/domain/entity/concierge_creator.dart';
import 'package:shared_features/shared_features.dart' show CodeRequest, CodeValidationPage;

import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';
import 'sub_user_test_helpers.dart';

const validCpf = '529.982.247-25';

void main() {
  late PageHarness harness;
  late RecordingNavigatorObserver observer;

  setUp(() async {
    harness = await installPageHarness();
    observer = RecordingNavigatorObserver();
    registerSubUserRoutes(harness.http);
  });

  SubUserEditController edit() => harness.resolve<SubUserEditController>();

  void select({SubUser? main, required SubUser selected}) {
    harness.resolve<SubUserController>().mainUser = main ?? owner();
    edit().userSelected = selected;
  }

  /// Desmonta a árvore anterior antes de montar: como a rota inicial é a
  /// mesma, o Navigator reaproveitaria o State da página e o initState não
  /// rodaria de novo.
  Future<void> pumpEdit(WidgetTester tester, {Size surface = const Size(400, 1400)}) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
    await pumpPage(tester, const SubUserEditPage(), observer: observer, surface: surface);
  }

  Iterable<String> paths() => harness.http.requests.map((r) => '${r.method} ${r.url.path}');

  group('usuário não registrado', () {
    testWidgets('proprietário vê o formulário completo e o botão salvar', (tester) async {
      select(selected: subUser(cpf: validCpf));

      await pumpEdit(tester, surface: const Size(800, 1400));

      expect(find.byType(SubUserEditUnregisteredPage), findsOneWidget);
      expect(find.text('edit'), findsOneWidget);
      expect(find.text('Edifício Lello - 101'), findsOneWidget);
      expect(find.text('resident_access_profile*'), findsOneWidget);
      expect(find.text('Morador'), findsOneWidget);
      expect(find.byType(SubUserDialogInfo), findsOneWidget);
      expect(find.text('CREATOR_VEHICLE_CONCIERGE'), findsOneWidget);
      expect(find.byType(ChangeOwnershipGenericInput), findsOneWidget);
      expect(find.text('receive_billet_by_email'), findsOneWidget);
      expect(find.text('resident_liberated_access_app'), findsOneWidget);
      expect(find.text('resident_remove_access_app'), findsOneWidget);
      expect(find.text('residents_register_sub_user_send_invide'), findsOneWidget);
      expect(find.text('save'), findsOneWidget);
      expect(find.byIcon(Icons.more_vert), findsOneWidget);
      expect(paths(), contains('GET /concierge/subUser/enabled_roles'));

      await expectLater(find.byType(SubUserEditPage), matchesGoldenFile('goldens/sub_user_edit_page.png'));
    });

    testWidgets('salvar com dados válidos atualiza o usuário', (tester) async {
      select(selected: subUser(cpf: validCpf));
      await pumpEdit(tester);

      await tester.enterText(find.widgetWithText(TextFormField, 'Bia Souza'), 'Bia Nova');
      await tester.enterText(find.widgetWithText(TextFormField, 'bia@lello.com'), 'nova@lello.com');
      await tester.enterText(find.widgetWithText(TextFormField, validCpf), '52998224725');
      await tester.enterText(find.widgetWithText(TextFormField, '(11) 99999-8888'), '11988887777');
      await tester.pump();
      expect(edit().userSelected!.name, 'Bia Nova');
      expect(edit().userSelected!.email, 'nova@lello.com');
      expect(edit().verifyChanges, isTrue);

      await tester.tap(find.text('receive_billet_by_email'));
      await tester.pump();
      expect(edit().userSelected!.flagBoletoEmail, isTrue);

      await tester.tap(find.text('save'));
      await tester.pumpAndSettle();

      expect(paths(), contains('PUT /concierge/subUser'));
      expect(paths().where((p) => p == 'GET /concierge/subUser/u1'), isNotEmpty);
      await tester.pump(const Duration(seconds: 4));
    });

    testWidgets('formulário inválido não salva', (tester) async {
      select(selected: subUser(cpf: '123.456.789-01'));
      await pumpEdit(tester);

      await tester.tap(find.text('save'));
      await tester.pumpAndSettle();

      expect(paths(), isNot(contains('PUT /concierge/subUser')));
    });

    testWidgets('perfil proprietário não pode ser salvo', (tester) async {
      select(selected: subUser(cpf: validCpf, role: 'morar.proprietario', roleDescription: 'Proprietário'));
      await pumpEdit(tester);

      await tester.tap(find.text('save'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('resident_need_profile'), findsOneWidget);
      expect(paths(), isNot(contains('PUT /concierge/subUser')));
      await tester.pump(const Duration(seconds: 4));
    });

    testWidgets('trocar o perfil no dropdown atualiza o usuário selecionado', (tester) async {
      select(selected: subUser(cpf: validCpf));
      await pumpEdit(tester);

      await tester.tap(find.byType(DropdownButton<SubUserRole>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Parcial').last);
      await tester.pumpAndSettle();

      expect(edit().userSelected!.role, 'morar.parcial');
      expect(edit().userSelected!.roleDescription, 'Parcial');
    });

    testWidgets('bloquear pelo menu abre o diálogo e conclui', (tester) async {
      select(selected: subUser(cpf: validCpf));
      await pumpEdit(tester);

      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      expect(find.text('block'), findsOneWidget);
      expect(find.text('exclude'), findsOneWidget);
      await tester.tap(find.text('block'));
      await tester.pumpAndSettle();

      expect(find.text('Você optou por bloquear esse usuário.'), findsOneWidget);
      await tester.tap(find.text('Não, quero voltar'));
      await tester.pumpAndSettle();
      expect(find.text('Você optou por bloquear esse usuário.'), findsNothing);

      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      await tester.tap(find.text('block'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sim, bloquear'));
      await tester.pumpAndSettle();

      expect(paths(), contains('PUT /concierge/subUser'));
      expect(find.byType(SubUserEditConcludePage), findsOneWidget);
      expect(find.text('Usuário bloqueado com sucesso!'), findsOneWidget);

      await tester.tap(find.text('Fechar'));
      await tester.pumpAndSettle();
      expect(find.byType(SubUserEditConcludePage), findsNothing);
    });

    testWidgets('excluir pelo menu confirma, chama a api e mostra sucesso', (tester) async {
      select(selected: subUser(cpf: validCpf));
      await pumpEdit(tester);

      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      await tester.tap(find.text('exclude'));
      await tester.pumpAndSettle();

      expect(find.text('Você tem certeza que deseja excluir'), findsOneWidget);
      await tester.tap(find.text('Não, quero voltar'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      await tester.tap(find.text('exclude'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sim, excluir'));
      await tester.pumpAndSettle();

      expect(paths(), contains('DELETE /concierge/subUser/u1/s1'));
      expect(find.byType(SubUserRemoveSuccessPage), findsOneWidget);
      expect(find.text(' foi excluído(a) com sucesso!'), findsOneWidget);

      await tester.tap(find.text('close'));
      await tester.pumpAndSettle();
      expect(find.byType(SubUserRemoveSuccessPage), findsNothing);
    });

    testWidgets('convite de biometria abre o diálogo e envia por sms', (tester) async {
      select(selected: subUser(cpf: validCpf));
      await pumpEdit(tester);

      await tester.tap(find.text('residents_register_sub_user_send_invide'));
      await tester.pumpAndSettle();
      expect(find.text('residents_invite_dialog_title'), findsOneWidget);
      await tester.tap(find.text('BACK'));
      await tester.pumpAndSettle();
      expect(find.text('residents_invite_dialog_title'), findsNothing);

      await tester.tap(find.text('residents_register_sub_user_send_invide'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(paths(), contains('POST /concierge/accesscontrol/sendInvite'));
      expect(find.byType(SendInviteSuccessPage), findsOneWidget);
    });

    testWidgets('falha no convite de biometria abre a página de erro', (tester) async {
      harness.http.on('POST', '/concierge/accesscontrol/sendInvite', status: 500, body: {'message': 'x'});
      select(selected: subUser(cpf: validCpf));
      await pumpEdit(tester);

      await tester.tap(find.text('residents_register_sub_user_send_invide'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(find.byType(SendInviteErrorPage), findsOneWidget);
      await tester.tap(find.text('close'));
      await tester.pumpAndSettle();
    });

    testWidgets('convite sem telefone avisa com flushbar', (tester) async {
      select(selected: subUser(cpf: validCpf, phone: null));
      await pumpEdit(tester);

      await tester.tap(find.text('residents_register_sub_user_send_invide'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('residents_invite_empty_phone'), findsOneWidget);
      await tester.pump(const Duration(seconds: 6));
    });

    testWidgets('remover acesso ao app pede confirmação e atualiza', (tester) async {
      select(selected: subUser(cpf: validCpf));
      await pumpEdit(tester);

      await tester.tap(find.text('resident_remove_access_app'));
      await tester.pumpAndSettle();
      expect(find.text('resident_sure_lock_app_access'), findsOneWidget);
      await tester.tap(find.text('NO'));
      await tester.pumpAndSettle();
      expect(find.text('resident_sure_lock_app_access'), findsNothing);

      await tester.tap(find.text('resident_remove_access_app'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('YES'));
      await tester.pumpAndSettle();

      expect(paths(), contains('PUT /concierge/subUser'));
      expect(find.byType(SubUserSuccessPage), findsOneWidget);
      expect(edit().userSelected!.useApp, isFalse);

      await tester.tap(find.text('conclude'));
      await tester.pumpAndSettle();
      expect(find.byType(SubUserSuccessPage), findsNothing);
    });

    testWidgets('usuário sem acesso ao app mostra liberar acesso', (tester) async {
      select(selected: subUser(cpf: validCpf, useApp: false));
      await pumpEdit(tester);

      expect(find.text('resident_blocked_access_app'), findsOneWidget);
      expect(find.text('resident_liberate_access_app'), findsOneWidget);
      await tester.tap(find.text('resident_liberate_access_app'));
      await tester.pumpAndSettle();
      expect(find.text('resident_sure_unlock_app_access'), findsOneWidget);
    });

    testWidgets('usuário registrado com app mostra instalado', (tester) async {
      select(selected: subUser(cpf: validCpf, registered: true));
      await pumpEdit(tester);
      expect(find.text('resident_installed_access_app'), findsOneWidget);
    });

    testWidgets('data de expiração passada mostra alerta e permite limpar', (tester) async {
      select(selected: subUser(cpf: validCpf, expiresAt: DateTime.now().subtract(const Duration(days: 3))));
      await pumpEdit(tester);

      expect(find.text('O PERÍODO DE ACESSO CONSTA EXPIRADO. ESTE USUÁRIO NÃO TEM ACESSO.'), findsOneWidget);
      expect(edit().expirationDateController.text, isNotEmpty);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      expect(edit().userSelected!.expiresAt, isNull);
      expect(edit().expirationDateController.text, isEmpty);
      expect(find.text('O PERÍODO DE ACESSO CONSTA EXPIRADO. ESTE USUÁRIO NÃO TEM ACESSO.'), findsNothing);

      // data passada: o picker abre em hoje e confirmar não altera nada
      await tester.tap(find.byIcon(Icons.calendar_month));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(edit().userSelected!.expiresAt, isNull);
    });

    testWidgets('data de expiração futura pode ser confirmada no picker', (tester) async {
      final future = DateUtils.dateOnly(DateTime.now().add(const Duration(days: 40)));
      select(selected: subUser(cpf: validCpf, expiresAt: future));
      await pumpEdit(tester);

      await tester.tap(find.byIcon(Icons.calendar_month));
      await tester.pumpAndSettle();
      expect(find.byType(DatePickerDialog), findsOneWidget);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(edit().userSelected!.expiresAt, future);
      expect(edit().expirationDateController.text, DateFormat('dd/MM/yyyy').format(future));
    });

    testWidgets('contador de boletos por email mostra o aviso e limite', (tester) async {
      edit().billetByEmailCounter = 2;
      select(selected: subUser(cpf: validCpf));
      await pumpEdit(tester);
      expect(find.textContaining('Atualmente, há 2 usuários'), findsOneWidget);

      edit().billetByEmailCounter = 3;
      select(selected: subUser(cpf: validCpf));
      await pumpEdit(tester);
      expect(find.text('max_residents_with_billet_by_email'), findsOneWidget);
      final tile = tester.widget<SwitchListTile>(find.byType(SwitchListTile));
      expect(tile.onChanged, isNull);
    });

    testWidgets('criador de cada tipo aparece no cabeçalho', (tester) async {
      for (final entry in {
        ConciergeCreatorType.appmorar: 'CREATOR_VEHICLE ANA',
        ConciergeCreatorType.moradorcriador: 'CREATOR_VEHICLE ANA',
        ConciergeCreatorType.appsindico: 'CREATOR_VEHICLE_SINDICO',
        ConciergeCreatorType.resolvafacil: 'CADASTRADO PELO RESOLVA FÁCIL',
      }.entries) {
        select(selected: subUser(cpf: validCpf, creator: ConciergeCreator(name: 'Ana', type: entry.key)));
        await pumpEdit(tester);
        expect(find.text(entry.value), findsOneWidget, reason: entry.key.toString());
      }
    });

    testWidgets('inquilino principal vê o aviso e não vê a troca de boleto', (tester) async {
      select(
        main: owner(role: 'morar.inquilino', roleDescription: 'Inquilino'),
        selected: subUser(cpf: validCpf),
      );
      await pumpEdit(tester);

      expect(find.byType(SubUserDialogInfo), findsNothing);
      expect(find.textContaining('Ao adicionar um morador'), findsOneWidget);
      expect(find.text('receive_billet_by_email'), findsNothing);
      expect(find.byType(ChangeOwnershipGenericInput), findsNothing);
      expect(find.text('save'), findsOneWidget);
      expect(find.byIcon(Icons.more_vert), findsOneWidget);
    });

    testWidgets('inquilino principal com usuário mascarado não edita', (tester) async {
      select(
        main: owner(role: 'morar.inquilino', roleDescription: 'Inquilino'),
        selected: subUser(cpf: validCpf, name: 'Bia ****'),
      );
      await pumpEdit(tester);

      expect(find.byType(SubUserEditRegisteredPage), findsOneWidget);
      expect(find.text('save'), findsNothing);
      expect(find.byIcon(Icons.more_vert), findsNothing);
    });

    testWidgets('mascarado e não registrado desabilita os campos', (tester) async {
      select(
        main: owner(role: 'morar.inquilino', roleDescription: 'Inquilino'),
        selected: subUser(cpf: validCpf, name: 'Bia ****'),
      );
      edit().userSelected = subUser(cpf: validCpf, name: 'Bia ****');
      await pumpEdit(tester);
      // registered=false mas nome mascarado cai na página registrada
      expect(find.byType(SubUserEditUnregisteredPage), findsNothing);
    });
  });

  group('usuário bloqueado', () {
    testWidgets('mostra os dados e permite desbloquear', (tester) async {
      select(selected: subUser(cpf: validCpf, blocked: true));
      await pumpEdit(tester);

      expect(find.byType(SubUserEditBlockedPage), findsOneWidget);
      expect(find.text('resident_unlock'), findsOneWidget);
      expect(find.text(validCpf), findsOneWidget);
      expect(find.text('save'), findsNothing);
      expect(find.text('residents_register_sub_user_app_access'), findsNothing);

      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      expect(find.text('block'), findsNothing);
      expect(find.text('exclude'), findsOneWidget);
      await tester.tapAt(const Offset(10, 700));
      await tester.pumpAndSettle();

      await tester.tap(find.text('resident_unlock'));
      await tester.pumpAndSettle();
      expect(find.text('Você optou por desbloquear esse usuário.'), findsOneWidget);
      await tester.tap(find.text('Não, quero voltar'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('resident_unlock'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sim, desbloquear'));
      await tester.pumpAndSettle();

      expect(paths(), contains('PUT /concierge/subUser'));
      expect(find.text('Usuário desbloqueado com sucesso!'), findsOneWidget);
    });

    testWidgets('dados não informados mostram o texto padrão', (tester) async {
      select(selected: subUser(cpf: null, email: null, phone: null, blocked: true));
      await pumpEdit(tester);
      expect(find.text('not_informed'), findsNWidgets(3));
    });
  });

  group('usuário principal', () {
    testWidgets('editar a si mesmo leva para a página de perfil', (tester) async {
      select(selected: owner());
      await pumpEdit(tester);

      expect(find.byType(SubUserEditRegisteredPage), findsOneWidget);
      expect(find.byIcon(Icons.more_vert), findsNothing);
      expect(find.text('APENAS O PRÓPRIO USUÁRIO PODE ATUALIZAR ESSES DADOS'), findsOneWidget);
      expect(find.text('residents_register_sub_user_biometric_not_registered'), findsOneWidget);
      expect(find.text('resident_remove_access_app'), findsNothing);

      await tester.tap(find.byType(PrimaryButton));
      await tester.pumpAndSettle();

      expect(observer.pushedNames.last, ApplicationRoute.me);
    });

    testWidgets('cadastrar biometria checa o serviço', (tester) async {
      select(selected: owner());
      await pumpEdit(tester);

      await tester.tap(find.text('residents_register_sub_user_biometric_not_registered'));
      await tester.pumpAndSettle();

      expect(paths(), contains('GET /concierge/accesscontrol/getServiceSeventh'));
      /// Corrigido: sub_user_edit_page.dart escuta CheckServiceOnlineState no
      /// SubUsersBloc (onde o checkService emite), então a navegação para a
      /// captura facial acontece.
      expect(observer.pushedNames, contains(ApplicationRoute.subUserServiceOn));
    });

    testWidgets('biometria cadastrada mostra ver foto e enviar nova foto', (tester) async {
      harness.sessionBloc.session.me!.biometricPictureHash = 'hash';
      select(selected: owner(useFacialBiometric: true));
      await pumpEdit(tester);

      expect(find.text('residents_register_sub_user_biometric_registered'), findsOneWidget);
      await tester.tap(find.text('residents_see_photo'));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.close), findsWidgets);
      await tester.tap(find.byIcon(Icons.close).last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('residents_send_new_photo'));
      await tester.pumpAndSettle();
      expect(paths(), contains('GET /concierge/accesscontrol/getServiceSeventh'));
    });

    testWidgets('data de expiração próxima mostra o alerta e permite renovar', (tester) async {
      select(
        selected: owner(
          role: 'morar.inquilino',
          roleDescription: 'Inquilino',
          expiresAt: DateTime.now().add(const Duration(days: 10)),
        ),
      );
      await pumpEdit(tester);

      expect(find.text('Data de expiração de acesso'), findsOneWidget);
      expect(find.text('Solicitar renovação'), findsOneWidget);
      await tester.tap(find.text('Solicitar renovação'));
      await tester.pumpAndSettle();

      expect(paths(), contains('POST /concierge/subUser/renew_access/u1'));
      expect(find.text('send_access_renew_request_success_title'), findsOneWidget);
      await tester.tap(find.text('close'));
      await tester.pumpAndSettle();
      expect(edit().userSelected!.accessRenewalRequestStatus, 'SOLICITADO');
    });

    testWidgets('renovação já solicitada mostra o aviso sem botão', (tester) async {
      select(
        selected: owner(
          expiresAt: DateTime.now().add(const Duration(days: 10)),
          accessRenewalRequestStatus: 'SOLICITADO',
          accessRenewalRequestDate: DateTime.now(),
        ),
      );
      await pumpEdit(tester);

      expect(find.text('Solicitar renovação'), findsNothing);
      expect(find.textContaining('Sua solicitação foi enviada', findRichText: true), findsOneWidget);
    });

    testWidgets('falha na renovação não navega', (tester) async {
      harness.http.on('POST', '/concierge/subUser/renew_access/u1', status: 500, body: {'message': 'x'});
      select(selected: owner(expiresAt: DateTime.now().add(const Duration(days: 10))));
      await pumpEdit(tester);

      await tester.tap(find.text('Solicitar renovação'));
      await tester.pumpAndSettle();
      expect(find.text('send_access_renew_request_success_title'), findsNothing);
    });
  });

  group('usuário registrado', () {
    testWidgets('proprietário pode trocar o perfil e o boleto por email', (tester) async {
      select(selected: subUser(cpf: validCpf, registered: true, expiresAt: DateTime.now().add(const Duration(days: 100))));
      await pumpEdit(tester);

      expect(find.byType(SubUserEditRegisteredPage), findsOneWidget);
      expect(find.byType(SubUserDialogInfo), findsOneWidget);
      expect(find.byType(ChangeOwnershipGenericInput), findsOneWidget);

      await tester.tap(find.byType(DropdownButton<SubUserRole>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Parcial').last);
      await tester.pumpAndSettle();
      expect(edit().userSelected!.role, 'morar.parcial');

      await tester.tap(find.text('receive_billet_by_email'));
      await tester.pumpAndSettle();
      expect(edit().userSelected!.flagBoletoEmail, isTrue);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      expect(edit().userSelected!.expiresAt, isNull);

      await tester.tap(find.text('save'));
      await tester.pumpAndSettle();
      expect(paths(), contains('PUT /concierge/subUser'));
      await tester.pump(const Duration(seconds: 4));
    });

    testWidgets('data expirada mostra alerta e picker confirma data futura', (tester) async {
      select(selected: subUser(cpf: validCpf, registered: true, expiresAt: DateTime.now().subtract(const Duration(days: 3))));
      await pumpEdit(tester);
      expect(find.text('O PERÍODO DE ACESSO CONSTA EXPIRADO. ESTE USUÁRIO NÃO TEM ACESSO.'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.calendar_month));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      final future = DateUtils.dateOnly(DateTime.now().add(const Duration(days: 40)));
      select(selected: subUser(cpf: validCpf, registered: true, expiresAt: future));
      await pumpEdit(tester);
      await tester.tap(find.byIcon(Icons.calendar_month));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(edit().expirationDateController.text, DateFormat('dd/MM/yyyy').format(future));
    });

    testWidgets('contador de boletos por email no formulário registrado', (tester) async {
      edit().billetByEmailCounter = 1;
      select(selected: subUser(cpf: validCpf, registered: true));
      await pumpEdit(tester);
      expect(find.textContaining('Atualmente, há 1 usuários'), findsOneWidget);

      edit().billetByEmailCounter = 3;
      select(selected: subUser(cpf: validCpf, registered: true));
      await pumpEdit(tester);
      expect(find.text('max_residents_with_billet_by_email'), findsOneWidget);
    });

    testWidgets('morador principal não edita o perfil nem o boleto', (tester) async {
      select(
        main: owner(role: 'morar.morador', roleDescription: 'Morador'),
        selected: subUser(cpf: validCpf, registered: true),
      );
      await pumpEdit(tester);

      final dropdown = tester.widget<DropdownButton<SubUserRole>>(find.byType(DropdownButton<SubUserRole>));
      expect(dropdown.onChanged, isNull);
      expect(find.text('receive_billet_by_email'), findsNothing);
      expect(find.byType(SubUserDialogInfo), findsNothing);
      expect(find.text('save'), findsNothing);
    });

    testWidgets('inquilino principal editando outro vê o aviso de morador', (tester) async {
      select(
        main: owner(role: 'morar.inquilino', roleDescription: 'Inquilino'),
        selected: subUser(cpf: validCpf, registered: true, creator: ConciergeCreator(name: 'Ana', type: ConciergeCreatorType.appmorar)),
      );
      await pumpEdit(tester);

      expect(find.textContaining('Ao adicionar um morador'), findsOneWidget);
      expect(find.text('CREATOR_VEHICLE ANA'), findsOneWidget);
      expect(find.text('receive_billet_by_email'), findsNothing);
    });

    testWidgets('edição ativa do usuário principal mostra campos editáveis', (tester) async {
      edit().activeEditMainUser = true;
      select(selected: owner());
      await pumpEdit(tester);

      expect(find.byType(TextFormField), findsNWidgets(3));
      await tester.enterText(find.byType(TextFormField).at(0), 'Ana Nova');
      await tester.enterText(find.byType(TextFormField).at(1), 'nova@lello.com');
      await tester.enterText(find.byType(TextFormField).at(2), '11988887777');
      await tester.pump();
      expect(edit().newMe!.name, 'Ana Nova');
      expect(edit().newMe!.email, 'nova@lello.com');
      expect(edit().phone, isNotEmpty);
      expect(find.text('full_name *'), findsOneWidget);
    });
  });

  group('ramos restantes', () {
    testWidgets('voltar pela app bar recarrega a lista e fecha', (tester) async {
      select(selected: subUser(cpf: validCpf));
      await pumpEdit(tester);
      harness.http.requests.clear();

      await tester.tap(find.descendant(of: find.byType(AppBar), matching: find.byType(IconButton)).first);
      await tester.pumpAndSettle();

      expect(paths(), contains('GET /concierge/subUser/u1'));
      expect(observer.popped, isNotEmpty);
    });

    testWidgets('perfil fora da lista de perfis mostra o hint sem quebrar o dropdown', (tester) async {
      /// Corrigido: sub_user_edit_unregistered_page.dart e
      /// sub_user_edit_registered_page.dart usam `value` nulo quando o perfil
      /// do usuário não está na lista de perfis habilitados, e o
      /// DropdownButton mostra o hint em vez de lançar asserção.
      select(selected: subUser(cpf: validCpf, role: 'morar.sindico', roleDescription: 'Síndico'));
      await pumpEdit(tester);
      expect(tester.takeException(), isNull);
      expect(find.text('choose_an_option'), findsOneWidget);

      select(selected: subUser(cpf: validCpf, registered: true, role: 'morar.sindico', roleDescription: 'Síndico'));
      await pumpEdit(tester);
      expect(tester.takeException(), isNull);
      expect(find.text('choose_an_option'), findsOneWidget);
    });

    testWidgets('campos do formulário não registrado reagem à digitação', (tester) async {
      select(selected: subUser(cpf: validCpf, expiresAt: DateTime.now().subtract(const Duration(days: 3))));
      await pumpEdit(tester);

      // com a data expirada o picker abre em hoje
      await tester.tap(find.byIcon(Icons.calendar_month));
      await tester.pumpAndSettle();
      expect(find.byType(DatePickerDialog), findsOneWidget);
      await tester.tap(find.text('CANCEL'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(1), '11144477735');
      await tester.pump();
      expect(edit().userSelected!.cpf, '111.444.777-35');
      /// Corrigido: SubUser.copyWith preserva `expiresAt` quando o parâmetro
      /// não é informado; digitar nos campos não zera a data de expiração.
      expect(edit().userSelected!.expiresAt, isNotNull);
      expect(edit().userSelected!.expiresAt!.isBefore(DateTime.now()), isTrue);

      await tester.enterText(find.byType(TextFormField).at(2), 'novo@lello.com');
      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pump();
      expect(edit().userSelected!.email, 'novo@lello.com');

      /// Corrigido: mesmo com a data original expirada, o datePicker recebe
      /// initialDate >= firstDate (clamp para hoje) e abre sem asserção.
      await tester.tap(find.byIcon(Icons.calendar_month));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(DatePickerDialog), findsOneWidget);
      await tester.tap(find.text('CANCEL'));
      await tester.pumpAndSettle();
    });

    testWidgets('formulário registrado sem dados e com data distante', (tester) async {
      select(selected: owner(expiresAt: DateTime.now().add(const Duration(days: 100))).copyWith(email: null, phone: null));
      edit().userSelected = SubUser(
        id: mainUserId,
        mainUser: true,
        registered: true,
        role: 'morar.proprietario',
        roleDescription: 'Proprietário',
        useApp: true,
        blocked: false,
        useFacialBiometric: false,
        expiresAt: DateTime.now().add(const Duration(days: 100)),
      );
      await pumpEdit(tester);

      expect(find.text('not_informed'), findsNWidgets(4));
      expect(find.text('Data de expiração de acesso'), findsOneWidget);
      expect(find.text('Solicitar renovação'), findsNothing);
    });

    testWidgets('criadores no formulário registrado', (tester) async {
      for (final entry in {
        ConciergeCreatorType.appsindico: 'CREATOR_VEHICLE_SINDICO',
        ConciergeCreatorType.portaria: 'CREATOR_VEHICLE_CONCIERGE',
        ConciergeCreatorType.resolvafacil: 'CADASTRADO PELO RESOLVA FÁCIL',
      }.entries) {
        select(selected: subUser(cpf: validCpf, registered: true, creator: ConciergeCreator(type: entry.key)));
        await pumpEdit(tester);
        expect(find.text(entry.value), findsOneWidget, reason: entry.key.toString());
      }
    });
  });

  group('estados do bloc', () {
    testWidgets('erro mostra o widget de erro e tenta de novo', (tester) async {
      select(selected: subUser(cpf: validCpf));
      await pumpEdit(tester);
      harness.http.requests.clear();

      await emitState(tester, edit().editBloc, SubUserEditErrorState(error: UnknownFailure('x')));
      expect(find.byType(ErrorHandlingWidget), findsOneWidget);

      await tester.tap(find.text('error_handling_widget_button_reTry').first);
      await tester.pumpAndSettle();
      expect(paths(), contains('GET /concierge/subUser/enabled_roles'));
      expect(find.byType(SubUserEditUnregisteredPage), findsOneWidget);

      await emitState(tester, edit().editBloc, SubUserDeleteErrorState(error: UnknownFailure('y')));
      expect(find.byType(ErrorHandlingWidget), findsOneWidget);
      await tester.tap(find.text('error_handling_widget_button_back').first);
      await tester.pumpAndSettle();
    });

    testWidgets('loading e estado desconhecido', (tester) async {
      select(selected: subUser(cpf: validCpf));
      await pumpEdit(tester);

      await emitState(tester, edit().editBloc, SubUserDeleteLoadingState(), settle: false);
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsWidgets);

      await emitState(tester, edit().editBloc, SubUserEditSendInviteSuccessState());
      expect(find.byType(SendInviteSuccessPage), findsOneWidget);
    });

    testWidgets('falha na exclusão mostra erro', (tester) async {
      harness.http.on('DELETE', '/concierge/subUser/*', status: 500, body: {'message': 'x'});
      select(selected: subUser(cpf: validCpf));
      await pumpEdit(tester);

      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      await tester.tap(find.text('exclude'));
      await tester.pumpAndSettle();

      /// Corrigido: sub_user_store.dart (deleteSubUserByUnitId) devolve false
      /// depois de emitir o erro em vez de relançar a falha, então a exclusão
      /// com erro só mostra o estado de erro.
      await tester.tap(find.text('Sim, excluir'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(ErrorHandlingWidget), findsOneWidget);
    });

    testWidgets('serviço online/offline pelo SubUsersBloc navegam', (tester) async {
      select(selected: subUser(cpf: validCpf));
      await pumpEdit(tester);

      await emitState(tester, edit().bloc, CheckServiceOfflineState());
      expect(observer.pushedNames.last, ApplicationRoute.subUserServiceOff);
      tester.state<NavigatorState>(find.byType(Navigator)).pop();
      await tester.pumpAndSettle();

      await emitState(tester, edit().bloc, CheckServiceOnlineState());
      expect(observer.pushedNames.last, ApplicationRoute.subUserServiceOn);
    });

    testWidgets('token de validação mostra a página de código', (tester) async {
      select(selected: owner());
      await pumpEdit(tester);

      await emitState(
        tester,
        edit().editBloc,
        SubUserEditSendTokenState(
          codeRequest: CodeRequest(
            source: CodeValidationSource.phone,
            origin: CodeValidationOrigin.changeNumber,
            value: '11999998888',
            token: 't',
          ),
        ),
        settle: false,
      );
      await tester.pump();
      expect(find.byType(CodeValidationPage), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('mudança de telefone do perfil abre o aviso e cancelar volta', (tester) async {
      select(selected: owner());
      await pumpEdit(tester);
      final me = harness.sessionBloc.session.me!;

      await emitState(tester, edit().blocMe, MeEditPhoneChangedState(me), settle: false);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(MeEditPhoneInfo), findsOneWidget);

      tester.widget<MeEditPhoneInfo>(find.byType(MeEditPhoneInfo)).cancelOnPressed!();
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(MeEditPhoneInfo), findsNothing);
      expect(edit().activeEditMainUser, isTrue);
      expect(edit().editBloc.state, isA<SubUserEditLoadedState>());
    });

    testWidgets('validação de código fecha o aviso e mostra o token', (tester) async {
      select(selected: owner());
      await pumpEdit(tester);
      final me = harness.sessionBloc.session.me!;

      await emitState(tester, edit().blocMe, MeEditPhoneChangedState(me), settle: false);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(MeEditPhoneInfo), findsOneWidget);
      await emitState(
        tester,
        edit().blocMe,
        MeEditValidateCodeState(
          me,
          CodeRequest(
            source: CodeValidationSource.phone,
            origin: CodeValidationOrigin.changeNumber,
            value: '11999998888',
            token: 't',
          ),
        ),
        settle: false,
      );
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(MeEditPhoneInfo), findsNothing);
      expect(find.byType(CodeValidationPage), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('sucesso e falha na edição do perfil', (tester) async {
      select(selected: owner());
      await pumpEdit(tester);
      final me = harness.sessionBloc.session.me!;

      await emitState(tester, edit().blocMe, MeEditFailedState(me, UnknownFailure('x')));
      expect(find.byType(ErrorHandlingWidget), findsOneWidget);

      await emitState(tester, edit().blocMe, MeEditSucceededState(me));
      expect(find.byType(SubUserSuccessPage), findsOneWidget);
      expect(edit().activeEditMainUser, isFalse);
    });
  });
}
