import 'package:essentials/essentials.dart';
import 'package:morar/feature/agreements/domain/entity/agreement.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_all_info.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_created.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_installment_credit.dart';
import 'package:morar/feature/agreements/domain/entity/agreements_recommendatio_payment.dart';

abstract class AgreementsRepository {
  Future<Try<AgreementAllInfo>> getAllInfo(
      String condoId, String unitTitle, bool onlyQuoteAndRule);
  Future<Try<List<AgreementRecommendationPayment>>> getRecommendation(
      String condId);
  Future<Try<List<String>>> getPayday(String unitId);
  Future<Try<List<AgreementInstallmentCredit>>> getInstallmentCredit(
      String condoId, double totalValue);
  Future<Try<Agreement>> postAgreement(String condoId, AgreementCreated body);
  Future<Try<Agreement>> getAgreementDetail(String condoId, String agreementId);
}
