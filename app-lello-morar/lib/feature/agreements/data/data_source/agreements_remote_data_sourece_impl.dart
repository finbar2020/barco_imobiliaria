import 'package:essentials/essentials.dart';
import 'package:morar/feature/agreements/data/data_source/agreements_api.dart';
import 'package:morar/feature/agreements/data/data_source/agreements_remote_data_source.dart';
import 'package:morar/feature/agreements/data/model/agreement_all_info_model.dart';
import 'package:morar/feature/agreements/data/model/agreement_created_model.dart';
import 'package:morar/feature/agreements/data/model/agreement_installment_credit_model.dart';
import 'package:morar/feature/agreements/data/model/agreement_rule_model.dart';
import 'package:morar/feature/agreements/data/model/agreements_model.dart';
import 'package:morar/feature/agreements/data/model/agreements_recommendation_payment_model.dart';

class AgreementsRemoteDataSourceImpl implements AgreementsRemoteDataSource {
  final AgreementsApi api;

  AgreementsRemoteDataSourceImpl({required this.api});

  @override
  Future<AgreementAllInfoModel> getAllInfo(
      String condoId, String unitTitle, bool onlyQuoteAndRule) async {
    var response = await api.getAllInfo(condoId, unitTitle, onlyQuoteAndRule);
    final allInfo =
        ApiMapper.map(response, (json) => AgreementAllInfoModel.fromJson(json));
    return allInfo;
  }

  @override
  Future<List<AgreementRecommendationPaymentModel>> getRecommendation(
      String condoId) async {
    var response = await api.getRecommendation(condoId);
    final recomendations = ApiMapper.mapList(
        response, (json) => AgreementRecommendationPaymentModel.fromJson(json));
    return recomendations;
  }

  @override
  Future<List<int>> getPayday(String condoId) async {
    var response = await api.getPayday(condoId);
    var list =
        ApiMapper.map(response, (json) => AgreementRuleModel.fromJson(json));
    return list.days;
  }

  @override
  Future<List<AgreementInstallmentCreditModel>> getInstallmentsCredit(
      String condoId, double totalValue) async {
    var response = await api.getInstallmentsCredit(condoId, totalValue);
    var installments = ApiMapper.mapList(
        response, (json) => AgreementInstallmentCreditModel.fromJson(json));
    return installments;
  }

  @override
  Future<AgreementModel> postAgreement(
      String condoId, AgreementCreatedModel body) async {
    var response = await api.postAgreement(condoId, body);
    var agreement =
        ApiMapper.map(response, (json) => AgreementModel.fromJson(json));
    return agreement;
  }

  @override
  Future<AgreementModel> getAgreementDetail(
      String condoId, String agreementId) async {
    var response = await api.getAgreementDetails(condoId, agreementId);
    var agreement =
        ApiMapper.map(response, (json) => AgreementModel.fromJson(json));
    return agreement;
  }
}
