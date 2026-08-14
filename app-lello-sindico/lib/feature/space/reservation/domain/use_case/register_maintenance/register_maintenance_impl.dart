import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation.dart';
import 'package:lello/feature/space/reservation/domain/repository/reservation_repository.dart';
import 'package:lello/feature/space/reservation/domain/use_case/register_maintenance/register_maintenance.dart';

class RegisterMaintenanceImpl extends RegisterMaintenance {
  final ReservationRepository repository;
  RegisterMaintenanceImpl({required this.repository});

  @override
  Future<Try<Reservation>> call(RegisterMaintenanceParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.insertMaintenance(
        params.condominiumId, params.registration);
  }

  Failure? _validate(RegisterMaintenanceParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();

    return null;
  }
}
