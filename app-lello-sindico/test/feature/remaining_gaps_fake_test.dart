import 'package:essentials/ui/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_periods.dart';
import 'package:lello/feature/agreements/domain/entity/agreement.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_analysis/agreement_analysis_type.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_analysis/agreements_analysis_element.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_installment.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_installment_status.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_status.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_day_appointments_check_in_data_day_item_entity.dart';
import 'package:lello/feature/maintenance_management/data/exceptions/maintenance_management_api_exception.dart';
import 'package:lello/feature/maintenance_management/data/model/chat/send_chat_message_request_model.dart';
import 'package:lello/feature/maintenance_management/domain/entity/calendar_day_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/calendar_days_response_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/chat/chat_channel_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/chat/chat_message_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/delete_schedule_event_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/efficiency_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/maintenance_task_event_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/maintenance_task_events_response_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/schedule_event_task_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/schedule_events_detail_response_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/schedule_events_response_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/task_details_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/task_by_asset_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/task_by_local_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/task_by_sector_entity.dart';
import 'package:lello/feature/maintenance_management/presentation/enums/efficiency_scope_enum.dart';
import 'package:lello/feature/maintenance_management/presentation/home/bloc/maintenance_management_last_week/maintenance_management_last_week_event.dart';
import 'package:lello/feature/maintenance_management/presentation/home/bloc/maintenance_management_last_week/maintenance_management_last_week_state.dart';
import 'package:lello/feature/payment/domain/entity/installment.dart';
import 'package:lello/feature/payment/domain/entity/send_token_request_entity.dart';
import 'package:lello/feature/reports_book/domain/entity/report.dart';
import 'package:lello/feature/reports_book/domain/entity/report_contents.dart';
import 'package:lello/feature/reports_book/domain/entity/report_filter.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';
import 'package:lello/feature/unit/domain/entity/unit_simple.dart';

