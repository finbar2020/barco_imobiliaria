import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_element_detail.dart';
import 'package:colaborador/feature/timesheet/domain/use_case/get_timesheet_detail/get_timesheet_detail.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_detail_page/bloc/timesheet_detail_event.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_detail_page/bloc/timesheet_detail_state.dart';
import "package:collection/collection.dart";
import 'package:flutter_bloc/flutter_bloc.dart';

class TimesheetDetailBloc
    extends Bloc<TimesheetDetailEvent, TimesheetDetailState> {
  final GetTimesheetDetailUsecase getTimesheetDetailUsecase;
  final SessionBloc sessionBloc;

  TimesheetDetailBloc({
    required this.getTimesheetDetailUsecase,
    required this.sessionBloc,
  }) : super(const TimesheetDetailInitialState()) {
    on<GetTimesheetDetailEvent>(_mapGetTimesheetDetail);
  }

  void getTimesheetDetail({required DateTime period}) {
    add(GetTimesheetDetailEvent(period));
  }

  Future<void> _mapGetTimesheetDetail(
    GetTimesheetDetailEvent event,
    Emitter<TimesheetDetailState> emit,
  ) async {
    emit(const TimesheetDetailLoadingState());
    String condoId = sessionBloc.getSession?.condominium.id ?? "";

    final result = await getTimesheetDetailUsecase.call(GetTimesheetDetailParam(
      condoId: condoId,
      period: event.period,
    ));

    TimesheetDetailState response = result.fold(
      (err) => TimesheetDetailFailedState(failure: err),
      (res) {
        return TimesheetDetailLoadedState(
            timesheetDetail:
                groupBy(res, (TimesheetElementDetail obj) => obj.date));
      },
    );

    emit(response);
  }
}
