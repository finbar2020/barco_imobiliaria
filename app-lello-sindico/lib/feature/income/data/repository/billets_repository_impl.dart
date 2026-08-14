import 'package:essentials/essentials.dart';
import 'package:lello/feature/income/data/data_source/remote/billets_remote_data_source.dart';
import 'package:lello/feature/income/data/repository/billets_repository.dart';
import 'package:lello/feature/income/domain/entity/billet.dart';
import 'package:lello/feature/income/domain/entity/billet_periods_availability.dart';

import '../../../unit/domain/entity/unit.dart';
import '../../domain/entity/billet_filter_parameters.dart';

class BilletsRepositoryImpl extends BilletsRepository {
  final BilletsRemoteDataSource remoteDataSource;

  BilletsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Try<Billet?>> get(
      String condominiumId, String unitId, DateTime period) async {
    try {
      final result = await remoteDataSource.get(condominiumId, unitId, period);
      return Success(result);
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<List<Unit>>> getUnitsByBillets(
    String condominiumId,
    BilletFilter filter,
  ) async {
    try {
      final future = remoteDataSource.getUnitsByBillets(
        condominiumId: condominiumId,
        query: filter.query,
        status: enumToString(filter.status),
        period: filter.period,
        lastUnitId: filter.lastUnitId,
      );
      final result = await future;

      return Success(result.map((e) => e.toEntity()).toList());
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<BilletPeriodAvailability>> getBilletPeriodAvailability(
      {required String condominiumId,
      required int? limit,
      required int? page}) async {
    try {
      final data = await remoteDataSource.getBilletPeriodAvailability(
          condominiumId: condominiumId, limit: limit, page: page);
      final entity = data.toEntity();
      return Success(entity);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance
          .recordError(e, stacktrace, reason: 'contentId: $condominiumId ');
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<XFile?>> downloadPdf({
    required Billet billet,
    required String reference,
  }) async {
    try {
      final result = await remoteDataSource.downloadPdf(
        billet: billet,
        reference: reference,
      );
      return Success(result);
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }
}
