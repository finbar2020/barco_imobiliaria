import 'package:colaborador/feature/timesheet/domain/entity/timesheet_element_detail.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_point_flag_enum.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_detail_page/widget/timesheet_detail_list_widget.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';

TimesheetElementDetail _detail({
  required String time,
  required DateTime date,
  TimesheetPointFlagEnum flag = TimesheetPointFlagEnum.none,
}) =>
    TimesheetElementDetail(time: time, timesheetFlag: flag, date: date);

Future<void> _pumpList(
  WidgetTester tester,
  Map<DateTime, List<TimesheetElementDetail>> detail,
) =>
    pumpApp(
      tester,
      TimesheetDetailListWidget(timesheetDetail: detail),
      localized: true,
      shrinkWrap: false,
      surface: const Size(500, 1600),
    );

void main() {
  final dayOne = DateTime(2026, 1, 10);
  final dayTwo = DateTime(2026, 1, 11);

  group('TimesheetDetailListWidget', () {
    testWidgets('agrupa as tratativas por dia', (tester) async {
      await _pumpList(tester, {
        dayOne: [
          _detail(time: '08:00', date: dayOne),
          _detail(time: '12:00', date: dayOne),
        ],
        dayTwo: [_detail(time: '09:00', date: dayTwo)],
      });

      // A data fica dentro de um RichText, por isso o findRichText.
      expect(
        find.textContaining(DateFormat.yMd().format(dayOne),
            findRichText: true),
        findsOneWidget,
      );
      expect(
        find.textContaining(DateFormat.yMd().format(dayTwo),
            findRichText: true),
        findsOneWidget,
      );
      expect(find.text('08:00'), findsOneWidget);
      expect(find.text('12:00'), findsOneWidget);
      expect(find.text('09:00'), findsOneWidget);
      expect(find.text('timesheet_detail_time'), findsNWidgets(2));
    });

    testWidgets('exibe símbolo e rótulo de cada tipo de tratativa',
        (tester) async {
      await _pumpList(tester, {
        dayOne: [
          _detail(
            time: '08:00',
            date: dayOne,
            flag: TimesheetPointFlagEnum.inserted,
          ),
          _detail(
            time: '12:00',
            date: dayOne,
            flag: TimesheetPointFlagEnum.preInsert,
          ),
          _detail(
            time: '18:00',
            date: dayOne,
            flag: TimesheetPointFlagEnum.notInserted,
          ),
        ],
      });

      expect(find.text('I'), findsOneWidget);
      expect(find.text('P'), findsOneWidget);
      expect(find.text('D'), findsOneWidget);
      expect(find.text('timesheet_info_page_type_included'), findsOneWidget);
      expect(find.text('timesheet_info_page_type_pre_signed'), findsOneWidget);
      expect(
        find.text('timesheet_info_page_type_not_considered'),
        findsOneWidget,
      );
    });

    testWidgets('batida sem tratativa não recebe símbolo', (tester) async {
      await _pumpList(tester, {
        dayOne: [_detail(time: '08:00', date: dayOne)],
      });

      expect(find.text('timesheet_info_page_type_none'), findsOneWidget);
      expect(find.text('I'), findsNothing);
      expect(find.text('P'), findsNothing);
      expect(find.text('D'), findsNothing);
    });

    testWidgets('sem tratativas exibe a mensagem de lista vazia',
        (tester) async {
      await _pumpList(tester, const {});

      expect(find.text('timesheet_detail_page_empty'), findsOneWidget);
      expect(find.text('timesheet_detail_time'), findsNothing);
    });
  });
}
