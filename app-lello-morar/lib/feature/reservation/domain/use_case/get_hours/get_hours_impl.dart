import 'package:essentials/essentials.dart';
import 'package:morar/feature/reservation/domain/entity/space_available_hours.dart';
import 'package:morar/feature/reservation/domain/repository/reserve_repository.dart';
import 'package:morar/feature/reservation/domain/use_case/get_hours/get_hours.dart';

class GetHoursImpl extends GetHours {
  final ReservationRepository repository;

  GetHoursImpl({required this.repository});

  @override
  Future<Try<List<SpaceAvailableHours>>> call(GetHoursParam params) async {
    final error = validate(params);

    if (error != null) return Rejection(error);

    final result = await repository.getHours(
      params.condominiumId,
      params.spaceId,
      params.date,
      params.unitId,
    );

    return result;
  }

  Failure? validate(GetHoursParam params) {
    if (params.condominiumId.isEmpty) return InvalidParamFailure();
    if (params.unitId.isEmpty) return InvalidParamFailure();

    return null;
  }
}
