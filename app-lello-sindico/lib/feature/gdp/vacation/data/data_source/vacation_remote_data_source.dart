import 'package:lello/feature/gdp/vacation/data/model/vacation_created_model.dart';
import 'package:lello/feature/gdp/vacation/data/model/vacation_locked_days_model.dart';
import 'package:lello/feature/gdp/vacation/data/model/vacation_model.dart';
import 'package:lello/feature/gdp/vacation/data/model/vacation_params_model.dart';
import 'package:lello/feature/gdp/vacation/data/model/vacation_request_model.dart';

abstract class VacationRemoteDataSource {
  Future<VacationModel> find(String condominiumId, String employeeId);
  Future<VacationModel> requestVacation(
      String condominiumId, String employeeId, VacationRequestModel model);
  Future<VacationParamsModel> getVacationPeriod(
      String condominiumId, String employeeId);
  Future<VacationLockedDaysModel> getLockedDays(
    String condominiumId,
    String employeeId,
    DateTime startDate,
    DateTime endDate,
  );

  Future<VacationCreatedModel> createVacation(String condominiumId,
      String employeeId, VacationCreatedModel? vacationCreated);
}
