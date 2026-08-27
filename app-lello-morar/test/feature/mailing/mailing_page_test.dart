import 'package:essentials/essentials.dart' hide isNull, isNotNull, Image;
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/feature/mailing/domain/entity/mailing.dart';
import 'package:morar/feature/mailing/presentation/bloc/mailing_bloc.dart';
import 'package:morar/feature/mailing/presentation/bloc/mailing_state.dart';
import 'package:morar/feature/mailing/presentation/controllers/mailing_controller.dart';
import 'package:morar/feature/mailing/presentation/page/mailing_page.dart';
import 'package:morar/feature/mailing/presentation/widgets/mailing_bottom_sheet.dart';
import 'package:morar/feature/mailing/presentation/widgets/mailing_card_widget.dart';

import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';

Map<String, dynamic> _mailing(
  String id, {
  String status = 'PENDENTE',
  String? photo,
  String? addressee = 'Maria',
  bool withPickUp = false,
}) =>
    {
      'id': id,
      'arrival_date': '2026-02-10T14:30:00',
      'pick_up_date': withPickUp ? '2026-02-11T09:15:00' : null,
      'addressee': addressee,
      'category': 'Caixa',
      'size': 'M',
      'status': status,
      'pick_up_resident': withPickUp ? 'João' : null,
      'notification_parameter': 'np$id',
      'photo': photo,
      'tracking_code': 'BR$id',
      'description': 'desc $id',
      'observation': null,
    };

// Corrigido: o cabeçalho do card usa Expanded/Flexible, então as chaves de
// tradução (mais longas que os textos reais) cabem em 400px sem overflow.
const _surface = Size(400, 1200);

