import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/maintenance_management/adapters/efficiency_bloc_adapter.dart';
import 'package:lello/feature/maintenance_management/adapters/maintenance_task_event_model_adapter.dart';
import 'package:lello/feature/maintenance_management/adapters/schedule_event_task_model_adapter.dart';
import 'package:lello/feature/maintenance_management/adapters/task_by_sector_model_adapter.dart';
import 'package:lello/feature/maintenance_management/adapters/task_details_model_adapter.dart';
import 'package:lello/feature/maintenance_management/adapters/task_files_model_adapter.dart';
import 'package:lello/feature/maintenance_management/adapters/task_formularies_model_adapter.dart';
import 'package:lello/feature/maintenance_management/data/adapter/create_task_adapter.dart';
import 'package:lello/feature/maintenance_management/data/adapter/delete_schedule_event_adapter.dart';
import 'package:lello/feature/maintenance_management/data/adapter/edit_schedule_event_adapter.dart';
import 'package:lello/feature/maintenance_management/data/adapter/event_details_model_adapter.dart';
import 'package:lello/feature/maintenance_management/data/adapter/schedule_events_detail_model_adapter.dart';
import 'package:lello/feature/maintenance_management/data/adapter/schedule_events_model_adapter.dart'
    hide TaskSummaryModelAdapter;
import 'package:lello/feature/maintenance_management/data/adapter/submit_form_adapter.dart';
import 'package:lello/feature/maintenance_management/data/mapper/origin_answer_mapper.dart';
import 'package:lello/feature/maintenance_management/data/model/create_task_response_model.dart';
import 'package:lello/feature/maintenance_management/data/model/delete_schedule_event_response_model.dart';
import 'package:lello/feature/maintenance_management/data/model/event_details_model.dart';
import 'package:lello/feature/maintenance_management/data/model/maintenance_task_event_model.dart';
import 'package:lello/feature/maintenance_management/data/model/maintenance_task_events_response_model.dart';
import 'package:lello/feature/maintenance_management/data/model/origin_answer_model.dart';
import 'package:lello/feature/maintenance_management/data/model/schedule_event_task_model.dart';
import 'package:lello/feature/maintenance_management/data/model/schedule_events_detail_response_model.dart';
import 'package:lello/feature/maintenance_management/data/model/schedule_events_response_model.dart';
import 'package:lello/feature/maintenance_management/data/model/submit_form_response_model.dart';
import 'package:lello/feature/maintenance_management/data/model/task_by_sector_response_model.dart';
import 'package:lello/feature/maintenance_management/data/model/task_details_model.dart'
    hide ParentScheduleEventModel;
import 'package:lello/feature/maintenance_management/data/model/task_files_model.dart';
import 'package:lello/feature/maintenance_management/data/model/task_formularies_model.dart';
import 'package:lello/feature/maintenance_management/data/model/task_summary_model.dart';
import 'package:lello/feature/maintenance_management/domain/entity/create_task_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/delete_schedule_event_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/edit_schedule_event_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/efficiency_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/origin_answer_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/submit_form_entity.dart';

FileContentEntity _file() => FileContentEntity(
      contentType: 'image/png',
      localUri: 'file://a',
      name: 'a.png',
      uploadTaskId: 'u1',
      firebaseRef: 'ref',
      deviceId: 'd1',
      bucket: 'b',
      failCount: 0,
      size: 10,
      url: 'https://s3/a',
    );

