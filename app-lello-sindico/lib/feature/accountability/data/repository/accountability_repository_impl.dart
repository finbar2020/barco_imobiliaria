import 'package:essentials/essentials.dart';
import 'package:lello/feature/accountability/data/data_source/accountability_remote_data_source.dart';
import 'package:lello/feature/accountability/data/model/acountability_doubt_request_model.dart';
import 'package:lello/feature/accountability/domain/entity/accountability.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_doubt.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_doubt_situation.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_periods.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_question_type_solicitation.dart';
import 'package:lello/feature/accountability/domain/repository/accountability_repository.dart';
import 'package:lib_facedetection/lib_facedetection.dart';

class AccountabilityRepositoryImpl extends AccountabilityRepository {
  final AccountabilityRemoteDataSource dataSource;

  AccountabilityRepositoryImpl({required this.dataSource});

  @override
  Future<Try<Accountability>> select(
      String condominiumId, DateTime period) async {
    try {
      final data = await dataSource.select(condominiumId, period);
      return Success(data.toEntity());
    } catch (ex) {
      //todo: handle http error
      return Rejection(UnknownFailure(ex));
    }
  }

  @override
  Future<Try<List<AccountabilityPeriods>>> getPeriod(
      String condominiumId) async {
    try {
      final data = await dataSource.getPeriod(condominiumId);
      return Success(data.map((e) => e.toEntity()).toList());
    } catch (ex) {
      //todo: handle http error
      return Rejection(UnknownFailure(ex));
    }
  }

  @override
  Future<Try<List<AccountabilityQuestionType>>> listType(
      String condominiumId) async {
    try {
      final data = await dataSource.listType(condominiumId);
      return Success(data.map((e) => e.toEntity()).toList());
    } catch (ex) {
      //todo: handle http error
      return Rejection(UnknownFailure(ex));
    }
  }

  @override
  Future<Try<List<AccountabilityDoubt>>> listDoubt(
      String condominiumId, DoubtSituation? questionSituation) async {
    try {
      final data = await dataSource.listDoubt(condominiumId, questionSituation);
      return Success(data.map((e) => e.toEntity()).toList());
    } catch (ex) {
      //todo: handle http error
      return Rejection(UnknownFailure(ex));
    }
  }

  @override
  Future<Try<List<AccountabilityDoubt>>> listDoubtDetail(
      String condominiumId, String id) async {
    try {
      final data = await dataSource.listDoubtDetail(condominiumId, id);
      return Success(data.map((e) => e.toEntity()).toList());
    } catch (ex) {
      //todo: handle http error
      return Rejection(UnknownFailure(ex));
    }
  }

  @override
  Future<Try<AccountabilityDoubt>> sendDoubt(
      String condominiumId, AccountabilityDoubt doubt) async {
    try {
      final data = await dataSource.sendDoubt(
          condominiumId, AccountabilityDoubtRequestModel.fromEntity(doubt));
      return Success(data.toEntity());
    } catch (ex) {
      //todo: handle http error
      return Rejection(UnknownFailure(ex));
    }
  }

  @override
  Future<Try<void>> sendRecommendation(
      String condominiumId, DateTime period) async {
    try {
      await dataSource.sendRecommendation(condominiumId, period);
      return Success(voidRight);
    } catch (ex) {
      //todo: handle http error
      return Rejection(UnknownFailure(ex));
    }
  }
}
