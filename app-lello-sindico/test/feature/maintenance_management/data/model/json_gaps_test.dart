import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/maintenance_management/data/model/calendar_days_response_model.dart';
import 'package:lello/feature/maintenance_management/data/model/chat/create_chat_channel_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/chat/filter_chat_channels_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/chat/send_chat_message_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/create_task_from_schedule_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/create_task_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/create_task_response_model.dart';
import 'package:lello/feature/maintenance_management/data/model/delete_schedule_event_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/delete_schedule_event_response_model.dart';
import 'package:lello/feature/maintenance_management/data/model/edit_schedule_event_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/event_details_model.dart';
import 'package:lello/feature/maintenance_management/data/model/schedule_event_history_response_model.dart';
import 'package:lello/feature/maintenance_management/data/model/submit_form_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/submit_form_response_model.dart';
import 'package:lello/feature/maintenance_management/data/model/task_by_asset_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/taskflow_event_model.dart';
import 'package:lello/feature/gdp/timesheet/data/model/timesheet_signature_model.dart';
import 'package:lello/feature/gdp/timesheet/data/model/timesheet_signature_request_model.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_signature_entity.dart';
import 'package:lello/feature/reports_book/data/model/content_send_model.dart';
import 'package:lello/feature/reports_book/domain/entity/content_send.dart';
import 'package:lello/feature/vox/data/model/announcement_detail_model.dart';

