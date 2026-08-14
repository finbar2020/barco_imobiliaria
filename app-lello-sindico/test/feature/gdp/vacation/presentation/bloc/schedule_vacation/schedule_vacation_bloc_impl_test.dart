import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lello/feature/gdp/vacation/domain/entity/vacation.dart';
import 'package:lello/feature/gdp/vacation/domain/use_case/schedule_vacation/schedule_vacation.dart';
import 'package:lello/feature/gdp/vacation/presentation/bloc/schedule_vacation/schedule_vacation_bloc.dart';
import 'package:lello/feature/gdp/vacation/presentation/bloc/schedule_vacation/schedule_vacation_bloc.dart';
import 'package:lello/feature/gdp/vacation/presentation/bloc/schedule_vacation/schedule_vacation_state.dart';
import 'package:mockito/mockito.dart';
import 'package:essentials/essentials.dart';
import '../../../../../../matcher/is_and_matcher.dart';

void main() {
  final _condominiumId = '1';
  final _employeeId = 'A';
  final _period = 0;
  final _numberOfDays = 0;
  final _vacation = Vacation();
  ScheduleVacationBloc bloc;
  ScheduleVacation scheduleVacation;

  setUp(() {
    scheduleVacation = ScheduleVacationMock();
    bloc = ScheduleVacationBloc(scheduleVacation: scheduleVacation);
  });

  group('scheduleVacation', () {
    test('Should emit loaded state if not in loading state', () async {
      when(scheduleVacation.call(any))
          .thenAnswer((_) async => Success(_vacation));
      bloc.createScheduledVacation(
          _condominiumId, _employeeId, _period, _numberOfDays);

      await expectLater(
          bloc,
          emitsInOrder([
            IsAnd<ScheduleVacationLoadedState>((state) => state.data == null),
            isA<ScheduleVacationLoadingState>(),
            IsAnd<ScheduleVacationLoadedState>(
                (state) => state.data == _vacation),
          ]));
    });

    test('Should emit loaded failed state if scheduleVacation fails', () async {
      when(scheduleVacation.call(any))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      bloc.createScheduledVacation(
          _condominiumId, _employeeId, _period, _numberOfDays);

      await expectLater(
          bloc,
          emitsInOrder([
            IsAnd<ScheduleVacationLoadedState>((state) => state.data == null),
            isA<ScheduleVacationLoadingState>(),
            IsAnd<ScheduleVacationLoadFailedState>(
                (state) => state.error is UnknownFailure),
          ]));
    });

    test('Should not emit loading state if in loading state', () async {
      when(scheduleVacation.call(any)).thenAnswer((_) async {
        await Future.delayed(Duration(milliseconds: 10));
        return Success(_vacation);
      });
      bloc.createScheduledVacation(
          _condominiumId, _employeeId, _period, _numberOfDays);
      await Future.delayed(Duration(milliseconds: 5));
      bloc.createScheduledVacation(
          _condominiumId, _employeeId, _period, _numberOfDays);

      emitsExactly(bloc, [
        IsAnd<ScheduleVacationLoadedState>((state) => state.data == null),
        isA<ScheduleVacationLoadingState>(),
        IsAnd<ScheduleVacationLoadedState>((state) => state.data == _vacation),
      ]);

      bloc.close();
    });
  });
}

class ScheduleVacationMock extends Mock implements ScheduleVacation {}
