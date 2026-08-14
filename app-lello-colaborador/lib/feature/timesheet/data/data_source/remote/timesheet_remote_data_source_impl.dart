import 'package:colaborador/feature/timesheet/data/data_source/remote/timesheet_api.dart';
import 'package:colaborador/feature/timesheet/data/data_source/remote/timesheet_remote_data_source.dart';
import 'package:colaborador/feature/timesheet/data/model/timesheet_element_detail_model.dart';
import 'package:colaborador/feature/timesheet/data/model/timesheet_model.dart';
import 'package:colaborador/feature/timesheet/data/model/timesheet_periods_model.dart';
import 'package:essentials/essentials.dart';

class TimesheetRemoteDataSourceImpl extends TimesheetRemoteDataSource {
  final TimesheetApi api;

  TimesheetRemoteDataSourceImpl({required this.api});

  @override
  Future<TimesheetModel> getTimesheet(
      String condominiumId, DateTime period) async {
    Response response = await api.getTimesheet(condominiumId, period);
    return ApiMapper.map(
      response,
      (json) => TimesheetModel.fromJson(json),
    );
  }

  @override
  Future<List<TimesheetElementDetailModel>> getTimesheetDetail(
      String condominiumId, DateTime period) async {
    Response response = await api.getTimesheetDetail(condominiumId, period);
    return ApiMapper.mapList(
        response, (json) => TimesheetElementDetailModel.fromJson(json));
  }

  @override
  Future<List<TimesheetPeriodsModel>> getTimesheetPeriods(
      String condominiumId) async {
    Response response = await api.getTimesheetPeriods(condominiumId);
    return ApiMapper.mapList(
        response, (json) => TimesheetPeriodsModel.fromJson(json));
  }

  @override
  Future<bool> sendEmail(
      String condominiumId, String email, DateTime period) async {
    Response response = await api.sendEmail(condominiumId, email, period);
    if (response.isSuccessful) {
      return true;
    }
    return false;
  }

  @override
  Future<bool> signTimesheet(
      String condominiumId, String timesheetSignType, DateTime period) async {
    Response response =
        await api.signTimesheet(condominiumId, timesheetSignType, period);
    if (response.isSuccessful) {
      return true;
    }
    return false;
  }
}
