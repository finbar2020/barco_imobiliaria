import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/access_management/data/model/url_upload_s3_model.dart';
import 'package:lello/feature/gdp/timesheet/data/model/timesheet_signature_model.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_appointments_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_collaborator_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_condo_location_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_day_appointments_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_signature_entity.dart';
import 'package:lello/feature/maintenance_management/data/model/calendar_day_model.dart';
import 'package:lello/feature/maintenance_management/data/model/calendar_days_response_model.dart';
import 'package:lello/feature/maintenance_management/data/model/efficiency_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/formulary_by_month_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/maintenance_task_events_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/origin_answer_model.dart';
import 'package:lello/feature/maintenance_management/data/model/taskflow_event_model.dart';
import 'package:lello/feature/reports_book/data/model/content_send_model.dart';
import 'package:lello/feature/reports_book/domain/entity/content_send.dart';
import 'package:lello/feature/splash/data/model/boot_data_model.dart';
import 'package:lello/feature/splash/domain/entity/boot_data.dart';

void main() {
  test('toJson gerado dos filters, signature, content e s3', () {
    expect(
      EfficiencyFiltersModel(
        typeTask: const ['ROTINA'],
        dayCurrent: '10/01/2026',
        procedureGroupLabels: const [],
        procedureGroupIds: const [],
        responsibleIds: const [],
        displayBy: 'GRUPO',
        status: const [],
      ).toJson()['displayBy'],
      'GRUPO',
    );
    expect(
      MaintenanceTaskEventsRequestFiltersModel(
        typeTask: const ['ROTINA'],
        procedureGroupLabels: const [],
        displayBy: 'GRUPO',
        status: const [],
        dayCurrent: '10/01/2026',
        assetIds: const [],
        localIds: const [],
        responsibleIds: const [],
      ).toJson()['dayCurrent'],
      '10/01/2026',
    );
    expect(
      const FormularyByMonthFiltersModel(
        typeTask: ['ROTINA'],
        status: [],
        dayCurrent: '10/01/2026',
        responsibleIds: [],
        localIds: [],
        assetIds: [],
      ).toJson()['localIds'],
      isEmpty,
    );
    expect(
      TimesheetSignatureModel(
        id: 1,
        approvedFlag: true,
        numCra: '123',
        notify: false,
      ).toJson()['num_cra'],
      '123',
    );
    expect(
      TimesheetSignatureModel.fromEntity(
        TimesheetSignatureEntity(id: 2, numCra: '9'),
      )?.toJson()['id'],
      2,
    );
    expect(
      ContentSendModel(idReport: 'r1', content: 'ok').toJson()['content'],
      'ok',
    );
    expect(ContentSendModel.fromEntity(null), isNull);
    expect(
      ContentSendModel.fromEntity(ContentSend(idReport: 'r1', content: 'x'))
          ?.toJson()['id_report'],
      'r1',
    );
    expect(
      UrlUploadS3Model(fileName: 'a.pdf', url: 'https://s3').toJson()['url'],
      'https://s3',
    );
    expect(
      UrlUploadS3Model.fromEntity(
        UrlUploadS3Model(fileName: 'b.pdf', url: 'https://s3/b').toEntity(),
      ).toJson()['file_name'],
      'b.pdf',
    );
  });

  test('BootDataModel fromEntity nulo e roundtrip', () {
    expect(BootDataModel.fromEntity(null), isNull);
    expect(
      BootDataModel.fromEntity(BootData()..showOnBoarding = true)
          ?.toEntity()
          .showOnBoarding,
      isTrue,
    );
    expect(
      (BootDataModel()..showOnBoarding = false).toEntity().showOnBoarding,
      isFalse,
    );
  });

  test('DayAppointmentsEntity cobrem showItem, marks e foto', () {
    final empty = DayAppointmentsEntity(
      collaborator: CollaboratorEntity(name: 'Ana'),
      appointments: const [],
      condoLocation: CondoLocationEntity(
        reference: 'portaria',
        latitude: 0,
        longitude: 0,
      ),
    );
    expect(empty.showItem, isFalse);
    expect(empty.marks, 'Sem marcação');
    expect(empty.pictureLink, '');

    final withPhoto = DayAppointmentsEntity(
      collaborator: CollaboratorEntity(name: 'Ana', photo: 'https://img'),
      appointments: [
        AppointmentsEntity(
          numCad: '1',
          reference: 'portaria',
          photo: '',
          date: DateTime(2026, 1, 10, 8, 30),
          distance: 1,
        ),
      ],
      condoLocation: CondoLocationEntity(
        reference: 'portaria',
        latitude: 0,
        longitude: 0,
      ),
    );
    expect(withPhoto.showItem, isTrue);
    expect(withPhoto.marks.contains('08:30'), isTrue);
    expect(withPhoto.pictureLink, 'https://img');
  });

  test('calendário cobre regex de data, == e hashCode', () {
    final fromRegex = CalendarDaysResponseModel.fromTasksArray(
      [
        {'date': 'dia 10-1-2026'},
      ],
      1,
      2026,
    );
    expect(fromRegex.days.any((d) => d.day == 10), isTrue);

    final days = [
      const CalendarDayModel(day: 1, hasEvents: true, taskCount: 2),
    ];
    final a = CalendarDaysResponseModel(month: 1, year: 2026, days: days);
    final b = CalendarDaysResponseModel(month: 1, year: 2026, days: days);
    expect(a == b, isTrue);
    expect(a.hashCode, b.hashCode);
    expect(
      a == CalendarDaysResponseModel(month: 2, year: 2026, days: days),
      isFalse,
    );
  });

  test('taskflow toJson e file fromJson sem id', () {
    final file = TaskflowFileModel.fromJson({
      'name': 'foto.png',
      'contentType': 'image/png',
      'url': 'https://s3/foto.png',
    });
    expect(file.id, isNotEmpty);
    expect(file.toJson()['name'], 'foto.png');

    final event = TaskflowEventModel(
      id: 'e1',
      formularyId: 'f1',
      status: 'DONE',
      responsibleName: 'Ana',
      formulary: TaskflowFormularyModel(
        id: 'f1',
        name: 'Form',
        questions: const [],
      ),
    );
    expect(
      TaskflowApiResponse(
        success: true,
        message: 'ok',
        data: event,
        errorCode: null,
        legacyStatusCode: 200,
      ).toJson()['legacyStatusCode'],
      200,
    );
    expect(
      TaskflowChildTaskModel(
        scheduleEventId: 'e1',
        originAnswer: OriginAnswerModel(id: 'a1', eventId: 'e1', questionId: 'q1'),
      ).toJson()['schedule_event_id'],
      'e1',
    );
    expect(TaskflowChildTaskModel().toJson()['origin_answer'], isNull);
  });
}
