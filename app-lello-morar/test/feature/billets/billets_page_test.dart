import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/billets/presentation/bloc/billets_bloc.dart';
import 'package:morar/feature/billets/presentation/bloc/billets_state.dart';
import 'package:morar/feature/billets/presentation/controllers/billets_controller.dart';
import 'package:morar/feature/billets/presentation/pages/billets_page.dart';
import 'package:morar/feature/billets/presentation/widgets/billets_card_widget.dart';

import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';

Map<String, dynamic> _billet(String id, {bool duplicate = false, String situation = 'pendente'}) => {
      'id': id,
      'value': 150.5,
      'period': '2026-01-10T00:00:00',
      'situation': situation,
      'code': 'c$id',
      'nr_billet': 'nr$id',
      'founds': <Map<String, dynamic>>[],
      'name': 'Boleto $id',
      'is_duplicate': duplicate,
      'notification_parameter': 'np$id',
    };

void main() {
  late PageHarness harness;
  late RecordingNavigatorObserver observer;

  setUp(() async {
    harness = await installPageHarness();
    observer = RecordingNavigatorObserver();
  });

  testWidgets('lista os boletos separando segundas vias', (tester) async {
    harness.http.on('GET', '/billet/R1/101', body: {
      'data': [_billet('1'), _billet('2', duplicate: true)],
      'meta': {'totalItems': 2},
    });

    await pumpPage(tester, const BilletsPage(), observer: observer);

    expect(find.byType(BilletsCardWidget), findsNWidgets(2));
    expect(find.text('income_control_billets_2_via'), findsOneWidget);
    expect(find.text('income_control_billets_outros'), findsOneWidget);
    expect(harness.http.requests.single.url.path, '/billet/R1/101');
  });

  testWidgets('tocar em um boleto busca o pdf e abre os detalhes', (tester) async {
    harness.http.on('GET', '/billet/R1/101', body: {
      'data': [_billet('1')],
      'meta': {'totalItems': 1},
    });
    harness.http.on('GET', '/billet/nr1', body: {'data': 'cGRm', 'name': 'b.pdf'});

    await pumpPage(tester, const BilletsPage(), observer: observer);
    await tester.tap(find.byType(BilletsCardWidget));
    await tester.pumpAndSettle();

    expect(observer.pushedNames.last, ApplicationRoute.billetsInfo);
    expect(findRoute(ApplicationRoute.billetsInfo), findsOneWidget);
    final bloc = harness.resolve<BilletsController>().bloc;
    expect(bloc.state, isA<BilletsShowInfoState>());
    expect(harness.http.requests.map((r) => r.url.path), contains('/billet/nr1'));
  });

  testWidgets('sem boletos mostra a mensagem de vazio', (tester) async {
    harness.http.on('GET', '/billet/R1/101', body: {'data': [], 'meta': {'totalItems': 0}});

    await pumpPage(tester, const BilletsPage());

    expect(find.text('billets_empty'), findsOneWidget);
  });

  testWidgets('erro na api mostra o widget de erro e permite tentar de novo', (tester) async {
    harness.http.failAll();

    await pumpPage(tester, const BilletsPage());
    expect(find.byType(ErrorHandlingWidget), findsOneWidget);

    harness.http.on('GET', '/billet/R1/101', body: {
      'data': [_billet('9')],
      'meta': {'totalItems': 1},
    });
    await tester.tap(find.text('error_handling_widget_button_reTry').first);
    await tester.pumpAndSettle();

    expect(find.byType(BilletsCardWidget), findsOneWidget);
  });

  testWidgets('estado de loading mostra o indicador', (tester) async {
    await pumpPage(tester, const BilletsPage(), settle: false);
    final bloc = harness.resolve<BilletsController>().bloc as BilletsBloc;

    await emitState(tester, bloc, const BilletsLoadingState(), settle: false);

    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });

  testWidgets('contexto de notificação abre o boleto automaticamente', (tester) async {
    harness.http.on('GET', '/billet/R1/101', body: {
      'data': [_billet('1'), _billet('2')],
      'meta': {'totalItems': 2},
    });
    harness.http.on('GET', '/billet/nr2', body: {'data': 'cGRm', 'name': 'b.pdf'});

    await pumpPage(
      tester,
      const BilletsPage(),
      observer: observer,
      arguments: BilletsPageArgs(billetsNotificationContext: 'np2'),
    );

    expect(observer.pushedNames, contains(ApplicationRoute.billetsInfo));
    expect(harness.http.requests.map((r) => r.url.path), contains('/billet/nr2'));
  });
}
