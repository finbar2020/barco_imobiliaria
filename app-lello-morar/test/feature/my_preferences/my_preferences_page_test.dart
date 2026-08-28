import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/navigation/application_rbac.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/me/domain/entity/me.dart';
import 'package:morar/feature/me/domain/use_case/get_me/get_me.dart';
import 'package:morar/feature/me/presentation/bloc/me_state.dart';
import 'package:morar/feature/me/presentation/controllers/me_controller.dart';
import 'package:morar/feature/my_preferences/presentation/my_preferences_page.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';

/// `MeController.meLoad` passa pelo banco local (drift) que não completa no
/// fake async; o use case é trocado por este fake antes do controller ser
/// resolvido pela página.
class _FakeGetMe extends Fake implements GetMe {
  _FakeGetMe(this.me);
  final Me? me;
  final origins = <DataOrigin>[];

  @override
  Future<Try<Me?>> call(DataOrigin origin) async {
    origins.add(origin);
    return Success(me);
  }
}

void main() {
  late PageHarness harness;
  late RecordingNavigatorObserver observer;
  late _FakeGetMe getMe;

  setUp(() async {
    harness = await installPageHarness();
    observer = RecordingNavigatorObserver();
    getMe = _FakeGetMe(testMe());
    await harness.override<GetMe>(getMe);
  });

  MeController controller() => harness.resolve<MeController>();

  testWidgets('mostra os dados do usuário e as opções', (tester) async {
    await pumpPage(tester, const MyPreferencesPage(), observer: observer);

    expect(controller().bloc.state, isA<MeLoadedState>());
    expect(getMe.origins, [DataOrigin.local, DataOrigin.remote]);
    expect(harness.sessionBloc.updatedMes, hasLength(1));
    expect(find.text('my_preferences'), findsOneWidget);
    expect(find.text('ana silva'), findsOneWidget);
    expect(find.text('CPF\n12345678901'), findsOneWidget);
    expect(find.text('Telefone\n11999998888'), findsOneWidget);
    expect(find.text('Email\nana@lello.com'), findsOneWidget);
    expect(find.text('Meus dados'), findsOneWidget);
    expect(find.text('receipt_of_documents'), findsOneWidget);
    expect(find.text('in_care'), findsOneWidget);
    expect(find.text('condominium_hub_residents'), findsOneWidget);
    expect(find.byType(ListTile), findsNWidgets(3));
    await expectLater(
      find.byType(MyPreferencesPage),
      matchesGoldenFile('goldens/my_preferences_page.png'),
    );
  });

  testWidgets('sem telefone mostra "Não informado"', (tester) async {
    await harness.override<GetMe>(_FakeGetMe(testMe(phone: '')));

    await pumpPage(tester, const MyPreferencesPage());

    expect(find.text('Telefone\nNão informado'), findsOneWidget);
  });

  testWidgets('enquanto carrega mostra o indicador', (tester) async {
    await pumpPage(tester, const MyPreferencesPage(), settle: false);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Meus dados'), findsNothing);

    await tester.pumpAndSettle();
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Meus dados'), findsOneWidget);

    await emitState(tester, controller().bloc, MeLoadingState(Me.empty()),
        settle: false);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('cada opção navega para a rota certa', (tester) async {
    await pumpPage(tester, const MyPreferencesPage(), observer: observer);
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));

    final expected = {
      'Meus dados': ApplicationRoute.me,
      'receipt_of_documents': ApplicationRoute.receivingDocuments,
      'in_care': ApplicationRoute.inCare,
      'condominium_hub_residents': ApplicationRoute.subUser,
    };
    for (final entry in expected.entries) {
      await tester.tap(find.text(entry.key));
      await tester.pumpAndSettle();
      expect(observer.pushedNames.last, entry.value);
      expect(findRoute(entry.value), findsOneWidget);
      navigator.pop();
      await tester.pumpAndSettle();
    }
    expect(find.byType(MyPreferencesPage), findsOneWidget);
  });

  testWidgets('sem permissão esconde as opções de conta', (tester) async {
    harness.sessionBloc.allowedRbacs = {};
    await pumpPage(tester, const MyPreferencesPage());

    expect(find.byType(ListTile), findsNothing);
    expect(find.text('Meus dados'), findsOneWidget);
    expect(harness.sessionBloc.rbacChecked,
        contains(ApplicationRbac.morarPreferenciasMinhaContaFull));
  });

  testWidgets('só com rbac de moradores mostra apenas "moradores"',
      (tester) async {
    harness.sessionBloc.allowedRbacs = {ApplicationRbac.morarMoradores};
    await pumpPage(tester, const MyPreferencesPage());

    expect(find.byType(ListTile), findsOneWidget);
    expect(find.text('condominium_hub_residents'), findsOneWidget);
    expect(find.text('receipt_of_documents'), findsNothing);
    expect(find.text('in_care'), findsNothing);
  });
}
