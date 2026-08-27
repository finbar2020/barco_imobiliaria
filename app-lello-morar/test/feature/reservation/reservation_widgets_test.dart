import 'dart:async';
import 'dart:io';

import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/widgets/loading_widget.dart';
import 'package:morar/feature/documents/domain/entity/document_file.dart';
import 'package:morar/feature/reservation/domain/entity/reservatio_chargin.dart';
import 'package:morar/feature/reservation/domain/entity/reservation_registration.dart';
import 'package:morar/feature/reservation/domain/entity/reservation_rule.dart';
import 'package:morar/feature/reservation/domain/entity/reservation_scheduled.dart';
import 'package:morar/feature/reservation/domain/entity/space.dart';
import 'package:morar/feature/reservation/domain/entity/space_available_hours.dart';
import 'package:morar/feature/reservation/domain/entity/space_calendar_response.dart';
import 'package:morar/feature/reservation/domain/entity/space_type.dart';
import 'package:morar/feature/reservation/presentation/bloc/reservation_bloc.dart';
import 'package:morar/feature/reservation/presentation/bloc/reservation_event.dart';
import 'package:morar/feature/reservation/presentation/bloc/reservation_state.dart';
import 'package:morar/feature/reservation/presentation/page/reservation_page.dart';
import 'package:morar/feature/reservation/presentation/widget/reservation_bottom_sheet_widget.dart';
import 'package:morar/feature/reservation/presentation/widget/reservation_card_widget.dart' as card;
import 'package:morar/feature/reservation/presentation/widget/reservation_dialog.dart';
import 'package:morar/feature/reservation/presentation/widget/reservation_moves_dialog.dart';
import 'package:morar/feature/reservation/presentation/widget/reservation_reserve_dialog.dart';
import 'package:morar/feature/reservation/presentation/widget/reservation_schedule_card_widget.dart' as schedule;
import 'package:morar/feature/reservation/presentation/widget/reservation_success_dialog.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/page_harness.dart';
import 'reservation_page_helpers.dart';

Space _space({
  String id = 'sp1',
  String name = 'Salao',
  String typeId = 'A',
  bool chargeable = false,
  double? price,
  double? percentageTax,
  String? paymentMethod,
  String? pictureUrl,
  String? term = 'Termo',
  String fileUrl = '',
  int? capacity = 10,
}) =>
    Space()
      ..id = id
      ..name = name
      ..pictureUrl = pictureUrl
      ..fileUrl = fileUrl
      ..capacity = capacity
      ..term = term
      ..type = (SpaceType()
        ..id = typeId
        ..description = 'Area')
      ..reservationRule = (ReservationRule()
        ..chargeable = chargeable
        ..price = price
        ..percentageTax = percentageTax
        ..paymentMethod = paymentMethod
        ..cancellationLimit = 2
        ..blockedForDefaulters = false
        ..blockedForSettlers = false);

ReservationScheduled _reservation({
  int id = 1,
  String areaId = 'sp1',
  double? value,
  ReservationCharging? charging,
  String? receipt,
  String? billetCode,
  String? flagChargingStatus,
  DateTime? billetPeriod,
}) {
  final start = DateTime(daysFromNow(2).year, daysFromNow(2).month, daysFromNow(2).day, 10);
  return ReservationScheduled()
    ..id = id
    ..areaId = areaId
    ..area = 'Salao'
    ..idStatus = 83
    ..reservationType = 'A'
    ..reservationValue = value
    ..flagChargingForm = charging
    ..charginFormDescription = charging
    ..receipt = receipt
    ..billetCode = billetCode
    ..flagChargingStatus = flagChargingStatus
    ..billetPeriod = billetPeriod
    ..startReservationDate = apiDate(start)
    ..endReservationDate = apiDate(start.add(const Duration(hours: 2)));
}

/// Bloc falso só para controlar o `downloadBillet` (observar o loading).
class _PdfBloc extends Fake implements ReservationBloc {
  /// Recrie dentro de `tester.runAsync` quando o fluxo depender de IO real:
  /// os callbacks de um Future rodam na zona em que ele foi criado.
  Completer<DocumentFile?> completer = Completer<DocumentFile?>();
  final billets = <String>[];

  @override
  List<Space> listSpaces = [_space(chargeable: true, price: 50, paymentMethod: 'billet')];

  @override
  Future<DocumentFile?> downloadBillet({required String billetNumber}) {
    billets.add(billetNumber);
    return completer.future;
  }
}

