import 'package:essentials/essentials.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:lello/feature/space/reservation/data/data_source/remote/reservation_rule/reservation_rule_remote_data_source.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_change_rules.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_rule.dart';
import 'package:lello/feature/space/reservation/domain/repository/reservation_rule_repository.dart';

class ReservationRuleRepositoryImpl extends ReservationRuleRepository {
  final ReservationRuleRemoteDataSource dataSource;
  ReservationRuleRepositoryImpl({required this.dataSource});

  @override
  Future<Try<ReservationRule>> select(
      String condominiumId, String spaceId) async {
    try {
      final model = await dataSource.select(condominiumId, spaceId);
      return Success(model.toEntity());
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'condominiumId: $condominiumId - spaceId: $spaceId',
      );
      return Rejection(UnknownFailure(e));
    }
  }

  //MOCKS DA REGRA DE MUDANÇA

  @override
  Future<Try<ReservationChangeRules>> getChangeRules(
      String condominiumId) async {
    try {
      final model = await dataSource.getChangeRules(condominiumId);
      return Success(model.toEntity());
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'condominiumId: $condominiumId',
      );
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<String>> postChangeRules(
      String condominiumId, Map<String, dynamic> body) async {
    try {
      final response = await dataSource.postChangeRules(condominiumId, body);
      return Success(response);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'condominiumId: $condominiumId',
      );
      return Rejection(UnknownFailure(e));
    }
  }
}
