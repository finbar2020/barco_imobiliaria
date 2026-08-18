import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/maintenance_management/data/model/chat/chat_channel_model.dart';
import 'package:lello/feature/maintenance_management/data/model/chat/chat_message_model.dart';
import 'package:lello/feature/maintenance_management/data/model/chat/create_chat_channel_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/chat/filter_chat_channels_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/chat/send_chat_message_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/create_task_from_schedule_response_model.dart';
import 'package:lello/feature/maintenance_management/data/model/filter_options_model.dart';
import 'package:lello/feature/maintenance_management/data/model/legal_obligation_response_model.dart';
import 'package:lello/feature/maintenance_management/data/model/procedure_options_model.dart';
import 'package:lello/feature/maintenance_management/data/model/schedule_event_history_response_model.dart';
import 'package:lello/feature/maintenance_management/data/model/schedule_event_task_model.dart';
import 'package:lello/feature/maintenance_management/data/model/submit_form_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/task_by_asset_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/task_by_local_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/task_by_sector_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/task_details_model.dart'
    hide ParentScheduleEventModel;
import 'package:lello/feature/maintenance_management/data/model/task_files_model.dart';
import 'package:lello/feature/maintenance_management/data/model/task_formularies_model.dart';

void main() {
  test('TaskDetailsModel toJson cobre nested generated', () {
    final model = TaskDetailsModel.fromJson({
      'id': 't1',
      'name': 'Limpeza',
      'status': 'PENDING',
      'type_task': 'ROTINA',
      'current_user': {
        'id': 'u1',
        'name': 'Ana',
        'admin': true,
        'references': <dynamic>[],
      },
      'currentFormulary': {
        'id': 'f1',
        'name': 'Form',
        'position': 1,
        'enabled': true,
      },
      'procedure': {
        'id': 'p1',
        'title': 'Limpeza',
        'procedure_group': {
          'id': 'g1',
          'name': 'Grupo',
          'type_task': 'ROTINA',
        },
        'first_responsible': {
          'id': 'u1',
          'name': 'Ana',
          'references': <dynamic>[],
        },
      },
      'schedule': {'id': 's1', 'name': 'Agenda'},
      'task': {
        'id': 't1',
        'channel': {
          'id': 'c1',
          'type_task': 'ROTINA',
          'status': 'OPEN',
          'created_at': '2026-01-10',
          'task': 't1',
        },
        'current_formulary': {
          'id': 'f1',
          'name': 'Form',
          'position': 1,
          'enabled': true,
        },
        'current_user': {
          'id': 'u1',
          'name': 'Ana',
          'references': <dynamic>[],
        },
      },
      'parent_schedule_event': {'id': 'p1', 'name': 'Pai'},
      'r_rule': {
        'frequency': 'WEEKLY',
        'by_days': ['MO'],
      },
      'procedure_group': {
        'id': 'g1',
        'name': 'Grupo',
        'type_task': 'ROTINA',
      },
    });
    expect(model.toJson()['id'], 't1');
    expect(model.currentUser!.toJson()['name'], 'Ana');
    expect(model.currentFormulary!.toJson()['id'], 'f1');
    expect(model.procedure!.toJson()['id'], 'p1');
    expect(model.procedure!.procedureGroup!.toJson()['id'], 'g1');
    expect(model.procedure!.firstResponsible!.toJson()['id'], 'u1');
    expect(model.schedule!.toJson()['id'], 's1');
    expect(model.task!.toJson()['id'], 't1');
    expect(model.task!.channel!.toJson()['id'], 'c1');
    expect(model.task!.currentFormulary!.toJson()['id'], 'f1');
    expect(model.task!.currentUser!.toJson()['id'], 'u1');
    expect(model.rRule!.toJson()['frequency'], 'WEEKLY');
    expect(model.procedureGroup!.toJson()['id'], 'g1');
    expect(model.parentScheduleEvent!.toJson()['id'], 'p1');
  });

  test('Chat models toJson cobrem nested generated', () {
    final channels = ChatChannelsResponseModel.fromJson({
      'success': true,
      'ttJwtToken': 'jwt',
      'pageInfo': {
        'hasNextPage': true,
        'hasPreviousPage': false,
        'startCursor': 'a',
        'endCursor': 'b',
      },
      'data': [
        {
          'id': 'ch1',
          'typeTask': 'ROTINA',
          'status': 'OPEN',
          'task': {'id': 't1', 'name': 'Limpeza'},
          'lastMessage': {
            'id': 'm1',
            'content': 'oi',
            'createdAt': '2026-01-10',
            'author': {'id': 'u1', 'name': 'Ana', 'email': 'a@b.com'},
          },
        }
      ],
    });
    expect(channels.toJson()['success'], isTrue);
    expect(channels.pageInfo!.toJson()['hasNextPage'], isTrue);
    expect(channels.data.single.toJson()['id'], 'ch1');
    expect(channels.data.single.task.toJson()['name'], 'Limpeza');
    expect(channels.data.single.lastMessage!.toJson()['id'], 'm1');
    expect(channels.data.single.lastMessage!.author.toJson()['email'], 'a@b.com');

    final messages = ChatMessagesResponseModel.fromJson({
      'success': true,
      'currentUserId': 'u1',
      'cursor': {
        'hasPreviousPage': false,
        'hasNextPage': true,
        'startCursor': 's',
        'endCursor': 'e',
      },
      'data': [
        {
          'id': 'm1',
          'content': 'olá',
          'channel_id': 'ch1',
          'author_id': 'u1',
          'messageType': 'TEXT',
          'createdAt': '10/01/2026 08:30:00',
          'author': {
            'id': 'u1',
            'name': 'Ana',
            'email': 'a@b.com',
            'imageUrl': 'https://img',
            'username': 'ana',
            'status': 'ONLINE',
            'profile': {'id': 'p1', 'name': 'Perfil', 'description': 'd'},
          },
          'attachment': {
            'id': 'a1',
            'name': 'foto.png',
            'url': 'https://s3',
            'attachmentType': 'image/png',
            'fileSize': '10',
          },
        }
      ],
    });
    expect(messages.toJson()['success'], isTrue);
    expect(messages.cursor.toJson()['hasNextPage'], isTrue);
    expect(messages.data.single.toJson()['id'], 'm1');
    expect(messages.data.single.author.toJson()['username'], 'ana');
    expect(messages.data.single.author.profile!.toJson()['id'], 'p1');
    expect(messages.data.single.attachment!.toJson()['url'], 'https://s3');

    expect(
      const FilterChatChannelsRequestModel(
        dtStart: 'a',
        untilDate: 'b',
        display: 'd',
        dayCurrent: 'c',
        responsibleIds: ['r'],
        assetIds: ['a'],
        status: ['OPEN'],
        typeTask: ['ROTINA'],
      ).toJson()['dtStart'],
      'a',
    );
    expect(
      const SendChatMessageRequestModel(
        channelId: 'ch1',
        content: 'oi',
        sentAt: 'agora',
      ).toJson()['channelId'],
      'ch1',
    );
    expect(
      const CreateChatChannelRequestModel(taskId: 't1', name: 'Chat').toJson()['taskId'],
      't1',
    );
  });

  test('Submit form, charts request, files e histórico toJson', () {
    final file = FileContentModel.fromJson({
      'content_type': 'image/png',
      'local_uri': 'file://a',
      'name': 'a.png',
      'upload_task_id': 'u1',
      'firebase_ref': 'ref',
      'device_id': 'd1',
      'bucket': 'b',
      'fail_count': 0,
      'size': 10,
      'url': 'https://s3',
    });
    expect(file.toJson()['name'], 'a.png');

    final submit = SubmitFormRequestModel.fromJson({
      'event_id': 'e1',
      'answers': {
        'q1': {'type': 'TEXT', 'question_id': 'q1', 'content': 'ok'},
        'q2': {
          'type': 'FILE',
          'question_id': 'q2',
          'content': file.toJson(),
        },
      },
    });
    expect(submit.toJson()['event_id'], 'e1');
    expect(submit.answers['q1']!.toJson()['type'], 'TEXT');

    expect(
      const TaskBySectorRequestModel(
        dtStart: '01/01/2026',
        untilDate: '31/01/2026',
        filters: TaskBySectorFiltersModel(
          responsibleIds: ['r'],
          assetIds: ['a'],
          localIds: ['l'],
          typeTask: ['ROTINA'],
          status: ['DONE'],
          dayCurrent: '10/01/2026',
          localGroupIds: ['g'],
          procedureIds: ['p'],
          assetGroupIds: ['ag'],
          sectorIds: ['s'],
        ),
      ).filters!
          .toJson()['sectorIds'],
      ['s'],
    );
    expect(
      const TaskByLocalRequestModel(
        dtStart: '01/01/2026',
        untilDate: '31/01/2026',
        filters: TaskByLocalFiltersModel(
          responsibleIds: ['r'],
          assetIds: ['a'],
          localIds: ['l'],
          typeTask: ['ROTINA'],
          status: ['DONE'],
          dayCurrent: '10/01/2026',
          localGroupIds: ['g'],
          procedureIds: ['p'],
          assetGroupIds: ['ag'],
          sectorIds: ['s'],
        ),
      ).filters!
          .toJson()['localIds'],
      ['l'],
    );
    expect(
      const TaskByAssetRequestModel(
        dtStart: '01/01/2026',
        untilDate: '31/01/2026',
        filters: TaskByAssetFiltersModel(
          responsibleIds: ['r'],
          assetIds: ['a'],
          localIds: ['l'],
          typeTask: ['ROTINA'],
          status: ['DONE'],
          dayCurrent: '10/01/2026',
          localGroupIds: ['g'],
          procedureIds: ['p'],
          assetGroupIds: ['ag'],
          sectorIds: ['s'],
        ),
      ).filters!
          .toJson()['assetIds'],
      ['a'],
    );

    final files = TaskFilesResponseModel.fromJson({
      'files': [
        {
          'id': 'f1',
          'task_id': 't1',
          'url': 'https://s3',
          'filename': 'a.png',
          'created_at': '2026-01-10',
          'author_id': 'u1',
          'author_name': 'Ana',
          'author_image_url': 'https://img',
          'author_email': 'a@b.com',
          'extension': 'png',
        }
      ],
    });
    expect(files.toJson()['files'], isNotEmpty);
    expect(files.files.single.toJson()['filename'], 'a.png');

    final forms = TaskFormulariesResponseModel.fromJson({
      'formularies': [
        {
          'id': 'f1',
          'name': 'Form',
          'responsible_name': 'Ana',
          'status': 'DONE',
          'event_id': 'e1',
          'position': 1,
          'author_id': 'u1',
          'max_created_at': 'a',
          'finished_at': 'b',
          'can_start': true,
        }
      ],
    });
    expect(forms.toJson()['formularies'], isNotEmpty);
    expect(forms.formularies.single.toJson()['name'], 'Form');

    final history = ScheduleEventHistoryResponseModel.fromJson({
      'success': true,
      'message': 'ok',
      'data': {
        'time_description': 'manhã',
        'time_start': '08:00',
        'time_end': '09:00',
        'name': 'Limpeza',
        'local_or_asset': 'Hall',
        'dt_start': '2026-01-10',
        'until': '2026-01-10',
        'all_day': false,
        'items': [
          {
            'dt_start': '2026-01-10',
            'status': 'DONE',
            'responsible_name': 'Ana',
          }
        ],
      },
    });
    expect(history.toJson()['success'], isTrue);
    expect(history.data!.toJson()['name'], 'Limpeza');
    expect(history.data!.items!.single.toJson()['status'], 'DONE');

    final created = CreateTaskFromScheduleResponseModel.fromJson({
      'task': {
        'id': 't1',
        'name': 'Limpeza',
        'current_responsible_name': 'Ana',
        'current_responsible_id': 'u1',
      },
      'event': {
        'id': 'e1',
        'name': 'Evento',
        'last_content_answers': {
          'questionId': 'q1',
          'type': 'TEXT',
          'content': 'ok',
          'updatedAt': '2026-01-10',
          'formularyId': 'f1',
        },
      },
    });
    expect(created.toJson(), isNotEmpty);
    expect(created.task.toJson()['id'], 't1');
    expect(created.event.toJson()['id'], 'e1');
    expect(created.event.lastContentAnswers!.toJson()['questionId'], 'q1');
  });

  test('Procedure, filter options, legal obligation e task model toJson', () {
    final procedures = ProcedureOptionsModel.fromJson({
      'procedure_options': [
        {
          'id': 12,
          'title': 'Limpeza',
          'title_key': 'clean',
          'url_image': 'https://img',
          'procedure_id': 'p1',
          'procedure_group_id': 'g1',
          'description': 'desc',
          'first_responsible': {'id': 'u1', 'name': 'João'},
        }
      ],
    });
    expect(procedures.toJson()['procedure_options'], isNotEmpty);
    expect(procedures.procedureOptions.single.toJson()['title'], 'Limpeza');
    expect(procedures.procedureOptions.single.firstResponsible!.toJson()['id'], 'u1');

    final filters = FilterOptionsModel.fromJson({
      'locals': [
        {'id': 'l1', 'name': 'Hall'}
      ],
      'assets': [
        {'id': 'a1', 'name': 'Bomba'}
      ],
      'responsibles': [
        {'id': 'r1', 'name': 'Maria'}
      ],
      'employee_group': [
        {'id': 'g1', 'name': 'Manutenção'}
      ],
    });
    expect(filters.locals.single.toJson()['id'], 'l1');
    expect(filters.assets.single.toJson()['id'], 'a1');
    expect(filters.responsibles.single.toJson()['id'], 'r1');
    expect(filters.employeeGroup.single.toJson()['id'], 'g1');

    final legal = LegalObligationResponseModel.fromJson({
      'success': true,
      'message': 'ok',
      'errorCode': 'E',
      'legacyStatusCode': 200,
      'metadata': {'requestPartner': true},
      'data': [
        {
          'id': '1',
          'reference': 'ref',
          'collectionCode': 'c',
          'documentType': 'PDF',
          'document': 'doc',
          'description': 'AVCB',
          'status': 'PENDING',
          'expirationDate': '2026-02-01',
          'availableActions': ['NOTIFY'],
          'submittedByName': 'Ana',
          'statusTooltip': 'tip',
          'collectionType': 't',
          'contentType': 'pdf',
          'lastNotificationDate': '2026-01-10',
          'observations': 'obs',
        }
      ],
    });
    expect(legal.toJson()['success'], isTrue);
    expect(legal.metadata!.toJson()['requestPartner'], isTrue);
    expect(legal.data.single.toJson()['id'], '1');

    const task = ScheduleEventTaskModel(
      idTask: 't1',
      idSchedule: 's1',
      idScheduleEvent: 'e1',
      typeTask: 'ROTINA',
      name: 'Limpeza',
      fullDescription: 'desc',
      responsibleUserable: 'Ana',
      procedureGroupId: 'g1',
      responsibleId: 'u1',
      timeStart: '08:00',
      timeEnd: '09:00',
      timeDescription: 'manhã',
      dtstart: 'a',
      dtend: 'b',
      dtstartFormatted: 'c',
      dtendFormatted: 'd',
      status: 'DONE',
      rrule: 'x',
      rruleDescription: 'y',
      allDay: true,
    );
    expect(ScheduleEventTaskModel.fromJson(task.toJson()).name, 'Limpeza');
  });
}