/// Botão que abre [builder] com `showDialog` (para testar `Navigator.pop`).
class _DialogLauncher extends StatelessWidget {
  const _DialogLauncher(this.builder);
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: ElevatedButton(
            key: const Key('open'),
            onPressed: () => showDialog(context: context, builder: builder),
            child: const Text('abrir'),
          ),
        ),
      );
}

void main() {
  late PageHarness harness;

  setUp(() async {
    harness = await installPageHarness();
  });

  Future<void> openDialog(WidgetTester tester, WidgetBuilder builder, {Map<String, String> locOverrides = const {}}) async {
    await pumpPage(tester, _DialogLauncher(builder), surface: const Size(600, 1000), locOverrides: locOverrides);
    await tester.tap(find.byKey(const Key('open')));
    await tester.pumpAndSettle();
  }

  group('ReservationCardWidget', () {
    Future<void> pumpCard(WidgetTester tester, Space space, {bool isChangeArea = false, VoidCallback? onTap}) =>
        pumpPage(
          tester,
          Scaffold(
            body: card.ReservationCardWidget(model: space, isChangeArea: isChangeArea, onTap: onTap ?? () {}),
          ),
          surface: const Size(600, 400),
        );

    testWidgets('área gratuita mostra nome, "free" e capacidade', (tester) async {
      var taps = 0;
      await pumpCard(tester, _space(), onTap: () => taps++);

      expect(find.text('Salao'), findsOneWidget);
      expect(find.text('free'), findsOneWidget);
      expect(find.text('maximum_capacity'), findsOneWidget);
      await tester.tap(find.byType(card.ReservationCardWidget));
      expect(taps, 1);
    });

    testWidgets('área de mudança mostra o ícone e o título de mudança', (tester) async {
      await pumpCard(tester, _space(typeId: 'M'), isChangeArea: true);

      expect(find.text('reserves_moving'), findsOneWidget);
      expect(find.text('free'), findsNothing);
    });

    testWidgets('área paga por boleto com preço mostra o valor', (tester) async {
      await pumpCard(tester, _space(chargeable: true, price: 80, paymentMethod: 'billet'));

      expect(find.textContaining('80,00'), findsOneWidget);
      expect(find.text('space_registration_single_bank_slip'), findsOneWidget);
    });

    testWidgets('área paga por boleto sem preço mostra o percentual', (tester) async {
      await pumpCard(tester, _space(chargeable: true, percentageTax: 7.5, paymentMethod: 'billet'));

      expect(find.text('7.5% of_condominium_quota'), findsOneWidget);
    });

    testWidgets('área paga por cota sem preço mostra o percentual', (tester) async {
      await pumpCard(tester, _space(chargeable: true, price: 0, percentageTax: 3, paymentMethod: 'quota'));

      expect(find.text('3.0% of_condominium_quota'), findsOneWidget);
      expect(find.text('space_registration_fee_billet'), findsOneWidget);
    });

    testWidgets('área paga por cota com preço mostra o valor', (tester) async {
      await pumpCard(tester, _space(chargeable: true, price: 42, paymentMethod: 'quota'));

      expect(find.textContaining('42,00'), findsOneWidget);
    });

    testWidgets('área com fiador é tratada como paga', (tester) async {
      await pumpCard(tester, _space(chargeable: false, paymentMethod: 'guarantor'));

      expect(find.text('space_registration_guarantor'), findsOneWidget);
      expect(find.text('free'), findsNothing);
    });

    testWidgets('com foto usa CachedNetworkImage', (tester) async {
      await pumpPage(
        tester,
        Scaffold(body: card.ReservationCardWidget(model: _space(pictureUrl: 'http://x/y.png'), onTap: () {})),
        surface: const Size(600, 400),
        settle: false,
      );
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(CachedNetworkImage), findsOneWidget);
    });
  });

  group('ReservationSuccessDialog', () {
    testWidgets('reserva gratuita: ok fecha o diálogo', (tester) async {
      final bloc = _PdfBloc();
      await openDialog(
        tester,
        (_) => ReservationSuccessDialog(
          bloc: bloc,
          reserva: _reservation(),
          space: _space(),
          condominium: testCondominium(),
          unity: testUnity(),
        ),
      );

      expect(find.text('space_reservation_reservation_success'), findsOneWidget);
      expect(find.text('Edifício Lello - 101'), findsOneWidget);
      await tester.tap(find.text('ok'));
      await tester.pumpAndSettle();
      expect(find.byType(ReservationSuccessDialog), findsNothing);
    });

    testWidgets('reserva paga com boleto: abrir boleto, copiar código e pagar depois', (tester) async {
      final calls = mockPlatformChannel();
      final bloc = _PdfBloc();
      await openDialog(
        tester,
        (_) => ReservationSuccessDialog(
          bloc: bloc,
          reserva: _reservation(receipt: 'nr9', billetCode: '9999', billetPeriod: daysFromNow(3)),
          space: _space(chargeable: true, price: 50, paymentMethod: 'billet'),
          condominium: testCondominium(),
          unity: testUnity(),
        ),
      );

      expect(find.textContaining('income_billet_detail_expiration'), findsOneWidget);

      // Abrir boleto: mostra loading enquanto baixa; sem documento não navega.
      await tester.tap(find.text('income_billet_detail_open'));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(bloc.billets, ['nr9']);
      bloc.completer.complete(null);
      await tester.pumpAndSettle();
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(ReservationSuccessDialog), findsOneWidget);

      // Copiar código de barras.
      await tester.tap(find.text('billet_copy_barcode'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(calls.map((c) => c.method), contains('Clipboard.setData'));
      expect(find.text('billet_copied_barcode'), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));

      await tester.tap(find.text('pay_later'));
      await tester.pumpAndSettle();
      expect(find.byType(ReservationSuccessDialog), findsNothing);
    });

    testWidgets('reserva paga sem boleto na resposta mostra a forma de pagamento', (tester) async {
      await openDialog(
        tester,
        (_) => ReservationSuccessDialog(
          bloc: _PdfBloc(),
          reserva: _reservation(),
          space: _space(chargeable: true, price: 50, paymentMethod: 'quota'),
          condominium: null,
          unity: null,
        ),
      );

      expect(find.text('chat_error_title!'), findsOneWidget);
      expect(find.text('space_registration_fee_billet'), findsOneWidget);
      expect(find.text(' - '), findsOneWidget);
      await tester.tap(find.text('ok'));
      await tester.pumpAndSettle();
      expect(find.byType(ReservationSuccessDialog), findsNothing);
    });

    testWidgets('reserva com fiador usa o layout gratuito', (tester) async {
      await openDialog(
        tester,
        (_) => ReservationSuccessDialog(
          bloc: _PdfBloc(),
          reserva: _reservation(),
          space: _space(chargeable: true, paymentMethod: 'guarantor'),
          condominium: testCondominium(),
          unity: testUnity(),
        ),
      );

      expect(find.text('ok'), findsOneWidget);
      expect(find.text('pay_later'), findsNothing);
    });
  });

  group('ReservationSchudeleCardWidget', () {
    Future<void> pumpCard(WidgetTester tester, ReservationScheduled model, ReservationBloc bloc, {VoidCallback? cancel}) =>
        pumpPage(
          tester,
          Scaffold(
            body: schedule.ReservationSchudeleCardWidget(model: model, bloc: bloc, cancelReservation: cancel ?? () {}),
          ),
          surface: const Size(600, 500),
        );

    testWidgets('botão pagar mostra loading e some sem documento', (tester) async {
      final bloc = _PdfBloc();
      await pumpCard(
        tester,
        _reservation(value: 50, charging: ReservationCharging.billet, receipt: 'nr1', billetCode: '1', flagChargingStatus: 'OPEN', billetPeriod: daysFromNow(3)),
        bloc,
      );

      expect(find.textContaining('refund_value'), findsOneWidget);
      expect(find.text('space_reservation_payment_billet'), findsOneWidget);
      await tester.tap(find.text('pay'));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(bloc.billets, ['nr1']);
      bloc.completer.complete(null);
      await tester.pumpAndSettle();
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('botão cancelar chama o callback', (tester) async {
      var cancels = 0;
      await pumpCard(tester, _reservation(), _PdfBloc(), cancel: () => cancels++);

      await tester.tap(find.text('cancel'));
      expect(cancels, 1);
      expect(find.text('pay'), findsNothing);
    });

    testWidgets('reserva destacada usa a cor de highlight', (tester) async {
      final model = _reservation()..highlight = true;
      await pumpCard(tester, model, _PdfBloc());

      final container = tester.widget<Container>(
        find.descendant(of: find.byType(Card), matching: find.byType(Container)).first,
      );
      expect(container.color, isNotNull);
    });

    testWidgets('PriceBuilder sem valor renderiza vazio; com cota e fiador mostra o texto', (tester) async {
      await pumpPage(
        tester,
        Scaffold(
          body: Column(children: [
            schedule.PriceBuilder(rule: ReservationRule(), reservation: _reservation()),
            schedule.PriceBuilder(rule: ReservationRule(), reservation: _reservation(value: 10, charging: ReservationCharging.quota)),
            schedule.PriceBuilder(rule: ReservationRule(), reservation: _reservation(value: 10, charging: ReservationCharging.guarantor)),
            schedule.PriceBuilder(rule: ReservationRule(), reservation: _reservation(value: 10, charging: ReservationCharging.gratis)),
          ]),
        ),
      );

      expect(find.textContaining('refund_value'), findsNWidgets(3));
      expect(find.text('space_reservation_payment_quota'), findsOneWidget);
      expect(find.text('space_reservation_payment_guarantor'), findsOneWidget);
    });
  });

  group('ReservationDialog e ReservationReserveDialog', () {
    late ReservationBloc bloc;
    late SpaceCalendarResponse calendar;

    setUp(() {
      stubReservationApi(harness.http);
      calendar = SpaceCalendarResponse()
        ..lockedDays = []
        ..alreadyReservatedDays = []
        ..freeToReserveDays = []
        ..raffledDays = [];
    });

    /// O bloc precisa nascer dentro do `testWidgets` (zona fake async): criado
    /// no `setUp`, os handlers rodam na zona real e os awaits nunca completam.
    void initBloc() {
      bloc = harness.resolve<ReservationBloc>();
      // `_mapPostReservation` lê `calendarResponse!`/`hoursResponse!` do bloc.
      bloc.calendarResponse = calendar;
      bloc.hoursResponse = [];
    }

    LoadedDialogState loaded(Space space) => LoadedDialogState(
          session: testSession(),
          reservations: [],
          space: space,
          hour: SpaceAvailableHours(from: '10:00:00', until: '12:00:00'),
          calendarResponse: calendar,
          reserveDate: daysFromNow(3),
          selectedDate: daysFromNow(3),
        );

    testWidgets('estado de loading mostra o LoadingWidget no diálogo', (tester) async {
      initBloc();
      await openDialog(tester, (_) => ReservationDialog(bloc: bloc));
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      bloc.emit(LoadingDialogState(calendarResponse: calendar, selectedDate: today));
      await tester.pump();
      await tester.pump();

      expect(find.byType(LoadingWidget), findsOneWidget);
    });

    testWidgets('mensagem de falha: chave sem tradução devolve a própria chave', (tester) async {
      initBloc();
      await openDialog(tester, (_) => ReservationDialog(bloc: bloc), locOverrides: {'xyz': '', '': ''});
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      bloc.emit(FailureDialogState(session: testSession(), reservations: [], calendarResponse: calendar, selectedDate: today, message: 'xyz'));
      await tester.pumpAndSettle();
      expect(find.text('xyz'), findsOneWidget);

      // Chave vazia cai na mensagem padrão.
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      bloc.emit(FailureDialogState(session: testSession(), reservations: [], calendarResponse: calendar, selectedDate: today, message: ''));
      await tester.pumpAndSettle();
      expect(find.text('reserve_limit_date'), findsOneWidget);

      await tester.tap(find.text('ok'));
      await tester.pumpAndSettle();
      expect(find.byType(ReservationDialog), findsNothing);
    });

    testWidgets('estado carregado escolhe o diálogo pelo tipo do espaço', (tester) async {
      initBloc();
      await openDialog(tester, (_) => ReservationDialog(bloc: bloc));
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      bloc.emit(loaded(_space(typeId: 'M')));
      await tester.pumpAndSettle();
      expect(find.byType(ReservationMovesDialog), findsOneWidget);

      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      bloc.emit(loaded(_space()));
      await tester.pumpAndSettle();
      expect(find.byType(ReservationReserveDialog), findsOneWidget);

      // Estado não tratado: diálogo vazio.
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      bloc.emit(ReservationEmptyState());
      await tester.pumpAndSettle();
      expect(find.byType(ReservationReserveDialog), findsNothing);
    });

    testWidgets('confirmar dispara PostReservationEvent com datas do horário', (tester) async {
      initBloc();
      final events = <ReservationEvent>[];
      await openDialog(tester, (_) => ReservationReserveDialog(state: loaded(_space()), bloc: bloc));
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      bloc.emit(loaded(_space()));
      await tester.pumpAndSettle();

      // Checkbox pelo texto (GestureDetector) e pelo próprio Checkbox.
      double confirmOpacity() =>
          tester.widget<Opacity>(find.ancestor(of: find.text('CONFIRM'), matching: find.byType(Opacity))).opacity;
      expect(confirmOpacity(), 0.3);
      await tester.tap(find.text('space_registration_agree_with_terms'));
      await tester.pumpAndSettle();
      expect(confirmOpacity(), 1.0);
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      expect(confirmOpacity(), 0.3);
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      expect(confirmOpacity(), 1.0);

      harness.http.on('POST', postPath('sp1'), body: postedReservationJson());
      await tester.tap(find.text('CONFIRM'));
      await tester.pumpAndSettle();

      final post = harness.http.requests.singleWhere((r) => r.method == 'POST');
      expect(post.url.path, postPath('sp1'));
      expect(events, isEmpty);
      expect(bloc.state, isA<ReservationSendSuccessState>());
    });

    testWidgets('regime interno sem arquivo mostra o aviso', (tester) async {
      initBloc();
      await openDialog(tester, (_) => ReservationReserveDialog(state: loaded(_space(fileUrl: '')), bloc: bloc));

      await tester.tap(find.text('space_registration_internal_regime_term'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('space_registration_internal_regime_term_error'), findsOneWidget);
      await tester.pump(const Duration(seconds: 6));
    });

    testWidgets('espaço com fiador mostra a forma de cobrança e o prazo', (tester) async {
      initBloc();
      await openDialog(
        tester,
        (_) => ReservationReserveDialog(state: loaded(_space(paymentMethod: 'guarantor')), bloc: bloc),
      );

      expect(find.textContaining('space_registration_guarantor', findRichText: true), findsOneWidget);
      expect(find.textContaining('space_registration_usage_term_message'), findsOneWidget);
      expect(find.text('free'), findsOneWidget);
    });

    testWidgets('diálogo de mudança confirma com o tipo do espaço', (tester) async {
      initBloc();
      harness.http.on('POST', postPath('mov'), body: postedReservationJson(areaId: 'mov', reservationType: 'M'));
      await openDialog(tester, (_) => ReservationMovesDialog(state: loaded(_space(id: 'mov', typeId: 'M')), bloc: bloc));

      await tester.tap(find.text('CONFIRM'));
      await tester.pumpAndSettle();

      final post = harness.http.requests.singleWhere((r) => r.method == 'POST');
      expect(post.url.path, postPath('mov'));
    });
  });

  group('ReservationBottomSheetWidget isolada', () {
    testWidgets('estados de diálogo e falha renderizam o corpo carregado', (tester) async {
      stubReservationApi(harness.http);
      final bloc = harness.resolve<ReservationBloc>();
      final calendar = SpaceCalendarResponse()
        ..lockedDays = [calendarDay(daysFromNow(1))]
        ..alreadyReservatedDays = [calendarDay(daysFromNow(2))]
        ..freeToReserveDays = []
        ..raffledDays = [];
      final space = _space();

      await pumpPage(
        tester,
        Scaffold(body: ReservationBottomSheetWidget(bloc: bloc, space: space)),
        surface: const Size(600, 1000),
        settle: false,
      );
      await tester.pump();

      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      bloc.emit(LoadingDialogState(calendarResponse: calendar, selectedDate: today, hours: [SpaceAvailableHours(from: '10:00:00', until: '12:00:00')]));
      await tester.pumpAndSettle();
      expect(find.text('Salao'), findsOneWidget);
      expect(find.byType(DropdownButton<SpaceAvailableHours>), findsOneWidget);

      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      bloc.emit(LoadedDialogState(
        session: testSession(),
        reservations: [],
        space: space,
        hour: SpaceAvailableHours(from: '10:00:00', until: '12:00:00'),
        calendarResponse: calendar,
        reserveDate: daysFromNow(3),
        selectedDate: daysFromNow(3),
        hours: [SpaceAvailableHours(from: '10:00:00', until: '12:00:00')],
      ));
      await tester.pumpAndSettle();
      expect(find.byType(DropdownButton<SpaceAvailableHours>), findsOneWidget);

      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      bloc.emit(FailureCalendarState(session: testSession(), reservations: []));
      await tester.pumpAndSettle();
      expect(find.text('error_unknown'), findsOneWidget);
    });

    testWidgets('erro conhecido sem código usa a mensagem padrão', (tester) async {
      stubReservationApi(harness.http);
      final bloc = harness.resolve<ReservationBloc>();
      final calendar = SpaceCalendarResponse()
        ..lockedDays = []
        ..alreadyReservatedDays = []
        ..freeToReserveDays = []
        ..raffledDays = [];

      await pumpPage(
        tester,
        Scaffold(body: ReservationBottomSheetWidget(bloc: bloc, space: _space())),
        surface: const Size(600, 1000),
        settle: false,
        locOverrides: {'xyz': '', '': ''},
      );
      await tester.pump();

      LoadedCalendarState withError(Failure error) => LoadedCalendarState(
            calendarResponse: calendar,
            session: testSession(),
            reservations: [],
            selectedDate: today,
            error: error,
          );

      // Código sem tradução devolve o próprio código.
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      bloc.emit(withError(KnownFailure('xyz', null)));
      await tester.pumpAndSettle();
      expect(find.text('xyz'), findsOneWidget);
      await tester.tap(find.text('ok'));
      await tester.pumpAndSettle();

      // Código vazio cai na mensagem padrão.
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      bloc.emit(withError(KnownFailure('', null)));
      await tester.pumpAndSettle();
      expect(find.text('reserve_limit_date'), findsOneWidget);
      await tester.tap(find.text('ok'));
      await tester.pumpAndSettle();

      // Erro desconhecido não abre alerta.
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      bloc.emit(withError(UnknownFailure('x')));
      await tester.pumpAndSettle();
      expect(find.text('chat_error_title!'), findsNothing);
    });
  });

  group('Aba de agendamentos com erro', () {
    testWidgets('tentar de novo e voltar no erro da aba de agendamentos', (tester) async {
      harness.http.failAll();
      await installReservationBloc(harness);
      await pumpReservationPage(tester, args: ReservationPageArgs(selectedTab: 1));
      expect(find.byType(ErrorHandlingWidget), findsWidgets);

      stubReservationApi(harness.http, reservations: [reservationJson()]);
      await tester.tap(find.text('error_handling_widget_button_reTry').last);
      await tester.pumpAndSettle();
      expect(find.byType(schedule.ReservationSchudeleCardWidget), findsOneWidget);

      harness.http.failAll();
      await tester.tap(find.text('cancel'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('error_handling_widget_button_back').last);
      await tester.pumpAndSettle();
      expect(find.byType(ReservationPage), findsNothing);
    });
  });

  group('Abertura do PDF (arquivo gravado e navegação para o PDFScreen)', () {
    /// O `PDFScreen` usa um visualizador nativo (pdfrx) que não roda no
    /// `flutter test`: gravamos o arquivo em um path_provider falso, deixamos
    /// o `Navigator.push` acontecer em tempo real e desmontamos a árvore
    /// antes do frame que construiria o visualizador.
    Future<void> unmountBeforePdfFrame(WidgetTester tester) async {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      await tester.pumpWidget(const SizedBox());
    }

    testWidgets('diálogo de sucesso grava o boleto e navega', (tester) async {
      final dir = installFakePathProvider();
      final bloc = _PdfBloc();
      await openDialog(
        tester,
        (_) => ReservationSuccessDialog(
          bloc: bloc,
          reserva: _reservation(receipt: 'nr9', billetCode: '9999', billetPeriod: daysFromNow(3)),
          space: _space(chargeable: true, price: 50, paymentMethod: 'billet'),
          condominium: testCondominium(),
          unity: testUnity(),
        ),
      );

      await tester.runAsync(() async {
        bloc.completer = Completer<DocumentFile?>();
        await tester.tap(find.text('income_billet_detail_open'));
        await tester.pump();
        bloc.completer.complete(DocumentFile(data: 'cGRm', name: 'boleto.pdf'));
        await unmountBeforePdfFrame(tester);
      });

      expect(File('${dir.path}/boleto.pdf').readAsStringSync(), 'pdf');
    });

    testWidgets('card de agendamento grava o boleto e navega', (tester) async {
      final dir = installFakePathProvider();
      final bloc = _PdfBloc();
      await pumpPage(
        tester,
        Scaffold(
          body: schedule.ReservationSchudeleCardWidget(
            model: _reservation(value: 50, charging: ReservationCharging.billet, receipt: 'nr1', billetCode: '1', flagChargingStatus: 'OPEN', billetPeriod: daysFromNow(3)),
            bloc: bloc,
            cancelReservation: () {},
          ),
        ),
        surface: const Size(600, 500),
      );

      await tester.runAsync(() async {
        bloc.completer = Completer<DocumentFile?>();
        await tester.tap(find.text('pay'));
        await tester.pump();
        bloc.completer.complete(DocumentFile(data: 'cGRm'));
        await unmountBeforePdfFrame(tester);
      });

      expect(File('${dir.path}/billet_file').readAsStringSync(), 'pdf');
    });

    testWidgets('ReservationDialog com boleto no estado grava o arquivo e navega', (tester) async {
      final dir = installFakePathProvider();
      stubReservationApi(harness.http);
      final bloc = harness.resolve<ReservationBloc>();
      final calendar = SpaceCalendarResponse()
        ..lockedDays = []
        ..alreadyReservatedDays = []
        ..freeToReserveDays = []
        ..raffledDays = [];
      await openDialog(tester, (_) => ReservationDialog(bloc: bloc));

      await tester.runAsync(() async {
        // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
        bloc.emit(LoadedDialogState(
          session: testSession(),
          reservations: [],
          space: _space(),
          hour: SpaceAvailableHours(from: '10:00:00', until: '12:00:00'),
          calendarResponse: calendar,
          reserveDate: daysFromNow(3),
          selectedDate: daysFromNow(3),
          isBillet: true,
          billetData: 'cGRm',
          billetName: 'reserva.pdf',
        ));
        await tester.pump();
        await tester.pump();
        expect(find.byType(ReservationReserveDialog), findsOneWidget);
        // O `viewFile` nasce no build (zona fake): o IO real completa em tempo
        // real e a continuação fica na fila de microtasks fake; `idle()`
        // esvazia a fila sem desenhar um frame.
        await Future<void>.delayed(const Duration(milliseconds: 300));
        await tester.binding.idle();
        await Future<void>.delayed(const Duration(milliseconds: 300));
        await tester.binding.idle();
        await unmountBeforePdfFrame(tester);
      });

      expect(File('${dir.path}/reserva.pdf').readAsStringSync(), 'pdf');
    });
  });

  group('ReservationBloc.downloadBillet', () {
    testWidgets('grava o pdf no diretório de documentos', (tester) async {
      final dir = installFakePathProvider();
      stubReservationApi(harness.http);
      harness.http.on('GET', '/billet/nr1', body: {'data': 'cGRm', 'name': 'b.pdf'});
      final bloc = harness.resolve<ReservationBloc>();

      await tester.runAsync(() async {
        final doc = await bloc.downloadBillet(billetNumber: 'nr1');
        expect(doc!.name, 'b.pdf');
        expect(File('${dir.path}/b.pdf').readAsStringSync(), 'pdf');
      });
    });
  });

  group('Eventos', () {
    test('props dos eventos incluem seus campos', () {
      final space = _space();
      final hour = SpaceAvailableHours(from: '10:00:00', until: '12:00:00');
      final date = DateTime(2026, 1, 2);
      expect(const GetSpacesEvent().props, isEmpty);
      expect(const GetAllReservationEvent().props, isEmpty);
      expect(GetCalendarEvent(spaceId: 's', startDate: date, endDate: date).props, [
        's',
        date,
        date
      ]);
      expect(GetCalendarMonthEvent(spaceId: 's', startDate: date, endDate: date).props, ['s', date, date]);
      expect(GetHoursEvent(condominiumId: 'c', spaceId: 's', date: date).props, ['c', 's', date]);
      expect(PostFreeSpaceEvent(space: space, reserveDate: date, hour: hour).props, [space, date, hour]);
      final model = ReservationRegistration(spaceId: 's');
      expect(PostReservationEvent(model: model, reserveDate: date, hour: hour).props, [model, date, hour]);
      expect(ClearHoursEvent(date: date).props, [date]);
      final state = LoadedCalendarState(
        calendarResponse: SpaceCalendarResponse(),
        session: testSession(),
        reservations: [],
        selectedDate: date,
      );
      expect(ClearErrorEvent(state: state).props, [state]);
    });
  });
}
