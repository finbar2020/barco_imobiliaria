import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/domain/entity/space_calendar_response.dart';
import 'package:lello/feature/space/reservation/data/data_source/local/reservation_summary/reservation_summary_local_data_source.dart';
import 'package:lello/feature/space/reservation/data/data_source/remote/reservation_summary/reservation_summary_remote_data_source.dart';
import 'package:lello/feature/space/reservation/data/model/reservation_summary_model.dart';
import 'package:lello/feature/space/reservation/domain/repository/reservation_summary_repository.dart';

class ReservationSummaryRepositoryImpl extends ReservationSummaryRepository {
  final ReservationSummaryLocalDataSource localDataSource;
  final ReservationSummaryRemoteDataSource remoteDataSource;

  ReservationSummaryRepositoryImpl(
      {required this.localDataSource, required this.remoteDataSource});

  @override
  Future<Try<SpaceCalendarResponse>> list(String condominiumId, String spaceId,
      DateTime periodStart, DateTime periodEnd, DataOrigin origin) async {
    try {
      // final future = origin == DataOrigin.local
      //     ? localDataSource.list(condominiumId, periodStart, periodEnd)
      //     : remoteDataSource.list(
      //         condominiumId, spaceId, periodStart, periodEnd);

      final result = await remoteDataSource.list(
          condominiumId, spaceId, periodStart, periodEnd);

      // if (origin == DataOrigin.remote) {
      //   await _saveLocal(condominiumId, result);
      // }
      return Success(result.toEntity());
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }

  Future<void> _saveLocal(
      String condominiumId, List<ReservationSummaryModel> models) async {
    try {
      await localDataSource.save(condominiumId, models);
    } catch (_) {}
  }
}
