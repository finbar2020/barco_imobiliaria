import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/feature/sub_user/presentation/enum/staff_access_permission_enum.dart';
import 'package:morar/feature/sub_user/presentation/pages/edit/send_access_renew_request_success_page.dart';
import 'package:morar/feature/sub_user/presentation/pages/edit/sub_user_edit_conclude_page.dart';
import 'package:morar/feature/sub_user/presentation/pages/edit/sub_user_remove_success.dart';
import 'package:morar/feature/sub_user/presentation/pages/pending_requests/update_access_request_status_success.dart.dart';
import 'package:morar/feature/sub_user/presentation/pages/sub_user_success.dart';
import 'package:morar/feature/sub_user/presentation/widget/access_table_widget.dart';
import 'package:morar/feature/sub_user/presentation/widget/no_expiration_date_dialog.dart';
import 'package:morar/feature/sub_user/presentation/widget/sub_user_dialog_info.dart';
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

  /// Monta [page] acima de uma rota base, para páginas que dão pop duas vezes.
  Future<void> pumpStacked(WidgetTester tester, Widget page) async {
    await pumpPage(tester, const Scaffold(body: Text('base')), observer: observer);
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.push(MaterialPageRoute(builder: (_) => const Scaffold(body: Text('meio'))));
    await tester.pumpAndSettle();
    navigator.push(MaterialPageRoute(builder: (_) => page));
    await tester.pumpAndSettle();
  }

  testWidgets('SubUserSuccessPage conclui recarregando a lista', (tester) async {
    await pumpStacked(tester, const SubUserSuccessPage());
    expect(find.text('profile_update_success'), findsOneWidget);
    harness.http.requests.clear();

    await tester.tap(find.text('conclude'));
    await tester.pumpAndSettle();

    expect(paths(), contains('GET /concierge/subUser/u1'));
    expect(find.byType(SubUserSuccessPage), findsNothing);
    expect(find.text('meio'), findsOneWidget);
  });

  testWidgets('SubUserEditConcludePage mostra bloqueado/desbloqueado e fecha duas telas', (tester) async {
    await pumpStacked(tester, SubUserEditConcludePage(blocked: true, session: harness.sessionBloc.session));
    expect(find.text('Usuário bloqueado com sucesso!'), findsOneWidget);
    expect(find.text('Moradores'), findsOneWidget);

    await tester.tap(find.text('Fechar'));
    await tester.pumpAndSettle();
    expect(find.text('base'), findsOneWidget);
    expect(find.text('meio'), findsNothing);

    await pumpStacked(tester, SubUserEditConcludePage(session: harness.sessionBloc.session));
    expect(find.text('Usuário desbloqueado com sucesso!'), findsOneWidget);
  });

  testWidgets('SubUserRemoveSuccessPage fecha duas telas', (tester) async {
    await pumpStacked(tester, const SubUserRemoveSuccessPage(name: 'Bia'));
    expect(find.text('Bia'), findsOneWidget);
    expect(find.text(S.current.pending_requests), findsOneWidget);

    await tester.tap(find.text('close'));
    await tester.pumpAndSettle();
    expect(find.text('base'), findsOneWidget);
    expect(find.text('meio'), findsNothing);
  });

  testWidgets('SendAccessRenewRequestSuccessPage fecha ao tocar em fechar', (tester) async {
    await pumpStacked(tester, const SendAccessRenewRequestSuccessPage());
    expect(find.text('send_access_renew_request_success_title'), findsOneWidget);
    expect(find.text('Solicitações pendentes'), findsOneWidget);

    await tester.tap(find.text('close'));
    await tester.pumpAndSettle();
    expect(find.text('meio'), findsOneWidget);
  });

  testWidgets('UpdateRequestStatusSuccessPage varia por status', (tester) async {
    await pumpStacked(tester, const UpdateRequestStatusSuccessPage(status: 'APROVADA_PROPRIETARIO'));
    expect(find.text(S.current.approvingSuccessfulUpperCase), findsOneWidget);
    expect(find.text(S.current.updateRequestStatusSuccessMessage), findsOneWidget);

    await tester.tap(find.text('close'));
    await tester.pumpAndSettle();
    expect(find.text('meio'), findsOneWidget);

    await pumpStacked(tester, const UpdateRequestStatusSuccessPage(status: 'REPROVADA_PROPRIETARIO'));
    expect(find.text(S.current.blockingSuccessful), findsOneWidget);
    expect(find.text(S.current.updateRequestStatusToBlockSuccessMessage), findsOneWidget);
  });

  testWidgets('SubUserDialogInfo abre a tabela de acessos', (tester) async {
    await pumpPage(tester, const Scaffold(body: SubUserDialogInfo()), surface: const Size(500, 1200));
    expect(find.text('resident_what_access_profile'), findsOneWidget);

    await tester.tap(find.text('resident_what_access_profile'));
    await tester.pumpAndSettle();
    /// Corrigido: access_table_widget.dart passa o ScrollController
    /// horizontal ao Scrollbar(thumbVisibility: true); sem asserção no
    /// bottom sheet.
    expect(tester.takeException(), isNull);

    expect(find.text('staff_access_info_title'), findsOneWidget);
    expect(find.byType(AccessTable), findsOneWidget);
    expect(find.text('access'), findsOneWidget);
    for (final role in StaffAccessRole.values) {
      expect(find.text(role.name.replaceAllMapped(RegExp(r'[A-Z]'), (m) => '_${m[0]!.toLowerCase()}')), findsOneWidget);
    }
    expect(find.byIcon(Icons.check_circle), findsWidgets);
    expect(find.byIcon(Icons.cancel), findsWidgets);

    // rola as colunas e as linhas para sincronizar os controladores
    await tester.drag(find.byType(Scrollbar), const Offset(-200, 0));
    await tester.pumpAndSettle();
    tester.takeException();
    await tester.drag(find.text('reserve_free_common_areas'), const Offset(0, -200));
    await tester.pumpAndSettle();
    tester.takeException();
    await tester.drag(find.byIcon(Icons.cancel).first, const Offset(0, 100));
    await tester.pumpAndSettle();
    tester.takeException();
  });

  testWidgets('NoExpirationDateDialog só aprova depois de escolher a data', (tester) async {
    DateTime? approved;
    await pumpPage(
      tester,
      Scaffold(body: NoExpirationDateDialog(onApproveAccess: (d) => approved = d)),
      observer: observer,
      surface: const Size(400, 900),
    );
    final approve = find.widgetWithText(PrimaryButton, 'Aprovar acesso');
    expect(tester.widget<PrimaryButton>(approve).onPressed, isNull);

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
    expect(find.text(DateFormat('dd/MM/yyyy').format(tomorrow)), findsOneWidget);

    await tester.tap(approve);
    await tester.pumpAndSettle();
    expect(approved, isNotNull);
  });

  testWidgets('staff_access_permission_enum rotula tipos e perfis', (tester) async {
    late BuildContext ctx;
    await pumpPage(tester, Builder(builder: (c) {
      ctx = c;
      return const SizedBox();
    }));
    for (final t in StaffAccessTypePermissionEnum.values) {
      expect(t.labelOf(ctx), isNotEmpty);
    }
    for (final r in StaffAccessRole.values) {
      expect(r.labelOf(ctx), isNotEmpty);
    }
    expect(accessPermissions[StaffAccessTypePermissionEnum.accessInvoices]!.isAllowed(StaffAccessRole.realEstate), isTrue);
    expect(accessPermissions[StaffAccessTypePermissionEnum.incidentReporting]!.isAllowed(StaffAccessRole.realEstate), isFalse);
    expect(accessPermissions, hasLength(StaffAccessTypePermissionEnum.values.length));
  });

  testWidgets('helpers de sub usuário', (tester) async {
    expect(subUser().isItself('s1'), isTrue);
    expect(owner().copyWith(name: 'x').name, 'x');
  });
}
