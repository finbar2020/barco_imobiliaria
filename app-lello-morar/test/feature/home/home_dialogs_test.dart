import 'dart:convert';

import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:morar/core/navigation/application_rbac.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_all_info.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_rule.dart';
import 'package:morar/feature/agreements/domain/entity/agreements_quotas.dart';
import 'package:morar/feature/agreements/domain/use_case/get_all_info/get_all_info.dart';
import 'package:morar/feature/agreements/presentation/bloc/agreements_bloc.dart';
import 'package:morar/feature/home/presentation/widget/agreements_dialog.dart';
import 'package:morar/feature/home/presentation/widget/home_dialogs/bloc/home_dialogs_bloc.dart';
import 'package:morar/feature/home/presentation/widget/home_dialogs/bloc/home_dialogs_event.dart';
import 'package:morar/feature/home/presentation/widget/home_dialogs/bloc/home_dialogs_state.dart';
import 'package:morar/feature/home/presentation/widget/home_dialogs/page/home_dialogs_page.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/shared_features.dart';

import '../../helpers/fake_permission_handler.dart';
import '../../helpers/firebase_mocks.dart';
import '../../helpers/fixtures.dart';
import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/test_application_container.dart';
import 'home_test_support.dart';

class _FakeGetAvailable extends Fake implements GetAvailableUseCase {
  _FakeGetAvailable({this.fail = false, this.quotes = const []});
  final bool fail;
  final List<AgreementQuota> quotes;
  final params = <GetAvailableParams>[];

  @override
  Future<Try<AgreementAllInfo>> call(GetAvailableParams p) async {
    params.add(p);
    if (fail) return Rejection(UnknownFailure('x'));
    return Success(AgreementAllInfo(
      quotes: quotes,
      agreements: [],
      rule: AgreementRule(installmentQtd: 1, days: [1], paymentMethod: []),
    ));
  }
}

AgreementQuota _quota() => AgreementQuota(
      id: 'q1',
      receipt: 'r1',
      originValue: 10,
      dueDate: DateTime(2026, 1, 1),
      fineValue: 1,
      feeValue: 1,
      honoraryValue: 1,
      overdueMessage: '',
    );

final _sessionBloc = HomeFakeSessionBloc();

