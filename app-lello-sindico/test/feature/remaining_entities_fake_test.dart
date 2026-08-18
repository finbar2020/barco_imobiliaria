import '../helpers/pump_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/core/extension/string_extension.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_grouped_account.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_grouped_account_entrie.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_recommendations.dart';
import 'package:lello/feature/agreements/domain/entity/agreement.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_analysis/agreement_analysis_type.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_analysis/agreements_analysis_element.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_analysis/agreements_finished.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_analysis/agreements_refused.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_quote.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_status.dart';
import 'package:lello/feature/agreements/domain/entity/agreements_all_info.dart';
import 'package:lello/feature/agreements/domain/entity/agreements_rules.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_employee_marks_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/schedule_event_task_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/schedule_events_response_entity.dart';
import 'package:lello/feature/maintenance_management/presentation/enums/efficiency_scope_enum.dart';
import 'package:lello/feature/maintenance_management/presentation/home/bloc/maintenance_management_last_week/maintenance_management_last_week_event.dart';
import 'package:lello/feature/maintenance_management/presentation/home/bloc/maintenance_management_last_week/maintenance_management_last_week_state.dart';
import 'package:lello/feature/payment/domain/entity/payment_history_item_status.dart';
import 'package:lello/feature/payment/domain/entity/update_transaction_installments_entity.dart';
import 'package:lello/feature/reports_book/domain/entity/content_send.dart';
import 'package:lello/feature/reports_book/domain/entity/report_contents.dart';
import 'package:lello/feature/reports_book/domain/entity/unit.dart';
import 'package:lello/feature/space/domain/entity/space_type.dart';
import 'package:lello/feature/staff_access_management/domain/entity/acess_type_enum.dart';
import 'package:lello/feature/staff_access_management/domain/entity/building_manager_user.dart';

