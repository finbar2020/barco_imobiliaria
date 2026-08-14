import 'package:essentials/essentials.dart';
import 'package:lello/feature/agreements/data/data_source/remote/agreements_api.dart';
import 'package:lello/feature/agreements/data/data_source/remote/agreements_remote_data_source.dart';
import 'package:lello/feature/agreements/data/model/agreement_model.dart';
import 'package:lello/feature/agreements/data/model/agreement_update_status_model.dart';
import 'package:lello/feature/agreements/data/model/agreements_all_info_model.dart';
import 'package:lello/feature/agreements/data/model/agreements_analysis_model.dart';
import 'package:lello/feature/agreements/data/model/agreements_rules_model.dart';

class AgreementsRemoteDataSourceImpl implements AgreementsRemoteDataSource {
  final AgreementsApi api;

  AgreementsRemoteDataSourceImpl({required this.api});

  @override
  Future<AgreementsAnalysisModel> getAnalysis(
      String condominiumId, String? fromDate, String? toDate) async {
    final response = await api.getAgreementsReport(
        condominiumId, fromDate ?? "", toDate ?? "");
    final result = ApiMapper.map(
        response, (json) => AgreementsAnalysisModel.fromJson(json));
    return result;
  }

  @override
  Future<AgreementsAllInfoModel> getAllAgreementsInfo(
      String condominiumId) async {
    final response = await api.getAllAgreementsInfo(condominiumId);
    final result = ApiMapper.map(
        response, (json) => AgreementsAllInfoModel.fromJson(json));
    return result;
  }

  @override
  Future<List<AgreementModel>> getAgreementsList(
      String condominiumId, String? status) async {
    final response = await api.getAgreementsList(condominiumId, status);
    final result =
        ApiMapper.mapList(response, (json) => AgreementModel.fromJson(json));
    return result;
  }

  @override
  Future<AgreementsRulesModel> getRules(String condominiumId) async {
    final response = await api.getRules(condominiumId);
    final result =
        ApiMapper.map(response, (json) => AgreementsRulesModel.fromJson(json));
    return result;
  }

  @override
  Future<AgreementsRulesModel> changeRules(
      String condominiumId, AgreementsRulesModel newRules) async {
    final response = await api.changeRules(condominiumId, newRules);
    final result =
        ApiMapper.map(response, (json) => AgreementsRulesModel.fromJson(json));
    return result;
  }

  @override
  Future<AgreementModel> agreementUpdateStatus(
      String condominiumId, AgreementUpdateStatusModel updateStatus) async {
    final response =
        await api.agreementUpdateStatus(condominiumId, updateStatus);
    final result =
        ApiMapper.map(response, (json) => AgreementModel.fromJson(json));
    return result;
  }
}
