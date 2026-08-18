import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/maintenance_management/domain/entity/calendar_day_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/calendar_days_response_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/filter_options_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/maintenance_management_entity.dart';
import 'package:lello/feature/maintenance_management/domain/enum/tracking_trade_status.dart';
import 'package:lello/feature/maintenance_management/presentation/home/widgets/task_card/task_card_enum.dart';
import 'package:lello/feature/maintenance_management/presentation/home/widgets/task_summary/task_summary_model.dart';

void main() {
  group('CalendarDaysResponseEntity', () {
    const response = CalendarDaysResponseEntity(
      month: 1,
      year: 2026,
      days: [
        CalendarDayEntity(day: 10, hasEvents: true, taskCount: 3),
        CalendarDayEntity(day: 11, hasEvents: false, taskCount: 0),
      ],
    );

    test('hasTasks só é true quando o dia tem eventos', () {
      expect(response.hasTasks(10), isTrue);
      expect(response.hasTasks(11), isFalse);
      expect(response.hasTasks(1), isFalse);
    });

    test('getTaskCount retorna a quantidade ou 0', () {
      expect(response.getTaskCount(10), 3);
      expect(response.getTaskCount(99), 0);
    });

    test('igualdade e toString', () {
      expect(response, response);
      expect(
        response,
        const CalendarDaysResponseEntity(
          month: 1,
          year: 2026,
          days: [
            CalendarDayEntity(day: 10, hasEvents: true, taskCount: 3),
            CalendarDayEntity(day: 11, hasEvents: false, taskCount: 0),
          ],
        ),
      );
      expect(response.toString(), contains('month: 1'));
      expect(
        const CalendarDayEntity(day: 1, hasEvents: false, taskCount: 0).toString(),
        contains('day: 1'),
      );
    });
  });

  group('FilterOptionsEntity.copyWith', () {
    test('substitui só os campos informados', () {
      final original = FilterOptionsEntity(
        locals: [FilterLocalEntity(id: 'l1', name: 'Hall')],
        assets: [],
        responsibles: [],
        employeeGroup: [],
        taskType: [TaskType.routine],
        taskStatus: [TaskStatusType.pending],
      );

      final copy = original.copyWith(
        locals: [FilterLocalEntity(id: 'l2', name: 'Piscina')],
        taskType: [TaskType.serviceOrder],
      );

      expect(copy.locals.single.id, 'l2');
      expect(copy.taskType, [TaskType.serviceOrder]);
      expect(copy.taskStatus, original.taskStatus);
      expect(copy.assets, original.assets);
    });
  });

  group('CondominiumInfoEntity', () {
    test('hasTokens e isTrackingTradeActive', () {
      const empty = CondominiumInfoEntity(
        id: 'c1',
        assets: 0,
        floor: '',
        localsCount: 0,
        workflowUsers: '',
        condominiumName: 'X',
        blocksCount: 0,
        unitsCount: 0,
        references: [],
      );
      expect(empty.hasTokens, isFalse);
      expect(empty.isTrackingTradeActive, isFalse);

      const active = CondominiumInfoEntity(
        id: 'c1',
        assets: 0,
        floor: '',
        localsCount: 0,
        workflowUsers: '',
        condominiumName: 'X',
        blocksCount: 0,
        unitsCount: 0,
        references: [],
        trackingTradeStatus: TrackingTradeStatus.active,
      );
      expect(active.isTrackingTradeActive, isTrue);
      expect(TrackingTradeStatus.active.isActive, isTrue);
      expect(TrackingTradeStatus.inactive.isActive, isFalse);
    });
  });
}
