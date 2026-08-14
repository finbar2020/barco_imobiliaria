import 'package:morar/feature/agreements/data/model/agreement_all_info_model.dart';
import 'package:morar/feature/agreements/data/model/agreement_created_model.dart';
import 'package:morar/feature/agreements/data/model/agreement_installment_credit_model.dart';
import 'package:morar/feature/agreements/data/model/agreements_model.dart';
import 'package:morar/feature/agreements/data/model/agreements_recommendation_payment_model.dart';

abstract class AgreementsRemoteDataSource {
  Future<AgreementAllInfoModel> getAllInfo(
      String condoId, String unitTitle, bool onlyQuoteAndRule);
  Future<List<AgreementRecommendationPaymentModel>> getRecommendation(
      String condoId);
  Future<List<int>> getPayday(String unitId);
  Future<List<AgreementInstallmentCreditModel>> getInstallmentsCredit(
      String condoId, double totalValue);
  Future<AgreementModel> postAgreement(
      String condoId, AgreementCreatedModel body);
  Future<AgreementModel> getAgreementDetail(String condoId, String agreementId);
}
