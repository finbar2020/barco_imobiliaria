import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/access_management/domain/entity/access_control_enum.dart';
import 'package:lello/feature/agreements/domain/entity/agreement.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_installment.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_installment_status.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_status.dart';
import 'package:lello/feature/agreements/domain/entity/payment_method.dart';
import 'package:lello/feature/dashboard/domain/entity/pendency.dart';
import 'package:lello/feature/dashboard/domain/repository/pendency_repository.dart';
import 'package:lello/feature/dashboard/domain/use_case/update_pendency/update_pendency.dart';
import 'package:lello/feature/dashboard/domain/use_case/update_pendency/update_pendency_impl.dart';
import 'package:lello/feature/gdp/domain/entity/employee.dart';
import 'package:lello/feature/gdp/vacation/domain/entity/vacation_period.dart';
import 'package:lello/feature/gdp/vacation/domain/entity/vacation_period_interval.dart';
import 'package:lello/feature/income/domain/entity/billet_found.dart';
import 'package:lello/feature/payment/domain/entity/bank.dart';
import 'package:lello/feature/payment/domain/entity/contas_pagar.dart';
import 'package:lello/feature/payment/domain/entity/contract.dart';
import 'package:lello/feature/payment/domain/entity/installment.dart';
import 'package:lello/feature/payment/domain/entity/lancamento.dart';
import 'package:lello/feature/payment/domain/entity/ledger_account.dart';
import 'package:lello/feature/payment/domain/entity/payment.dart';
import 'package:lello/feature/payment/domain/entity/payment_attachments.dart';
import 'package:lello/feature/payment/domain/entity/payment_data.dart';
import 'package:lello/feature/payment/domain/entity/payment_document_type.dart';
import 'package:lello/feature/payment/domain/entity/payment_form.dart';
import 'package:lello/feature/payment/domain/entity/payment_form_bank_data.dart';
import 'package:lello/feature/payment/domain/entity/payment_installment_approver.dart';
import 'package:lello/feature/payment/domain/entity/payment_installment_ledger_account.dart';
import 'package:lello/feature/payment/domain/entity/payment_installment_supplier.dart';
import 'package:lello/feature/payment/domain/entity/payment_list_filter.dart';
import 'package:lello/feature/payment/domain/entity/payment_source.dart';
import 'package:lello/feature/payment/domain/entity/supplier_payment_type.dart';
import 'package:lello/feature/reports_book/domain/entity/report.dart';
import 'package:lello/feature/reports_book/domain/entity/report_filter.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_change_rules.dart';
import 'package:lello/feature/unit/domain/entity/unit_simple.dart';
import 'package:lello/feature/vox/data/model/announcement_model.dart';
import 'package:lello/feature/vox/data/model/document_reason_model.dart';

class _FakePendencyRepo extends Fake implements PendencyRepository {
  @override
  Future<Try<List<Pendency>>> updateNotification(
      String condominiumId, String pendencyId) async {
    return Success([Pendency(id: pendencyId)]);
  }
}

