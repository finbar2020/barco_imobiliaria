import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/agreements/domain/entity/agreement.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_analysis/agreements_analysis.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_update_status.dart';
import 'package:lello/feature/agreements/domain/entity/agreements_all_info.dart';
import 'package:lello/feature/agreements/domain/entity/agreements_rules.dart';
import 'package:lello/feature/agreements/domain/repository/agreements_repository.dart';
import 'package:lello/feature/agreements/domain/use_case/agreement_update_status_use_case.dart';
import 'package:lello/feature/agreements/domain/use_case/agreement_update_status_use_case_impl.dart';
import 'package:lello/feature/agreements/domain/use_case/change_rules_use_case.dart';
import 'package:lello/feature/agreements/domain/use_case/change_rules_use_case_impl.dart';
import 'package:lello/feature/agreements/domain/use_case/get_all_agreements_info_use_case.dart';
import 'package:lello/feature/agreements/domain/use_case/get_all_agreements_info_use_case_impl.dart';
import 'package:lello/feature/agreements/domain/use_case/get_analysis_use_case.dart';
import 'package:lello/feature/agreements/domain/use_case/get_analysis_use_case_impl.dart';
import 'package:lello/feature/agreements/domain/use_case/get_rules_use_case.dart';
import 'package:lello/feature/agreements/domain/use_case/get_rules_use_case_impl.dart';
import 'package:lello/feature/nonpayment/data/repository/nonpayments_repository.dart';
import 'package:lello/feature/nonpayment/domain/entity/nonpayments.dart';
import 'package:lello/feature/nonpayment/domain/use_case/get_nonpayments.dart';
import 'package:lello/feature/nonpayment/domain/use_case/get_nonpayments_impl.dart';
import 'package:lello/feature/reports_book/data/model/report_filter_model.dart';
import 'package:lello/feature/reports_book/domain/entity/report.dart';
import 'package:lello/feature/reports_book/domain/entity/report_filter.dart';
import 'package:lello/feature/reports_book/domain/entity/reports.dart';
import 'package:lello/feature/reports_book/domain/repository/reports_book_repository.dart';
import 'package:lello/feature/reports_book/data/model/content_send_model.dart';
import 'package:lello/feature/reports_book/domain/use_case/close_report.dart';
import 'package:lello/feature/reports_book/domain/use_case/close_report_impl.dart';
import 'package:lello/feature/reports_book/domain/use_case/get_report.dart';
import 'package:lello/feature/reports_book/domain/use_case/get_report_impl.dart';
import 'package:lello/feature/reports_book/domain/use_case/get_reports.dart';
import 'package:lello/feature/reports_book/domain/use_case/get_reports_impl.dart';
import 'package:lello/feature/reports_book/domain/use_case/put_report_content.dart';
import 'package:lello/feature/reports_book/domain/use_case/put_report_content_impl.dart';
import 'package:lello/feature/resident/domain/entity/resident.dart';
import 'package:lello/feature/resident/domain/repository/resident_repository.dart';
import 'package:lello/feature/unit/domain/use_case/list_unit_resident/list_unit_resident.dart';
import 'package:lello/feature/unit/domain/use_case/list_unit_resident/list_unit_resident_impl.dart';

AgreementsRules _rules() => AgreementsRules(installmentQtd: 3, days: [5, 10]);

class _FakeAgreementsRepo extends Fake implements AgreementsRepository {
  Object? last;

  @override
  Future<Try<AgreementsRules>> getRules(String condominiumId) async =>
      Success(_rules());

  @override
  Future<Try<AgreementsRules>> changeRules(
          String condominiumId, AgreementsRules rules) async =>
      Success(rules);

  @override
  Future<Try<AgreementsAllInfo>> getAllAgreementsInfo(
      String condominiumId) async {
    last = 'remote';
    return Success(AgreementsAllInfo(agreements: const [], rule: _rules()));
  }

  @override
  Future<Try<AgreementsAllInfo?>> selectAllAgreementsInfoFromCache(
      String condominiumId) async {
    last = 'local';
    return Success(AgreementsAllInfo(agreements: const [], rule: _rules()));
  }

  @override
  Future<Try<AgreementsAnalysis>> getAnalysis(
      String condominiumId, String? fromDate, String? toDate) async {
    last = fromDate;
    return Success(AgreementsAnalysis(
      fromDate: DateTime(2026, 1, 1),
      toDate: DateTime(2026, 1, 31),
    ));
  }

  @override
  Future<Try<Agreement>> agreementUpdateStatus(
      String condominiumId, AgreementUpdateStatus updateStatus) async {
    last = updateStatus.agreementId;
    return Success(Agreement(id: updateStatus.agreementId));
  }
}

class _FakeReportsRepo extends Fake implements ReportsBookRepository {
  Object? last;

  @override
  Future<Try<Reports>> getReports(
      ReportFilterModel reportFilterModel, int page) async {
    last = page;
    return Success(Reports(report: [Report(idReport: 'r1')]));
  }

