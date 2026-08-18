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
import 'package:lello/feature/space/reservation/presentation/widget/reservation_rule_days_time_widget.dart';
import 'package:lello/feature/space/reservation/presentation/widget/reservation_summary_filter_widget.dart';
import 'package:lello/feature/space/reservation/presentation/widget/reservation_week_selector_widget.dart';
import 'package:lello/feature/space/reservation/presentation/widget/reservation_weekend_selector_widget.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';

import '../../../../helpers/pump_app.dart';

const _reservationLoc = {
  'space_reservation_maintenance': 'Manutenção',
  'space_reservation_reservation': 'Reserva',
  'space_reservation_raffle': 'Sorteio',
  'space_reservation_area': 'Área',
  'space_reservation_date': 'Data',
  'space_reservation_time': 'Horário',
  'space_reservation_unit': 'Unidade',
  'space_reservation_price': 'Valor',
  'space_reservation_expiration': 'Expiração',
  'space_reservation_receipt': 'Recibo',
  'space_reservation_cancellation_limit': 'Limite de cancelamento',
  'space_reservation_status': 'Status',
  'space_reservation_do_raffle': 'Sortear',
  'cancel': 'Cancelar',
};

void main() {
  testWidgets('golden — item de reserva de manutenção', (tester) async {
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
      locOverrides: _reservationLoc,
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/reservation_list_item.png'),
    );
  });

  testWidgets('golden — reserva de morador expandida', (tester) async {
    await pumpApp(
      tester,
      ReservationListItem(
        headerType: ReservationItemHeader.SHOW_TYPE,
        reservation: Reservation()
          ..type = ReservationType.reservation
          ..from = DateTime(2026, 8, 14, 10)
          ..expiration = DateTime(2026, 8, 14, 18)
          ..cancellationLimit = DateTime(2026, 8, 13, 18)
          ..price = 150
          ..receipt = 'REC-1'
          ..status = 'Confirmada'
          ..unit = Unit(title: '101')
          ..space = (Space()..name = 'Churrasqueira'),
      ),
      localized: true,
      locOverrides: _reservationLoc,
      shrinkWrap: false,
      surface: const Size(400, 920),
    );
    await tester.tap(find.text('Reserva'));
    await tester.pumpAndSettle();
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/reservation_expanded.png'),
    );
  });

  testWidgets('golden — seletor de dias da semana', (tester) async {
    await pumpApp(
      tester,
      ReservationWeekSelectorWidget(
        state: ReservationChangeRulesLoadedState(
          rules: ReservationChangeRules(allowedDaysList: [1, 3, 5]),
        ),
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/reservation_week_selector.png'),
    );
  });

  testWidgets('golden — seletor de fim de semana', (tester) async {
    await pumpApp(
      tester,
      ReservationWeekendSelectorWidget(
        state: ReservationChangeRulesLoadedState(
          rules: ReservationChangeRules(allowedDaysList: [0, 6]),
        ),
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/reservation_weekend_selector.png'),
    );
  });

  testWidgets('golden — item de reserva pelo dia', (tester) async {
    await pumpApp(
      tester,
      ReservationListItem(
        headerType: ReservationItemHeader.SHOW_DAY,
        reservation: Reservation()
          ..type = ReservationType.maintenance
          ..from = DateTime(2026, 8, 14, 10)
          ..space = (Space()..name = 'Salão de Festas'),
      ),
      localized: true,
      locOverrides: _reservationLoc,
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/reservation_day_header.png'),
    );
  });

  testWidgets('golden — filtro do resumo de reservas', (tester) async {
    await pumpApp(
      tester,
      ReservationSummaryFilterWidget(
        entity: ReservationSummaryListFilter(),
        onApply: (_) {},
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
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/reservation_summary_filter.png'),
    );
  });

  testWidgets('golden — regras de dias úteis', (tester) async {
    await pumpApp(
      tester,
      ReservationRuleDaysTimeWidget(
        isWeek: true,
        state: ReservationChangeRulesLoadedState(
          rules: ReservationChangeRules(
            allowedDaysList: [1, 3, 5],
            weekHourStart: '08:00:00',
            weekHourEnd: '18:00:00',
          ),
        ),
      ),
      localized: true,
      locOverrides: const {
        'week_days': 'Dias úteis',
        'time_allowed': 'Horário permitido',
        'from': 'De',
        'to': 'Até',
      },
      shrinkWrap: false,
      surface: const Size(400, 360),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/reservation_rule_week.png'),
    );
  });

  testWidgets('golden — regras de fim de semana', (tester) async {
    await pumpApp(
      tester,
      ReservationRuleDaysTimeWidget(
        isWeek: false,
        state: ReservationChangeRulesLoadedState(
          rules: ReservationChangeRules(
            allowedDaysList: [0, 6],
            weekendHourStart: '09:00:00',
            weekendHourEnd: '13:00:00',
          ),
        ),
      ),
      localized: true,
      locOverrides: const {
        'weekend_days': 'Fim de semana',
        'time_allowed': 'Horário permitido',
        'from': 'De',
        'to': 'Até',
      },
      shrinkWrap: false,
      surface: const Size(400, 360),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/reservation_rule_weekend.png'),
    );
  });

  testWidgets('golden — alteração de reserva', (tester) async {
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
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/reservation_change_reserved.png'),
    );
  });
}
