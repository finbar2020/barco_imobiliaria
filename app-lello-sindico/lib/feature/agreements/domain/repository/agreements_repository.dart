import 'package:essentials/essentials.dart';
import 'package:lello/feature/agreements/domain/entity/agreement.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_analysis/agreements_analysis.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_update_status.dart';
import 'package:lello/feature/agreements/domain/entity/agreements_all_info.dart';
import 'package:lello/feature/agreements/domain/entity/agreements_rules.dart';

abstract class AgreementsRepository {
  Future<Try<AgreementsAnalysis>> getAnalysis(
      String condominiumId, String? fromDate, String? toDate);
  Future<Try<AgreementsAllInfo?>> selectAllAgreementsInfoFromCache(
      String condominiumId);
  Future<Try<AgreementsAllInfo>> getAllAgreementsInfo(String condominiumId);
  Future<Try<AgreementsRules>> getRules(String condominiumId);
  Future<Try<AgreementsRules>> changeRules(
      String condominiumId, AgreementsRules rules);
  Future<Try<Agreement>> agreementUpdateStatus(
      String condominiumId, AgreementUpdateStatus updateStatus);
}
