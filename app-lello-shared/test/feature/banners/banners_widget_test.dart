import 'dart:async';

import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/banners/domain/entity/banner.dart';
import 'package:shared_features/feature/banners/domain/entity/banner_location_enum.dart';
import 'package:shared_features/feature/banners/domain/entity/banner_redirect_type_enum.dart';
import 'package:shared_features/feature/banners/presentation/bloc/banners_state.dart';
import 'package:shared_features/feature/banners/presentation/widgets/banners_widget.dart';

import '../../helpers/fake_url_launcher.dart';
import '../../helpers/firebase_mocks.dart';
import '../../helpers/pump_app.dart';
import 'banners_support.dart';

const _nativeUrlChannel = MethodChannel('com.example.app/url_launcher');

void main() {
  late BannersHarness harness;
  late MemoryBannersLocalDataSource memory;
  late List<BannerEntity> clicked;
  late FakeUrlLauncherPlatform launcher;

  setUpAll(() async {
    await setUpFakeFirebase();
    PackageInfo.setMockInitialValues(
      appName: 'Lello Morar',
      packageName: 'br.com.lello.morar',
      version: '1.20.0',
      buildNumber: '1',
      buildSignature: '',
    );
  });

  setUp(() {
    fakeAnalytics.reset();
    clicked = [];
    launcher = installFakeUrlLauncher();
    memory = MemoryBannersLocalDataSource();
    harness = BannersHarness(local: memory);
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(
        _nativeUrlChannel, (_) async => throw PlatformException(code: 'x'));
    addTearDown(
        () => messenger.setMockMethodCallHandler(_nativeUrlChannel, null));
  });

  Future<void> pumpBanners(
    WidgetTester tester, {
    String? title,
    int maxItems = 10,
    bool showCounterIndicator = false,
    String? accessButtonLabel,
    BannerLocationEnum? location,
    bool compact = false,
    bool stacked = false,
    Size surface = const Size(400, 800),
    bool settle = true,
  }) async {
    await tester.pumpWidget(const SizedBox());
    await pumpPage(
      tester,
      Scaffold(
        body: SingleChildScrollView(
          child: BannersWidget(
            appContainer: harness.container,
            sessionBloc: harness.sessionBloc,
            onBannerClick: (banner) {
              clicked.add(banner);
            },
            title: title,
            maxItems: maxItems,
            showCounterIndicator: showCounterIndicator,
            accessButtonLabel: accessButtonLabel,
            location: location,
            compact: compact,
            stacked: stacked,
          ),
        ),
      ),
      surface: surface,
      settle: settle,
    );
  }

  /// Desmonta para cancelar o timer periódico do carrossel.
  Future<void> unmount(WidgetTester tester) =>
      tester.pumpWidget(const SizedBox());

  List<Map<String, dynamic>> threeBanners() => [
        bannerJson(id: 'b2', name: 'Segundo', ordem: 2),
        bannerJson(id: 'b1', name: 'Primeiro', ordem: 1),
        bannerJson(id: 'b3', name: 'Terceiro', ordem: 3),
      ];

  testWidgets('carrega da API, ordena pelo campo ordem e mostra o carrossel',
      (tester) async {
    harness.stubBanners([
      ...threeBanners(),
      bannerJson(id: 'inativo', name: 'Inativo', ativo: 'n', ordem: 0),
      bannerJson(id: 'outra', name: 'Outra tela', location: 'COMODIDADES'),
    ]);
    await pumpBanners(tester,
        showCounterIndicator: true, location: BannerLocationEnum.home);

    expect(find.text('for_you'), findsOneWidget);
    expect(find.byType(PageView), findsOneWidget);
    expect(find.text('Primeiro'), findsOneWidget);
    expect(find.text('Inativo'), findsNothing);
    expect(find.text('Outra tela'), findsNothing);
    expect(find.text('Acesse aqui'), findsWidgets);
    // Indicador com 3 pontos.
    expect(find.byType(AnimatedContainer), findsNWidgets(3));
    expect(harness.requestedPaths, ['/condominiums/C1/banners/v2']);

    await expectLater(
      find.byType(BannersWidget),
      matchesGoldenFile('goldens/banners_widget_carousel.png'),
    );

    // Arrastar avança para o segundo banner e move o indicador.
    await tester.drag(find.byType(PageView), const Offset(-350, 0));
    await tester.pumpAndSettle();
    expect(find.text('Segundo'), findsOneWidget);
    final active = tester
        .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
        .map((c) => c.constraints?.maxWidth)
        .toList();
    expect(active, hasLength(3));

    await unmount(tester);
  });

  testWidgets('auto-scroll avança a cada 15 segundos', (tester) async {
    harness.stubBanners(threeBanners());
    await pumpBanners(tester, showCounterIndicator: true);
    expect(find.text('Primeiro'), findsOneWidget);

    await tester.pump(const Duration(seconds: 15));
    await tester.pumpAndSettle();
    expect(find.text('Segundo'), findsOneWidget);

    await tester.pump(const Duration(seconds: 15));
    await tester.pumpAndSettle();
    expect(find.text('Terceiro'), findsOneWidget);

    await unmount(tester);
  });

  testWidgets('um banner só não tem indicador nem auto-scroll', (tester) async {
    harness.stubBanners([bannerJson(id: 'b1', name: 'Único')]);
    await pumpBanners(tester, showCounterIndicator: true, title: 'Ofertas');
    expect(find.text('Ofertas'), findsOneWidget);
    expect(find.text('for_you'), findsNothing);
    expect(find.byType(AnimatedContainer), findsNothing);

    await tester.pump(const Duration(seconds: 15));
    await tester.pumpAndSettle();
    expect(find.text('Único'), findsOneWidget);
    await unmount(tester);
  });

  testWidgets('maxItems limita a quantidade', (tester) async {
    harness.stubBanners(threeBanners());
    await pumpBanners(tester, maxItems: 2, stacked: true);
    expect(find.text('Primeiro'), findsOneWidget);
    expect(find.text('Segundo'), findsOneWidget);
    expect(find.text('Terceiro'), findsNothing);
    await unmount(tester);
  });

  testWidgets('loading mostra o indicador; erro e vazio não desenham nada',
      (tester) async {
    harness.stubBanners([]);
    memory.gate = Completer<void>();
    await pumpBanners(tester, settle: false);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    memory.gate!.complete();
    await tester.pumpAndSettle();
    expect(find.byType(PageView), findsNothing);
    expect(find.text('for_you'), findsNothing);

    harness.http.failAll();
    await pumpBanners(tester);
    expect(harness.controller!.bloc.state, isA<ErrorBannersState>());
    expect(find.byType(PageView), findsNothing);
    await unmount(tester);
  });

  testWidgets('cache fresco não chama a API', (tester) async {
    memory.store['C1'] = [buildBannerModel(id: 'cache', name: 'Do cache')];
    await pumpBanners(tester);
    expect(find.text('Do cache'), findsOneWidget);
    expect(harness.http.requests, isEmpty);
    await unmount(tester);
  });

  testWidgets('modo compacto no carrossel', (tester) async {
    harness.stubBanners(threeBanners());
    await pumpBanners(tester, compact: true, accessButtonLabel: 'Ver');
    expect(find.text('Ver'), findsWidgets);
    expect(find.text('Subtítulo 1'), findsWidgets);
    await expectLater(
      find.byType(BannersWidget),
      matchesGoldenFile('goldens/banners_widget_compact.png'),
    );

    // O botão do card compacto também abre o banner.
    await tester.tap(find.text('Ver').hitTestable().first);
    await tester.pumpAndSettle();
    expect(launcher.launched, ['https://lello.com.br']);
    await unmount(tester);
  });

  testWidgets('lista que encolhe volta o índice para o primeiro banner',
      (tester) async {
    harness.stubBanners(threeBanners());
    await pumpBanners(tester, showCounterIndicator: true);
    await tester.drag(find.byType(PageView), const Offset(-350, 0));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(PageView), const Offset(-350, 0));
    await tester.pumpAndSettle();
    expect(find.text('Terceiro'), findsOneWidget);

    harness.controller!.bloc
        // ignore: invalid_use_of_visible_for_testing_member
        .emit(LoadedBannersState(banners: [buildBanner(name: 'Sozinho')]));
    await tester.pump();
    await tester.pump();
    expect(find.text('Sozinho'), findsOneWidget);
    expect(find.byType(AnimatedContainer), findsNothing);
    await unmount(tester);
  });

  testWidgets('modo empilhado (compacto e completo)', (tester) async {
    harness.stubBanners([
      bannerJson(id: 'b1', name: 'Primeiro', ordem: 1),
      bannerJson(id: 'b2', name: 'Sem subtítulo', subTitle: '', ordem: 2),
    ]);
    await pumpBanners(tester, stacked: true, compact: true);
    expect(find.byType(PageView), findsNothing);
    expect(find.text('for_you'), findsNothing);
    expect(find.text('Primeiro'), findsOneWidget);
    expect(find.text('Sem subtítulo'), findsOneWidget);
    expect(find.text('Subtítulo 1'), findsOneWidget);
    expect(find.text('Acessar'), findsNWidgets(2));
    await expectLater(
      find.byType(BannersWidget),
      matchesGoldenFile('goldens/banners_widget_stacked_compact.png'),
    );
    await tester.tap(find.text('Acessar').first);
    await tester.pumpAndSettle();
    expect(launcher.launched, ['https://lello.com.br']);

    await pumpBanners(tester, stacked: true, title: 'Empilhado');
    expect(find.text('Empilhado'), findsOneWidget);
    expect(find.text('Acesse aqui'), findsNWidgets(2));
    await unmount(tester);
  });

  group('clique', () {
    testWidgets('url abre no launcher e registra analytics', (tester) async {
      harness.stubBanners([bannerJson(id: 'b1', name: 'Site')]);
      await pumpBanners(tester);

      await tester.tap(find.text('Acesse aqui'));
      await tester.pumpAndSettle();

      expect(launcher.launched, ['https://lello.com.br']);
      expect(clicked, isEmpty);
      final params = fakeAnalytics.events.values.single!;
      expect(params['id_banner'], 'b1');
      expect(params['id_parceiro'], 'p1');
      expect(params['id_partner'], 'p1');
      expect(params['referencia'], 'R1');
      expect(params['unidade'], '101');
      expect(params['userId'], 'ME1');
      await unmount(tester);
    });

    testWidgets('url nula não abre nada', (tester) async {
      harness.stubBanners([bannerJson(id: 'b1', name: 'Site', redirect: null)]);
      await pumpBanners(tester);
      await tester.tap(find.text('Site'));
      await tester.pumpAndSettle();
      expect(launcher.launched, isEmpty);
      await unmount(tester);
    });

    testWidgets('whatsapp monta o link wa.me só com dígitos', (tester) async {
      harness.stubBanners([
        bannerJson(
            id: 'b1',
            name: 'Zap',
            redirectType: 'whatsapp',
            redirect: '+55 (11) 99999-0000',
            arg: null),
      ]);
      await pumpBanners(tester);
      await tester.tap(find.text('Zap'));
      await tester.pumpAndSettle();
      expect(launcher.launched, ['https://wa.me/5511999990000']);
      expect(fakeAnalytics.events.values.single!['id_parceiro'], '');
      await unmount(tester);
    });

    testWidgets('whatsapp sem dígitos usa o redirect cru; vazio ignora',
        (tester) async {
      harness.stubBanners([
        bannerJson(id: 'b1', name: 'Zap', redirectType: 'whatsapp', redirect: 'abc'),
        bannerJson(id: 'b2', name: 'Vazio', redirectType: 'whatsapp', redirect: '', ordem: 2),
      ]);
      await pumpBanners(tester, stacked: true);
      await tester.tap(find.text('Zap'));
      await tester.pumpAndSettle();
      expect(launcher.launched, ['abc']);

      await tester.tap(find.text('Vazio'));
      await tester.pumpAndSettle();
      expect(launcher.launched, ['abc']);
      await unmount(tester);
    });

    testWidgets('feature chama onBannerClick; other não faz nada',
        (tester) async {
      harness.stubBanners([
        bannerJson(id: 'b1', name: 'Feature', redirectType: 'feature'),
        bannerJson(id: 'b2', name: 'Nada', redirectType: 'xpto', ordem: 2),
      ]);
      await pumpBanners(tester, stacked: true);

      await tester.tap(find.text('Feature'));
      await tester.pumpAndSettle();
      expect(clicked.single.id, 'b1');
      expect(clicked.single.redirectType, BannerRedirectTypeEnum.feature);

      await tester.tap(find.text('Nada'));
      await tester.pumpAndSettle();
      expect(clicked, hasLength(1));
      expect(launcher.launched, isEmpty);
      await unmount(tester);
    });

    testWidgets('síndico registra a referência do condomínio selecionado',
        (tester) async {
      harness = BannersHarness(local: memory, origin: AppOriginEnum.manager);
      harness.stubBanners([bannerJson(id: 'b1', name: 'Site')]);
      await pumpBanners(tester);
      await tester.tap(find.text('Site'));
      await tester.pumpAndSettle();
      final params = fakeAnalytics.events.values.single!;
      expect(params['referencia'], 'SR1');
      expect(params.containsKey('unidade'), isFalse);
      expect(harness.requestedPaths, ['/condominiums/SC1/banners/v2']);
      await unmount(tester);
    });
  });
}
