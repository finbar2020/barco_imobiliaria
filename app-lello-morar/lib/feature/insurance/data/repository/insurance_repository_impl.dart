import 'package:essentials/essentials.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:morar/feature/insurance/data/data_source/insurance_remote_data_source.dart';
import 'package:morar/feature/insurance/domain/entity/insurance.dart';
import 'package:morar/feature/insurance/domain/repository/insurance_repository.dart';

class InsuranceRepositoryImpl extends InsuranceRepository {
  final InsuranceRemoteDataSource remoteDataSource;

  InsuranceRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Try<Insurance>> getInsurance(String unitId) async {
    try {
      final result = await remoteDataSource.getInsurance(unitId);
      Insurance entity = result.toEntity();
      return Success(entity);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'unitId: $unitId',
      );
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<String>> postInsurance(String unitId) async {
    try {
      final result = await remoteDataSource.postInsurance(unitId);
      return Success(result);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'unitId: $unitId',
      );
      return Rejection(UnknownFailure(e));
    }
  }
}
