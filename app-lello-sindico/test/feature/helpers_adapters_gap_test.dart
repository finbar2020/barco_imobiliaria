import 'dart:typed_data';

import 'package:essentials/ui/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/agreements/domain/entity/agreement.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_analysis/agreements_analysis_element.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_analysis/agreements_finished.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_analysis/agreements_refused.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_installment.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_installment_status.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_status.dart';
import 'package:lello/feature/agreements/domain/entity/payment_method.dart';
import 'package:lello/feature/condominium/data/model/condominium_balance_model.dart';
import 'package:lello/feature/condominium/data/model/condominium_model.dart';
import 'package:lello/feature/condominium/data/model/layout_model.dart';
import 'package:lello/feature/condominium/domain/entity/condominium.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_balance.dart';
import 'package:lello/feature/condominium/domain/entity/layout.dart';
import 'package:lello/feature/maintenance_management/data/adapter/schedule_events_model_adapter.dart';
import 'package:lello/feature/maintenance_management/data/model/schedule_events_detail_response_model.dart';
import 'package:lello/feature/maintenance_management/domain/entity/efficiency_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/schedule_event_task_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/schedule_events_response_entity.dart';
import 'package:lello/feature/maintenance_management/presentation/enums/efficiency_scope_enum.dart';
import 'package:lello/feature/maintenance_management/presentation/home/bloc/maintenance_management_last_week/maintenance_management_last_week_state.dart';
import 'package:lello/feature/reports_book/domain/entity/report.dart';
import 'package:lello/feature/reports_book/domain/entity/report_filter.dart';
import 'package:lello/feature/vox/data/model/announcement_create_model.dart';
import 'package:lello/feature/vox/data/model/announcement_request_model.dart';
import 'package:lello/feature/vox/data/model/document_attachment_model.dart';
import 'package:lello/feature/vox/data/model/fine_request_model.dart';
import 'package:lello/feature/vox/data/model/warning_create_model.dart';
import 'package:lello/feature/vox/data/model/warning_request_model.dart';
import 'package:lello/feature/vox/domain/entity/document_attachment.dart';
import 'package:lello/feature/vox/domain/entity/document_request.dart';
import 'package:lello/feature/vox/domain/entity/recipient_type.dart';