void main() {
  test('Agenda detalhada cobre props de todos os nested types', () {
    const formulary = ScheduleEventTaskFormularyEntity(
      idSchedule: 's1',
      idScheduleEvent: 'e1',
      name: 'Limpeza',
      dtStart: '2026-01-10',
      dtEnd: '2026-01-10',
      allDay: false,
      percentDone: '50',
      description: 'desc',
      procedureGroupLabel: 'Grupo',
      localsLabel: 'Hall',
      createdAt: 'a',
      effectiveDate: 'b',
      updatedAt: 'c',
      status: 'OPEN',
      rrule: 'FREQ=DAILY',
      color: '#000',
      icon: 'i',
      timeStart: '08:00',
      timeEnd: '09:00',
      timeDescription: 'manhã',
      typeTask: 'OS',
    );
    const day = ScheduleEventTaskSummaryDayEntity(
      date: '2026-01-10',
      taskFormulary: [formulary],
    );
    const obligation = ScheduleEventObligationEntity(
      id: 'o1',
      collectionCode: 'c',
      reference: 2,
      partnerType: 'p',
      legalObligationType: 'PDF',
      name: 'AVCB',
      expirationDescription: 'vence',
      expirationDate: '2026-02-01',
      expirationStatus: 'ALERT',
    );
    const data = ScheduleEventsDetailDataEntity(
      taskSummaryDay: [day],
      obligations: [obligation],
    );
    const detail = ScheduleEventsDetailResponseEntity(
      success: false,
      message: 'err',
      data: data,
      errorCode: 'E1',
      legacyStatusCode: 500,
    );
    expect(formulary.props, isNotEmpty);
    expect(day.props, [day.date, day.taskFormulary]);
    expect(obligation.props.first, 'o1');
    expect(data.props, [data.taskSummaryDay, data.obligations]);
    expect(detail.props, contains('E1'));
    expect(detail, detail);
  });

  test('Schedule events response cobre fromJson com resumo, igualdade e hash', () {
    const task = ScheduleEventTaskEntity(
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
      timeDescription: 'manhã',
      dtStart: '2026-01-10',
      dtStartFormatted: '10/01/2026',
      status: 'DONE',
      allDay: true,
    );
    final entity = ScheduleEventsResponseEntity(
      success: true,
      message: 'ok',
      taskSummaryDay: TaskSummaryEntity(
        total: 2,
        done: 1,
        notStarted: 1,
        draft: 0,
        pending: 1,
      ),
      taskFormulary: const [task],
      errorCode: 'none',
      legacyStatusCode: 200,
    );
    final json = entity.toJson();
    final parsed = ScheduleEventsResponseEntity.fromJson(json);
    expect(parsed.taskSummaryDay?.pending, 1);
    expect(parsed.taskFormulary.single.name, 'Limpeza');
    expect(parsed == parsed, isTrue);
    expect(entity.hashCode, entity.hashCode);
    expect(
      ScheduleEventsResponseEntity.fromJson({
        'success': true,
        'message': 'ok',
        'legacyStatusCode': 200,
        'data': {'taskFormulary': null},
      }).taskFormulary,
      isEmpty,
    );
  });

  test('Chat cobre copyWith completo, pageInfo e canais', () {
    const profile = ChatAuthorProfileEntity(
      id: 'p1',
      name: 'Perfil',
      description: 'desc',
    );
    const author = ChatAuthorEntity(
      id: 'u1',
      name: 'Ana',
      email: 'a@b.com',
      imageUrl: 'https://img',
      username: 'ana',
      status: 'online',
      profile: profile,
    );
    const attachment = ChatAttachmentEntity(
      id: 'a1',
      name: 'foto.png',
      url: 'https://s3',
      attachmentType: 'image',
      fileSize: '10kb',
    );
    final created = DateTime(2026, 1, 10);
    final message = ChatMessageEntity(
      id: 'm1',
      content: 'oi',
      channelId: 'ch1',
      authorId: 'u1',
      messageType: 'TEXT',
      createdAt: created,
      author: author,
      attachment: attachment,
    );
    final copied = message.copyWith(
      id: 'm2',
      content: 'novo',
      channelId: 'ch2',
      authorId: 'u2',
      messageType: 'FILE',
      createdAt: DateTime(2026, 2, 1),
      author: author,
      attachment: attachment,
      isUnread: true,
      isSending: true,
      isFailed: true,
    );
    expect(copied.id, 'm2');
    expect(copied.isUnread, isTrue);
    expect(copied, copied);
    expect(message.props, isNotEmpty);
    expect(author.props, contains('online'));
    expect(profile.props, contains('desc'));
    expect(attachment.props, contains('10kb'));

    const task = ChannelTaskEntity(id: 't1', name: 'Limpeza');
    final last = ChannelLastMessageEntity(
      id: 'lm1',
      createdAt: created,
      author: const MessageAuthorEntity(id: 'u1', name: 'Ana', email: 'a@b.com'),
    );
    expect(
      last.copyWith(
        id: 'lm2',
        content: 'x',
        createdAt: DateTime(2026, 3, 1),
        author: const MessageAuthorEntity(id: 'u2', name: 'B', email: 'b@b.com'),
      ).id,
      'lm2',
    );
    final channel = ChatChannelEntity(
      id: 'ch1',
      typeTask: 'OS',
      status: 'OPEN',
      task: task,
    );
    expect(channel.hasUnread, isFalse);
    expect(
      channel
          .copyWith(
            id: 'ch2',
            typeTask: 'ROTINA',
            status: 'DONE',
            task: task,
            lastMessage: last,
            hasUnreadMessages: true,
          )
          .props,
      isNotEmpty,
    );
    expect(
      const ChatChannelsResponseEntity(
        channels: [],
        pageInfo: PageInfoEntity(
          hasNextPage: false,
          hasPreviousPage: true,
          startCursor: 'a',
          endCursor: 'b',
        ),
        ttJwtToken: 'jwt',
      ).props,
      contains('jwt'),
    );
    expect(
      const PageInfoEntity(
        hasNextPage: false,
        hasPreviousPage: true,
        startCursor: 'a',
        endCursor: 'b',
      ).props,
      contains('a'),
    );
  });

  test('Last week events, error state e copyWith de busca', () {
    final start = DateTime(2026, 1, 1);
    final end = DateTime(2026, 1, 7);
    expect(
      FetchMaintenanceLastWeekEfficiencyEvent(startDate: start, endDate: end)
          .props,
      [start, end],
    );
    expect(const SearchEfficiencyEvent('ana').props, ['ana']);
    expect(
      const ChangeEfficiencyScopeEvent(EfficiencyScope.responsibles).props,
      [EfficiencyScope.responsibles],
    );
    expect(
      const MaintenanceManagementLastWeekErrorState('falhou').props,
      ['falhou'],
    );
    const item = EfficiencyItem(
      id: '1',
      title: 'Ana',
      completed: 1,
      pending: 0,
      inProgress: 0,
      avatarColor: '#fff',
    );
    final loaded = MaintenanceManagementLastWeekLoadedState(
      responsibles: const [item],
      groups: const [],
      currentScope: EfficiencyScope.groups,
      searchQuery: '',
    );
    expect(loaded.copyWith(searchQuery: 'x').searchQuery, 'x');
    expect(loaded.props, isNotEmpty);
    expect(MaintenanceManagementLastWeekInitialState().props, isEmpty);
    expect(MaintenanceManagementLastWeekLoadingState().props, isEmpty);
    expect(item.props.contains(null), isTrue);
    expect(
      const MaintenanceManagementLastWeekErrorState('falhou'),
      const MaintenanceManagementLastWeekErrorState('falhou'),
    );
  });

  test('Entidades de gráfico, exclusão, eventos e token/parcela', () {
    expect(
      const TaskBySectorResponseEntity(data: [
        TaskBySectorDataEntity(id: '1', name: 'A', value: 2, color: '#000'),
      ]).props,
      isNotEmpty,
    );
    expect(
      const TaskByLocalResponseEntity(data: [
        TaskByLocalDataEntity(
          id: '1',
          name: 'Hall',
          done: 1,
          draft: 0,
          notStarted: 0,
          total: 1,
        ),
      ]).data.single.props,
      contains('Hall'),
    );
    expect(
      const TaskByAssetResponseEntity(
        dataTaskByAssetResponse: [
          TaskByAssetDataEntity(id: 1, name: 'Bomba', total: 3),
        ],
      ).props,
      isNotEmpty,
    );
    expect(
      const DeleteScheduleEventResponseEntity(success: true, message: 'ok')
          .props,
      [true, 'ok'],
    );

    final event = MaintenanceTaskEventEntity(
      typeTask: 'ROTINA',
      name: 'Limpeza',
      fullDescription: 'desc',
      responsibleUserable: 'Ana',
      timeStart: '08:00',
      timeEnd: '09:00',
      timeDescription: 'manhã',
      dtstart: '2026-01-10T08:00:00.000',
      dtend: '2026-01-10T09:00:00.000',
      dtstartFormatted: '10/01/2026',
      dtendFormatted: '10/01/2026',
      status: 'DONE',
      allDay: false,
    );
    expect(event.title, 'Limpeza');
    expect(event.dtStart.year, 2026);
    expect(event.untilDate.hour, 9);
    expect(
      MaintenanceTaskEventsResponseEntity(
        taskSummaryDay:
            TaskSummaryEntity(total: 1, done: 1, notStarted: 0, draft: 0),
        taskFormulary: [event],
      ).events.single.name,
      'Limpeza',
    );

    final token = SendTokenRequestEntity(method: 'sms', value: '1199');
    expect(token.copyWith(method: 'email', value: 'a@b.com').method, 'email');
    final installment = InstallmentEntity(
      id: 1,
      dueDate: DateTime(2026, 1, 10),
      value: 12.34,
      paymentFormId: 1,
      paymentTypeId: 2,
      agency: '0001',
      bankId: 33,
      accountDigit: '1',
      accountNumber: '123',
      accountType: 'CC',
    );
    expect(installment.valueInt, 1234);
    expect(
      installment
          .copyWith(
            id: 2,
            dueDate: DateTime(2026, 2, 1),
            value: 10,
            paymentFormId: 3,
            paymentTypeId: 4,
            agency: '0002',
            bankId: 1,
            accountDigit: '9',
            accountNumber: '999',
            accountType: 'CP',
          )
          .id,
      2,
    );
  });

  test('Accountability, relatório, unidade, timesheet e exception', () {
    final approved = AccountabilityPeriods(
      period: DateTime(2026, 1, 1),
      situation: 'APROVADA',
      approvalDate: DateTime(2026, 1, 10),
    );
    expect(approved.isAproved, isTrue);
    expect(approved.getDropColor, Colors.green);
    expect(approved.getFormattedDate, isNotEmpty);
    expect(
      AccountabilityPeriods(
        period: DateTime(2026, 1, 1),
        situation: 'PENDENTE',
        approvalDate: null,
      ).getFormattedDate,
      '',
    );

    final theme = LelloTheme.light;
    expect(
      AgreementsAnalysisElement(description: '1', value: 1, percentage: 10)
          .getColor(theme, AgreementAnalysisType.installmentQtd),
      isA<Color>(),
    );
    expect(
      AgreementsAnalysisElement(description: '1', value: 1, percentage: 10)
          .getColor(theme, AgreementAnalysisType.dueDate),
      isA<Color>(),
    );
    expect(
      AgreementsAnalysisElement(description: '1', value: 1, percentage: 10)
          .getColor(theme, 'x') ==
          null,
      isTrue,
    );
    expect(AgreementAnalysisType.getList, hasLength(2));
    expect(AgreementAnalysisType.getTypeKey('x'), contains('other'));

    final contents = ReportContents(
      id: '1',
      dateContent: DateTime(2026, 1, 10, 8, 30),
    );
    expect(contents.getDate(), contains('10/01/2026'));
    expect(ReportContents().getDate(), contains('h'));
    expect(contents.toString(), contains('1'));
    expect(Report().toString(), contains('Report'));

    final filter = ReportFilter(dateFrom: DateTime(2026, 1, 1));
    filter.unitName = '101';
    expect(filter.toString(), contains('101'));

    expect(Unit.fromUnitSimple(UnitSimple(id: 'u1', title: '101')).title, '101');
    expect(
      TimesheetDayAppointmentsCheckInDataDayItem(
        photoHash: 'h',
        checkInDateTime: DateTime(2026, 1, 10),
        distance: 1500,
        latitude: 1,
        longitude: 2,
        outOfRadius: false,
      ).distanceInKilometers,
      contains('1.5'),
    );
    expect(
      MaintenanceManagementApiException('E1', 'falhou').toString(),
      contains('E1'),
    );

    const request = SendChatMessageRequestModel(
      channelId: 'ch1',
      content: 'oi',
      sentAt: '10/01/2026 08:00:00',
    );
    expect(
      SendChatMessageRequestModel.fromJson(request.toJson()).content,
      'oi',
    );

    expect(
      Agreement(status: AgreementStatus.pending).getStatusColor(theme),
      isA<Color>(),
    );
    expect(
      AgreementInstallment(status: AgreementInstallmentsStatus.pending)
          .getStatusColor(theme),
      isA<Color>(),
    );

    final dayA = CalendarDayEntity(day: 10, hasEvents: true, taskCount: 2);
    final dayB = CalendarDayEntity(day: 10, hasEvents: true, taskCount: 2);
    expect(dayA == dayB, isTrue);
    expect(dayA.hashCode, dayB.hashCode);
    expect(
      dayA == const CalendarDayEntity(day: 11, hasEvents: false, taskCount: 0),
      isFalse,
    );
    final days = [dayA];
    final calA = CalendarDaysResponseEntity(month: 1, year: 2026, days: days);
    final calB = CalendarDaysResponseEntity(month: 1, year: 2026, days: days);
    expect(calA == calB, isTrue);
    expect(calA.hashCode, calB.hashCode);

    const task = ChannelTaskEntity(id: 't1', name: 'Limpeza');
    expect(task, const ChannelTaskEntity(id: 't1', name: 'Limpeza'));
    expect(task.props, ['t1', 'Limpeza']);
    const author = MessageAuthorEntity(id: 'u1', name: 'Ana', email: 'a@b.com');
    expect(author, author);
    expect(author.props, contains('Ana'));

    final installment = InstallmentEntity(
      id: 1,
      dueDate: DateTime(2026, 1, 10),
      value: 12.34,
      paymentFormId: 1,
      agency: '0001',
    );
    final copied = installment.copyWith(
      dueDate: DateTime(2026, 2, 1),
      value: 10,
    );
    expect(copied.id, 1);
    expect(copied.agency, '0001');
    expect(copied.paymentFormId, 1);
  });

  test('TaskDetails getters e igualdade de schedule events', () {
    final nestedUser = TaskDetailsUserEntity(
      id: 'u2',
      name: 'Bia',
      references: const [],
    );
    final details = TaskDetailsEntity(
      id: 't1',
      name: 'Limpeza',
      status: 'OPEN',
      typeTask: 'ROTINA',
      allDay: true,
      task: TaskDetailsTaskEntity(id: 't1', currentUser: nestedUser),
    );
    expect(details.title, 'Limpeza');
    expect(details.effectiveCurrentUser?.name, 'Bia');
    expect(TaskDetailsRRuleEntity(frequency: 'WEEKLY').isWeekly, isTrue);
    expect(TaskDetailsRRuleEntity(frequency: 'DAILY').isDaily, isTrue);

    final tasks = <ScheduleEventTaskEntity>[];
    final a = ScheduleEventsResponseEntity(
      success: true,
      message: 'ok',
      taskFormulary: tasks,
      legacyStatusCode: 200,
    );
    final b = ScheduleEventsResponseEntity(
      success: true,
      message: 'ok',
      taskFormulary: tasks,
      legacyStatusCode: 200,
    );
    expect(a == b, isTrue);
    expect(a.hashCode, b.hashCode);
  });
}
