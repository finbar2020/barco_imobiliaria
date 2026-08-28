import 'package:essentials/enum/app_origin_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/core/widgets/error_message_widget.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/bloc/comfort_partners_state.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/comfort_page_origin_enum.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/controller/comfort_partners_controller.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/pages/comfort_my_favorites/comfort_disfavor_success_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/pages/comfort_my_favorites/comfort_my_favorites_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/pages/comfort_partner_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/comfort_my_favorites/disfavor_partner_dialog.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/comfort_my_favorites/favorite_partner_card.dart';
import 'package:shared_features/shared_features.dart';

import '../../../helpers/firebase_mocks.dart';
import '../../../helpers/pump_app.dart';
import 'comfort_partners_test_support.dart';

void main() {
  late ComfortHarness harness;
  late RecordingNavigatorObserver observer;

  setUp(() async {
    harness = await installComfortHarness();
    observer = RecordingNavigatorObserver();
  });

  Future<ComfortPartnersController> pumpFavorites(
    WidgetTester tester, {
    List<Map<String, dynamic>>? partners,
    bool loadPartners = true,
  }) async {
    harness.mockPartners(partners ??
        [
          partnerJson('P1', title: 'Alfa', favorite: true),
          partnerJson('P2', title: 'Beta', favorite: false),
          partnerJson('P3', title: 'Gama', favorite: true),
        ]);
    final controller = harness.controller();
    if (loadPartners) {
      await controller.getAllPartners(ComfortPageOriginEnum.homePage);
    }
    await pumpPage(
      tester,
      ComfortMyFavoritesPage(appContainer: harness.container),
      arguments: ComfortMyFavoritesPageArgs(controller, AppOriginEnum.owner),
      observer: observer,
      routes: {
        SharedApplicationRoute.comfortDisfavorSuccess: (_) =>
            const ComfortDisfavorSuccessPage(),
      },
    );
    return controller;
  }

  testWidgets('lista só os parceiros favoritos', (tester) async {
    await pumpFavorites(tester);

    expect(find.text('comfort'), findsOneWidget);
    expect(find.text('comfort_my_favorites'), findsOneWidget);
    expect(find.byType(FavoritePartnerCard), findsNWidgets(2));
    expect(find.text('Alfa'), findsOneWidget);
    expect(find.text('Gama'), findsOneWidget);
    expect(find.text('Beta'), findsNothing);
    expect(find.text('comfort_disfavor_partner'), findsNWidgets(2));

    await expectLater(
      find.byType(ComfortMyFavoritesPage),
      matchesGoldenFile('goldens/comfort_my_favorites_page.png'),
    );
  });

  testWidgets('sem favoritos mostra a mensagem de vazio', (tester) async {
    await pumpFavorites(tester, partners: [partnerJson('P2')]);

    expect(find.text('comfort_my_favorites_empty'), findsOneWidget);
    expect(find.byType(FavoritePartnerCard), findsNothing);
  });

  testWidgets('tocar em um favorito abre a página do parceiro',
      (tester) async {
    final controller = await pumpFavorites(tester);

    await tester.tap(find.text('Gama'));
    await tester.pumpAndSettle();

    expect(findRoute(SharedApplicationRoute.comfortPartner), findsOneWidget);
    expect(controller.selectedPartner?.id, 'P3');
    final args = observer.pushed.last.settings.arguments as ComfortPartnerPageArgs;
    expect(args.reference, '');
    expect(args.appOriginEnum, AppOriginEnum.owner);
    expect(fakeAnalytics.events['comodidades_parceiro_acessar']?['origem_acesso'],
        'myFavoritesPage');
  });

  testWidgets('cancelar no diálogo de desfavoritar mantém o favorito',
      (tester) async {
    await pumpFavorites(tester);

    await tester.tap(find.text('comfort_disfavor_partner').first);
    await tester.pumpAndSettle();

    expect(find.byType(DisfavorPartnerDialog), findsOneWidget);
    expect(find.text('comfort_disfavor_dialog_confirmation'), findsOneWidget);
    expect(find.byType(RichText), findsWidgets);

    await tester.tap(find.text('comfort_disfavor_dialog_cancel'));
    await tester.pumpAndSettle();

    expect(find.byType(DisfavorPartnerDialog), findsNothing);
    expect(find.byType(FavoritePartnerCard), findsNWidgets(2));
    expect(harness.requestedPaths, ['/condominiums/C1/comfort/v2']);
  });

  testWidgets('confirmar desfavoritar abre a página de sucesso e volta',
      (tester) async {
    harness.mockFavorite('P1', isFavorite: false);
    final controller = await pumpFavorites(tester);

    await tester.tap(find.text('comfort_disfavor_partner').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('comfort_disfavor_dialog_confirmation'));
    await tester.pumpAndSettle();

    expect(find.byType(ComfortDisfavorSuccessPage), findsOneWidget);
    expect(find.text('comfort_disfavor_complete'), findsOneWidget);
    expect(observer.pushedNames,
        contains(SharedApplicationRoute.comfortDisfavorSuccess));
    expect(harness.http.requests.last.url.queryParameters['is_favorite'],
        'false');

    await tester.tap(find.text('comfort_disfavor_conclude'));
    await tester.pumpAndSettle();

    expect(find.byType(ComfortDisfavorSuccessPage), findsNothing);
    expect(controller.comfortPartnersBloc.state,
        isA<LoadedComfortPartnersState>());
    expect(find.byType(FavoritePartnerCard), findsOneWidget);
    expect(find.text('Gama'), findsOneWidget);
  });

  testWidgets('voltar da página de sucesso pelo sistema reemite a lista',
      (tester) async {
    harness.mockFavorite('P1', isFavorite: false);
    final controller = await pumpFavorites(tester);

    await tester.tap(find.text('comfort_disfavor_partner').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('comfort_disfavor_dialog_confirmation'));
    await tester.pumpAndSettle();
    expect(find.byType(ComfortDisfavorSuccessPage), findsOneWidget);

    await tester.state<NavigatorState>(find.byType(Navigator)).maybePop();
    await tester.pumpAndSettle();

    expect(find.byType(ComfortDisfavorSuccessPage), findsNothing);
    expect(
        (controller.comfortPartnersBloc.state as LoadedComfortPartnersState)
            .partnerFocus,
        isNull);
  });

  testWidgets('falha ao desfavoritar mantém a lista', (tester) async {
    harness.http.on('PUT', '/condominiums/C1/comfort/favorite/P1',
        status: 500, body: {'message': 'erro'});
    await pumpFavorites(tester);

    await tester.tap(find.text('comfort_disfavor_partner').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('comfort_disfavor_dialog_confirmation'));
    await tester.pumpAndSettle();

    expect(find.byType(ComfortDisfavorSuccessPage), findsNothing);
    expect(find.byType(FavoritePartnerCard), findsNWidgets(2));
    /// Corrigido: a mensagem de erro (`flushbarMessage`) é repassada pelo
    /// bloc e o SnackBar aparece.
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('comfort_change_partner_favorite_status_error'),
        findsOneWidget);
  });

  testWidgets('mensagem do flushbar vira SnackBar', (tester) async {
    final controller = await pumpFavorites(tester);

    await emitState(
      tester,
      controller.comfortPartnersBloc,
      const LoadedComfortPartnersState(
        flushbarMessage: 'comfort_change_partner_favorite_status_error',
        comfortPartnerCategoryIsFilter: true,
        comfortPartnersIsRandomic: false,
        categoriesToYourCondo: [],
      ),
      settle: false,
    );
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('comfort_change_partner_favorite_status_error'),
        findsOneWidget);
  });

  testWidgets('estados de carregamento, erro e vazio', (tester) async {
    final controller = await pumpFavorites(tester, loadPartners: false);
    expect(find.byType(FavoritePartnerCard), findsNothing);
    expect(find.byType(LoadingWidget), findsNothing);

    await emitState(tester, controller.comfortPartnersBloc,
        const LoadingComfortPartnersState(),
        settle: false);
    expect(find.byType(LoadingWidget), findsOneWidget);

    await emitState(
        tester,
        controller.comfortPartnersBloc,
        const ErrorComfortPartnersState(
            errorMessageKey: 'comfort_error_message',
            errorCode: null,
            errorDescription: null));
    expect(find.byType(ErrorMessageWidget), findsOneWidget);
    expect(find.text('comfort_error_message'), findsOneWidget);
  });

  testWidgets('voltar reemite a lista de parceiros', (tester) async {
    final controller = await pumpFavorites(tester);
    controller.selectedPartner = controller.allPartnersList.first;

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(find.byType(ComfortMyFavoritesPage), findsNothing);
    expect(
        (controller.comfortPartnersBloc.state as LoadedComfortPartnersState)
            .partnerFocus
            ?.id,
        'P1');
  });

  testWidgets('orientação paisagem usa outra proporção de célula',
      (tester) async {
    await pumpFavorites(tester);
    tester.view.physicalSize = const Size(900, 500);
    await tester.pumpAndSettle();

    final grid = tester.widget<GridView>(find.byType(GridView));
    expect((grid.childrenDelegate as SliverChildListDelegate).children,
        hasLength(2));
  });
}
