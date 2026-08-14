import 'package:essentials/essentials.dart';
import 'package:lello/feature/income/domain/entity/billet_periods_availability.dart';

abstract class GetBilletPeriodAvailabilityUseCase extends UseCase<
    BilletPeriodAvailability?, GetBilletPeriodAvailabilityParam> {}

class GetBilletPeriodAvailabilityParam {
  final String condominiumId;
  final int? limit;
  final int? page;
  GetBilletPeriodAvailabilityParam(
      {required this.condominiumId, required this.limit, required this.page});
}
