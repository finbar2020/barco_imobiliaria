import '../../domain/entity/schedule_events_detail_response_entity.dart';
import '../model/schedule_events_detail_response_model.dart';

class ScheduleEventsDetailModelAdapter {
  static ScheduleEventsDetailResponseEntity toEntity(
      ScheduleEventsDetailResponseModel model) {
    return ScheduleEventsDetailResponseEntity(
      success: model.success,
      message: model.message,
      data: ScheduleEventsDetailDataEntity(
        taskSummaryDay: [
          ScheduleEventTaskSummaryDayEntity(
            date: _getCurrentDateFormatted(),
            taskFormulary: model.data.taskFormulary
                .map((task) => ScheduleEventTaskFormularyEntity(
                      idSchedule: task.idSchedule ?? '',
                      idScheduleEvent: task.idScheduleEvent ?? '',
                      name: task.name ?? '',
                      dtStart: task.dtstart ?? '',
                      dtEnd: task.dtend ?? '',
                      allDay: task.allDay ?? true,
                      percentDone: '0%',
                      description: task.fullDescription ?? '',
                      procedureGroupLabel: '',
                      localsLabel: '',
                      createdAt: task.createdAt ?? '',
                      effectiveDate: task.effectiveDate ?? '',
                      updatedAt: '',
                      status: task.status ?? 'NOT_STARTED',
                      rrule: task.rrule ?? '',
                      color: '',
                      icon: '',
                      timeStart: task.timeStart ?? '',
                      timeEnd: task.timeEnd ?? '',
                      timeDescription: task.timeDescription ?? '',
                      typeTask: task.typeTask ?? 'ROTINA',
                    ))
                .toList(),
          ),
        ],
        obligations: model.data.obligations
            .map(
              (obligation) => ScheduleEventObligationEntity(
                id: obligation.id ?? '',
                collectionCode: obligation.collectionCode ?? '',
                reference: obligation.reference ?? 0,
                partnerType: obligation.partnerType ?? '',
                legalObligationType: obligation.legalObligationType ?? '',
                name: obligation.name ?? '',
                expirationDescription: obligation.expirationDescription ?? '',
                expirationDate: obligation.expirationDate ?? '',
                expirationStatus: obligation.expirationStatus ?? '',
              ),
            )
            .toList(),
      ),
      errorCode: model.errorCode,
      legacyStatusCode: model.legacyStatusCode,
    );
  }

  static String _getCurrentDateFormatted() {
    final now = DateTime.now();
    return '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
  }
}
