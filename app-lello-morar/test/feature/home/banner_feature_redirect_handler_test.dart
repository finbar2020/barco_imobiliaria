import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/home/presentation/controllers/banner_feature_redirect_handler.dart';
import 'package:shared_features/feature/banners/domain/entity/banner.dart';
import 'package:shared_features/feature/banners/domain/entity/banner_args.dart';
import 'package:shared_features/feature/banners/domain/entity/banner_redirect_enum.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/comfort_page_origin_enum.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/pages/comfort_page.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/pump_app.dart';

BannerEntity _banner(BannerFeatureEnum feature, {String? partnerId}) =>
    BannerEntity(
      id: 'b1',
      image: 'img',
      feature: feature,
      arg: partnerId == null ? null : BannerArgs(partnerId: partnerId),
    );

void main() {
  late FakeSessionBloc sessionBloc;
  late RecordingNavigatorObserver observer;
  late BuildContext context;

  setUp(() {
    sessionBloc = FakeSessionBloc();
    observer = RecordingNavigatorObserver();
  });

  Future<void> pump(WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      navigatorObservers: [observer],
      onGenerateRoute: (settings) => MaterialPageRoute(
        settings: settings,
        builder: (_) => const SizedBox(),
      ),
      home: Builder(builder: (c) {
        context = c;
        return const SizedBox();
      }),
    ));
    // Descarta o push da rota inicial ('/').
    observer.pushed.clear();
  }

  void redirect(
    BannerFeatureEnum feature, {
    String? partnerId,
    VoidCallback? onNavigateToComodities,
    bool isGeneric = true,
  }) =>
      BannerFeatureRedirectHandler.redirect(
        context: context,
        sessionBloc: sessionBloc,
        banner: _banner(feature, partnerId: partnerId),
        isGeneric: isGeneric,
        onNavigateToComodities: onNavigateToComodities,
      );

  testWidgets('features mapeadas navegam para a rota correspondente',
      (tester) async {
    await pump(tester);
    final cases = <BannerFeatureEnum, String>{
      BannerFeatureEnum.lelloMorarInsurance: ApplicationRoute.insurance,
      BannerFeatureEnum.seguros: ApplicationRoute.insurance,
      BannerFeatureEnum.acordos: ApplicationRoute.agreements,
      BannerFeatureEnum.acordosRealizados: ApplicationRoute.agreements,
      BannerFeatureEnum.assembleia: ApplicationRoute.digitalMeeting,
      BannerFeatureEnum.autorizacaoEntrada: ApplicationRoute.accessControl,
      BannerFeatureEnum.boletos: ApplicationRoute.billets,
      BannerFeatureEnum.correspondencias: ApplicationRoute.mailing,
      BannerFeatureEnum.documentosAdvertencias: ApplicationRoute.documents,
      BannerFeatureEnum.documentosAtas: ApplicationRoute.documents,
      BannerFeatureEnum.documentosCirculares: ApplicationRoute.documents,
      BannerFeatureEnum.documentosEditais: ApplicationRoute.documents,
      BannerFeatureEnum.documentosMultas: ApplicationRoute.documents,
      BannerFeatureEnum.minhasOcorrencias: ApplicationRoute.reports,
      BannerFeatureEnum.ocorrencias: ApplicationRoute.reports,
      BannerFeatureEnum.moradoresSubmoradores: ApplicationRoute.subUser,
      BannerFeatureEnum.prestacaoContas: ApplicationRoute.accountability,
      BannerFeatureEnum.reservaAreaAgendamentos: ApplicationRoute.reserve,
      BannerFeatureEnum.minhaConta: ApplicationRoute.myPreferences,
      BannerFeatureEnum.bella: ApplicationRoute.iaBella,
    };

    for (final entry in cases.entries) {
      observer.pushed.clear();
      redirect(entry.key);
      await tester.pumpAndSettle();
      expect(observer.pushedNames, [entry.value], reason: '${entry.key}');
      Navigator.of(context).pop();
      await tester.pumpAndSettle();
    }
  });

  testWidgets('features sem mapeamento não navegam', (tester) async {
    await pump(tester);
    for (final feature in [
      BannerFeatureEnum.others,
      BannerFeatureEnum.gestaoTecnica,
      BannerFeatureEnum.lelloMorarTDB,
      BannerFeatureEnum.espelhoPonto,
      BannerFeatureEnum.despesasAprovacoesPendentes,
      BannerFeatureEnum.despesasConsultarPagamentos,
    ]) {
      redirect(feature);
    }
    await tester.pumpAndSettle();

    expect(observer.pushedNames, isEmpty);
  });

  testWidgets('sem rbac a feature mapeada não navega', (tester) async {
    await pump(tester);
    sessionBloc.rbacAllowed = false;

    redirect(BannerFeatureEnum.boletos);
    await tester.pumpAndSettle();

    expect(observer.pushedNames, isEmpty);
  });

  testWidgets('parceiro de comodidades abre a página de comfort com os args',
      (tester) async {
    await pump(tester);

    redirect(BannerFeatureEnum.lelloMorarComfortPartner, partnerId: ' p9 ');
    await tester.pumpAndSettle();

    expect(observer.pushedNames, [ApplicationRoute.comfort]);
    final args = observer.pushed.last.settings.arguments as ComfortPageArgs;
    expect(args.partnerId, 'p9');
    expect(args.reference, sessionBloc.state.session!.condominium!.reference);
    expect(args.accessRouteOrigin, ComfortPageOriginEnum.banner);
    expect(args.unit, isNotEmpty);
  });

  testWidgets('parceiro sem id usa o callback da aba de comodidades',
      (tester) async {
    await pump(tester);
    var called = 0;

    redirect(
      BannerFeatureEnum.lelloMorarComfortPartner,
      onNavigateToComodities: () => called++,
    );
    redirect(
      BannerFeatureEnum.lelloMorarComfortPartner,
      partnerId: '   ',
      onNavigateToComodities: () => called++,
    );
    await tester.pumpAndSettle();

    expect(called, 2);
    expect(observer.pushedNames, isEmpty);
  });

  testWidgets('parceiro sem id e sem callback navega para o comfort',
      (tester) async {
    await pump(tester);

    redirect(BannerFeatureEnum.lelloMorarComfortPartner);
    await tester.pumpAndSettle();

    expect(observer.pushedNames, [ApplicationRoute.comfort]);
    final args = observer.pushed.last.settings.arguments as ComfortPageArgs;
    expect(args.partnerId, isNull);
  });

  testWidgets('sem rbac de comodidades o parceiro é ignorado', (tester) async {
    await pump(tester);
    sessionBloc.rbacAllowed = false;
    var called = 0;

    redirect(
      BannerFeatureEnum.lelloMorarComfortPartner,
      onNavigateToComodities: () => called++,
    );
    await tester.pumpAndSettle();

    expect(called, 0);
    expect(observer.pushedNames, isEmpty);
  });
}
