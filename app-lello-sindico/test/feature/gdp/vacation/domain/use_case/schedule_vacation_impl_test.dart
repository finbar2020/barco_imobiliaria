import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lello/feature/gdp/vacation/domain/entity/vacation.dart';
import 'package:lello/feature/gdp/vacation/domain/repository/vacation_repository.dart';
import 'package:lello/feature/gdp/vacation/domain/use_case/schedule_vacation/schedule_vacation.dart';
import 'package:lello/feature/gdp/vacation/domain/use_case/schedule_vacation/schedule_vacation_impl.dart';
import 'package:mockito/mockito.dart';
import 'package:essentials/essentials.dart';
import '../../../../../matcher/is_and_matcher.dart';

void main() {
  final _condominiumId = '1';
  final _employeeId = 'A';
  final _period = 1;
  final _numberOfDay = 2;
  final _vacation = Vacation();
  ScheduleVacation scheduleVacation;
  VacationRepository repository;

  setUp(() {
    repository = VacationRepositoryMock();
    scheduleVacation = ScheduleVacationImpl(repository: repository);
  });

  group('call', () {
    group('With invalid parameters', () {
      test('Should throw invalid param failure if condominium id is null',
          () async {
        final param = ScheduleVacationParam(
            condominiumId: null,
            employeeId: _employeeId,
            period: _period,
            numberOfDays: _numberOfDay);
        final result = await scheduleVacation.call(param);
        expect(
            result,
            IsAnd<Rejection<Vacation>>(
                (it) => it.get() is InvalidParamFailure));
      });

      test('Should throw invalid param failure if condominium id is empty',
          () async {
        final param = ScheduleVacationParam(
            condominiumId: '',
            employeeId: _employeeId,
            period: _period,
            numberOfDays: _numberOfDay);
        final result = await scheduleVacation.call(param);
        expect(
            result,
            IsAnd<Rejection<Vacation>>(
                (it) => it.get() is InvalidParamFailure));
      });

      test('Should throw invalid param failure if employee id is null',
          () async {
        final param = ScheduleVacationParam(
            condominiumId: _condominiumId,
            employeeId: null,
            period: _period,
            numberOfDays: _numberOfDay);
        final result = await scheduleVacation.call(param);
        expect(
            result,
            IsAnd<Rejection<Vacation>>(
                (it) => it.get() is InvalidParamFailure));
      });

      test('Should throw invalid param failure if employee id is empty',
          () async {
        final param = ScheduleVacationParam(
            condominiumId: _condominiumId,
            employeeId: '',
            period: _period,
            numberOfDays: _numberOfDay);
        final result = await scheduleVacation.call(param);
        expect(
            result,
            IsAnd<Rejection<Vacation>>(
                (it) => it.get() is InvalidParamFailure));
      });

      test('Should throw invalid param failure if start date is null',
          () async {
        final param = ScheduleVacationParam(
            condominiumId: _condominiumId,
            employeeId: _employeeId,
            period: null,
            numberOfDays: _numberOfDay);
        final result = await scheduleVacation.call(param);
        expect(
            result,
            IsAnd<Rejection<Vacation>>(
                (it) => it.get() is InvalidParamFailure));
      });

      test('Should throw invalid param failure if end date is null', () async {
        final param = ScheduleVacationParam(
            condominiumId: _condominiumId,
            employeeId: _employeeId,
            period: _period,
            numberOfDays: null);
        final result = await scheduleVacation.call(param);
        expect(
            result,
            IsAnd<Rejection<Vacation>>(
                (it) => it.get() is InvalidParamFailure));
      });

      test(
          'Should throw invalid param failure if end date is earlier than start date',
          () async {
        final param = ScheduleVacationParam(
            condominiumId: _condominiumId,
            employeeId: _employeeId,
            period: _period,
            numberOfDays: 0);
        final result = await scheduleVacation.call(param);
        expect(
            result,
            IsAnd<Rejection<Vacation>>(
                (it) => it.get() is InvalidParamFailure));
      });
    });

    group('From repository', () {
      test('Should call repository scheduleVacation', () async {
        when(repository.scheduleVacation(any))
            .thenAnswer((_) async => Success(_vacation));
        final param = ScheduleVacationParam(
            condominiumId: _condominiumId,
            employeeId: _employeeId,
            period: _period,
            numberOfDays: _numberOfDay);
        await scheduleVacation.call(param);
        verify(repository.scheduleVacation(any));
      });

      test('Should return success if repository succeeds', () async {
        when(repository.scheduleVacation(any))
            .thenAnswer((_) async => Success(_vacation));
        final param = ScheduleVacationParam(
            condominiumId: _condominiumId,
            employeeId: _employeeId,
            period: _period,
            numberOfDays: _numberOfDay);
        final result = await scheduleVacation.call(param);
        expect(result, IsAnd<Success<Vacation>>((it) => it.get() == _vacation));
      });

      test('Should return rejection if repository fails', () async {
        when(repository.scheduleVacation(any))
            .thenAnswer((_) async => Rejection(UnknownFailure(null)));
        final param = ScheduleVacationParam(
            condominiumId: _condominiumId,
            employeeId: _employeeId,
            period: _period,
            numberOfDays: _numberOfDay);
        final result = await scheduleVacation.call(param);
        expect(result,
            IsAnd<Rejection<Vacation>>((it) => it.get() is UnknownFailure));
      });
    });
  });
}

class VacationRepositoryMock extends Mock implements VacationRepository {}
