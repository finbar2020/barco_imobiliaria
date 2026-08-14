import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/reservation/data/data_source/remote/reservation_time/reservation_time_remote_data_source.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_time.dart';
import 'package:lello/feature/space/reservation/domain/repository/reservation_time_repository.dart';

class ReservationTimeRepositoryImpl extends ReservationTimeRepository {
  final ReservationTimeRemoteDataSource dataSource;

  ReservationTimeRepositoryImpl({required this.dataSource});
  @override
  Future<Try<List<ReservationTime>>> list(
    String condominiumId,
    String spaceId,
    DateTime date,
  ) async {
    try {
      final result = await dataSource.list(condominiumId, spaceId, date);
      return Success(result.map((e) => e.toEntity()).toList());
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }
}
