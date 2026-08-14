import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/domain/entity/space_calendar_response.dart';
import 'package:lello/feature/space/reservation/domain/repository/reservation_summary_repository.dart';
import 'package:lello/feature/space/reservation/domain/use_case/list_reservation_summary/list_reservation_summary.dart';

class ListReservationSummaryImpl extends ListReservationSummary {
  final ReservationSummaryRepository repository;

  ListReservationSummaryImpl({required this.repository});

  @override
  Future<Try<SpaceCalendarResponse>> call(
      ListReservationSummaryParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.list(params.condominiumId, params.spaceId,
        params.periodStart, params.periodEnd, params.origin);
  }

  Failure? _validate(ListReservationSummaryParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
