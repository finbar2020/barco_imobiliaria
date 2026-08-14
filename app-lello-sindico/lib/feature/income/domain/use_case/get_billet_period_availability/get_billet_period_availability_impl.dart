import 'package:essentials/essentials.dart';
import 'package:lello/feature/income/data/repository/billets_repository.dart';
import 'package:lello/feature/income/domain/entity/billet_periods_availability.dart';
import 'package:lello/feature/income/domain/use_case/get_billet_period_availability/get_billet_period_availability.dart';

class GetBilletPeriodAvailabilityUseCaseImpl
    extends GetBilletPeriodAvailabilityUseCase {
  final BilletsRepository repository;
  GetBilletPeriodAvailabilityUseCaseImpl({required this.repository});

  @override
  Future<Try<BilletPeriodAvailability?>> call(
      GetBilletPeriodAvailabilityParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.getBilletPeriodAvailability(
        condominiumId: params.condominiumId,
        limit: params.limit,
        page: params.page);
  }

  Failure? _validate(GetBilletPeriodAvailabilityParam? params) {
    if (params == null) return InvalidParamFailure();
    if (params.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
