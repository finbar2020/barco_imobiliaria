import 'package:lello/feature/agreements/data/model/agreement_model.dart';
import 'package:lello/feature/agreements/data/model/agreement_update_status_model.dart';
import 'package:lello/feature/agreements/data/model/agreements_all_info_model.dart';
import 'package:lello/feature/agreements/data/model/agreements_analysis_model.dart';
import 'package:lello/feature/agreements/data/model/agreements_rules_model.dart';

abstract class AgreementsRemoteDataSource {
  Future<AgreementsAnalysisModel> getAnalysis(
      String condominiumId, String? fromDate, String? toDate);
  Future<AgreementsAllInfoModel> getAllAgreementsInfo(String condominiumId);
  Future<List<AgreementModel>> getAgreementsList(
      String condominiumId, String? status);
  Future<AgreementsRulesModel> getRules(String condominiumId);
  Future<AgreementsRulesModel> changeRules(
      String condominiumId, AgreementsRulesModel newRules);
  Future<AgreementModel> agreementUpdateStatus(
      String condominiumId, AgreementUpdateStatusModel updateStatus);
}
