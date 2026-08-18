import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/maintenance_management/data/model/assets_lookup_model.dart';
import 'package:lello/feature/maintenance_management/data/model/chat/create_chat_channel_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/chat/filter_chat_channels_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/locals_lookup_model.dart';
import 'package:lello/feature/maintenance_management/data/model/schedule_events_response_model.dart';
import 'package:lello/feature/maintenance_management/data/model/task_by_asset_data_model.dart';
import 'package:lello/feature/maintenance_management/data/model/task_by_asset_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/task_by_local_data_model.dart';
import 'package:lello/feature/maintenance_management/data/model/task_by_local_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/task_by_sector_data_model.dart';
import 'package:lello/feature/maintenance_management/data/model/task_by_sector_request_model.dart';
import 'package:lello/feature/reports_book/data/model/report_filter_model.dart';
import 'package:lello/feature/reports_book/domain/entity/report_filter.dart';

void main() {
  test('fromJson de filtros cobre listas opcionais geradas', () {
    const filtersJson = {
      'responsibleIds': ['u1'],
      'assetIds': ['a1'],
      'localIds': ['l1'],
      'typeTask': ['ROTINA'],
      'status': ['DONE'],
      'dayCurrent': '10/01/2026',
      'localGroupIds': ['g1'],
      'procedureIds': ['p1'],
      'assetGroupIds': ['ag1'],
      'sectorIds': ['s1'],
    };
    expect(
      TaskBySectorFiltersModel.fromJson(filtersJson).toJson()['sectorIds'],
      ['s1'],
    );
    expect(
      TaskByLocalFiltersModel.fromJson(filtersJson).toJson()['localIds'],
      ['l1'],
    );
    expect(
      TaskByAssetFiltersModel.fromJson(filtersJson).toJson()['assetIds'],
      ['a1'],
    );
    expect(
      TaskBySectorRequestModel.fromJson({
        'dtStart': 'a',
        'untilDate': 'b',
        'filters': filtersJson,
      }).filters?.dayCurrent,
      '10/01/2026',
    );
  });

  test('lookup, data charts e chat request cobrem toJson gerado', () {
    expect(
      LocalLookupModel.fromJson({
        'id': '1',
        'name': 'Hall',
        'hierarchy_locals': 'Bloco/Hall',
      }).toJson()['hierarchy_locals'],
      'Bloco/Hall',
    );
    expect(
      LocalsLookupModel.fromJson({
        'locals': [
          {'id': '1', 'name': 'Hall', 'hierarchy_locals': 'x'},
        ],
      }).locals.single.name,
      'Hall',
    );
    expect(
      AssetLookupModel.fromJson({
        'id': '1',
        'name': 'Bomba',
        'nameWithHierarchyLocals': 'Hall/Bomba',
      }).toJson()['name'],
      'Bomba',
    );
    expect(
      TaskByLocalDataModel.fromJson({
        'id': '1',
        'name': 'Hall',
        'done': 1,
        'draft': 0,
        'not_started': 0,
        'total': 1,
      }).toJson()['not_started'],
      0,
    );
    expect(
      TaskByAssetDataModel.fromJson({
        'id': '1',
        'name': 'Bomba',
        'done': 1,
        'draft': 0,
        'not_started': 0,
        'total': 1,
      }).toJson()['total'],
      1,
    );
    expect(
      TaskBySectorDataModel.fromJson({
        'id': '1',
        'name': 'Limpeza',
        'value': 2,
        'color': '#000',
      }).toJson()['color'],
      '#000',
    );

    const chat = FilterChatChannelsRequestModel(
      dtStart: 'a',
      untilDate: 'b',
      display: 'DAY',
      dayCurrent: '10/01/2026',
      responsibleIds: ['u1'],
      assetIds: ['a1'],
      status: ['OPEN'],
      typeTask: ['ROTINA'],
    );
    expect(
      FilterChatChannelsRequestModel.fromJson(chat.toJson()).dayCurrent,
      '10/01/2026',
    );
    expect(
      CreateChatChannelRequestModel.fromJson({'taskId': 't1', 'name': 'Chat'})
          .toJson()['name'],
      'Chat',
    );
  });

  test('ScheduleEventsResponseModel toJson e fromJson sem data', () {
    const empty = ScheduleEventsResponseModel(
      success: true,
      message: 'ok',
      legacyStatusCode: 200,
    );
    expect(empty.toJson()['data'] == null, isTrue);
    expect(empty.taskFormulary, isEmpty);
    final parsed = ScheduleEventsResponseModel.fromJson({
      'success': true,
      'message': 'ok',
      'legacyStatusCode': 200,
      'data': {
        'taskSummaryDay': {
          'total': 1,
          'done': 1,
          'notStarted': 0,
          'draft': 0,
        },
        'taskFormulary': [
          {
            'idSchedule': 's1',
            'idScheduleEvent': 'e1',
            'typeTask': 'ROTINA',
            'name': 'Limpeza',
            'fullDescription': 'd',
            'responsibleUserable': 'Ana',
            'procedureGroupId': 'g1',
            'responsibleId': 'u1',
            'timeStart': '08:00',
            'timeDescription': 'manhã',
            'dtstart': '2026-01-10',
            'dtstartFormatted': '10/01/2026',
            'status': 'DONE',
            'allDay': true,
          }
        ],
      },
    });
    expect(parsed.toJson()['data']['taskFormulary'], isNotEmpty);
    expect(parsed.taskSummaryDay?.total, 1);
  });

  test('ReportFilterModel fromJson snake_case e fromEntity', () {
    final model = ReportFilterModel.fromJson({
      'date_from': '2026-01-01T00:00:00.000',
      'date_to': '2026-01-31T00:00:00.000',
      'type': 1,
      'closed': true,
      'unit_id': 'u1',
      'show_only_new_reports': true,
      'show_only_replies': false,
    });
    expect(model.toJson()['unit_id'], 'u1');
    expect(
      ReportFilterModel.fromEntity(ReportFilter(unitId: 'u2', closed: true))
          ?.unitId,
      'u2',
    );
    expect(ReportFilterModel.fromEntity(null) == null, isTrue);
  });

  test('CreateChatChannelResponseModel aceita data, channelId, id e erros', () {
    expect(CreateChatChannelResponseModel.fromJson('ch1').channelId, 'ch1');
    expect(
      CreateChatChannelResponseModel.fromJson({'channelId': 'ch2'}).channelId,
      'ch2',
    );
    expect(
      CreateChatChannelResponseModel.fromJson({'id': 'ch3'}).channelId,
      'ch3',
    );
    expect(
      CreateChatChannelResponseModel.fromJson({'data': 'ch4'}).toJson()['channelId'],
      'ch4',
    );
    expect(
      () => CreateChatChannelResponseModel.fromJson(<String, dynamic>{}),
      throwsA(isA<FormatException>()),
    );
    expect(
      () => CreateChatChannelResponseModel.fromJson(1),
      throwsA(isA<FormatException>()),
    );
  });
}
