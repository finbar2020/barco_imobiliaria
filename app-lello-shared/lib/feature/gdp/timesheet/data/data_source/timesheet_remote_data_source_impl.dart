import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/data/model/employee_model.dart';
import 'package:shared_features/feature/gdp/timesheet/data/data_source/timesheet_api.dart';
import 'package:shared_features/feature/gdp/timesheet/data/data_source/timesheet_remote_data_source.dart';
import 'package:shared_features/feature/gdp/timesheet/data/model/timesheet_event_model.dart';
import 'package:shared_features/feature/gdp/timesheet/data/model/timesheet_model.dart';
import 'package:shared_features/feature/gdp/timesheet/data/model/timesheet_report_day_model.dart';
import 'package:shared_features/feature/gdp/timesheet/data/model/timesheet_signature_model.dart';
import 'package:shared_features/feature/gdp/timesheet/data/model/timesheet_signature_request_model.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_filter.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_signature.dart';

class TimesheetGDPRemoteDataSourceImpl implements TimesheetGDPRemoteDataSource {
  TimesheetGDPApi api;

  TimesheetGDPRemoteDataSourceImpl({required this.api});

  @override
  Future<List<TimesheetModel>> list(
      String condominiumId, TimesheetFilter? filter) async {
    final response = await api.list(condominiumId,
        name: filter?.name,
        idEmployee: filter?.id,
        type: enumToString(filter?.type),
        dobFrom: filter?.dobFrom,
        dobTo: filter?.dobTo);
    return ApiMapper.mapList(response, (json) => TimesheetModel.fromJson(json));
  }

  @override
  Future<List<EmployeeModel>> listEmployees(String condominiumId) async {
    final response = await api.listEmployees(condominiumId);
    return ApiMapper.mapList(response, (json) => EmployeeModel.fromJson(json));
  }

  @override
  Future<TimesheetReportDayModel> getReportDay(
      String condominiumId, TimesheetFilter? filter) async {
    final response = await api.getReportDay(condominiumId,
        name: filter?.name,
        idEmployee: filter?.id,
        type: enumToString(filter?.type),
        dobFrom: filter?.dobFrom,
        dobTo: filter?.dobTo);
    return ApiMapper.map(
        response, (json) => TimesheetReportDayModel.fromJson(json));
  }

  @override
  Future<List<TimesheetSignatureModel>> listSignature(
      String condominiumId, TimesheetFilter? filter) async {
    final response = await api.listSignature(condominiumId,
        name: filter?.name,
        idEmployee: filter?.id,
        type: enumToString(filter?.type),
        dobFrom: filter?.dobFrom,
        dobTo: filter?.dobTo);
    return ApiMapper.mapList(
        response, (json) => TimesheetSignatureModel.fromJson(json));
  }

  @override
  Future<List<TimesheetSignatureModel>> sign(
      String condominiumId, List<TimesheetSignature> signatures) async {
    TimesheetSignatureRequestModel request =
        new TimesheetSignatureRequestModel();
    request.signaturesRequest = signatures
        .map((model) => TimesheetSignatureModel.fromEntity(model)!)
        .toList();
    final response = await api.sign(condominiumId, request);
    return ApiMapper.mapList(
        response, (json) => TimesheetSignatureModel.fromJson(json));
  }

  @override
  Future<TimesheetEventModel> insertTimesheetEvent(
      String condominiumId, TimesheetEventModel events) async {
    final response = await api.insertTimesheetEvent(condominiumId, events);
    return ApiMapper.map(
        response, (json) => TimesheetEventModel.fromJson(json));
  }

  @override
  Future<String> requestTimesheet(String condominiumId) async {
    final response = await api.requestTimesheet(condominiumId);
    if (response.error != null) {
      throw Exception();
    } else {
      return "Success";
    }
  }

  // @override
  // Future<TimesheetFileModel> getFile(String nameFile, String registrationNumber) async {
  //   final response = await api.getFile(nameFile, registrationNumber);
  //   final model = ApiMapper.map(response, (json) => TimesheetFileModel.fromJson(json));
  //   return model;
  // }

}
