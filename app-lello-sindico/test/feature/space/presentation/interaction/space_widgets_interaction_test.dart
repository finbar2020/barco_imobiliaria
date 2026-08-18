import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/space/domain/entity/space.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_change_rules.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_summary_list_filter.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_type.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_change_rules/reservation_change_rules_state.dart';
import 'package:lello/feature/space/reservation/presentation/page/reservation_change_reserved_page.dart';
import 'package:lello/feature/space/reservation/presentation/widget/reservation_list_item.dart';
import 'package:lello/feature/space/reservation/presentation/widget/reservation_summary_filter_widget.dart';
import 'package:lello/feature/space/reservation/presentation/widget/reservation_week_selector_widget.dart';
import 'package:lello/feature/space/reservation/presentation/widget/reservation_weekend_selector_widget.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('expande a reserva e mostra a área', (tester) async {
    await pumpApp(
      tester,
      ReservationListItem(
        headerType: ReservationItemHeader.SHOW_TYPE,
        reservation: Reservation()
          ..type = ReservationType.maintenance
          ..from = DateTime(2026, 8, 14, 10)
          ..space = (Space()..name = 'Salão de Festas'),
      ),
      localized: true,
      locOverrides: const {
        'space_reservation_maintenance': 'Manutenção',
        'space_reservation_area': 'Área',
        'space_reservation_date': 'Data',
        'space_reservation_time': 'Horário',
        'cancel': 'Cancelar',
      },
    );

    expect(find.text('Área'), findsNothing);
    await tester.tap(find.text('Manutenção'));
    await tester.pumpAndSettle();
    expect(find.text('Área'), findsOneWidget);
    expect(find.text('Salão de Festas'), findsWidgets);
  });

  testWidgets('expande reserva de morador e mostra unidade', (tester) async {
    await pumpApp(
      tester,
      ReservationListItem(
        headerType: ReservationItemHeader.SHOW_TYPE,
        reservation: Reservation()
          ..type = ReservationType.reservation
          ..from = DateTime(2026, 8, 14, 10)
          ..price = 80
          ..status = 'Pendente'
          ..unit = Unit(title: '202')
          ..space = (Space()..name = 'Piscina'),
      ),
      localized: true,
      locOverrides: const {
        'space_reservation_reservation': 'Reserva',
        'space_reservation_area': 'Área',
        'space_reservation_date': 'Data',
        'space_reservation_time': 'Horário',
        'space_reservation_unit': 'Unidade',
        'space_reservation_price': 'Valor',
        'space_reservation_expiration': 'Expiração',
        'space_reservation_receipt': 'Recibo',
        'space_reservation_cancellation_limit': 'Limite de cancelamento',
        'space_reservation_status': 'Status',
        'cancel': 'Cancelar',
      },
      shrinkWrap: false,
      surface: const Size(400, 920),
    );

    await tester.tap(find.text('Reserva'));
    await tester.pumpAndSettle();
    expect(find.text('Unidade'), findsOneWidget);
    expect(find.text('202'), findsOneWidget);
  });

  testWidgets('expande sorteio e mostra o botão sortear', (tester) async {
    await pumpApp(
      tester,
      ReservationListItem(
        headerType: ReservationItemHeader.SHOW_TYPE,
        reservation: Reservation()
          ..type = ReservationType.raffle
          ..from = DateTime(2026, 8, 20, 9)
          ..space = (Space()..name = 'Salão'),
      ),
      localized: true,
      locOverrides: const {
        'space_reservation_raffle': 'Sorteio',
        'space_reservation_area': 'Área',
        'space_reservation_date': 'Data',
        'space_reservation_do_raffle': 'Sortear',
        'cancel': 'Cancelar',
      },
    );

    await tester.tap(find.text('Sorteio'));
    await tester.pumpAndSettle();
    expect(find.text('Sortear'), findsOneWidget);
  });

  testWidgets('alterna o dia da semana na regra de reserva', (tester) async {
    final rules = ReservationChangeRules(allowedDaysList: [1, 3]);
    await pumpApp(
      tester,
      ReservationWeekSelectorWidget(
        state: ReservationChangeRulesLoadedState(rules: rules),
      ),
    );

    await tester.tap(find.text('Ter'));
    await tester.pump();
    expect(rules.allowedDaysList, contains(2));

    await tester.tap(find.text('Seg'));
    await tester.pump();
    expect(rules.allowedDaysList, isNot(contains(1)));
  });

  testWidgets('alterna sábado e domingo na regra', (tester) async {
    final rules = ReservationChangeRules(allowedDaysList: <int>[]);
    await pumpApp(
      tester,
      ReservationWeekendSelectorWidget(
        state: ReservationChangeRulesLoadedState(rules: rules),
      ),
    );

    await tester.tap(find.text('Sab'));
    await tester.pump();
    expect(rules.allowedDaysList, contains(6));

    await tester.tap(find.text('Dom'));
    await tester.pump();
    expect(rules.allowedDaysList, contains(0));
  });

  testWidgets('aplica o filtro do resumo de reservas', (tester) async {
    ReservationSummaryListFilter? applied;
    await pumpApp(
      tester,
      ReservationSummaryFilterWidget(
        entity: ReservationSummaryListFilter(),
        onApply: (filter) => applied = filter,
      ),
      localized: true,
      locOverrides: const {
        'space_reservation_category': 'Categoria',
        'space_reservation_all': 'Todas',
        'space_reservation_maintenance': 'Manutenção',
        'space_reservation_reservation': 'Reserva',
        'find': 'Buscar',
      },
      shrinkWrap: false,
      surface: const Size(400, 360),
    );

    await tester.tap(find.text('Buscar'));
    await tester.pump();
    expect(applied, isNotNull);
  });

  testWidgets('cancela a alteração de reserva', (tester) async {
    await pumpApp(
      tester,
      const ReservationChangeReservedPage(),
      wrapInScaffold: false,
      localized: true,
      locOverrides: const {
        'space_change_scheduled': 'Alterar reserva',
        'cancel': 'Cancelar',
      },
      surface: const Size(400, 720),
    );

    await tester.tap(find.text('Cancelar'));
    await tester.pump();
    expect(find.text('Alterar reserva'), findsOneWidget);
  });

  testWidgets('volta da alteração de reserva', (tester) async {
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          return TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const ReservationChangeReservedPage(),
                ),
              );
            },
            child: const Text('Abrir'),
          );
        },
      ),
      localized: true,
      locOverrides: const {
        'space_change_scheduled': 'Alterar reserva',
        'cancel': 'Cancelar',
      },
      shrinkWrap: false,
      surface: const Size(400, 720),
    );

    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('VTeste'));
    await tester.pumpAndSettle();
    expect(find.text('Alterar reserva'), findsNothing);
  });
}