void main() {
  test('AgreementQuote formata valores e data', () {
    final empty = AgreementQuote();
    expect(empty.getDate, '');
    expect(empty.fines, 0);

    final quote = AgreementQuote(
      originValue: 100,
      fineValue: 10,
      feeValue: 5,
      honoraryValue: 5,
      dueDate: DateTime(2026, 1, 10),
    );
    expect(quote.getTotalValue.contains('120'), isTrue);
    expect(quote.getOriginValue.contains('100'), isTrue);
    expect(quote.getFinesValue.contains('20'), isTrue);
    expect(quote.getDate, '10/01/2026');
  });

  test('AgreementsAllInfo separa propostas, andamento e histórico', () {
    final info = AgreementsAllInfo(
      rule: AgreementsRules(installmentQtd: 3, days: [10, 5]),
      agreements: [
        Agreement(status: AgreementStatus.pending),
        Agreement(status: AgreementStatus.approvedByManager),
        Agreement(status: AgreementStatus.approvedAutomatically),
        Agreement(status: AgreementStatus.completed),
        Agreement(status: AgreementStatus.rejected),
      ],
    );
    expect(info.agreementsProposals, hasLength(1));
    expect(info.agreementsInProgress, hasLength(2));
    expect(info.agreementsHistory, hasLength(2));
    expect(info.rule.getAllowedDays.contains('5'), isTrue);
    expect(info.rule.getMaxInstallments, '3x');
    expect(info.rule.getpaymentMethodsKeyList, isNotEmpty);
  });

  test('Análise de acordos ordena e calcula totais', () {
    final finished = AgreementsFinished(
      agreementsPerformedAutomaticallyQtd: 1,
      agreementsManuallyApprovedQtd: 2,
      reportPaymentMethod: const [],
      reportInstallments: [
        AgreementsAnalysisElement(description: '2', value: 1, percentage: 50),
      ],
      reportDueDate: [
        AgreementsAnalysisElement(description: '10', value: 1, percentage: 50),
        AgreementsAnalysisElement(description: '5', value: 1, percentage: 50),
      ],
    );
    expect(finished.getTotal, 3);
    expect(finished.isEmpty, isFalse);
    expect(finished.getReportDueDateSorted.first.description, '5');
    expect(AgreementsFinished(
      agreementsPerformedAutomaticallyQtd: 0,
      agreementsManuallyApprovedQtd: 0,
      reportPaymentMethod: const [],
      reportInstallments: const [],
      reportDueDate: const [],
    ).isEmpty, isTrue);

    final refused = AgreementsRefused(
      agreementsReprovedQtd: 1,
      reportReprovedReason: [
        AgreementsAnalysisElement(
          description: AgreementAnalysisType.dueDate,
          value: 2,
          percentage: 100,
        ),
      ],
      reportInstallments: [
        AgreementsAnalysisElement(description: '3', value: 1, percentage: 100),
      ],
      reportDueDate: [
        AgreementsAnalysisElement(description: '20', value: 1, percentage: 100),
      ],
    );
    expect(refused.getReportDueDateSorted.single.description, '20');
    expect(refused.getReportInstallmentsSorted.single.description, '3');
    expect(AgreementAnalysisType.getList, contains(AgreementAnalysisType.dueDate));
    expect(AgreementAnalysisType.getTypeKey('x'), contains('other'));
  });

  test('BuildingManagerUser, SpaceType e helpers de pagamento', () {
    final user = BuildingManagerUser(id: 'u1', name: 'Ana');
    expect(user.copyWith(email: 'a@b.com').email, 'a@b.com');
    expect(user.copyWith(accessType: AccessType.fullJanitor).accessType,
        AccessType.fullJanitor);

    expect(SpaceType()..id = 's1', SpaceType()..id = 's1');
    expect(
      UpdateTransactionInstallmentsEntity(transactionId: 1)
          .copyWith(installmentId: 2)
          .installmentId,
      2,
    );
    expect('lello'.capitalize(), 'Lello');
    expect(Unit(id: 'u1', name: '101').toString().contains('101'), isTrue);
    expect(ContentSend(idReport: 'r1').toString().contains('r1'), isTrue);
    expect(
      ReportContents(dateContent: DateTime(2026, 1, 10, 8, 30))
          .getDate()
          .contains('10/01/2026'),
      isTrue,
    );
    expect(ReportContents().getDate().contains('h'), isTrue);
  });

  test('Accountability e marcações de ponto', () {
    final account = AccountabilityGroupedAccount(
      account: 1,
      description: 'Água',
      entries: [
        AccountabilityGroupedAccaountEntrie(
          id: 1,
          date: DateTime(2026, 1, 10),
          value: 10,
          signal: '+',
          credit: 10,
          debit: 0,
          history: 'pgto',
        ),
        AccountabilityGroupedAccaountEntrie(
          id: 2,
          date: DateTime(2026, 1, 11),
          value: 3,
          signal: '-',
          credit: 0,
          debit: 3,
          history: 'ajuste',
        ),
      ],
    );
    expect(account.getTotalCredit, 10);
    expect(account.getTotalDebit, 3);
    expect(account.getTotal, 7);
    expect(account.creditOnly, isFalse);
    expect(account.entries.first.dateFormatted, '10/01/2026');
    expect(
      AccountabilityRecommendations(date: '10/01/2026 08:30').dateFormatted,
      contains('às'),
    );

    final emptyMark = TimesheetEmployeeMarksEntity(
      craNumber: '1',
      reference: 'r',
      referenceDate: DateTime(2026, 1, 10),
      type: 'IN',
      receivedMarking: '',
      occurrenceDuration: 0,
      outOfRadius: false,
    );
    expect(emptyMark.marks, 'Sem marcação');
    expect(emptyMark.convertExtraHours(), '0min');

    final mark = TimesheetEmployeeMarksEntity(
      craNumber: '1',
      reference: 'r',
      referenceDate: DateTime(2026, 1, 10),
      type: 'IN',
      receivedMarking: '08:00;12:00',
      occurrenceDuration: 90,
      outOfRadius: false,
    );
    expect(mark.marks.contains('-'), isTrue);
    expect(mark.convertExtraHours(), '1h30min');
    expect(
      TimesheetEmployeeMarksEntity(
        craNumber: '1',
        reference: 'r',
        referenceDate: DateTime(2026, 1, 10),
        type: 'IN',
        receivedMarking: '08:00',
        occurrenceDuration: 60,
        outOfRadius: false,
      ).convertExtraHours(),
      '1h',
    );
    expect(mark.convertDate.isNotEmpty, isTrue);
    expect(mark.convertAbrevDay.isNotEmpty, isTrue);
  });

  test('Schedule event entity json, igualdade e last week state', () {
    final task = ScheduleEventTaskEntity.fromJson({
      'idTask': 't1',
      'idSchedule': 's1',
      'idScheduleEvent': 'e1',
      'typeTask': 'ROTINA',
      'name': 'Limpeza',
      'fullDescription': 'desc',
      'responsibleUserable': 'u1',
      'procedureGroupId': 'g1',
      'responsibleId': 'u1',
      'timeStart': '08:00',
      'timeDescription': 'manhã',
      'dtstart': '2026-01-10',
      'dtstartFormatted': '10/01',
      'status': 'PENDING',
      'allDay': false,
    });
    expect(task.toJson()['name'], 'Limpeza');
    expect(task, task);
    expect(task.toString().contains('Limpeza'), isTrue);

    final response = ScheduleEventsResponseEntity.fromJson({
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
        'taskFormulary': [task.toJson()],
      },
    });
    expect(response.taskFormulary.single.name, 'Limpeza');
    expect(response.toJson()['success'], isTrue);
    expect(response.toString().contains('tasks: 1'), isTrue);

    const loaded = MaintenanceManagementLastWeekLoadedState(
      responsibles: [
        EfficiencyItem(
          id: 'r1',
          title: 'Ana',
          completed: 1,
          pending: 0,
          inProgress: 0,
          avatarColor: '#000',
        ),
      ],
      groups: [],
      currentScope: EfficiencyScope.responsibles,
      searchQuery: '',
    );
    expect(loaded.copyWith(searchQuery: 'ana').searchQuery, 'ana');
    expect(
      const MaintenanceManagementLastWeekErrorState('x').props,
      ['x'],
    );
    expect(
      FetchMaintenanceLastWeekEfficiencyEvent(
        startDate: DateTime(2026, 1, 1),
        endDate: DateTime(2026, 1, 7),
      ).props,
      hasLength(2),
    );
    expect(const SearchEfficiencyEvent('q').query, 'q');
    expect(
      const ChangeEfficiencyScopeEvent(EfficiencyScope.groups).scope,
      EfficiencyScope.groups,
    );
  });

  testWidgets('status de pagamento formata labels', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Builder(builder: (context) {
        expect(
          paymentHistoryItemStatusToString(
            context,
            PaymentHistoryItemStatus.paid,
          ),
          'Pago',
        );
        expect(
          paymentHistoryItemStatusToString(
            context,
            PaymentHistoryItemStatus.accounted,
          ),
          'Contabilizado',
        );
        expect(
          paymentHistoryItemStatusToString(
            context,
            PaymentHistoryItemStatus.canceled,
          ),
          'Cancelado',
        );
        expect(
          paymentHistoryItemStatusToString(
            context,
            PaymentHistoryItemStatus.suspended,
          ),
          'Suspenso',
        );
        expect(
          paymentHistoryItemStatusToString(
            context,
            PaymentHistoryItemStatus.progress,
          ),
          'Em Andamento',
        );
        return const SizedBox.shrink();
      }),
    ));
  });

  testWidgets('legenda do gráfico de parcelas do acordo', (tester) async {
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          final finished = AgreementsFinished(
            agreementsPerformedAutomaticallyQtd: 1,
            agreementsManuallyApprovedQtd: 0,
            reportPaymentMethod: const [],
            reportInstallments: [
              AgreementsAnalysisElement(
                description: '2',
                value: 4,
                percentage: 50,
              ),
            ],
            reportDueDate: const [],
          );
          final list = finished.getReportInstallmentsForChart(context);
          expect(list.single.legend.contains('4'), isTrue);
          expect(list.single.legend.contains('2x'), isTrue);
          return const SizedBox.shrink();
        },
      ),
      localized: true,
      locOverrides: const {
        'agreements_analysis_paid_in': 'pago em',
      },
    );
  });
}