void main() {
  group('HomeDialogBloc', () {
    late FakeSessionBloc sessionBloc;
    late FakePermissionHandler permission;
    final dateFormat = DateFormat.yMd().add_Hms();

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      sessionBloc = FakeSessionBloc();
      permission = FakePermissionHandler(status: PermissionStatus.granted);
      setFakePermissionHandler(permission);
    });

    Future<HomeDialogBloc> build() async {
      final bloc = HomeDialogBloc(sessionBloc: sessionBloc);
      await Future<void>.delayed(const Duration(milliseconds: 20));
      return bloc;
    }

    test('com permissão concedida fica no estado inicial', () async {
      final bloc = await build();
      expect(bloc.state, const HomeDialogInitialState());
      expect(bloc.jumpFirstStep, isFalse);
    });

    test('permissão negada pede a permissão e guarda a data', () async {
      permission.status = PermissionStatus.denied;
      final bloc = await build();
      expect(bloc.state, const NotificationPermissionState());
      expect(bloc.jumpFirstStep, isTrue);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString(SharedPreferencesKeys.notificationPermission),
          isNotNull);

      // Na próxima passada o passo 1 é pulado.
      bloc.initialState();
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(bloc.state, const NotificationPermissionState());
    });

    test('permissão negada permanentemente também pede', () async {
      permission.status = PermissionStatus.permanentlyDenied;
      final bloc = await build();
      expect(bloc.state, const NotificationPermissionState());
    });

    test('status restrito pede sem guardar a data', () async {
      permission.status = PermissionStatus.restricted;
      final bloc = await build();
      expect(bloc.state, const NotificationPermissionState());
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString(SharedPreferencesKeys.notificationPermission),
          isNull);
    });

    test('data recente guardada evita pedir de novo', () async {
      SharedPreferences.setMockInitialValues({
        SharedPreferencesKeys.notificationPermission:
            dateFormat.format(DateTime.now()),
      });
      permission.status = PermissionStatus.denied;
      final bloc = await build();
      expect(bloc.state, const HomeDialogInitialState());
    });

    test('data antiga guardada volta a pedir', () async {
      SharedPreferences.setMockInitialValues({
        SharedPreferencesKeys.notificationPermission: dateFormat
            .format(DateTime.now().subtract(const Duration(days: 90))),
      });
      permission.status = PermissionStatus.denied;
      final bloc = await build();
      expect(bloc.state, const NotificationPermissionState());
    });

    test('data inválida guardada é removida', () async {
      SharedPreferences.setMockInitialValues({
        SharedPreferencesKeys.notificationPermission: 'nao-e-data',
      });
      permission.status = PermissionStatus.restricted;
      final bloc = await build();
      expect(bloc.state, const NotificationPermissionState());
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString(SharedPreferencesKeys.notificationPermission),
          isNull);
    });

    test('switchRolesNeeded emite o alerta e limpa os dados', () async {
      final bloc = await build();
      final condo = testCondominium();
      final unity = testUnity();
      bloc.switchRolesNeeded(condo, unity);
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(bloc.state,
          AlertSwitchRoleState(switchCondominium: condo, switchUnity: unity));
      expect(bloc.switchCondominium, isNull);
      expect(bloc.switchUnity, isNull);
    });

    test('AlertSwitchRoleEvent emite o alerta diretamente', () async {
      final bloc = await build();
      final condo = testCondominium();
      final unity = testUnity();
      bloc.add(AlertSwitchRoleEvent(
          switchCondominium: condo, switchUnity: unity));
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(bloc.state, isA<AlertSwitchRoleState>());
    });

    test('showUpdate e showConfort emitem os estados correspondentes',
        () async {
      final bloc = await build();
      /// Corrigido (home_dialogs_bloc.dart): `NeedsUpdateEvent` e
      /// `ComfortEvent` agora têm `on<>` registrado e emitem
      /// `NeedsUpdateState`/`ComfortState` em vez de lançar erro.
      bloc.showUpdate();
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(
        bloc.state,
        const NeedsUpdateState(
          appOriginEnum: AppOriginEnum.owner,
          needsUpdate: NeedsUpdate.minor,
        ),
      );

      bloc.showUpdate(needsUpdate: NeedsUpdate.mandatory);
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect((bloc.state as NeedsUpdateState).needsUpdate,
          NeedsUpdate.mandatory);
      expect(
        const NeedsUpdateEvent(needsUpdate: NeedsUpdate.mandatory).props,
        [NeedsUpdate.mandatory, AppOriginEnum.owner],
      );

      bloc.showConfort();
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(bloc.state, const ComfortState());
    });
  });

  group('HomeDialogsWidget', () {
    late PageHarness harness;

    setUp(() async {
      harness = await installHomeHarness(_sessionBloc);
    });

    /// Bloc próprio registrado no container para o widget resolver. Os
    /// handlers do bloc rodam na zona em que ele foi construído, então ele
    /// precisa ser criado dentro de [withStoreLookup] para o `http.get` do
    /// diálogo enxergar o cliente falso.
    Future<HomeDialogBloc> installBloc() async {
      final bloc = HomeDialogBloc(sessionBloc: harness.resolve<SessionBloc>());
      await harness.override<HomeDialogBloc>(bloc);
      return bloc;
    }

    /// O link da loja no iOS/macOS vem de uma consulta HTTP ao iTunes; o
    /// `http.get` é interceptado por zona com um cliente falso.
    Future<T> withStoreLookup<T>(Future<T> Function() body) =>
        http.runWithClient(
          body,
          () => MockClient((_) async => http.Response(
                jsonEncode({
                  'results': [
                    {'trackViewUrl': 'https://apps.apple.com/br/app/morar'}
                  ]
                }),
                200,
              )),
        );

    Future<void> drain(WidgetTester tester) async {
      for (var i = 0; i < 4; i++) {
        await tester.pump(const Duration(seconds: 1));
      }
      await tester.pumpAndSettle();
    }

    testWidgets('monta sem erro e não mostra nada no estado inicial',
        (tester) async {
      /// Corrigido (home_dialogs_page.dart): o `BlocListener` agora recebe
      /// um `child`, então o widget monta sem assertion.
      await installBloc();
      await pumpPage(tester, const Scaffold(body: HomeDialogsWidget()));
      expect(tester.takeException(), isNull);
      expect(find.byType(HomeDialogsWidget), findsOneWidget);
      expect(find.text('new_version_app_title'), findsNothing);
      expect(
        const NeedsUpdateState(
          appOriginEnum: AppOriginEnum.owner,
          needsUpdate: NeedsUpdate.mandatory,
        ).props,
        [AppOriginEnum.owner, NeedsUpdate.mandatory],
      );
    });

    testWidgets('atualização obrigatória mostra o diálogo sem opção de adiar',
        (tester) async {
      await withStoreLookup(() async {
        final dialogBloc = await installBloc();
        await pumpPage(tester, const Scaffold(body: HomeDialogsWidget()));
        dialogBloc.showUpdate(needsUpdate: NeedsUpdate.mandatory);
        await drain(tester);
      });
      expect(find.text('new_version_app_title'), findsOneWidget);
      expect(
          find.text('new_version_app_critical_dialog_text'), findsOneWidget);
      expect(find.text('no_update_app'), findsNothing);
    });

    testWidgets('atualização opcional pode ser adiada e volta ao inicial',
        (tester) async {
      late HomeDialogBloc dialogBloc;
      await withStoreLookup(() async {
        dialogBloc = await installBloc();
        await pumpPage(tester, const Scaffold(body: HomeDialogsWidget()));
        dialogBloc.showUpdate();
        await drain(tester);
      });
      expect(find.text('new_version_app_title'), findsOneWidget);
      expect(find.text('new_version_app_dialog_text'), findsOneWidget);

      // Ao adiar, o bloc refaz as checagens (`initialState()`): com a
      // permissão de notificação negada ele passa a pedir a permissão.
      setFakePermissionHandler(
          FakePermissionHandler(status: PermissionStatus.denied));
      await tester.tap(find.text('no_update_app'));
      await drain(tester);
      expect(find.text('new_version_app_title'), findsNothing);
      expect(dialogBloc.state, const NotificationPermissionState());
      expect(dialogBloc.jumpFirstStep, isTrue);
    });
  });

  group('AgreementsDialog', () {
    late PageHarness harness;
    late RecordingNavigatorObserver observer;

    setUp(() async {
      harness = await installHomeHarness(_sessionBloc);
      observer = RecordingNavigatorObserver();
      AgreementsDialog.agreementsInfo = null;
    });

    testWidgets('sem rbac ou sem configuração não mostra', (tester) async {
      _sessionBloc.allowedRbacs = {};
      expect(await AgreementsDialog.canShowAgreementsDialog(), isFalse);

      final semConfig = FakeSessionBloc(configAllowed: false);
      await harness.override<SessionBloc>(semConfig);
      expect(await AgreementsDialog.canShowAgreementsDialog(), isFalse);
      expect(semConfig.configChecked, ['agreement_reference']);
    });

    testWidgets('primeira vez consulta as cotas disponíveis', (tester) async {
      final useCase = _FakeGetAvailable(quotes: [_quota()]);
      await harness.override<GetAvailableUseCase>(useCase);

      expect(await AgreementsDialog.canShowAgreementsDialog(), isTrue);
      expect(useCase.params.single.condoId, 'c1');
      expect(useCase.params.single.unitTitle, '101');
      expect(AgreementsDialog.agreementsInfo?.quotes, hasLength(1));

      // Segunda chamada no mesmo dia: intervalo não venceu.
      expect(await AgreementsDialog.canShowAgreementsDialog(), isFalse);
      expect(useCase.params, hasLength(1));
    });

    testWidgets('sem cotas ou com erro não mostra', (tester) async {
      await harness.override<GetAvailableUseCase>(_FakeGetAvailable());
      expect(await AgreementsDialog.canShowAgreementsDialog(), isFalse);

      SharedPreferences.setMockInitialValues({});
      await harness.override<GetAvailableUseCase>(_FakeGetAvailable(fail: true));
      expect(await AgreementsDialog.canShowAgreementsDialog(), isFalse);
    });

    testWidgets('data antiga consulta de novo e data inválida não',
        (tester) async {
      final useCase = _FakeGetAvailable(quotes: [_quota()]);
      await harness.override<GetAvailableUseCase>(useCase);
      SharedPreferences.setMockInitialValues({
        'AGREEMENTS_DIALOG_DATE_CHECK':
            DateTime.now().subtract(const Duration(days: 30)).toString(),
      });
      expect(await AgreementsDialog.canShowAgreementsDialog(), isTrue);

      SharedPreferences.setMockInitialValues({
        'AGREEMENTS_DIALOG_DATE_CHECK': 'data-invalida',
      });
      expect(await AgreementsDialog.canShowAgreementsDialog(), isFalse);
    });

    testWidgets('intervalo vem do remote config quando configurado',
        (tester) async {
      await setUpFakeFirebase(
          remoteConfigValues: {'agreements_dialog_show_interval': '1000'});
      final useCase = _FakeGetAvailable(quotes: [_quota()]);
      await harness.override<GetAvailableUseCase>(useCase);
      SharedPreferences.setMockInitialValues({
        'AGREEMENTS_DIALOG_DATE_CHECK':
            DateTime.now().subtract(const Duration(seconds: 5)).toString(),
      });
      expect(await AgreementsDialog.canShowAgreementsDialog(), isTrue);
      await setUpFakeFirebase();
    });

    testWidgets('diálogo: "depois" fecha e "vamos lá" abre acordos',
        (tester) async {
      AgreementsDialog.agreementsInfo = AgreementAllInfo(
        quotes: [_quota()],
        agreements: [],
        rule: AgreementRule(installmentQtd: 1, days: [1], paymentMethod: []),
      );
      await pumpPage(
        tester,
        Builder(
          builder: (ctx) => Scaffold(
            body: ElevatedButton(
              onPressed: () => AgreementsDialog.show(context: ctx),
              child: const Text('abrir'),
            ),
          ),
        ),
        observer: observer,
        surface: const Size(800, 800),
      );
      await tester.tap(find.text('abrir'));
      await tester.pumpAndSettle();
      expect(find.byType(AgreementsDialogWidget), findsOneWidget);

      await tester.tap(find.text('LATER'));
      await tester.pumpAndSettle();
      expect(find.byType(AgreementsDialogWidget), findsNothing);

      await tester.tap(find.text('abrir'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('LETSGO'));
      await tester.pumpAndSettle();
      expect(observer.pushedNames.last, ApplicationRoute.agreements);
      expect(find.byType(AgreementsDialogWidget), findsNothing);
      final bloc = harness.resolve<AgreementsBloc>();
      expect(bloc.state, isNotNull);

      // Voltar do sistema também fecha.
      await tester.pumpWidget(const SizedBox());
      await pumpPage(
        tester,
        Builder(
          builder: (ctx) => Scaffold(
            body: ElevatedButton(
              onPressed: () => AgreementsDialog.show(context: ctx),
              child: const Text('abrir'),
            ),
          ),
        ),
        surface: const Size(800, 800),
      );
      await tester.tap(find.text('abrir'));
      await tester.pumpAndSettle();
      await tester.state<NavigatorState>(find.byType(Navigator)).maybePop();
      await tester.pumpAndSettle();
      expect(find.byType(AgreementsDialogWidget), findsNothing);
    });
  });

  group('rbac de acordos', () {
    test('constante usada pelo diálogo', () {
      expect(ApplicationRbac.morarAcordos, 'morar.acordos');
      expect(installTestEnvironment, isNotNull);
    });
  });
}
