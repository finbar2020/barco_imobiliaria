import 'package:essentials/essentials.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:morar/feature/accountability/data/data_source/accountability_remote_data_source.dart';
import 'package:morar/feature/accountability/domain/entity/accountability.dart';
import 'package:morar/feature/accountability/domain/entity/accountability_periods.dart';
import 'package:morar/feature/accountability/domain/repository/accountability_repository.dart';

class AccountabilityRepositoryImpl extends AccountabilityRepository {
  final AccountabilityRemoteDataSource dataSource;

  AccountabilityRepositoryImpl({required this.dataSource});

  @override
  Future<Try<Accountability>> select(
      String condominiumId, DateTime period) async {
    try {
      final data = await dataSource.select(condominiumId, period);
      return Success(data.toEntity());
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'condominiumId: $condominiumId - period: $period',
      );
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<List<AccountabilityPeriods>>> getPeriod(
      String condominiumId) async {
    try {
      final data = await dataSource.getPeriod(condominiumId);
      return Success(data.map((e) => e.toEntity()).toList());
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
