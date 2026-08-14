import 'package:essentials/essentials.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:morar/feature/home/data/data_source/home_remote_data_source.dart';
import 'package:morar/feature/home/domain/entity/home_banner.dart';
import 'package:morar/feature/home/domain/repository/home_repository.dart';

class HomeRepositoryImpl extends HomeRepository {
  final HomeRemoteDataSource dataSource;

  HomeRepositoryImpl({required this.dataSource});

  @override
  Future<Try<List<HomeBanner>>> getBanners(String condominiumId) async {
    try {
      final data = await dataSource.getBanners(condominiumId);
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

  @override
  Future<Try<String>> getLink(String unitId) async {
    try {
      final data = await dataSource.getLink(unitId);
      return Success(data);
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
  Future<Try<String>> postTerms(String unitId) async {
    try {
      final data = await dataSource.postTerms(unitId);
      return Success(data);
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
