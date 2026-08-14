import 'package:flutter_test/flutter_test.dart';

import 'package:lello/feature/condominium/domain/entity/condominium.dart';
import 'package:lello/feature/payroll/domain/entity/payroll.dart';
import 'package:lello/feature/payroll/domain/entity/payroll_entry.dart';
import 'package:lello/feature/payroll/domain/use_case/list_payroll_entry/list_payroll_entry.dart';
import 'package:lello/feature/payroll/presentation/bloc/payroll_entry/payroll_entry_bloc.dart';
import 'package:lello/feature/payroll/presentation/bloc/payroll_entry/payroll_entry_bloc_impl.dart';
import 'package:lello/feature/payroll/presentation/bloc/payroll_entry/payroll_entry_state.dart';

import 'package:lello/feature/session/domain/entity/session.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';
import 'package:mockito/mockito.dart';
import 'package:essentials/essentials.dart';
import '../../../condominium/presentation/bloc/condominium_balance/condominium_balance_bloc_impl_test.dart';

void main() {
  ListPayrollEntry listPayrollEntry;
  SessionBloc sessionBloc;
  PayrollEntryBloc bloc;

  final sessionLoadedState = SessionLoadedState(
      Session()..selectedCondominium = Condominium(id: "123"));
  final payrollEntry = Payroll();
  var _payrollEntry = PayrollEntry();
  setUp(() {
    listPayrollEntry = ListPayrollEntryMock();
    sessionBloc = SessionBlocMock();
    bloc = PayrollEntryBlocImpl(
        sessionBloc: sessionBloc, listPayrollEntry: listPayrollEntry);
  });

  group('begin load', () {
    test('Should emit loading state when session state is already loaded',
        () async {
      when(sessionBloc.state).thenReturn(sessionLoadedState);
      when(listPayrollEntry.call(any))
          .thenAnswer((_) async => Success([_payrollEntry]));

      bloc.beginLoad(payrollEntry);

      expect(
          bloc,
          emitsInOrder([
            isA<PayrollEntryLoadingState>(),
            isA<PayrollEntryLoadingState>(),
            isA<PayrollEntryLoadedState>()
          ]));
    });

    test(
        'Should emit failure state when session state is already loaded and get payrollEntry fails',
        () async {
      when(sessionBloc.state).thenReturn(sessionLoadedState);
      when(listPayrollEntry.call(any))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));

      bloc.beginLoad(payrollEntry);

      expect(
          bloc,
          emitsInOrder([
            isA<PayrollEntryLoadingState>(),
            isA<PayrollEntryLoadingState>(),
            isA<PayrollEntryLoadFailedState>()
          ]));
    });

    test('Should emit nothing when session is not loaded yet', () async {
      when(sessionBloc.state).thenReturn(SessionLoadingState(null));
      when(listPayrollEntry.call(any))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      bloc.beginLoad(payrollEntry);

      expect(
          bloc,
          emitsInOrder([
            isA<PayrollEntryLoadingState>(),
          ]));
    });
  });
}

class ListPayrollEntryMock extends Mock implements ListPayrollEntry {}