void main() {
  late PageHarness harness;

  setUp(() async {
    harness = await installPageHarness();
  });

  void mockList(List<Map<String, dynamic>> items, {int total = 0}) {
    harness.http.on('GET', '/concierge/mailing/*', body: {
      'data': items,
      'meta': {'totalItems': total == 0 ? items.length : total},
    });
  }

  testWidgets('lista as correspondências com o cabeçalho da unidade',
      (tester) async {
    mockList([_mailing('1'), _mailing('2', status: 'RETIRADA')]);

    await pumpPage(tester, const MailingPage(), surface: _surface);

    expect(find.byType(MailingCardWidget), findsNWidgets(2));
    expect(find.text('mailing_available'), findsOneWidget);
    expect(find.text('mailing_withdrawn'), findsOneWidget);
    expect(find.textContaining('mailing_all_records'), findsNothing);
  });

  testWidgets('mostra o botão de ver todos quando há mais registros',
      (tester) async {
    mockList([_mailing('1')], total: 5);

    await pumpPage(tester, const MailingPage(), surface: _surface);
    expect(find.textContaining('mailing_all_records'), findsOneWidget);

    mockList(List.generate(5, (i) => _mailing('$i')));
    await tester.tap(find.textContaining('mailing_all_records'));
    await tester.pumpAndSettle();

    expect(find.byType(MailingCardWidget), findsNWidgets(5));
    expect(harness.http.requests.last.url.queryParameters['showAll'], 'true');
  });

  testWidgets('sem correspondências mostra a mensagem de vazio',
      (tester) async {
    mockList([]);

    await pumpPage(tester, const MailingPage(), surface: _surface);

    expect(find.text('resident_mail_empty'), findsOneWidget);
  });

  testWidgets('erro mostra o widget de erro e permite tentar de novo',
      (tester) async {
    harness.http.failAll();

    await pumpPage(tester, const MailingPage(), surface: _surface);
    expect(find.byType(ErrorHandlingWidget), findsOneWidget);

    mockList([_mailing('9')]);
    await tester.tap(find.text('error_handling_widget_button_reTry').first);
    await tester.pumpAndSettle();

    expect(find.byType(MailingCardWidget), findsOneWidget);
  });

  testWidgets('estado de loading mostra o indicador', (tester) async {
    await pumpPage(tester, const MailingPage(), settle: false, surface: _surface);
    final bloc = harness.resolve<MailingController>().bloc as MailingBloc;

    await emitState(tester, bloc, MailingLoadingState(), settle: false);

    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });

  testWidgets('contexto de notificação destaca a correspondência',
      (tester) async {
    mockList([_mailing('1'), _mailing('2')]);

    await pumpPage(
      tester,
      const MailingPage(),
      surface: _surface,
      arguments: MailingPageArgs(mailingNotificationContext: 'np2'),
    );

    final cards = tester
        .widgetList<MailingCardWidget>(find.byType(MailingCardWidget))
        .toList();
    expect(cards[0].model.highlight, isFalse);
    expect(cards[1].model.highlight, isTrue);
  });

  testWidgets('tocar em uma correspondência abre o bottom sheet com detalhes',
      (tester) async {
    mockList([_mailing('1', withPickUp: true, status: 'RETIRADA')]);

    await pumpPage(tester, const MailingPage(), surface: _surface);
    await tester.tap(find.byType(MailingCardWidget));
    await tester.pumpAndSettle();

    expect(find.byType(MailingBottomSheet), findsOneWidget);
    expect(find.text('BR1'), findsOneWidget);
    expect(find.text('desc 1'), findsOneWidget);
    expect(find.text('mailing_withdraw_by'), findsOneWidget);
    expect(find.text('João'), findsOneWidget);
    expect(find.text('mailing_without_attachment'), findsWidgets);

    // A seta fecha o bottom sheet.
    await tester.tap(find.byIcon(Icons.keyboard_arrow_down_outlined));
    await tester.pumpAndSettle();
    expect(find.byType(MailingBottomSheet), findsNothing);
  });

  testWidgets('bottom sheet com foto busca a imagem e abre o zoom',
      (tester) async {
    mockList([_mailing('1', photo: 'hash1')]);
    harness.http.on(
      'GET',
      '/concierge/mailing/photo/hash1',
      body: 'nao-e-uma-imagem',
      headers: const {'content-type': 'image/png'},
    );

    await pumpPage(tester, const MailingPage(), surface: _surface);
    expect(find.byIcon(Icons.photo_outlined), findsOneWidget);

    await tester.tap(find.byType(MailingCardWidget));
    await tester.pumpAndSettle();

    final controller = harness.resolve<MailingController>();
    expect(controller.picture, isNotNull);
    // Bytes inválidos caem no errorBuilder (ícone), que ainda abre o zoom.
    expect(find.byType(Image), findsWidgets);
    await tester.tap(find.byType(Image).first);
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsOneWidget);
    expect(find.byIcon(Icons.close), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsNothing);
  });

  testWidgets('card e cores refletem o status', (tester) async {
    final theme = LelloTheme.light;
    final pendente = Mailing(
      status: 'PENDENTE',
      arrivalDate: DateTime(2026, 2, 10, 14, 30),
      category: 'Caixa',
      size: 'M',
      photo: 'h',
    );
    final outro = Mailing(
      status: 'OUTRO',
      arrivalDate: DateTime(2026, 2, 10, 14, 30),
      category: 'Envelope',
      size: 'P',
    );

    await pumpApp(
      tester,
      Column(children: [
        MailingCardWidget(model: pendente),
        MailingCardWidget(model: outro),
      ]),
      localized: true,
      surface: const Size(400, 700),
    );

    final card = tester
        .widget<MailingCardWidget>(find.byType(MailingCardWidget).first);
    expect(card.color('PENDENTE', theme), LelloTheme.palleteOf(theme).warning());
    expect(card.color('RETIRADA', theme), LelloTheme.palleteOf(theme).success());
    expect(card.color('X', theme), LelloTheme.palleteOf(theme).customColor());
    expect(color('RETIRADA', theme), LelloTheme.palleteOf(theme).success());
    expect(color('', theme), LelloTheme.palleteOf(theme).customColor());
    expect(find.text('mailing_receiver: not_informed'), findsNWidgets(2));
    expect(find.byIcon(Icons.photo_outlined), findsOneWidget);
    expect(find.text('mailing_without_attachment'), findsOneWidget);
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/mailing_cards.png'),
    );
  });
}
