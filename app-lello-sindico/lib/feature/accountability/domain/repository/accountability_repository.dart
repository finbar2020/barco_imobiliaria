import 'package:essentials/essentials.dart';
import 'package:lello/feature/accountability/domain/entity/accountability.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_doubt.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_doubt_situation.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_periods.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_question_type_solicitation.dart';

abstract class AccountabilityRepository {
  Future<Try<Accountability>> select(String condominiumId, DateTime period);
  Future<Try<List<AccountabilityPeriods>>> getPeriod(String condominiumId);
  Future<Try<List<AccountabilityQuestionType>>> listType(String condominiumId);
  Future<Try<List<AccountabilityDoubt>>> listDoubt(
      String condominiumId, DoubtSituation? questionSituation);
  Future<Try<List<AccountabilityDoubt>>> listDoubtDetail(
      String condominiumId, String id);
  Future<Try<AccountabilityDoubt>> sendDoubt(
      String condominiumId, AccountabilityDoubt doubt);
  Future<Try<void>> sendRecommendation(String condominiumId, DateTime period);
}