void main() {
  test('Agreement formata unidade, valor e parcelas', () {
    final empty = Agreement();
    expect(empty.unitAndNameDescription, '');
    expect(empty.getApprovalDate, '-');
    expect(empty.getProposalDate, '-');
    expect(empty.getExpirationDay, '-');
    expect(empty.getInstallmentsAndValue, '-');

    final named = Agreement(unit: '101', unitOwner: 'ana', baseValue: 1000);
    expect(named.unitAndNameDescription, '101 - ANA');
    expect(named.totalValue, 1000);
    expect(named.getTotalValueFormatted.contains('1.000'), isTrue);

    final onlyOwner = Agreement(unitOwner: 'ana');
    expect(onlyOwner.unitAndNameDescription, 'ANA');
    expect(Agreement(unit: '101').unitAndNameDescription, '101');

    final withInstallments = Agreement(
      approvalDate: DateTime(2026, 1, 10),
      proposaldedDate: DateTime(2026, 1, 1),
      dueDate: 10,
      paymentMethod: PaymentMethod.billet,
      status: AgreementStatus.pending,
      installments: [
        AgreementInstallment(
          value: 50,
          status: AgreementInstallmentsStatus.pending,
        ),
        AgreementInstallment(
          value: 50,
          status: AgreementInstallmentsStatus.paid,
        ),
      ],
    );
    expect(withInstallments.getAmountReceivable, 50);
    expect(withInstallments.getPendingOverTotalInstallments, '1/2');
    expect(withInstallments.getApprovalDate, '10/01/2026');
    expect(withInstallments.getProposalDate, '01/01/2026');
    expect(withInstallments.getPaymentMethodKey, 'agreements_billet');
    expect(withInstallments.getStatusKey, 'agreements_pendency');
    expect(withInstallments.getInstallmentsAndValue.contains('2x'), isTrue);
    expect(withInstallments.getExpirationDay, '10');
    expect(
      Agreement(installmentQuantity: 2, baseValue: 100).getInstallmentsAndValue,
      contains('2x'),
    );
    expect(PaymentMethod.getList, contains(PaymentMethod.credit));
    expect(PaymentMethod.getPaymentMethodKey('x'), '');
    expect(AgreementStatus.getList, contains(AgreementStatus.completed));
    expect(AgreementStatus.getStatusKey('x'), '');
    expect(AgreementInstallmentsStatus.getList, contains('paid'));
    expect(AgreementInstallmentsStatus.getStatusKey('paid'),
        'agreements_installment_paid');
  });

  test('Report e ReportFilter mapeiam tipo e status', () {
    final report = Report(
      typeReport: 'COMPLAINT',
      dateReport: DateTime(2026, 1, 10, 8, 30),
    );
    expect(report.getTypeReport, 'reports_type_complaint');
    expect(report.getDate().contains('10/01/2026'), isTrue);
    expect(report.getTypesReport, contains('SUGGESTION'));
    expect(report.toString().contains('COMPLAINT'), isTrue);
    report.setTypeReport('Sugestões');
    expect(report.typeReport, 'SUGGESTION');
    report.setTypeReport('Complaint');
    expect(report.typeReport, 'COMPLAINT');
    report.setTypeReport('Elogios');
    expect(report.typeReport, 'COMPLIMENT');
    report.setTypeReport('Violence no');
    expect(report.typeReport, 'VIOLENCE_NO');
    report.setTypeReport('Others');
    expect(report.typeReport, 'OTHERS');

    final filter = ReportFilter(
      dateFrom: DateTime(2026, 1, 1),
      dateTo: DateTime(2026, 1, 31),
    )..unitName = '101';
    filter.setTypeReport('Reclamações');
    expect(filter.getTypeReport(), contains('complaint'));
    filter.setTypeReport('Suggestion');
    expect(filter.type, 1);
    filter.setStatusReport('Encerradas');
    expect(filter.getStatusReport(), contains('closed'));
    filter.setStatusReport('All');
    expect(filter.getStatusReport(), contains('all'));
    expect(filter.getUnidId(), '101');
    expect(filter.getPeriodReport().contains('01/01/2026'), isTrue);
    expect(filter.toString().contains('101'), isTrue);
  });

  test('Payment, PaymentData e ContasPagar copyWith/helpers', () {
    final payment = Payment(id: 'p1', totalValue: 10);
    expect(payment.totalValueFormat!.contains('10'), isTrue);
    expect(payment.copyWith(id: 'p2').id, 'p2');

    final data = PaymentDataEntity(
      documentSupplier: '123',
      documentType: PaymentDocumentType.bill,
      dueDate: DateTime.now().add(const Duration(days: 2)),
      totalValue: 10,
      installmentQuantity: 1,
      installments: [
        InstallmentEntity(dueDate: DateTime(2026, 2, 1), value: 10),
      ],
    );
    expect(data.checkStep(0), isTrue);
    expect(data.checkStep(1), isTrue);
    expect(data.checkStep(2), isTrue);
    expect(data.checkTotalInstallmentValue, isTrue);
    expect(data.toJson()['documentSupplier'], '123');
    expect(data.copyWith(observation: 'obs').observation, 'obs');
    expect(paymentDocumentTypeToString(PaymentDocumentType.bill), 'BOLETO');
    expect(paymentDocumentTypeFromString('GUIA'), PaymentDocumentType.paySlip);
    expect(getPaymentDocumentTypes(), hasLength(6));
    for (final type in PaymentDocumentType.values) {
      expect(
        paymentDocumentTypeFromString(paymentDocumentTypeToString(type)),
        type,
      );
    }
    expect(paymentDocumentTypeFromString('x'), PaymentDocumentType.receipt);

    expect(
      ContasPagarEntity(status: 'A').copyWith(status: 'B').status,
      'B',
    );
    expect(PaymentListFilter().copyWith(value: 1).value, 1);
    expect(
      InstallmentEntity(dueDate: DateTime(2026, 1, 1), value: 1.5).valueInt,
      150,
    );
    expect(
      LancamentoEntity(status: 'A').copyWith(status: 'B').status,
      'B',
    );
    expect(
      PaymentAttachments(name: 'a').copyWith(name: 'b').name,
      'b',
    );
    expect(LedgerAccountEntity(id: 1).copyWith(id: 2).id, 2);
    expect(ContractEntity(id: 1).copyWith(code: 'c').code, 'c');
    expect(SupplierPaymentTypeEntity(id: 1).copyWith(name: 'pix').name, 'pix');
    expect(PaymentFormEntity(id: 1).copyWith(name: 'ted').name, 'ted');
    expect(
      PaymentInstallmentSupplier(email: 'a').copyWith(email: 'b').email,
      'b',
    );
    expect(
      PaymentInstallmentApprover(name: 'a').copyWith(name: 'b').name,
      'b',
    );
    expect(
      PaymentInstallmentLedgerAccount(name: 'a').copyWith(name: 'b').name,
      'b',
    );
    expect(Bank(id: 1, name: 'BB').toString().contains('BB'), isTrue);
    expect(PaymentFormBankDataEntity(agency: '1').agency, '1');
    expect(PaymentListFilter(source: PaymentSource.all).source,
        PaymentSource.all);
  });

  test('ReservationChangeRules, UnitSimple, Employee e férias', () {
    expect(ReservationChangeRules().diasAntecedencia, 9);
    expect(ReservationChangeRules(daysInAdvance: 1).diasAntecedencia, 0);
    expect(ReservationChangeRules(daysInAdvance: 2).diasAntecedencia, 1);
    expect(ReservationChangeRules(daysInAdvance: 5).diasAntecedencia, 2);
    expect(ReservationChangeRules(daysInAdvance: 10).diasAntecedencia, 3);
    expect(ReservationChangeRules(daysInAdvance: 20).diasAntecedencia, 4);
    expect(ReservationChangeRules(daysInAdvance: 25).diasAntecedencia, 5);
    expect(ReservationChangeRules(daysInAdvance: 45).diasAntecedencia, 6);
    expect(ReservationChangeRules(daysInAdvance: 70).diasAntecedencia, 7);
    expect(ReservationChangeRules(daysInAdvance: 90).diasAntecedencia, 8);
    final rules = ReservationChangeRules(idMovingRule: 'r1');
    expect(rules.setDiasAntecedencia(0), 1);
    expect(rules.setDiasAntecedencia(8), 90);
    expect(rules.setDiasAntecedencia(9), 0);
    expect(rules.toString().contains('r1'), isTrue);

    final unit = UnitSimple(id: 'u1', title: '101');
    expect(unit.copyWith(title: '102').title, '102');
    expect(unit, UnitSimple(id: 'u1', title: '101'));

    final employee = Employee()
      ..statusBiometriaColaborador = AccessControlBiometricStatus.registered;
    expect(employee.condoHasBiometric, isTrue);
    expect(employee.userHasBiometric, isTrue);

    final period = VacationPeriod(
      periodsNumber: 0,
      intervals: [
        VacationPeriodInterval(intervals: [10, 20], allowence: 0),
      ],
    );
    expect(period.getIntervals.single.contains('10'), isTrue);
    expect(BilletFound()..value = 10.5, isA<BilletFound>());
    expect((BilletFound()..value = 10).valueFormatted.isNotEmpty, isTrue);
  });

  test('Vox announcement e document reason json', () {
    final announcement = AnnouncementModel.fromJson({
      'id': 'a1',
      'name': 'Aviso',
      'description': 'desc',
      'content': 'texto',
      'flag_email_distribution': true,
      'pages_quantity': 1,
      'status': 'PUBLISHED',
    });
    expect(announcement.toDocument().name, 'Aviso');
    expect(announcement.toJson()['id'], 'a1');

    final reason = DocumentReasonModel.fromJson({
      'id': 'r1',
      'description': 'Barulho',
      'flag_active': true,
    });
    expect(reason.toEntity().description, 'Barulho');
    expect(reason.toJson()['id'], 'r1');
  });

  test('UpdatePendencyImpl valida e atualiza', () async {
    final repo = _FakePendencyRepo();
    expect(
      await UpdatePendencyImpl(repository: repo)(UpdatePendencyParam('', 'p1')),
      isA<Rejection<List<Pendency>>>(),
    );
    expect(
      await UpdatePendencyImpl(repository: repo)(
        UpdatePendencyParam('c1', 'p1'),
      ),
      isA<Success<List<Pendency>>>(),
    );
  });
}
