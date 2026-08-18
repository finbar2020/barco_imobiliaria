import 'package:colaborador/feature/timesheet/domain/entity/timesheet_point_flag_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';

void main() {
  test('TimesheetPointFlag.symbol e titleKey', () {
    expect(TimesheetPointFlag.symbol(TimesheetPointFlagEnum.inserted), 'I');
    expect(TimesheetPointFlag.symbol(TimesheetPointFlagEnum.preInsert), 'P');
    expect(TimesheetPointFlag.symbol(TimesheetPointFlagEnum.notInserted), 'D');
    expect(TimesheetPointFlag.symbol(TimesheetPointFlagEnum.none), '');
    expect(
      TimesheetPointFlag.titleKey(TimesheetPointFlagEnum.inserted),
      'timesheet_info_page_type_included',
    );
    expect(
      TimesheetPointFlag.descriptionKey(TimesheetPointFlagEnum.none),
      '',
    );
  });

  testWidgets('TimesheetPointFlag.color usa o tema', (tester) async {
    Color? inserted;
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          inserted = TimesheetPointFlag.color(
            context,
            TimesheetPointFlagEnum.inserted,
          );
          return const SizedBox.shrink();
        },
      ),
    );
    expect(inserted, isNotNull);
  });
}
