import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/maintenance_management/data/model/calendar_day_model.dart';
import 'package:lello/feature/maintenance_management/data/model/child_task_model.dart';
import 'package:lello/feature/maintenance_management/data/model/origin_answer_model.dart';
import 'package:lello/feature/maintenance_management/data/model/parent_schedule_event_model.dart';
import 'package:lello/feature/maintenance_management/data/model/upload_legal_obligation_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/upload_legal_obligation_response_model.dart';
import 'package:lello/feature/maintenance_management/domain/entity/calendar_day_entity.dart';

void main() {
  test('CalendarDayModel json, entity e igualdade', () {
    final parsed = CalendarDayModel.fromJson({
      'day': 10,
      'hasEvents': true,
      'taskCount': 3,
    });
    expect(parsed.taskCount, 3);
    expect(parsed.toEntity().hasEvents, isTrue);
    expect(parsed.toJson()['day'], 10);
    final fromEntity = CalendarDayModel.fromEntity(
      CalendarDayEntity(day: 10, hasEvents: true, taskCount: 3),
    );
    expect(fromEntity, parsed);
    expect(fromEntity.hashCode, parsed.hashCode);
    expect(parsed.toString().contains('taskCount: 3'), isTrue);
  });

  test('OriginAnswer, ChildTask e ParentScheduleEvent json', () {
    final origin = OriginAnswerModel.fromJson({
      'id': 'o1',
      'event_id': 'e1',
      'question_id': 'q1',
    });
    expect(origin.eventId, 'e1');
    expect(origin.toJson()['question_id'], 'q1');
    expect(
      origin,
      OriginAnswerModel(id: 'o1', eventId: 'e1', questionId: 'q1'),
    );

    final child = ChildTaskModel.fromJson({
      'scheduleEventId': 'e1',
      'originAnswer': {
        'id': 'o1',
        'event_id': 'e1',
        'question_id': 'q1',
      },
    });
    expect(child.originAnswer?.id, 'o1');
    expect(child.toJson()['scheduleEventId'], 'e1');

    final parent = ParentScheduleEventModel.fromJson({
      'id': 'p1',
      'name': 'Pai',
    });
    expect(parent.name, 'Pai');
    expect(parent.toJson()['id'], 'p1');
  });

  test('Upload legal obligation request/response json', () {
    final request = UploadLegalObligationRequestModel.fromJson({
      'type': 'PDF',
      'id': '1',
      'fileName': 'laudo.pdf',
      'fileUrl': 'https://s3',
      'date': '2026-01-10',
    });
    expect(request.fileName, 'laudo.pdf');
    expect(request.toJson()['fileUrl'], 'https://s3');

    final response = UploadLegalObligationResponseModel.fromJson({
      'link': 'https://s3/laudo.pdf',
      'success': true,
      'error_code': null,
    });
    expect(response.success, isTrue);
    expect(response.toJson()['link'], 'https://s3/laudo.pdf');
  });
}