void main() {
  test('EventDetails e submit form adapters', () {
    final details = EventDetailsModelAdapter.toEntity(
      EventDetailsModel(
        id: 'e1',
        parentScheduleEvent: ParentScheduleEventModel(id: 'p1'),
        lastContentAnswers: LastContentAnswersModel(
          formularyId: 'f1',
          createdAt: '2026-01-10',
          updatedAt: '2026-01-10',
          status: 'DONE',
          taskId: 't1',
          formulary: FormularyModel(
            id: 'f1',
            name: 'Form',
            position: 1,
            procedureId: 'p1',
            enabled: true,
            createdAt: 'a',
            updatedAt: 'b',
            questions: [
              QuestionModel(
                id: 'q1',
                name: 'Pergunta',
                position: 0,
                formularyId: 'f1',
                hidden: false,
                required: true,
                createdAt: 'a',
                updatedAt: 'b',
                fieldType: 'TEXT',
                options: [
                  OptionModel(
                    id: 'o1',
                    name: 'Sim',
                    position: 0,
                    questionId: 'q1',
                    createdAt: 'a',
                    updatedAt: 'b',
                  ),
                ],
                expressions: [
                  ExpressionModel(
                    id: 'x1',
                    factors: [
                      FactorModel(
                        targetValue: '1',
                        originId: 'q1',
                        comparisonType: 'EQ',
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    expect(details.parentScheduleEvent?.id, 'p1');
    expect(details.lastContentAnswers?.formulary?.questions.single.options?.single.name,
        'Sim');

    final request = SubmitFormAdapter.toModel(
      SubmitFormRequestEntity(
        eventId: 'e1',
        answers: {
          'q1': AnswerEntity(type: 'TEXT', questionId: 'q1', content: 'ok'),
          'q2': AnswerEntity(type: 'FILE', questionId: 'q2', content: _file()),
          'q3': AnswerEntity(
            type: 'FILES',
            questionId: 'q3',
            content: [_file()],
          ),
          'q4': AnswerEntity(type: 'EMPTY', questionId: 'q4'),
        },
      ),
    );
    expect(request.eventId, 'e1');
    expect(request.answers['q1']?.content, 'ok');

    final response = SubmitFormAdapter.toEntity(
      SubmitFormResponseModel(success: true, message: 'ok', data: 'd1'),
    );
    expect(response.success, isTrue);
  });

  test('Schedule, create, edit e delete adapters', () {
    final events = ScheduleEventsResponseModel.fromJson({
      'success': true,
      'message': 'ok',
      'legacyStatusCode': 200,
      'data': {
        'taskSummaryDay': {
          'total': 2,
          'done': 1,
          'notStarted': 1,
          'draft': 0,
        },
        'taskFormulary': [
          {'idTask': 't1', 'name': 'Limpeza', 'typeTask': 'ROTINA'},
        ],
      },
    }).toEntity;
    expect(events.taskFormulary.single.name, 'Limpeza');

    final detail = ScheduleEventsDetailModelAdapter.toEntity(
      ScheduleEventsDetailResponseModel.fromJson({
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
              'name': 'Limpeza',
              'fullDescription': 'desc',
            }
          ],
          'obligations': [
            {'id': 'o1', 'name': 'AVCB', 'reference': 1},
          ],
        },
      }),
    );
    expect(detail.data.obligations.single.name, 'AVCB');
    expect(detail.data.taskSummaryDay.single.taskFormulary.single.name, 'Limpeza');

    final created = CreateTaskModelAdapter.fromEntity(
      CreateTaskRequestEntity(
        procedureGroupId: 'g1',
        procedureId: 'p1',
        allDay: true,
        dtStart: '2026-01-10',
        repeat: true,
        rrule: RruleEntity(frequency: 'WEEKLY', byDays: const ['MO']),
      ),
    );
    expect(created.rrule?.frequency, 'WEEKLY');
    expect(
      CreateTaskModelAdapter.toEntity(
        CreateTaskResponseModel(idSchedule: 's1', idScheduleEvents: const ['e1']),
      ).idSchedule,
      's1',
    );

    final edited = EditScheduleEventAdapter.fromEntity(
      EditScheduleEventRequestEntity(
        idSchedule: 's1',
        idScheduleEvent: 'e1',
        dtStart: '2026-01-10',
        allDay: false,
        repeat: true,
        updateType: 'THIS',
        rrule: EditScheduleEventRRuleEntity(frequency: 'DAILY'),
      ),
    );
    expect(edited.idSchedule, 's1');
    expect(
      EditScheduleEventAdapter.toEntity({'success': true, 'message': 'ok'}).success,
      isTrue,
    );

    expect(
      DeleteScheduleEventAdapter.fromEntity(
        const DeleteScheduleEventRequestEntity(
          scheduleEventId: 'e1',
          mode: 'THIS_SCHEDULE_EVENT',
        ),
      ).scheduleEventId,
      'e1',
    );
    expect(
      DeleteScheduleEventAdapter.toEntity(
        const DeleteScheduleEventResponseModel(success: true, message: 'ok'),
      ).success,
      isTrue,
    );
  });

  test('Task details, files, formularies, sector e events', () {
    final details = TaskDetailsModelAdapter.toEntity(
      TaskDetailsModel.fromJson({
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
      }),
    );
    expect(details.procedure?.title, 'Limpeza');
    expect(details.parentScheduleEvent?.name, 'Pai');

    expect(
      TaskFilesModelAdapter.toEntity(
        TaskFilesResponseModel.fromJson({
          'files': [
            {
              'id': 'f1',
              'task_id': 't1',
              'url': 'https://s3',
              'filename': 'a.png',
              'created_at': '2026-01-10',
              'author_id': 'u1',
              'extension': 'png',
            }
          ],
        }),
      ).files.single.filename,
      'a.png',
    );

    expect(
      TaskFormulariesModelAdapter.toEntity(
        TaskFormulariesResponseModel.fromJson({
          'formularies': [
            {'name': 'Form', 'status': 'DONE', 'position': 1, 'can_start': true}
          ],
        }),
      ).formularies.single.name,
      'Form',
    );

    expect(
      TaskBySectorResponseModelAdapter.toEntity(
        TaskBySectorResponseModel.fromJson({
          'data': [
            {'id': 's1', 'name': 'Elétrica', 'value': 4, 'color': '#fff'}
          ],
        }),
      ).data.single.name,
      'Elétrica',
    );

    expect(
      const ScheduleEventTaskModel(name: 'Limpeza', idSchedule: 's1').toEntity.name,
      'Limpeza',
    );

    final events = MaintenanceTaskEventsResponseModel(
      taskSummaryDay: TaskSummaryModel(total: 2, done: 1, notStarted: 1, draft: 0),
      taskFormulary: [
        MaintenanceTaskEventModel(
          typeTask: 'ROTINA',
          name: 'Limpeza',
          fullDescription: 'desc',
          responsibleUserable: 'u1',
          timeStart: '08:00',
          timeDescription: 'manhã',
          dtstart: '2026-01-10',
          dtstartFormatted: '10/01',
          status: 'PENDING',
          allDay: false,
        ),
      ],
    ).toEntity;
    expect(events.taskFormulary.single.name, 'Limpeza');
    expect(events.taskSummaryDay.total, 2);

    final efficiency = EfficiencyResponseEntity(
      efficiencyResponse: [
        EfficiencyItemEntity(
          id: 'g1',
          name: 'Grupo',
          done: 1,
          notStarted: 2,
          draft: 0,
        ),
      ],
      taskSummary: TaskSummaryEntity(total: 3, done: 1, notStarted: 2, draft: 0),
    );
    expect(efficiency.toBlocItems().single.title, 'Grupo');

    final origin = OriginAnswerModel(id: 'o1', eventId: 'e1', questionId: 'q1');
    expect(origin.toEntity().id, 'o1');
    expect(origin.toEntity().toModel().eventId, 'e1');
  });
}
