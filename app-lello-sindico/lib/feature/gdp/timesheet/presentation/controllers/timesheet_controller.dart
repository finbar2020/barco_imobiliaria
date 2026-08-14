import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/gdp/timesheet/data/model/timesheet_signature_model.dart';
import 'package:lello/feature/gdp/timesheet/data/model/timesheet_signature_request_model.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_employee.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_employee_detail_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_employee_detail/get_employee_detail.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_list_employee/get_list_employee.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/put_signature_notify/post_signature_notify.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet/timesheet_bloc.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet/timesheet_event.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';

class TimesheetController {
  final SessionBloc sessionBloc;
  final TimesheetBloc bloc;
  final GetListEmployees getListTimesheet;
  final GetEmployeeDetail getEmployeeDetail;
  final String baseUrl;
  final PutSignatureNotify putSignatureNotify;

  TimesheetController({
    required this.sessionBloc,
    required this.getListTimesheet,
    required this.getEmployeeDetail,
    required this.bloc,
    required this.baseUrl,
    required this.putSignatureNotify,
  });

  final AuthenticationStore authenticationStore =
      ApplicationContainer.instance().resolve();
  var customHeader;

  List<TimesheetEmployee> list = [];
  DateTime selectedDate = DateTime.now();

  TimesheetEmployee? timesheetEmployee;
  TimesheetEmployeeDetailEntity? employeeDetail;

  String photoUrl(String hash) {
    return "$baseUrl/condominiums/${sessionBloc.state.session?.selectedCondominium?.id}/employees/photo/$hash";
  }

  Future<void> getList(DateTime date) async {
    bloc.add(TimesheetLoadingEvent());
    customHeader = authenticationStore.getCustomHeader();
    selectedDate = date;
    final result = await getListTimesheet.call(GetListEmployeesParam(
        id: sessionBloc.state.session?.selectedCondominium?.id ?? ""));

    result.fold(
      (err) => bloc.add(TimesheetFailedEvent()),
      (data) {
        list = data;

        bloc.add(TimesheetLoadedEvent(list: data));
      },
    );
  }

  Future<void> getDetailFromEmployee(TimesheetEmployee employee) async {
    bloc.add(TimesheetLoadingEvent());
    final result = await getEmployeeDetail.call(GetEmployeeDetailParam(
        date: selectedDate, numCra: employee.numCra ?? ''));

    result.fold(
        (err) =>
            bloc.add(TimesheetLoadedEvent(list: list, getDetailFailed: true)),
        (data) {
      employeeDetail = data;
      timesheetEmployee = employee;
      bloc.add(TimesheetDetailLoadedEvent(entity: data, employee: employee));
    });
  }

  Future getTimesheetReport() async {
    bloc.add(TimesheetLoadingEvent());

    try {
      String numCra = timesheetEmployee?.numCra ?? '';
      DateTime date = selectedDate;
      File getFile = await DefaultCacheManager().getSingleFile(
        '$baseUrl/timesheet/report?numcra=$numCra&date=$date&type=PDF',
        headers: customHeader,
      );
      bloc.add(TimesheetDetailLoadedEvent(
          entity: employeeDetail!, employee: timesheetEmployee!, pdf: getFile));
      return;
    } catch (e) {
      bloc.add(TimesheetDetailLoadedEvent(
          entity: employeeDetail!, employee: timesheetEmployee!));
    }
  }

  Future postSignatureOrNotify({bool notify = false}) async {
    bloc.add(TimesheetLoadingEvent());
    List<TimesheetSignatureModel> signatures = [];
    if (notify) {
      signatures.add(TimesheetSignatureModel(
          numCra: timesheetEmployee?.numCra, notify: true));
    } else {
      signatures.add(TimesheetSignatureModel(
          id: employeeDetail?.signatureId ?? 0, approvedFlag: true));
    }
    final result = await putSignatureNotify.call(PutSignatureNotifyParam(
        model: TimesheetSignatureRequestModel(signaturesRequest: signatures)));

    result.fold(
        (err) => bloc.add(TimesheetDetailLoadedEvent(
            entity: employeeDetail!,
            employee: timesheetEmployee!,
            putFailed: true)), (data) {
      employeeDetail = null;
      timesheetEmployee = null;
      bloc.add(TimesheetLoadedEvent(list: list, saveSignatureOrNotify: notify));
    });
  }

  previousStep() {
    employeeDetail = null;
    timesheetEmployee = null;
    bloc.add(TimesheetLoadedEvent(list: list));
  }

  void dispose() {
    list = [];
  }
}
