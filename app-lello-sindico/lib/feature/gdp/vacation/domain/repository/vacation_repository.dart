import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/vacation/domain/entity/vacation.dart';
import 'package:lello/feature/gdp/vacation/domain/entity/vacation_created.dart';
import 'package:lello/feature/gdp/vacation/domain/entity/vacation_locked_days.dart';
import 'package:lello/feature/gdp/vacation/domain/entity/vacation_params.dart';
import 'package:lello/feature/gdp/vacation/domain/entity/vacation_request.dart';

abstract class VacationRepository {
  Future<Try<Vacation>> getVacation(String condominiumId, String employeeId);
  Future<Try<VacationParams>> getVacationPeriod(
      String condominiumId, String employeeId);
  Future<Try<Vacation>> scheduleVacation(VacationRequest request);
  Future<Try<VacationCreated>> createVacation({
    required String condominiumId,
    required String employeeId,
    required VacationCreated vacationCreated,
  });
  Future<Try<VacationLockedDays>> getLockedDays(
    String condominiumId,
    String employeeId,
    DateTime startDate,
    DateTime endDate,
  );
}
