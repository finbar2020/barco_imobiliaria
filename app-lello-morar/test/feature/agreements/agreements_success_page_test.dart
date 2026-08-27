import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/agreements/presentation/bloc/agreements_bloc.dart';
import 'package:morar/feature/agreements/presentation/pages/agreements_success_page.dart';

import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';
import 'agreements_test_support.dart';

void main() {
  late PageHarness harness;
  late RecordingNavigatorObserver observer;
  late AgreementsBloc bloc;

  setUp(() async {
    harness = await installPageHarness();
    observer = RecordingNavigatorObserver();
    harness.sessionBloc.session.condominium!.reference = '77';
  });

  Future<void> pumpSuccess(WidgetTester tester) async {
    stubAgreementsApi(harness.http);
    bloc = harness.resolve<AgreementsBloc>();
    await pumpAgreementsStack(
      tester,
      [
        const RouteStep('/agreements'),
        RouteStep(ApplicationRoute.agreementSuccessSend, arguments: [bloc]),
      ],
      routes: onlyRoute(ApplicationRoute.agreementSuccessSend),
      observer: observer,
    );
  }

  testWidgets('mostra a confirmação de envio da proposta (golden)', (tester) async {
    await pumpSuccess(tester);

    expect(find.byIcon(Icons.check_circle), findsOneWidget);
    expect(find.text('agreements_send_proposal'), findsOneWidget);
    expect(find.text('Edifício Lello - 101'), findsOneWidget);
    expect(find.text('agreements_description_success'), findsOneWidget);
    expect(find.text('conclude'), findsOneWidget);
    await expectLater(
      find.byType(AgreementsSuccessPage),
      matchesGoldenFile('goldens/agreements_success_page.png'),
    );
  });

  testWidgets('concluir recarrega as cotas e volta para acordos', (tester) async {
    await pumpSuccess(tester);
    final before = harness.http.requests.where((r) => r.url.path == allInfoPath).length;

    await tester.tap(find.text('conclude'));
    await tester.pumpAndSettle();

    expect(findRoute('/agreements'), findsOneWidget);
    expect(find.byType(AgreementsSuccessPage), findsNothing);
    expect(harness.http.requests.where((r) => r.url.path == allInfoPath).length, before + 1);
  });

  testWidgets('voltar pelo sistema volta para acordos', (tester) async {
    await pumpSuccess(tester);

    await systemBack(tester);

    expect(findRoute('/agreements'), findsOneWidget);
    expect(find.byType(AgreementsSuccessPage), findsNothing);
  });
}
