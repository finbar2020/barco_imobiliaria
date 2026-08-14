import 'package:essentials/essentials.dart';
import 'package:lello/feature/agreements/data/data_source/local/agreements_local_data_source.dart';
import 'package:lello/feature/agreements/data/data_source/remote/agreements_remote_data_source.dart';
import 'package:lello/feature/agreements/data/model/agreement_update_status_model.dart';
import 'package:lello/feature/agreements/data/model/agreements_rules_model.dart';
import 'package:lello/feature/agreements/domain/entity/agreement.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_analysis/agreements_analysis.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_update_status.dart';
import 'package:lello/feature/agreements/domain/entity/agreements_all_info.dart';
import 'package:lello/feature/agreements/domain/entity/agreements_rules.dart';
import 'package:lello/feature/agreements/domain/repository/agreements_repository.dart';

class AgreementsRepositoryImpl extends AgreementsRepository {
  final AgreementsRemoteDataSource remoteDataSource;
  final AgreementsLocalDataSource localDataSource;

  AgreementsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Try<AgreementsAnalysis>> getAnalysis(
      String condominiumId, String? fromDate, String? toDate) async {
    try {
      final data =
          await remoteDataSource.getAnalysis(condominiumId, fromDate, toDate);
      return Success(data.toEntity());
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<AgreementsAllInfo>> getAllAgreementsInfo(
      String condominiumId) async {
    try {
      final data = await remoteDataSource.getAllAgreementsInfo(condominiumId);
      await localDataSource.saveAllInfo(data, condominiumId);
      return Success(data.toEntity());
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<AgreementsAllInfo?>> selectAllAgreementsInfoFromCache(
      String condominiumId) async {
    try {
      final agreementsAllInfoModel =
          await localDataSource.selectAllInfo(condominiumId);
      return Success(agreementsAllInfoModel?.toEntity());
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<AgreementsRules>> getRules(String condominiumId) async {
    try {
      final data = await remoteDataSource.getRules(condominiumId);
      return Success(data.toEntity());
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<AgreementsRules>> changeRules(
      String condominiumId, AgreementsRules newRules) async {
    try {
      AgreementsRulesModel agreementsRulesModel =
          AgreementsRulesModel.fromEntity(newRules)!;
      final data = await remoteDataSource.changeRules(
          condominiumId, agreementsRulesModel);
      await localDataSource.saveRules(data, condominiumId);
      return Success(data.toEntity());
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<Agreement>> agreementUpdateStatus(
      String condominiumId, AgreementUpdateStatus updateStatus) async {
    try {
      AgreementUpdateStatusModel updateStatusModel =
          AgreementUpdateStatusModel.fromEntity(updateStatus)!;
      final data = await remoteDataSource.agreementUpdateStatus(
          condominiumId, updateStatusModel);
      return Success(data.toEntity());
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }
}
