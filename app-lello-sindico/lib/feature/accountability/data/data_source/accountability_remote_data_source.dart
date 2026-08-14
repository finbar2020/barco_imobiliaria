import 'package:lello/feature/accountability/data/model/accountability_model.dart';
import 'package:lello/feature/accountability/data/model/accountability_period_model.dart';
import 'package:lello/feature/accountability/data/model/acountability_doubt_request_model.dart';
import 'package:lello/feature/accountability/data/model/acountability_doubt_response_model.dart';
import 'package:lello/feature/accountability/data/model/acountability_question_model.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_doubt_situation.dart';

abstract class AccountabilityRemoteDataSource {
  Future<List<AccountabilityPeriodModel>> getPeriod(String condominiumId);
  Future<AccountabilityModel> select(String condominiumId, DateTime period);
  Future<List<AccountabilityQuestionTypeModel>> listType(String condominiumId);
  Future<List<AccountabilityDoubtResponseModel>> listDoubt(
      String condominiumId, DoubtSituation? questionSituation);
  Future<List<AccountabilityDoubtResponseModel>> listDoubtDetail(
      String condominiumId, String id);
  Future<AccountabilityDoubtResponseModel> sendDoubt(
      String condominiumId, AccountabilityDoubtRequestModel doubt);
  Future<void> sendRecommendation(String condominiumId, DateTime period);
}
