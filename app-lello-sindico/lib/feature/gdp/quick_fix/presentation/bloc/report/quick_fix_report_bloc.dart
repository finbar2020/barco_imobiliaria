import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/gdp/quick_fix/domain/entity/employee_report_filter.dart';
import 'package:lello/feature/gdp/quick_fix/presentation/bloc/report/quick_fix_report_event.dart';
import 'package:lello/feature/gdp/quick_fix/presentation/bloc/report/quick_fix_report_state.dart';

abstract class QuickFixReportBloc
    extends Bloc<QuickFixReportEvent, QuickFixReportState> {
  QuickFixReportBloc(QuickFixReportState initialState) : super(initialState);

  void beginLoad(EmployeeReportFilter filter);
}
