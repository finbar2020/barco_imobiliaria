import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/feature/me/presentation/pages/me_delete_account_error.dart';
import 'package:morar/feature/me/presentation/pages/me_delete_account_success.dart';
import 'package:morar/feature/me/presentation/pages/me_edit_success.dart';

import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';
import 'me_page_helpers.dart';

const _launcherKey = Key('launcher-push');

void main() {
  late PageHarness harness;
  late MeFakes fakes;
  late RecordingNavigatorObserver observer;

  setUp(() async {
    harness = await installPageHarness();
    fakes = await installMeFakes(harness);
    observer = RecordingNavigatorObserver();
  });

  /// Empurra [page] por cima de uma página vazia para o `pop` ter destino.
  Future<void> pumpPushed(WidgetTester tester, Widget page) async {
    await pumpPage(
      tester,
      Builder(
        builder: (context) => Scaffold(
          body: ElevatedButton(
            key: _launcherKey,
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => page)),
            child: const Text('abrir'),
          ),
        ),
      ),
      observer: observer,
    );
    await tester.tap(find.byKey(_launcherKey));
    await tester.pumpAndSettle();
  }

  testWidgets('sucesso da edição: concluir pede avaliação e volta',
      (tester) async {
    await pumpPushed(tester, MeEditSuccessPage());

    expect(find.text('profile_update_success'), findsOneWidget);
    await expectLater(
      find.byType(MeEditSuccessPage),
      matchesGoldenFile('goldens/me_edit_success_page.png'),
    );

    await tester.tap(find.text('conclude'));
    await tester.pumpAndSettle();

    expect(fakes.reviewCalls, contains('isAvailable'));
    expect(observer.popped, hasLength(1));
    expect(find.byType(MeEditSuccessPage), findsNothing);
  });

  testWidgets('sucesso da edição: voltar do sistema também pede avaliação',
      (tester) async {
    await pumpPushed(tester, MeEditSuccessPage());

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(fakes.reviewCalls, contains('isAvailable'));
    expect(find.byType(MeEditSuccessPage), findsNothing);
  });

  testWidgets('erro da exclusão: tentar de novo volta', (tester) async {
    await pumpPushed(tester, MeDeleteAccountErrorPage());

    expect(find.text('error_unknown'), findsOneWidget);
    await expectLater(
      find.byType(MeDeleteAccountErrorPage),
      matchesGoldenFile('goldens/me_delete_account_error_page.png'),
    );

    await tester.tap(find.text('try_again'));
    await tester.pumpAndSettle();

    expect(observer.popped, hasLength(1));
    expect(find.byType(MeDeleteAccountErrorPage), findsNothing);
  });

  testWidgets('erro da exclusão: voltar do sistema fecha', (tester) async {
    await pumpPushed(tester, MeDeleteAccountErrorPage());

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.byType(MeDeleteAccountErrorPage), findsNothing);
  });

  testWidgets('sucesso da exclusão: concluir encerra a sessão e volta',
      (tester) async {
    await pumpPushed(
        tester, MeDeleteAccountSuccessPage(controller: fakes.controller));

    expect(find.text('Conta excluída com sucesso.'), findsOneWidget);
    await expectLater(
      find.byType(MeDeleteAccountSuccessPage),
      matchesGoldenFile('goldens/me_delete_account_success_page.png'),
    );

    await tester.tap(find.text('conclude'));
    await tester.pumpAndSettle();

    expect(observer.popped, hasLength(1));
    expect(fakes.logMeOut.calls, 1);
    expect(fakes.disableFcm.calls, 1);
    expect(harness.sessionBloc.logoutCalls, hasLength(2));
    expect(fakes.authStore.logouts, 2);
  });
}
