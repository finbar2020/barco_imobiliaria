import 'package:essentials/essentials.dart';
import 'package:essentials/network/api_failure.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:morar/feature/agreements/data/data_source/agreements_remote_data_source.dart';
import 'package:morar/feature/agreements/data/model/agreement_created_model.dart';
import 'package:morar/feature/agreements/domain/entity/agreement.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_all_info.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_created.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_installment_credit.dart';
import 'package:morar/feature/agreements/domain/entity/agreements_recommendatio_payment.dart';
import 'package:morar/feature/agreements/domain/repository/agreements_repository.dart';

class AgreementsRepositoryImpl extends AgreementsRepository {
  final AgreementsRemoteDataSource remoteDataSource;

  AgreementsRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Try<AgreementAllInfo>> getAllInfo(
      String condoId, String unitTitle, bool onlyQuoteAndRule) async {
    try {
      final data = await remoteDataSource.getAllInfo(
          condoId, unitTitle, onlyQuoteAndRule);
      final entity = data.toEntity();
      return Success(entity);
    } catch (e, stacktrace) {
      if (e is ApiFailure) {
        switch (e.status) {
          case 406:
            return Rejection(
                KnownFailure(e.failure?.toString() ?? "not_acceptable", e));
          default:
            FirebaseCrashlytics.instance.recordError(
              e,
              stacktrace,
              reason: 'condominiumId: $condoId - unitTitle: $unitTitle',
            );
            return Rejection(UnknownFailure(e));
        }
      } else {
        FirebaseCrashlytics.instance.recordError(
          e,
          stacktrace,
          reason: 'condominiumId: $condoId - unitTitle: $unitTitle',
        );
        return Rejection(UnknownFailure(e));
      }
    }
  }

  @override
  Future<Try<List<AgreementRecommendationPayment>>> getRecommendation(
      String condoId) async {
    try {
      final data = await remoteDataSource.getRecommendation(condoId);
      return Success(data.map((model) => model.toEntity()).toList());
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<List<String>>> getPayday(String condoId) async {
    try {
      final data = await remoteDataSource.getPayday(condoId);
      List<String> lista =
          List.generate(data.length, (index) => data[index].toString());
      return Success(lista);
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<List<AgreementInstallmentCredit>>> getInstallmentCredit(
    String condoId,
    double totalValue,
  ) async {
    try {
      final data =
          await remoteDataSource.getInstallmentsCredit(condoId, totalValue);
      return Success(data.map((model) => model.toEntity()).toList());
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<Agreement>> postAgreement(
      String condoId, AgreementCreated body) async {
    try {
      AgreementCreatedModel bodyModel = AgreementCreatedModel.fromEntity(body);
      final data = await remoteDataSource.postAgreement(condoId, bodyModel);
      return Success(data.toEntity());
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<Agreement>> getAgreementDetail(
      String condoId, String agreementId) async {
    try {
      final data =
          await remoteDataSource.getAgreementDetail(condoId, agreementId);
      return Success(data.toEntity());
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }
}