  @override
  Future<Try<Report>> getReport(String unitId, String reportId) async {
    last = reportId;
    return Success(Report(idReport: reportId));
  }

  @override
  Future<Try<Report>> closeReport(String reportId) async {
    last = reportId;
    return Success(Report(idReport: reportId, closed: true));
  }

  @override
  Future<Try<Report>> putReportContent(
      String reportId, ContentSendModel content) async {
    last = content.content;
    return Success(Report(idReport: reportId));
  }
}

class _FakeNonPayRepo extends Fake implements NonPaymentsRepository {
  @override
  Future<Try<NonPayment>> get(String condominiumId, String period) async =>
      Success(NonPayment(value: 10, quotes: 2));
}

class _FakeResidentRepo extends Fake implements ResidentRepository {
  @override
  Future<Try<List<Resident>>> listFromUnit(
          String condominiumId, String unitId) async =>
      Success([Resident(id: 'r1', name: 'Maria')]);
}

void main() {
  test('Acordos: regras, lista, análise e status', () async {
    final repo = _FakeAgreementsRepo();
    expect(
      await GetRulesUseCaseImpl(repository: repo)(
        GetRulesParams(condominiumId: 'c1'),
      ),
      isA<Success<AgreementsRules>>(),
    );
    expect(_rules().getMaxInstallments, '3x');
    expect(_rules().getAllowedDays, '5 , 10');

    expect(
      await ChangeRulesUseCaseImpl(repository: repo)(
        ChangeRulesParams(condominiumId: 'c1', newRules: _rules()),
      ),
      isA<Success<AgreementsRules>>(),
    );

    await GetAllAgreementsInfoUseCaseImpl(repository: repo)(
      GetAllAgreementsInfoParams(
        condominiumId: 'c1',
        origin: DataOrigin.local,
      ),
    );
    expect(repo.last, 'local');

    expect(
      await GetAnalysisUseCaseImpl(repository: repo)(
        GetAnalysisParams(
          condominiumId: 'c1',
          fromDate: '01/01/2026',
          toDate: '31/01/2026',
        ),
      ),
      isA<Success<AgreementsAnalysis>>(),
    );

    expect(
      await AgreementUpdateStatusUseCaseImpl(repository: repo)(
        AgreementUpdateStatusParams(
          condominiumId: 'c1',
          updateStatus: AgreementUpdateStatus(
            userName: 'Ana',
            agreementId: 'a1',
            approved: true,
          ),
        ),
      ),
      isA<Success<Agreement>>(),
    );
  });

  test('Livro de ocorrências e filtro JSON', () async {
    final repo = _FakeReportsRepo();
    expect(
      await GetReportsUseCaseImpl(repository: repo)(
        GetReportsParams(reportFilterModel: ReportFilterModel(), page: 1),
      ),
      isA<Success<Reports>>(),
    );
    expect(
      await GetReportUseCaseImpl(repository: repo)(
        GetReportParams(unitId: 'u1', reportId: 'r1'),
      ),
      isA<Success<Report>>(),
    );
    expect(
      await CloseReportUseCaseImpl(repository: repo)(
        CloseReportParams(reportId: 'r1'),
      ),
      isA<Success<Report>>(),
    );
    expect(
      await PutReportContentUseCaseImpl(repository: repo)(
        PutReportContentParams(
          reportId: '',
          content: ContentSendModel(idReport: 'r1', content: 'texto'),
        ),
      ),
      isA<Rejection<Report>>(),
    );
    expect(
      await PutReportContentUseCaseImpl(repository: repo)(
        PutReportContentParams(
          reportId: 'r1',
          content: ContentSendModel(idReport: 'r1', content: 'texto'),
        ),
      ),
      isA<Success<Report>>(),
    );

    final parsed = ReportFilterModel.fromJson({
      'type': 1,
      'closed': false,
      'unit_id': 'u1',
      'show_only_new_reports': true,
    });
    expect(parsed.unitId, 'u1');
    expect(ReportFilterModel.fromEntity(parsed.toEntity())?.type, 1);
  });

  test('Inadimplência e moradores da unidade', () async {
    expect(
      await GetNonPaymentsImpl(repository: _FakeNonPayRepo())(
        GetNonPaymentsParam(condominiumId: '', period: '2026-01'),
      ),
      isA<Rejection<NonPayment>>(),
    );
    expect(
      await GetNonPaymentsImpl(repository: _FakeNonPayRepo())(
        GetNonPaymentsParam(condominiumId: 'c1', period: '2026-01'),
      ),
      isA<Success<NonPayment>>(),
    );

    expect(
      await ListUnitResidentImpl(repository: _FakeResidentRepo())(
        ListUnitResidentParam(condominiumId: 'c1', unitId: ''),
      ),
      isA<Rejection<List<Resident>>>(),
    );
    expect(
      await ListUnitResidentImpl(repository: _FakeResidentRepo())(
        ListUnitResidentParam(condominiumId: 'c1', unitId: 'u1'),
      ),
      isA<Success<List<Resident>>>(),
    );
  });
}
