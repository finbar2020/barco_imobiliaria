import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/feature/billets/domain/entity/billet.dart';
import 'package:morar/feature/billets/domain/entity/billet_status_enum.dart';
import 'package:morar/feature/billets/presentation/bloc/billets_state.dart';
import 'package:morar/feature/billets/presentation/controllers/billets_controller.dart';
import 'package:morar/feature/billets/presentation/pages/billets_info_page.dart';
import 'package:morar/feature/billets/presentation/widgets/billet_info_intro_widget.dart';
import 'package:morar/feature/billets/presentation/widgets/billet_pending_details_widget.dart';
import 'package:morar/feature/billets/presentation/widgets/billets_card_widget.dart';

import '../../helpers/fake_url_launcher.dart';
import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';

Billet _billet({
  BilletStatusEnum situation = BilletStatusEnum.pendente,
  DateTime? period,
  String? code = '123456',
}) =>
    Billet(
      id: '1',
      value: 150.5,
      period: period ?? DateTime.now().add(const Duration(days: 5)),
      situation: situation,
      nrBillet: 'nr1',
      code: code,
      name: 'Boleto 1',
      isDuplicate: false,
    );

void main() {
  late PageHarness harness;
  late FakeUrlLauncherPlatform launcher;
  late BilletsController controller;
  final clipboard = <dynamic>[];

  setUp(() async {
    harness = await installPageHarness();
    launcher = installFakeUrlLauncher();
    controller = harness.resolve<BilletsController>();
    // Clipboard.setData precisa de resposta do canal para completar.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
      if (call.method == 'Clipboard.setData') clipboard.add(call.arguments);
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
  });

  Future<void> pumpInfo(WidgetTester tester, BilletsState state) async {
    await pumpPage(tester, const BilletsInfoPage(), arguments: controller);
    await emitState(tester, controller.bloc, state);
  }

  testWidgets('boleto pendente com pdf mostra dados e botões', (tester) async {
    await pumpInfo(
      tester,
      BilletsShowInfoState(billet: _billet(), pdf: 'cGRm', fileName: 'b.pdf'),
    );

    expect(find.byType(BilletInfoIntroWidget), findsOneWidget);
    expect(find.text('Boleto 1'), findsOneWidget);
    expect(find.text('nr1'), findsOneWidget);
    expect(find.text('income_billet_detail_situation_open'), findsOneWidget);
    expect(find.byType(BilletPendingDetailsWidget), findsOneWidget);
    expect(find.text('income_billet_detail_open'), findsOneWidget);
    expect(find.text('billet_copy_barcode'), findsOneWidget);
    await expectLater(
      find.byType(BilletsInfoPage),
      matchesGoldenFile('goldens/billets_info_page.png'),
    );
  });

  testWidgets('copiar código de barras mostra o aviso e marca a avaliação',
      (tester) async {
    await pumpInfo(
      tester,
      BilletsShowInfoState(billet: _billet(), pdf: 'cGRm', fileName: 'b.pdf'),
    );

    await tester.tap(find.text('billet_copy_barcode'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('billet_copied_barcode'), findsOneWidget);
    expect(clipboard.last['text'], '123456');
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    // Voltar pela app bar dispara a avaliação do app e recarrega os boletos.
    harness.http.on('GET', '/billet/R1/101', body: {'data': [], 'meta': {'totalItems': 0}});
    await tester.tap(find.byType(IconButton).first);
    await tester.pumpAndSettle();
    expect(harness.http.requests.map((r) => r.url.path), contains('/billet/R1/101'));
    tester.takeException();
  });

  testWidgets('boleto baixado sem pdf oferece o whatsapp', (tester) async {
    await pumpInfo(
      tester,
      BilletsShowInfoState(
        billet: _billet(situation: BilletStatusEnum.baixado),
        pdf: null,
        fileName: null,
      ),
    );

    expect(find.text('billet_contact_us'), findsOneWidget);
    expect(find.text('billet_copy_barcode'), findsNothing);

    await tester.tap(find.text('whats_app_button_title'));
    await tester.pumpAndSettle();
    expect(launcher.launched, isNotEmpty);
  });

  testWidgets('boleto cancelado não mostra a seção de pagamento',
      (tester) async {
    await pumpInfo(
      tester,
      BilletsShowInfoState(
        billet: _billet(situation: BilletStatusEnum.cancelado),
        pdf: 'cGRm',
        fileName: 'b.pdf',
      ),
    );

    expect(find.byType(BilletPendingDetailsWidget), findsNothing);
    expect(find.text('income_billet_detail_situation_canceled'), findsOneWidget);
  });

  testWidgets('loading e erro', (tester) async {
    await pumpPage(tester, const BilletsInfoPage(), arguments: controller);
    await emitState(tester, controller.bloc, const BilletsLoadingState(),
        settle: false);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsWidgets);

    await emitState(
      tester,
      controller.bloc,
      const BilletsFailureState(errorMessageKey: 'billets_error'),
    );
    expect(find.text('billets_error'), findsOneWidget);
  });

  testWidgets('cards de boleto por situação', (tester) async {
    final theme = LelloTheme.light;
    final vencido = _billet(period: DateTime.now().subtract(const Duration(days: 3)));
    final aVencer = _billet();
    final baixado = _billet(situation: BilletStatusEnum.baixado);
    final cancelado = _billet(situation: BilletStatusEnum.cancelado);
    final acordo = _billet(situation: BilletStatusEnum.acordo);
    final outros = _billet(situation: BilletStatusEnum.outros);
    var taps = 0;

    await pumpApp(
      tester,
      Column(
        children: [
          for (final b in [vencido, aVencer, baixado, cancelado, acordo, outros])
            BilletsCardWidget(model: b, onTap: () => taps++),
        ],
      ),
      localized: true,
      surface: const Size(400, 1400),
    );

    expect(find.textContaining('Vencido em'), findsOneWidget);
    expect(find.textContaining('Vence em'), findsOneWidget);
    expect(find.text('income_billet_detail_situation_paid_out'), findsOneWidget);
    expect(find.text('income_billet_detail_situation_agreement'), findsOneWidget);
    expect(find.text('income_billet_detail_situation_other'), findsOneWidget);
    expect(vencido.colorDueDate, Colors.red);
    expect(aVencer.colorDueDate, Colors.black);
    expect(cancelado.color(theme), theme.primaryColor);
    expect(baixado.color(theme), LelloTheme.palleteOf(theme).success());
    expect(Billet().vencido, isNull);
    expect(Billet().dueDate, '');
    expect(Billet().mes, ' - ');
    expect(Billet().vencimentoFullDate, ' - ');

    await tester.tap(find.byType(BilletsCardWidget).first);
    expect(taps, 1);
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/billets_cards.png'),
    );
  });
}
