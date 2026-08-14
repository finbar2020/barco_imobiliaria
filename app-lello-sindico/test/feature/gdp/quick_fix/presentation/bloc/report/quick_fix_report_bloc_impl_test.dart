import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/feature/condominium/domain/entity/condominium.dart';
import 'package:lello/feature/gdp/domain/entity/employee.dart';
import 'package:lello/feature/gdp/quick_fix/domain/entity/employee_report.dart';
import 'package:lello/feature/gdp/quick_fix/domain/entity/employee_report_filter.dart';
import 'package:lello/feature/gdp/quick_fix/domain/entity/employee_report_type.dart';
import 'package:lello/feature/gdp/quick_fix/domain/use_case/get_report/get_employee_report.dart';
import 'package:lello/feature/gdp/quick_fix/presentation/bloc/report/quick_fix_report_bloc.dart';
import 'package:lello/feature/gdp/quick_fix/presentation/bloc/report/quick_fix_report_bloc.dart';
import 'package:lello/feature/gdp/quick_fix/presentation/bloc/report/quick_fix_report_event.dart';
import 'package:lello/feature/gdp/quick_fix/presentation/bloc/report/quick_fix_report_state.dart';
import 'package:lello/feature/session/domain/entity/session.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';
import 'package:mockito/mockito.dart';

import '../../../../../../matcher/is_and_matcher.dart';

void main() {
  const EmployeeReport _employeeReport = null;
  final _session = Session()..selectedCondominium = Condominium(id: '123');
  final _employeeReportFilter = EmployeeReportFilter()
    ..employee = (Employee()..id = 'ABC')
    ..reportType = EmployeeReportType.vacation;
  GetEmployeeReport getEmployeeReport;
  SessionBloc sessionBloc;
  QuickFixReportBloc bloc;

  Future _setupLoaded(QuickFixReportBloc bloc, Session session,
      {EmployeeReport employeeReport = _employeeReport}) async {
    when(getEmployeeReport.call(any))
        .thenAnswer((_) async => Success(employeeReport));

    bloc.add(QuickFixReportLoadEvent(
        condominium: session.selectedCondominium,
        filter: _employeeReportFilter));
    await expectLater(
        bloc,
        emitsInOrder([
          isA<QuickFixReportLoadingState>(),
          isA<QuickFixReportLoadingState>(),
          isA<QuickFixReportLoadedState>(),
        ]));
  }

  setUp(() {
    getEmployeeReport = GetEmployeeReportMock();
    sessionBloc = SessionBlocMock();
    bloc = QuickFixReportBloc(
        sessionBloc: sessionBloc, getEmployeeReport: getEmployeeReport);
  });

  group('beginLoad', () {
    test('Should emit loaded state when session is valid', () async {
      await _setupLoaded(bloc, _session);

      when(sessionBloc.state).thenReturn(SessionLoadedState(_session));
      bloc.beginLoad(_employeeReportFilter);

      expect(
          bloc,
          emitsInOrder([
            isA<QuickFixReportLoadedState>(),
            isA<QuickFixReportLoadingState>(),
            isA<QuickFixReportLoadedState>()
          ]));
    });

    test('Should emit load failed state if getEmployeeReports fails', () async {
      await _setupLoaded(bloc, _session);

      when(getEmployeeReport.call(any))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      when(sessionBloc.state).thenReturn(SessionLoadedState(_session));
      bloc.beginLoad(_employeeReportFilter);

      await expectLater(
          bloc,
          emitsInOrder([
            isA<QuickFixReportLoadedState>(),
            isA<QuickFixReportLoadingState>(),
            IsAnd<QuickFixReportLoadFailedState>(
                (state) => state.error is UnknownFailure)
          ]));
    });

    test('Should not emit loading state when in loading state', () async {
      bloc.beginLoad(_employeeReportFilter);

      expect(bloc, emitsInOrder([isA<QuickFixReportLoadingState>()]));
    });
  });
}

class SessionBlocMock extends Mock implements SessionBloc {}

class GetEmployeeReportMock extends Mock implements GetEmployeeReport {}
