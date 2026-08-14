import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/vacation/data/data_source/vacation_api.dart';
import 'package:shared_features/feature/gdp/vacation/data/data_source/vacation_remote_data_source.dart';
import 'package:shared_features/feature/gdp/vacation/data/model/vacation_created_model.dart';
import 'package:shared_features/feature/gdp/vacation/data/model/vacation_locked_days_model.dart';
import 'package:shared_features/feature/gdp/vacation/data/model/vacation_model.dart';
import 'package:shared_features/feature/gdp/vacation/data/model/vacation_params_model.dart';
import 'package:shared_features/feature/gdp/vacation/data/model/vacation_request_model.dart';

class VacationRemoteDataSourceImpl implements VacationRemoteDataSource {
  VacationApi api;

  VacationRemoteDataSourceImpl({required this.api});

  @override
  Future<VacationModel> find(String condominiumId, String employeeId) async {
    final response = await api.getEmployeeVacation(condominiumId, employeeId);
    final model =
        ApiMapper.map(response, (json) => VacationModel.fromJson(json));
    model.reference = condominiumId;
    return model;
  }

  @override
  Future<VacationModel> requestVacation(String condominiumId, String employeeId,
      VacationRequestModel model) async {
    final response =
        await api.postEmployeeVacation(condominiumId, employeeId, model);
    return ApiMapper.map(response, (json) => VacationModel.fromJson(json));
  }

  @override
  Future<VacationParamsModel> getVacationPeriod(
      String condominiumId, String employeeId) async {
    final response = await api.getVacationPeriod(condominiumId, employeeId);
    return ApiMapper.map(
        response, (json) => VacationParamsModel.fromJson(json));
  }

  @override
  Future<VacationLockedDaysModel> getLockedDays(
    String condominiumId,
    String employeeId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    String insertNumber(String date) {
      if (date.length == 1) {
        return "0$date";
      } else {
        return "$date";
      }
    }

    final response = await api.getLockedDays(
      condominiumId,
      employeeId,
      "${startDate.year}-${insertNumber(startDate.month.toString())}-${insertNumber(startDate.day.toString())}",
      "${endDate.year}-${insertNumber(endDate.month.toString())}-${insertNumber(endDate.day.toString())}",
    );

    return ApiMapper.map(
        response, (json) => VacationLockedDaysModel.fromJson(json));
  }

  @override
  Future<VacationCreatedModel> createVacation(String condominiumId,
      String employeeId, VacationCreatedModel? vacationCreated) async {
    final response =
        await api.createVacation(condominiumId, employeeId, vacationCreated);
    return ApiMapper.map(
        response, (json) => VacationCreatedModel.fromJson(json));
  }
}
