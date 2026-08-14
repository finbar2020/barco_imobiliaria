import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lello/feature/condominium/domain/entity/condominium.dart';
import 'package:lello/feature/payroll/domain/entity/payroll.dart';
import 'package:lello/feature/payroll/domain/use_case/get_payroll/get_payroll.dart';
import 'package:lello/feature/payroll/domain/use_case/list_payroll/list_payroll.dart';
import 'package:lello/feature/payroll/presentation/bloc/payroll/payroll_bloc.dart';
import 'package:lello/feature/payroll/presentation/bloc/payroll/payroll_bloc_impl.dart';
import 'package:lello/feature/payroll/presentation/bloc/payroll/payroll_state.dart';
import 'package:lello/feature/session/domain/entity/session.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';
import 'package:mockito/mockito.dart';
import 'package:essentials/essentials.dart';
import '../../../../matcher/is_and_matcher.dart';
import '../../../condominium/presentation/bloc/condominium_balance/condominium_balance_bloc_impl_test.dart';

void main() {
  ListPayroll listPayroll;
  GetPayroll getPayroll;
  SessionBloc sessionBloc;
  PayrollBloc bloc;

  var _payroll = Payroll();
  setUp(() {
    listPayroll = ListPayrollMock();
    getPayroll = GetPayrollMock();
    sessionBloc = SessionBlocMock();
    bloc = PayrollBlocImpl(
        sessionBloc: sessionBloc,
        getPayroll: getPayroll,
        listPayroll: listPayroll);
  });

  group('when session changes', () {
    test('Should not emit any state if session has no selected condominiun',
        () async {
      final session = Session();
      whenListen(
          sessionBloc, Stream.fromIterable([SessionLoadedState(session)]));
      bloc = PayrollBlocImpl(
          sessionBloc: sessionBloc,
          getPayroll: getPayroll,
          listPayroll: listPayroll);

      expect(
          bloc,
          emitsInOrder([
            isA<PayrollLoadingState>() //default state
          ]));
    });

    test(
        'Should call list payroll use case when session contains selected condominium',
        () async {
      final session = Session()..selectedCondominium = Condominium(id: "123");

      whenListen(
          sessionBloc, Stream.fromIterable([SessionLoadedState(session)]));
      when(listPayroll.call(any)).thenAnswer((_) async => Success([_payroll]));

      bloc = PayrollBlocImpl(
          sessionBloc: sessionBloc,
          getPayroll: getPayroll,
          listPayroll: listPayroll);

      await expectLater(
          bloc,
          emitsInOrder([
            isA<PayrollLoadingState>(),
            isA<PayrollLoadingState>(),
          ]));

      verify(listPayroll.call(any));
    });

    test('Should emit succeess when list payroll succeeds', () async {
      final session = Session()..selectedCondominium = Condominium(id: "123");

      whenListen(
          sessionBloc, Stream.fromIterable([SessionLoadedState(session)]));
      when(listPayroll.call(any)).thenAnswer((_) async => Success([_payroll]));

      bloc = PayrollBlocImpl(
          sessionBloc: sessionBloc,
          getPayroll: getPayroll,
          listPayroll: listPayroll);

      expect(
          bloc,
          emitsInOrder([
            isA<PayrollLoadingState>(),
            isA<PayrollLoadingState>(),
            IsAnd<PayrollListLoadedState>((it) => it.data.length == 1)
          ]));
    });

    test('Should emit load failed when list payroll fails', () async {
      final session = Session()..selectedCondominium = Condominium(id: "123");

      whenListen(
          sessionBloc, Stream.fromIterable([SessionLoadedState(session)]));
      when(listPayroll.call(any))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));

      bloc = PayrollBlocImpl(
          sessionBloc: sessionBloc,
          getPayroll: getPayroll,
          listPayroll: listPayroll);

      expect(
          bloc,
          emitsInOrder([
            isA<PayrollLoadingState>(),
            isA<PayrollLoadingState>(),
            IsAnd<PayrollLoadFailedState>((it) => it.error is UnknownFailure)
          ]));
    });
  });
}

class ListPayrollMock extends Mock implements ListPayroll {}

class GetPayrollMock extends Mock implements GetPayroll {}