void main() {
  final theme = LelloTheme.light;

  test('Agreement formata valores, datas, status e parcelas', () {
    expect(Agreement().unitAndNameDescription, '');
    expect(Agreement(unitOwner: 'ana').unitAndNameDescription, 'ANA');
    expect(Agreement(unit: '101').unitAndNameDescription, '101');
    expect(
      Agreement(unit: '101', unitOwner: 'ana').unitAndNameDescription,
      '101 - ANA',
    );

    final big = Agreement(baseValue: 1200, fineAndCosts: 50);
    expect(big.getTotalValueFormatted.contains('1.250'), isTrue);
    expect(Agreement(baseValue: 10).getTotalValueFormatted, 'R\$ 10,00');
    expect(Agreement().getApprovalDate, '-');
    expect(Agreement().getProposalDate, '-');
    expect(
      Agreement(approvalDate: DateTime(2026, 1, 10)).getApprovalDate,
      '10/01/2026',
    );
    expect(
      Agreement(proposaldedDate: DateTime(2026, 2, 1)).getProposalDate,
      '01/02/2026',
    );
    expect(Agreement(paymentMethod: PaymentMethod.billet).getPaymentMethodKey,
        'agreements_billet');
    expect(Agreement(paymentMethod: PaymentMethod.credit).getPaymentMethodKey,
        'agreements_credit_card');
    expect(Agreement().getPaymentMethodKey, '');
    expect(Agreement(status: AgreementStatus.pending).getStatusKey,
        'agreements_pendency');
    expect(Agreement().getInstallmentsAndValue, '-');
    expect(
      Agreement(installmentQuantity: 2, baseValue: 100).getInstallmentsAndValue,
      contains('2x'),
    );
    expect(
      Agreement(installments: [
        AgreementInstallment(value: 50, status: AgreementInstallmentsStatus.pending),
      ]).getInstallmentsAndValue,
      contains('1x'),
    );
    expect(Agreement().getExpirationDay, '-');
    expect(Agreement(dueDate: 10).getExpirationDay, '10');
    expect(
      Agreement(installments: [
        AgreementInstallment(value: 20, status: AgreementInstallmentsStatus.pending),
        AgreementInstallment(value: 10, status: AgreementInstallmentsStatus.paid),
      ]).getAmountReceivable,
      20,
    );
    expect(
      Agreement(installments: [
        AgreementInstallment(status: AgreementInstallmentsStatus.pending),
        AgreementInstallment(status: AgreementInstallmentsStatus.paid),
      ]).getPendingOverTotalInstallments,
      '1/2',
    );

    for (final status in AgreementStatus.getList) {
      expect(AgreementStatus.getStatusKey(status), isNotEmpty);
      expect(AgreementStatus.getStatusColor(theme, status), isA<Color>());
    }
    expect(AgreementStatus.getStatusKey('x'), '');
    expect(AgreementStatus.getStatusColor(theme, 'x'), isA<Color>());
    expect(PaymentMethod.getList, hasLength(2));

    for (final status in AgreementInstallmentsStatus.getList) {
      expect(AgreementInstallmentsStatus.getStatusKey(status), isNotEmpty);
      expect(AgreementInstallmentsStatus.getStatusColor(theme, status), isA<Color>());
    }
    expect(AgreementInstallmentsStatus.getStatusKey('x'), '');
    expect(
      AgreementInstallment(status: AgreementInstallmentsStatus.paid).getStatusKey,
      'agreements_installment_paid',
    );
  });

  test('Report e ReportFilter cobrem tipos e períodos', () {
    final report = Report(dateReport: DateTime(2026, 1, 10, 8, 30));
    expect(report.getDate(), contains('10/01/2026'));
    expect(report.getTypesReport, contains('COMPLAINT'));
    expect(report.toString(), contains('Report'));
    expect(Report(typeReport: 'x').getTypeReport, '');
    for (final pair in {
      'Sugestões': 'SUGGESTION',
      'Suggestion': 'SUGGESTION',
      'Reclamações': 'COMPLAINT',
      'Complaint': 'COMPLAINT',
      'Elogios': 'COMPLIMENT',
      'Compliment': 'COMPLIMENT',
      'Violência não': 'VIOLENCE_NO',
      'Violence no': 'VIOLENCE_NO',
      'Outros': 'OTHERS',
      'Others': 'OTHERS',
    }.entries) {
      report.setTypeReport(pair.key);
      expect(report.typeReport, pair.value);
      expect(report.getTypeReport, isNotEmpty);
    }
    report.setTypeReport('desconhecido');

    final filter = ReportFilter(
      dateFrom: DateTime(2026, 1, 1),
      dateTo: DateTime(2026, 1, 31),
    )..unitName = '101';
    expect(filter.toString(), contains('ReportFilter'));
    expect(filter.getUnidId(), '101');
    expect(filter.getPeriodReport(), contains('01/01/2026'));
    expect(ReportFilter().getPeriodReport(), ' - ');
    for (final type in [
      'Reclamações',
      'Complaint',
      'Sugestões',
      'Suggestion',
      'Elogios',
      'Compliment',
      'Outros',
      'Others',
    ]) {
      filter.setTypeReport(type);
      expect(filter.getTypeReport(), isNotEmpty);
    }
    filter.setTypeReport('x');
    expect(filter.getTypeReport(), isNotEmpty);
    for (final status in ['Abertas', 'Open', 'Encerradas', 'Closed', 'Todas', 'All']) {
      filter.setStatusReport(status);
      expect(filter.getStatusReport(), isNotEmpty);
    }
    filter.setStatusReport('x');
  });

  test('Análise de acordos ordena sem localização', () {
    final refused = AgreementsRefused(
      agreementsReprovedQtd: 1,
      reportReprovedReason: const [],
      reportInstallments: [
        AgreementsAnalysisElement(description: '10', value: 1, percentage: 50),
        AgreementsAnalysisElement(description: '2', value: 1, percentage: 50),
      ],
      reportDueDate: [
        AgreementsAnalysisElement(description: '20', value: 1, percentage: 50),
        AgreementsAnalysisElement(description: '5', value: 1, percentage: 50),
      ],
    );
    expect(refused.getReportInstallmentsSorted.first.description, '2');
    expect(refused.getReportDueDateSorted.first.description, '5');

    expect(
      AgreementsFinished(
        agreementsPerformedAutomaticallyQtd: 0,
        agreementsManuallyApprovedQtd: 0,
        reportPaymentMethod: const [],
        reportInstallments: const [],
        reportDueDate: const [],
      ).isEmpty,
      isTrue,
    );
    final finished = AgreementsFinished(
      agreementsPerformedAutomaticallyQtd: 1,
      agreementsManuallyApprovedQtd: 2,
      reportPaymentMethod: const [],
      reportInstallments: [
        AgreementsAnalysisElement(description: '3', value: 1, percentage: 50),
      ],
      reportDueDate: [
        AgreementsAnalysisElement(description: '8', value: 1, percentage: 50),
        AgreementsAnalysisElement(description: '1', value: 1, percentage: 50),
      ],
    );
    expect(finished.isEmpty, isFalse);
    expect(finished.getTotal, 3);
    expect(finished.getReportDueDateSorted.first.description, '1');
  });

  test('Schedule events adapter, entity json e last week states', () {
    final detail = ScheduleEventsDetailResponseModel.fromJson({
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
          {'idSchedule': 's1', 'idScheduleEvent': 'e1', 'name': 'Limpeza'},
        ],
        'obligations': [
          {'id': 'o1', 'name': 'AVCB', 'reference': 1},
        ],
      },
    });
    expect(detail.toEntity.taskFormulary.single.name, 'Limpeza');
    expect(detail.data.taskSummaryDay.toEntity.total, 1);
    expect(detail.data.toJson(), isNotEmpty);
    expect(detail.data.taskFormulary.single.toJson()['name'], 'Limpeza');
    expect(detail.data.obligations.single.toJson()['id'], 'o1');
    expect(detail.toJson()['success'], isTrue);

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
      rrule: 'FREQ=DAILY',
      rruleDescription: 'diário',
      allDay: false,
    );
    expect(task, ScheduleEventTaskEntity.fromJson(task.toJson()));
    expect(task.hashCode, task.hashCode);
    expect(task.toString(), contains('Limpeza'));

    final emptySummary = ScheduleEventsResponseEntity(
      success: true,
      message: 'ok',
      taskFormulary: const [],
      legacyStatusCode: 200,
    );
    expect(emptySummary.toJson()['data']['taskSummaryDay'] == null, isTrue);
    expect(emptySummary == emptySummary, isTrue);
    expect(emptySummary.toString(), contains('tasks: 0'));

    expect(MaintenanceManagementLastWeekInitialState(), isA<MaintenanceManagementLastWeekState>());
    expect(MaintenanceManagementLastWeekLoadingState(), isA<MaintenanceManagementLastWeekState>());
    const item = EfficiencyItem(
      id: '1',
      title: 'Ana',
      subtitle: 'x',
      completed: 1,
      pending: 2,
      inProgress: 3,
      avatarColor: '#000',
    );
    expect(item, item);
    final loaded = MaintenanceManagementLastWeekLoadedState(
      responsibles: const [item],
      groups: const [item],
      currentScope: EfficiencyScope.groups,
      searchQuery: 'a',
      taskSummary: TaskSummaryEntity(total: 1, done: 1, notStarted: 0, draft: 0),
    );
    expect(
      loaded
          .copyWith(
            isLoadingList: true,
            currentScope: EfficiencyScope.responsibles,
            groups: const [],
            responsibles: const [],
            taskSummary: TaskSummaryEntity(total: 2, done: 0, notStarted: 2, draft: 0),
          )
          .isLoadingList,
      isTrue,
    );
  });

  test('Condomínio e saldo roundtrip de model', () {
    final condo = CondominiumModel.fromJson({
      'id': 'c1',
      'reference': 'r1',
      'name': 'Edifício',
      'number': '10',
      'address': 'Rua',
      'regulation_url': 'https://x',
      'use_facial_biometric': true,
      'manager_access_control_biometric_status': 'unavailable',
      'notification_context': 'n',
      'layout': {
        'cod': 'l1',
        'name': 'azul',
        'reference': 'r',
        'primary': '#000',
        'secondary': '#fff',
        'logo_path': '/logo',
      },
    });
    expect(condo.toJson()['id'], 'c1');
    expect(condo.layout!.toJson()['cod'], 'l1');
    expect(condo.toEntity().name, 'Edifício');
    expect(
      CondominiumModel.fromEntity(const Condominium(
        id: 'c1',
        reference: 'r1',
        layout: null,
      ))!
          .id,
      'c1',
    );
    expect(
      LayoutModel.fromEntity(Layout(cod: 'x', name: 'n'))!.toEntity().cod,
      'x',
    );

    final balance = CondominiumBalanceModel.fromJson({
      'id': 'b1',
      'balance': 10.5,
      'previous_balance': 1,
      'forecast': 2,
      'income': 3,
      'expenses': 4,
      'reference': 'r',
      'date': '2026-01-10T00:00:00.000',
      'last_updated_at': '2026-01-11T00:00:00.000',
    });
    expect(balance.toJson()['id'], 'b1');
    expect(balance.toEntity().balance, 10.5);
    expect(
      CondominiumBalanceModel.fromEntity(CondominiumBalance(id: 'b2', balance: 1))!
          .id,
      'b2',
    );
  });

  test('VOX request/create fromEntity e toJson cobrem generated', () {
    final request = DocumentRequest(
      id: 'd1',
      userId: 'u1',
      condominiumId: 'c1',
      unityId: '101',
      content: 'texto',
      title: 'Título',
      block: 'A',
      reason: 'motivo',
      reasonId: 'r1',
      model: 'm1',
      value: '10',
      occurrenceDate: DateTime(2026, 1, 10),
      recipientList: const ['101'],
      recipientType: RecipientType.units,
      flagEmailDistribution: true,
      flagPrintDistribution: false,
      flagOverride: true,
      flagEmailBodyAttachment: true,
      singleCopiesQuantity: 2,
      attachments: [
        DocumentAttachment(
          type: 'application/pdf',
          name: 'a.pdf',
          bytes: Uint8List.fromList(const [1, 2, 3]),
        ),
      ],
    );

    final warning = WarningRequestModel.fromEntity(request);
    expect(warning.toJson()['flag_overrride'], isTrue);
    expect(warning.toEntity().reason, 'motivo');
    expect(
      WarningRequestModel.fromJson(warning.toJson()..['attachments'] = []).serviceId,
      '790850',
    );
    expect(warning.attachments.single!.toJson()['name'], 'a.pdf');
    expect(warning.attachments.single!.toEntity().name, 'a.pdf');

    final fine = FineRequestModel.fromEntity(request);
    expect(fine.toJson()['value'], '10');
    expect(fine.toEntity().value, '10');
    expect(FineRequestModel.fromJson(fine.toJson()..['attachments'] = []).serviceId,
        '790851');

    final announcement = AnnouncementRequestModel.fromEntity(request);
    expect(announcement.toJson()['single_copies_quantity'], '2');
    expect(announcement.toEntity().block, 'A');
    expect(
      AnnouncementRequestModel.fromJson(announcement.toJson()..['attachments'] = [])
          .serviceId,
      '790829',
    );

    final warningCreate = WarningCreateModel.fromEntity(request);
    expect(WarningCreateModel.fromJson(warningCreate.toJson()).modelId, 'm1');
    final announcementCreate = AnnouncementCreateModel.fromEntity(request);
    expect(
      AnnouncementCreateModel.fromJson(announcementCreate.toJson()).title,
      'Título',
    );

    expect(DocumentAttachmentModel.fromEntity(null) == null, isTrue);
    expect(
      DocumentAttachmentModel.fromJson({
        'type': 'image/png',
        'content': 'YQ==',
        'name': 'a.png',
      }).toJson()['name'],
      'a.png',
    );
  });
}
