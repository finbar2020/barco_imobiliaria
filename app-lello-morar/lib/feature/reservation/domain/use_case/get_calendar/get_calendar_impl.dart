import 'package:essentials/essentials.dart';
import 'package:morar/feature/reservation/domain/entity/space_calendar_response.dart';
import 'package:morar/feature/reservation/domain/repository/reserve_repository.dart';
import 'package:morar/feature/reservation/domain/use_case/get_calendar/get_calendar.dart';

class GetCalendarImpl extends GetCalendar {
  final ReservationRepository repository;

  GetCalendarImpl({required this.repository});

  @override
  Future<Try<SpaceCalendarResponse>> call(GetCalendarParam params) async {
    final error = validate(params);

    if (error != null) return Rejection(error);

    final result = await repository.getCalendar(
      params.condominiumId,
      params.spaceId,
      params.startDate,
      params.endDate,
    );

    return result;
  }

  Failure? validate(GetCalendarParam params) {
    if (params.condominiumId.isEmpty) return InvalidParamFailure();
    if (params.spaceId.isEmpty) return InvalidParamFailure();

    return null;
  }
}
