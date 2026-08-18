import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_doubt.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_doubt_situation.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_question_type_solicitation.dart';
import 'package:lello/feature/condominium/domain/entity/condominium.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_action_enum.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_employee_detail_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_employee_marks_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_occurrence_certificate_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_occurrence_vacation_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_ocurrence_entity.dart';
import 'package:lello/feature/gdp/vacation/domain/entity/vacation.dart';
import 'package:lello/feature/income/domain/entity/billet_filter_parameters.dart';
import 'package:lello/feature/income/domain/entity/billet_status_enum.dart';
import 'package:lello/feature/maintenance_management/domain/entity/calendar_day_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/calendar_days_response_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/chat/chat_channel_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/chat/chat_message_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/origin_answer_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/schedule_events_detail_response_entity.dart';
import 'package:lello/feature/me/domain/entity/me.dart';
import 'package:lello/feature/payment/domain/entity/contract.dart';
import 'package:lello/feature/payment/domain/entity/ledger_account.dart';
import 'package:lello/feature/payment/domain/entity/ledger_account_balance.dart';
import 'package:lello/feature/payment/domain/entity/payment_form.dart';
import 'package:lello/feature/payment/domain/entity/payment_installment_in_approval.dart';
import 'package:lello/feature/payment/domain/entity/payment_installments.dart';
import 'package:lello/feature/payment/domain/entity/process_files_response.dart';
import 'package:lello/feature/payment/domain/entity/send_token_data.dart';
import 'package:lello/feature/payment/domain/entity/supplier_data_entity.dart';
import 'package:lello/feature/payment/domain/entity/supplier_ledger_accounts.dart';
import 'package:lello/feature/payment/domain/entity/supplier_payment_type.dart';
import 'package:lello/feature/payment/domain/entity/update_installment_lancamento_entity.dart';
import 'package:lello/feature/payment/domain/entity/update_transaction_installments_entity.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_receipt.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_receipt_type.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_status.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_type.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';
import 'package:lello/feature/unit/domain/entity/unit_simple.dart';
import 'package:lello/feature/vox/domain/entity/document_mode.dart';
import 'package:lello/feature/vox/domain/entity/document_request.dart';
import 'package:lello/feature/vox/domain/entity/document_type.dart';
import 'package:lello/feature/vox/domain/entity/recipient_type.dart';