void main() {
  test('EventDetailsModel fromJson/toJson cobre generated', () {
    final model = EventDetailsModel.fromJson({
      'id': 'e1',
      'parent_schedule_event': {'id': 'p1'},
      'last_content_answers': {
        'formulary_id': 'f1',
        'created_at': '2026-01-10',
        'updated_at': '2026-01-10',
        'status': 'DONE',
        'task_id': 't1',
        'formulary': {
          'id': 'f1',
          'name': 'Form',
          'position': 1,
          'procedure_id': 'p1',
          'enabled': true,
          'created_at': 'a',
          'updated_at': 'b',
          'questions': [
            {
              'id': 'q1',
              'name': 'Pergunta',
              'position': 0,
              'formulary_id': 'f1',
              'hidden': false,
              'required': true,
              'created_at': 'a',
              'updated_at': 'b',
              'field_type': 'TEXT',
              'options': [
                {
                  'id': 'o1',
                  'name': 'Sim',
                  'position': 0,
                  'question_id': 'q1',
                  'created_at': 'a',
                  'updated_at': 'b',
                }
              ],
              'expressions': [
                {
                  'id': 'x1',
                  'factors': [
                    {
                      'target_value': '1',
                      'origin_id': 'q1',
                      'comparison_type': 'EQ',
                    }
                  ],
                }
              ],
            }
          ],
        },
      },
    });
    expect(model.lastContentAnswers?.formulary?.questions.single.options?.single.name,
        'Sim');
    expect(model.toJson()['id'], 'e1');
  });

  test('TaskflowEvent json cobre texto, arquivo lista e string', () {
    final json = {
      'success': true,
      'message': 'ok',
      'error_code': null,
      'legacy_status_code': 200,
      'data': {
        'id': 'e1',
        'formulary_id': 'f1',
        'status': 'DONE',
        'responsible_name': 'Ana',
        'finished_at': '2026-01-10',
        'last_content_answers': {
          'q1': {
            'question_id': 'q1',
            'type': 'TEXT',
            'content': 'ok',
            'updated_at': 1,
          },
          'q2': {
            'question_id': 'q2',
            'type': 'FILE',
            'content': [
              {
                'name': 'a.png',
                'url': 'https://s3/a',
                'contentType': 'image/png',
                'size': 10,
              }
            ],
          },
          'q3': {
            'question_id': 'q3',
            'type': 'FILE',
            'content':
                '[{"name":"b.pdf","url":"https://s3/b","contentType":"application/pdf"}]',
          },
          'q4': {
            'question_id': 'q4',
            'type': 'FILE',
            'content': 'nao-json',
          },
          'q5': {
            'question_id': 'q5',
            'type': 'RADIO',
            'content': 'o1',
          },
        },
        'formulary': {
          'id': 'f1',
          'name': 'Form',
          'procedure_id': 'p1',
          'enabled': true,
          'questions': [
            {
              'id': 'q1',
              'name': 'Texto',
              'field_type': 'TEXT',
              'options': [
                {'id': 'o1', 'name': 'Sim', 'question_id': 'q1'}
              ],
            }
          ],
          'expressions': [
            {
              'id': 'x1',
              'factors': [
                {
                  'target_value': 'o1',
                  'origin_id': 'q1',
                  'comparison_type': 'EQ',
                }
              ],
            }
          ],
        },
        'child_tasks': [
          {
            'schedule_event_id': 'c1',
            'origin_answer': {
              'id': 'o1',
              'event_id': 'e1',
              'question_id': 'q1',
            },
          }
        ],
      },
    };
    final response = TaskflowEventResponseModel.fromJson(json);
    expect(response.data.formulary.questions.single.name, 'Texto');
    expect(response.data.childTasks?.single.scheduleEventId, 'c1');
    expect(response.toJson()['success'], isTrue);
    expect(
      TaskflowApiResponse.fromJson({
        'success': true,
        'message': 'ok',
        'legacyStatusCode': 200,
        'data': json['data'],
      }).data.id,
      'e1',
    );
  });

  test('CalendarDaysResponseModel fromJson, arrays e igualdade', () {
    final parsed = CalendarDaysResponseModel.fromJson({
      'month': 1,
      'year': 2026,
      'days': [
        {'day': 10, 'hasEvents': true, 'taskCount': 2}
      ],
    });
    expect(parsed.toEntity().days.single.taskCount, 2);
    expect(parsed.toJson()['month'], 1);

    final fromDays = CalendarDaysResponseModel.fromDaysArray(
      [
        {'day': 10, 'size': 2},
        {'date': '15/01/2026', 'tasks': [1, 2, 3]},
        {'day': 2, 'size': 0},
      ],
      1,
      2026,
    );
    expect(fromDays.days.first.day, 10);
    expect(fromDays.days.last.taskCount, 3);

    final fromTasks = CalendarDaysResponseModel.fromTasksArray(
      [
        {'dtStart': '10/01/2026'},
        {'date': '2026-01-10'},
        {'until': '11/01/2026 08:00:00'},
        {'dtStart': '10/02/2026'},
        {'date': 'xyz'},
        {'date': ''},
        'invalid',
      ],
      1,
      2026,
    );
    expect(fromTasks.days.any((d) => d.day == 10), isTrue);

    final fromEntity = CalendarDaysResponseModel.fromEntity(parsed.toEntity());
    expect(fromEntity.month, parsed.month);
    expect(fromEntity.days.single.day, 10);
    expect(parsed == parsed, isTrue);
    expect(parsed.hashCode, parsed.hashCode);
    expect(parsed.toString().contains('2026'), isTrue);
  });

  test('Requests de chat, tarefa, form e histórico json', () {
    expect(
      CreateChatChannelRequestModel.fromJson({'taskId': 't1', 'name': 'Chat'})
          .toJson()['taskId'],
      't1',
    );
    expect(CreateChatChannelResponseModel.fromJson('ch1').channelId, 'ch1');
    expect(
      CreateChatChannelResponseModel.fromJson({'data': 'ch2'}).channelId,
      'ch2',
    );

    final filter = FilterChatChannelsRequestModel.fromJson({
      'dtStart': '01/01/2026',
      'status': ['OPEN'],
    });
    expect(filter.toJson()['dtStart'], '01/01/2026');

    expect(
      const SendChatMessageRequestModel(
        channelId: 'ch1',
        content: 'oi',
        sentAt: '10/01/2026 08:00:00',
      ).toJson()['content'],
      'oi',
    );

    final create = CreateTaskRequestModel.fromJson({
      'procedureGroupId': 'g1',
      'procedureId': 'p1',
      'allDay': true,
      'dtStart': '2026-01-10',
      'repeat': true,
      'rrule': {
        'frequency': 'WEEKLY',
        'byDays': ['MO'],
      },
    });
    expect(create.toJson()['rrule'], isNotNull);
    expect(
      CreateTaskResponseModel.fromJson({
        'idSchedule': 's1',
        'idScheduleEvents': ['e1'],
      }).toJson()['idSchedule'],
      's1',
    );
    expect(
      CreateTaskFromScheduleRequestModel.fromJson({
        'scheduleId': 's1',
        'scheduleEventId': 'e1',
      }).toJson()['scheduleId'],
      's1',
    );

    final submit = SubmitFormRequestModel.fromJson({
      'event_id': 'e1',
      'answers': {
        'q1': {
          'type': 'TEXT',
          'question_id': 'q1',
          'content': 'ok',
        },
        'q2': {
          'type': 'FILE',
          'question_id': 'q2',
          'content': {
            'content_type': 'image/png',
            'local_uri': 'file://a',
            'name': 'a.png',
            'upload_task_id': 'u1',
            'firebase_ref': 'ref',
            'device_id': 'd1',
            'bucket': 'b',
            'fail_count': 0,
            'size': 10,
            'url': 'https://s3/a',
          },
        },
      },
    });
    expect(submit.toJson()['event_id'], 'e1');
    expect(
      SubmitFormResponseModel.fromJson({
        'success': true,
        'detail': 'ok',
        'data': 'd1',
      }).toJson()['success'],
      isTrue,
    );

    final edited = EditScheduleEventRequestModel.fromJson({
      'idSchedule': 's1',
      'idScheduleEvent': 'e1',
      'dtStart': '2026-01-10',
      'allDay': false,
      'repeat': true,
      'updateType': 'THIS',
      'rrule': {'frequency': 'DAILY', 'byDays': ['MO']},
    });
    expect(edited.toJson()['idSchedule'], 's1');

    expect(
      const DeleteScheduleEventRequestModel(
        scheduleEventId: 'e1',
        mode: 'THIS_SCHEDULE_EVENT',
      ).toJson()['scheduleEventId'],
      'e1',
    );
    expect(
      DeleteScheduleEventResponseModel.fromJson({
        'success': true,
        'message': 'ok',
      }).success,
      isTrue,
    );

    final history = ScheduleEventHistoryResponseModel.fromJson({
      'success': true,
      'message': 'ok',
      'data': {
        'name': 'Limpeza',
        'items': [
          {'status': 'DONE', 'responsible_name': 'Ana'}
        ],
      },
    });
    expect(history.toJson()['success'], isTrue);
    expect(history.data?.items?.single.responsibleName, 'Ana');

    final asset = TaskByAssetRequestModel.fromJson({
      'dtStart': '01/01/2026',
      'untilDate': '31/01/2026',
      'filters': {
        'typeTask': ['ROTINA'],
        'status': ['PENDENTE'],
        'dayCurrent': '10/01/2026',
      },
    });
    expect(asset.toJson()['dtStart'], '01/01/2026');
  });

  test('Vox detalhe, content send e assinatura de ponto json', () {
    final detail = AnnouncementDetailModel.fromJson({
      'id': 'a1',
      'name': 'Aviso',
      'description': 'desc',
      'content': 'texto',
      'flag_email_distribution': true,
      'pages_quantity': 1,
      'status': 'PUBLISHED',
      'recipient_list': '101,102',
    });
    expect(detail.toDetail().recipientList, '101,102');
    expect(detail.toJson()['id'], 'a1');

    final send = ContentSendModel.fromJson({
      'id_report': 'r1',
      'content': 'resposta',
    });
    expect(send.toEntity().content, 'resposta');
    expect(ContentSendModel.fromEntity(ContentSend(idReport: 'r1'))?.idReport, 'r1');

    final signature = TimesheetSignatureModel.fromJson({
      'id': 1,
      'approved_flag': true,
      'num_cra': '123',
      'notify': false,
    });
    expect(signature.toEntity().numCra, '123');
    expect(
      TimesheetSignatureModel.fromEntity(
        TimesheetSignatureEntity(id: 1, numCra: '123'),
      )?.numCra,
      '123',
    );
    expect(
      TimesheetSignatureRequestModel.fromJson({
        'signatures_request': [
          {'id': 1, 'num_cra': '123'}
        ],
      }).toJson()['signatures_request'],
      isNotEmpty,
    );
  });
}
