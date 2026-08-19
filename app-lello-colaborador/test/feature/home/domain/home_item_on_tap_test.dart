import 'dart:async';

import 'package:colaborador/core/navigation/application_route.dart';
import 'package:colaborador/feature/home/domain/entity/home_item_enum.dart';
import 'package:colaborador/feature/home/presentation/bloc/register_point_bloc.dart';
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/shared_features.dart';

import '../../../helpers/firebase_mocks.dart';
import '../../../helpers/test_application_container.dart';

const _page0Key = Key('page0');

Future<BuildContext> _pumpPageView(
  WidgetTester tester,
  TestApplicationContainerScope scope, {
  Map<String, WidgetBuilder>? routes,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      onGenerateRoute: (settings) {
        final builder = routes?[settings.name];
        if (builder != null) {
          return MaterialPageRoute(builder: builder);
        }
        return MaterialPageRoute(
          builder: (_) => Scaffold(body: Text(settings.name ?? '')),
        );
      },
      home: PageView(
        controller: scope.homeController.pageController,
        children: const [
          SizedBox(),
          SizedBox(key: _page0Key),
        ],
      ),
    ),
  );
  return tester.element(find.byKey(_page0Key));
}

void main() {
  testWidgets('myDocuments altera página atual', (tester) async {
    final scope = await installTestApplicationContainer();
    addTearDown(scope.dispose);
    final context = await _pumpPageView(tester, scope);

    await HomeItemEnum.myDocuments.onTap(context: context);
    await tester.pump();

    expect(scope.homeController.currentPage, 1);
  });

  testWidgets('registerDigitalPoint chama controller', (tester) async {
    final scope = await installTestApplicationContainer();
    addTearDown(scope.dispose);
    final context = await _pumpPageView(tester, scope);
    final nextState = scope.registerPointBloc.stream.first;

    await HomeItemEnum.registerDigitalPoint.onTap(context: context);

    expect(await nextState, isA<StartRegisterPointState>());
  });

  testWidgets('digitalPoint retorna sem alterar página', (tester) async {
    final scope = await installTestApplicationContainer();
    addTearDown(scope.dispose);
    final context = await _pumpPageView(tester, scope);
    final initialPage = scope.homeController.currentPage;

    await HomeItemEnum.digitalPoint.onTap(context: context);
    await tester.pump();

    expect(scope.homeController.currentPage, initialPage);
  });

  test('checkVisible com sessão carregada respeita circuit breaker', () async {
    final session = LoadedSessionBloc();
    await installTestCircuitBreaker(sessionBloc: session, circuitVisible: false);
    addTearDown(resetTestApplicationContainer);

    for (final item in HomeItemEnum.values) {
      expect(
        item.checkVisible(session),
        isFalse,
        reason: '$item',
      );
    }
  });

  test('checkVisible com sessão carregada retorna true', () async {
    final session = LoadedSessionBloc();
    await installTestCircuitBreaker(sessionBloc: session, circuitVisible: true);
    addTearDown(resetTestApplicationContainer);

    expect(HomeItemEnum.proof.checkVisible(session), isTrue);
    expect(HomeItemEnum.benefits.checkVisible(session), isTrue);
    expect(HomeItemEnum.discounts.checkVisible(session), isTrue);
  });

  group('navegação via onTap', () {
    final navigationCases = <HomeItemEnum, String>{
      HomeItemEnum.teamManagement: SharedApplicationRoute.gdp,
      HomeItemEnum.timeSheet: ApplicationRoute.timesheet,
      HomeItemEnum.proof: ApplicationRoute.proof,
      HomeItemEnum.sickNote: ApplicationRoute.sickNote,
      HomeItemEnum.sendTimeSheet: ApplicationRoute.manualTimesheet,
      HomeItemEnum.incomeReport: ApplicationRoute.incomeReportList,
      HomeItemEnum.payStub: ApplicationRoute.payStubList,
      HomeItemEnum.vacation: ApplicationRoute.vacationList,
      HomeItemEnum.benefits: ApplicationRoute.benefitsList,
      HomeItemEnum.discounts: ApplicationRoute.comfortEmbedded,
      HomeItemEnum.employeeReferral: ApplicationRoute.employeeReferral,
    };

    for (final entry in navigationCases.entries) {
      testWidgets('${entry.key.name} navega para ${entry.value}', (tester) async {
        final scope = await installTestApplicationContainer();
        addTearDown(scope.dispose);
        final context = await _pumpPageView(tester, scope);
        scope.homeController.currentPage = 0;

        // `discounts` aguarda o pop da rota empurrada, então o onTap só
        // completa quando a tela é fechada — não dá para await aqui.
        unawaited(entry.key.onTap(context: context));
        await tester.pumpAndSettle();

        expect(find.text(entry.value), findsOneWidget);

        // Ao voltar da tela o callback de retorno religa o relógio da home.
        Navigator.of(context).pop();
        await tester.pumpAndSettle();
        expect(find.text(entry.value), findsNothing);
      });
    }

    testWidgets('links externos usam a configuração remota', (tester) async {
      final launched = <MethodCall>[];
      for (final channel in const [
        MethodChannel('plugins.flutter.io/url_launcher'),
        MethodChannel('plugins.flutter.io/url_launcher_macos'),
      ]) {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, (call) async {
          launched.add(call);
          return true;
        });
        addTearDown(() {
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
              .setMockMethodCallHandler(channel, null);
        });
      }

      await setUpFakeFirebase(
        remoteConfigValues: {
          CustomFirebaseRemoteConfig.indiqueGanhe:
              '{"link":"indique.lello.com.br","path":"/vagas"}',
          CustomFirebaseRemoteConfig.condoLivre:
              '{"link":"condolivre.lello.com.br","path":"/home"}',
          CustomFirebaseRemoteConfig.cursos:
              '{"link":"cursos.lello.com.br","path":"/lista"}',
        },
      );
      final scope = await installTestApplicationContainer(
        remoteConfig: FirebaseRemoteConfig.instance,
      );
      addTearDown(scope.dispose);
      final context = await _pumpPageView(tester, scope);
      scope.homeController.currentPage = 0;

      await HomeItemEnum.indicateReceiveBenefits.onTap(context: context);
      await HomeItemEnum.condolivre.onTap(context: context);
      await HomeItemEnum.courses.onTap(context: context);
      await tester.pumpAndSettle();

      expect(launched, isNotEmpty);
      expect(tester.takeException(), isNull);
    });

    testWidgets('configuração remota inválida não abre link', (tester) async {
      await setUpFakeFirebase(
        remoteConfigValues: {
          CustomFirebaseRemoteConfig.indiqueGanhe: 'nao-e-json',
          CustomFirebaseRemoteConfig.condoLivre: 'nao-e-json',
          CustomFirebaseRemoteConfig.cursos: 'nao-e-json',
        },
      );
      final scope = await installTestApplicationContainer(
        remoteConfig: FirebaseRemoteConfig.instance,
      );
      addTearDown(scope.dispose);
      final context = await _pumpPageView(tester, scope);

      await HomeItemEnum.indicateReceiveBenefits.onTap(context: context);
      await HomeItemEnum.condolivre.onTap(context: context);
      await HomeItemEnum.courses.onTap(context: context);
      await tester.pump();

      expect(tester.takeException(), isNull);
    });

    testWidgets('benefícios externos não lançam exceção', (tester) async {
      final scope = await installTestApplicationContainer();
      addTearDown(scope.dispose);
      final context = await _pumpPageView(tester, scope);

      await HomeItemEnum.indicateReceiveBenefits.onTap(context: context);
      await HomeItemEnum.condolivre.onTap(context: context);
      await HomeItemEnum.courses.onTap(context: context);
      await tester.pump();
    });
  });
}