void main() {
  test('Chat channel e mensagem cobrem copyWith e getters', () {
    const task = ChannelTaskEntity(id: 't1', name: 'Limpeza');
    final last = ChannelLastMessageEntity(
      id: 'm1',
      content: 'oi',
      createdAt: DateTime(2026, 1, 10),
      author: const MessageAuthorEntity(id: 'u1', name: 'Ana', email: 'a@b.com'),
    );
    final channel = ChatChannelEntity(
      id: 'ch1',
      typeTask: 'ROTINA',
      status: 'DONE',
      task: task,
      lastMessage: last,
    );
    expect(channel.isDone, isTrue);
    expect(channel.hasUnread, isTrue);
    expect(channel.copyWith(status: 'OPEN', hasUnreadMessages: true).isDone, isFalse);
    expect(last.copyWith(content: 'novo').content, 'novo');
    expect(
      const ChatChannelsResponseEntity(channels: []).props,
      isNotEmpty,
    );
    expect(const PageInfoEntity(hasNextPage: true, hasPreviousPage: false).props,
        contains(true));

    final message = ChatMessageEntity(
      id: 'm1',
      channelId: 'ch1',
      authorId: 'u1',
      messageType: 'TEXT',
      createdAt: DateTime(2026, 1, 10),
      author: const ChatAuthorEntity(
        id: 'u1',
        name: 'Ana',
        email: 'a@b.com',
        profile: ChatAuthorProfileEntity(id: 'p1', name: 'Perfil'),
      ),
      attachment: const ChatAttachmentEntity(
        id: 'a1',
        name: 'foto.png',
        url: 'https://s3',
      ),
    );
    expect(message.copyWith(isSending: true, isFailed: true).isSending, isTrue);
    expect(message.author.profile?.name, 'Perfil');
  });

  test('Agenda detalhada, calendário e origin answer', () {
    const formulary = ScheduleEventTaskFormularyEntity(
      idSchedule: 's1',
      idScheduleEvent: 'e1',
      name: 'Limpeza',
      dtStart: '2026-01-10',
      dtEnd: '2026-01-10',
      allDay: true,
      percentDone: '100',
      description: 'desc',
      procedureGroupLabel: 'Grupo',
      localsLabel: 'Hall',
      createdAt: 'a',
      effectiveDate: 'b',
      updatedAt: 'c',
      status: 'DONE',
      rrule: '',
      color: '#fff',
      icon: 'i',
      timeStart: '08:00',
      timeEnd: '09:00',
      timeDescription: 'manhã',
      typeTask: 'ROTINA',
    );
    const detail = ScheduleEventsDetailResponseEntity(
      success: true,
      message: 'ok',
      data: ScheduleEventsDetailDataEntity(
        taskSummaryDay: [
          ScheduleEventTaskSummaryDayEntity(
            date: '2026-01-10',
            taskFormulary: [formulary],
          ),
        ],
        obligations: [
          ScheduleEventObligationEntity(
            id: 'o1',
            collectionCode: 'c',
            reference: 1,
            partnerType: 'p',
            legalObligationType: 'PDF',
            name: 'AVCB',
            expirationDescription: 'vence',
            expirationDate: '2026-02-01',
            expirationStatus: 'OK',
          ),
        ],
      ),
      legacyStatusCode: 200,
    );
    expect(detail.props, isNotEmpty);
    expect(detail.data.obligations.single.name, 'AVCB');

    const day = CalendarDayEntity(day: 10, hasEvents: true, taskCount: 2);
    expect(day == const CalendarDayEntity(day: 10, hasEvents: true, taskCount: 2),
        isTrue);
    expect(day.toString(), contains('taskCount: 2'));
    const calendar = CalendarDaysResponseEntity(
      month: 1,
      year: 2026,
      days: [day],
    );
    expect(calendar.hasTasks(10), isTrue);
    expect(calendar.hasTasks(11), isFalse);
    expect(calendar.getTaskCount(10), 2);
    expect(calendar.getTaskCount(11), 0);
    expect(calendar.toString(), contains('2026'));

    final origin = OriginAnswerEntity(id: '1', eventId: 'e', questionId: 'q');
    expect(origin == OriginAnswerEntity(id: '1', eventId: 'e', questionId: 'q'),
        isTrue);
    expect(origin.hashCode == origin.hashCode, isTrue);
  });

  test('Me clona, compara e lista condomínios', () {
    const condo = Condominium(id: 'c1', reference: 'r1', name: 'Edifício');
    final me = Me(
      name: 'Ana',
      id: 'u1',
      email: 'a@b.com',
      cpf: '1',
      phone: '2',
      picture: 'old',
      pictureHash: 'hash',
      condominiums: const [condo],
    );
    expect(Me.clone(me).name, 'Ana');
    expect(me.copyWith(name: 'Bia').name, 'Bia');
    expect(me.compareStr(Me(name: 'Bia', email: 'x')), contains('nome'));
    expect(me.allCondominiums, 1);
    expect(me.allCondominiunsEntity.single.reference, 'r1');
    expect(me.pictureLink, contains('hash'));
    expect(Me().pictureLink, '');
  });

  test('DocumentType e DocumentRequest rotulam destinatários', () {
    expect(DocumentType.warning.serviceId, '790850');
    expect(DocumentType.fine.serviceId, '790851');
    expect(DocumentType.announcement.serviceId, '790829');
    expect(DocumentType.warning.hasReasons, isTrue);
    expect(DocumentType.fine.hasValue, isTrue);
    expect(DocumentType.announcement.hasTitle, isTrue);
    expect(DocumentType.announcement.hasCopies, isTrue);
    expect(DocumentType.announcement.hasRecipientTypeSelector, isTrue);
    expect(DocumentType.warning.hasOccurrenceDate, isTrue);
    expect(DocumentType.warning.usesTemplates(DocumentMode.create), isTrue);
    expect(DocumentType.announcement.usesTemplates(DocumentMode.create), isTrue);
    expect(DocumentType.announcement.usesTemplates(DocumentMode.request), isFalse);
    expect(DocumentType.fine.supportsCreate, isFalse);
    expect(DocumentType.warning.supportsCreate, isTrue);

    expect(DocumentRequest(recipientType: RecipientType.all).recipientsLabel(),
        'TODOS');
    expect(
      DocumentRequest(
        recipientType: RecipientType.block,
        recipientListMap: const {'A': 'a', 'B': 'b'},
      ).recipientsLabel(),
      contains('Blocos'),
    );
    expect(
      DocumentRequest(
        recipientType: RecipientType.units,
        recipientListMap: const {'1|101': 'u1'},
      ).recipientsLabel(),
      contains('1 - 101'),
    );
    expect(DocumentRequest().recipientsLabel(), '');
  });

  test('Timesheet occurrence formata horas, data e marcações', () {
    TimesheetOccurrenceEntity occ({
      int duration = 90,
      String marks = '08:00;12:00',
    }) =>
        TimesheetOccurrenceEntity(
          photo: '',
          name: 'joao silva',
          jobPosition: 'porteiro',
          numCra: '1',
          receivedMark: marks,
          hourRange: '08:00;17:00',
          referenceDate: '2026-01-10',
          occurenceDuration: duration,
          occurrenceName: 'extra',
          canTreat: true,
          occurrenceType: 'EXTRA',
        );

    expect(occ().convertExtraHours(), '1h30min');
    expect(occ(duration: 60).convertExtraHours(), '1h');
    expect(occ(duration: 15).convertExtraHours(), '15min');
    expect(occ().convertDate(), isNotEmpty);
    expect(occ().convertStringToDate().year, 2026);
    expect(occ().turn, contains(' - '));
    expect(occ().marks, contains(' - '));
    expect(occ(marks: '08:00;25:00;12:00').marksList, ['08:00', '12:00']);
    expect(occ().enableButton, isTrue);
    expect(occ(marks: 'a;b;c;d;e;f').enableButton, isFalse);
    expect(occ().nameFormatted.toLowerCase(), contains('joao'));

    final detail = TimesheetEmployeeDetailEntity(
      startDateOfAssessment: DateTime(2026, 1, 1),
      endDateOfAssessment: DateTime(2026, 1, 31),
      signatureId: 1,
      employeeSigned: true,
      syndicateSigned: false,
      action: TimesheetActionEnum.notify,
      markings: [
        TimesheetEmployeeMarksEntity(
          craNumber: '1',
          reference: 'r',
          referenceDate: DateTime(2026, 1, 10),
          type: 'N',
          receivedMarking: '08:00',
          occurrenceDuration: 0,
          outOfRadius: false,
        ),
      ],
    );
    expect(detail.signatureStatus, 'ASSINADO');
    expect(detail.notifyButton, isTrue);
    expect(detail.dontShowButton, isFalse);
    expect(detail.initDate, isNotEmpty);
    expect(detail.endDate, isNotEmpty);

    expect(
      TimesheetEntity(name: 'ana lima', action: TimesheetActionEnum.none)
          .nameFormatted
          .toLowerCase(),
      contains('ana'),
    );
    expect(
      TimesheetOccurrenceVacationEntity(name: 'ana lima').nameFormatted.toLowerCase(),
      contains('ana'),
    );
    expect(
      TimesheetOccurrenceCertificateEntity(name: 'ana lima')
          .nameFormatted
          .toLowerCase(),
      contains('ana'),
    );
  });

  test('AccountabilityDoubt cobre cores e textos de situação', () {
    final doubt = AccountabilityDoubt(period: DateTime(2026, 1, 1))
      ..doubtType = AccountabilityQuestionType(
        id: '1',
        name: 'Dúvida',
        idCompany: 1,
        idSupervisor: 1,
        idRequestPpc: 1,
      );
    expect(doubt.selectedTypeText, 'Dúvida');
    for (final situation in DoubtSituation.values) {
      doubt.questionSituation = situation;
      expect(doubt.questionSituationColor, isA<Color>());
      expect(doubt.questionSituationText, isNotEmpty);
    }
  });

  test('Resin refund, vacation, unit e copyWiths de pagamento', () {
    final receipt = ResinRefundReceipt(
      receiptValue: 10,
      sendDate: DateTime(2026, 1, 10, 8),
      receiptType: ResinRefundReceiptType.receipt,
    );
    expect(receipt.sendDateFormatted(), contains('10/01/2026'));
    expect(ResinRefundReceipt(receiptValue: 1).sendDateFormatted(), ' - ');
    expect(receipt.valueFormatted(), contains('10'));
    for (final type in ResinRefundReceiptType.values) {
      expect(
        ResinRefundReceipt(receiptValue: 1, receiptType: type).receiptTypeKey,
        isNotEmpty,
      );
    }
    expect(ResinRefundReceipt(receiptValue: 1).receiptTypeKey, '');

    final refund = ResinRefund(
      requestDate: DateTime(2026, 1, 10, 9),
      requester: 'Ana',
      status: ResinRefundStatus.sended,
      type: ResinRefundType.refund,
      value: 20,
      receipts: [receipt, ResinRefundReceipt(receiptValue: 5)],
    );
    expect(refund.getTotalReceiptsValue, 15);
    expect(refund.getTotalReceiptsValueFormatted, contains('15'));
    expect(refund.requestDateFormatted, contains('10/01/2026'));
    expect(ResinRefund(
      requestDate: null,
      requester: 'Ana',
      status: ResinRefundStatus.paid,
      type: ResinRefundType.advance,
      value: 1,
    ).requestDateFormatted, ' - ');

    final vacation = Vacation(
      advance13: 'S',
      numbersUnitVacation: 2,
      scheduledDays: 10,
      acquisitivePeriodStartDate: '01/01/2026',
      acquisitivePeriodEndDate: '31/12/2026',
    );
    expect(vacation.getAdvance13, 'yes');
    expect(Vacation(advance13: 'N').getAdvance13, 'no');
    expect(vacation.getNumbersUnitVacation, 2);
    expect(Vacation().getNumbersUnitVacation == null, isTrue);
    expect(vacation.getScheduledDays, isNotEmpty);
    expect(vacation.getPeriodVacation, contains(' a '));

    final unit = Unit.fromUnitSimple(UnitSimple(id: '1', title: '101'));
    expect(unit.title, '101');
    expect(UnitSimple(id: '1', title: '101').copyWith(title: '102').title, '102');

    expect(
      ProcessFilesResponseEntity(success: true, status: 'ok')
          .copyWith(message: 'feito')
          .message,
      'feito',
    );
    expect(SupplierDataEntity().copyWith(name: 'Fornecedor').name, 'Fornecedor');
    expect(
      SupplierLedgerAccountsEntity().copyWith(all: [LedgerAccountEntity(id: 1)]).all,
      hasLength(1),
    );
    expect(PaymentInstallments().copyWith(value: 10).value, 10);
    expect(SendTokenData(id: 1).copyWith(id: 2).id, 2);
    expect(LedgerAccountBalance(balance: 1).copyWith(balance: 2).balance, 2);
    expect(
      PaymentInstallmentInApprovalEntity().copyWith(installmentId: 9).installmentId,
      9,
    );
    expect(
      UpdateInstallmentLancamentoEntity(
        status: 'a',
        motivo: 'b',
        canal: 'c',
        lancamentos: const [],
      ).copyWith(status: 'x').status,
      'x',
    );
    expect(
      UpdateTransactionInstallmentsEntity().copyWith(transactionId: 3).transactionId,
      3,
    );
    expect(BilletFilter().copyWith(status: BilletStatus.paid).status, BilletStatus.paid);
    expect(LedgerAccountEntity().copyWith(name: 'caixa').name, 'caixa');
    expect(ContractEntity().copyWith(code: 'c1').code, 'c1');
    expect(SupplierPaymentTypeEntity().copyWith(name: 'pix').name, 'pix');
    expect(PaymentFormEntity().copyWith(name: 'ted').name, 'ted');
  });
}
