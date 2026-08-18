import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/maintenance_management/data/model/maintenance_task_event_model.dart';
import 'package:lello/feature/maintenance_management/data/model/maintenance_task_events_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/maintenance_task_events_response_model.dart';
import 'package:lello/feature/maintenance_management/data/model/task_summary_model.dart';

void main() {
  test('MaintenanceTaskEventsRequestModel toJson e fromJson com mapa cru', () {
    final model = MaintenanceTaskEventsRequestModel(
      dtstart: '01/01/2026',
      untilDate: '07/01/2026',
      pageName: 'agenda',
      filters: MaintenanceTaskEventsRequestFiltersModel(
        typeTask: const ['ROTINA'],
        procedureGroupLabels: const [],
        displayBy: 'GRUPO',
        status: const ['PENDENTE'],
        dayCurrent: '03/01/2026',
        assetIds: const ['a1'],
        localIds: const ['l1'],
        responsibleIds: const ['r1'],
      ),
    );

    final json = model.toJson();
    expect(json['dtstart'], '01/01/2026');
    expect(json['pageName'] ?? json['page_name'], 'agenda');

    final parsed = MaintenanceTaskEventsRequestModel.fromJson({
      'dtstart': '01/01/2026',
      'untilDate': '07/01/2026',
      'pageName': 'agenda',
      'filters': {
        'typeTask': ['ROTINA'],
        'procedureGroupLabels': [],
        'displayBy': 'GRUPO',
        'status': ['PENDENTE'],
        'dayCurrent': '03/01/2026',
        'assetIds': ['a1'],
        'localIds': ['l1'],
        'responsibleIds': ['r1'],
      },
    });
    expect(parsed.dtstart, '01/01/2026');
    expect(parsed.filters.typeTask, ['ROTINA']);
    expect(parsed.filters.assetIds, ['a1']);
  });

  test('MaintenanceTaskEventsResponseModel fromJson com mapa cru', () {
    final parsed = MaintenanceTaskEventsResponseModel.fromJson({
      'taskSummaryDay': {
        'total': 2,
        'done': 1,
        'notStarted': 1,
        'draft': 0,
      },
      'taskFormulary': [
        {
          'idTask': 't-1',
          'typeTask': 'ROTINA',
          'name': 'Bomba',
          'fullDescription': 'desc',
          'responsibleUserable': 'Maria',
          'timeStart': '09:00',
          'timeDescription': '09:00',
          'dtstart': '2026-01-15T00:00:00.000Z',
          'dtstartFormatted': '15/01/2026',
          'status': 'PENDENTE',
          'allDay': false,
        },
      ],
    });
    expect(parsed.taskSummaryDay.total, 2);
    expect(parsed.taskFormulary.single.name, 'Bomba');
    expect(parsed.toJson()['taskFormulary'], isNotEmpty);
  });

  test('TaskSummaryModel toJson/fromJson', () {
    final model = TaskSummaryModel(total: 4, done: 1, notStarted: 2, draft: 1);
    final parsed = TaskSummaryModel.fromJson(model.toJson());
    expect(parsed.total, 4);
    expect(parsed.done, 1);
    expect(parsed.notStarted, 2);
    expect(parsed.draft, 1);
  });

  test('MaintenanceTaskEventModel toJson/fromJson', () {
    final model = MaintenanceTaskEventModel(
      idTask: 't-1',
      typeTask: 'ROTINA',
      name: 'Bomba',
      fullDescription: 'desc',
      responsibleUserable: 'Maria',
      timeStart: '09:00',
      timeDescription: '09:00',
      dtstart: '2026-01-15T00:00:00.000Z',
      dtstartFormatted: '15/01/2026',
      status: 'PENDENTE',
      allDay: false,
    );
    final parsed = MaintenanceTaskEventModel.fromJson(model.toJson());
    expect(parsed.name, 'Bomba');
    expect(parsed.idTask, 't-1');
  });
}
