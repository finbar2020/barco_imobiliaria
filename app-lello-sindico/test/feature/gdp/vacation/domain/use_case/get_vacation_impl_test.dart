import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/vacation/domain/entity/vacation.dart';
import 'package:lello/feature/gdp/vacation/domain/repository/vacation_repository.dart';
import 'package:lello/feature/gdp/vacation/domain/use_case/get_vacation/get_vacation.dart';
import 'package:lello/feature/gdp/vacation/domain/use_case/get_vacation/get_vacation_impl.dart';
import 'package:mockito/mockito.dart';

import '../../../../../matcher/is_and_matcher.dart';

void main() {
  VacationRepository repository;
  GetVacation getVacation;
  final _vacation = Vacation();
  final _condominiumId = '1';
  final _employeeId = 'A';

  setUp(() {
    repository = VacationRepositoryMock();
    getVacation = GetVacationImpl(repository: repository);
  });

  group('call', () {
    group('With invalid parameters', () {
      test('Should throw invalid param failure if condominium id is null',
          () async {
        final param =
            GetVacationParam(condominiumId: null, employeeId: _employeeId);
        final result = await getVacation.call(param);
        expect(
            result,
            IsAnd<Rejection<Vacation>>(
                (it) => it.get() is InvalidParamFailure));
      });

      test('Should throw invalid param failure if condominium id is empty',
          () async {
        final param =
            GetVacationParam(condominiumId: '', employeeId: _employeeId);
        final result = await getVacation.call(param);
        expect(
            result,
            IsAnd<Rejection<Vacation>>(
                (it) => it.get() is InvalidParamFailure));
      });

      test('Should throw invalid param failure if employee id is null',
          () async {
        final param =
            GetVacationParam(condominiumId: _condominiumId, employeeId: null);
        final result = await getVacation.call(param);
        expect(
            result,
            IsAnd<Rejection<Vacation>>(
                (it) => it.get() is InvalidParamFailure));
      });

      test('Should throw invalid param failure if employee id is empty',
          () async {
        final param =
            GetVacationParam(condominiumId: _condominiumId, employeeId: '');
        final result = await getVacation.call(param);
        expect(
            result,
            IsAnd<Rejection<Vacation>>(
                (it) => it.get() is InvalidParamFailure));
      });
    });

    group('From repository', () {
      test('Should call repository get', () async {
        when(repository.getVacation(any, any))
            .thenAnswer((_) async => Success(_vacation));
        final param = GetVacationParam(
            condominiumId: _condominiumId, employeeId: _employeeId);
        await getVacation.call(param);
        verify(repository.getVacation(_condominiumId, _employeeId));
      });

      test('Should return success if repository succeeds', () async {
        when(repository.getVacation(any, any))
            .thenAnswer((_) async => Success(_vacation));
        final param = GetVacationParam(
            condominiumId: _condominiumId, employeeId: _employeeId);
        final result = await getVacation.call(param);
        expect(result, IsAnd<Success<Vacation>>((it) => it.get() == _vacation));
      });

      test('Should return rejection if repository fails', () async {
        when(repository.getVacation(any, any))
            .thenAnswer((_) async => Rejection(UnknownFailure(null)));
        final param = GetVacationParam(
            condominiumId: _condominiumId, employeeId: _employeeId);
        final result = await getVacation.call(param);
        expect(result,
            IsAnd<Rejection<Vacation>>((it) => it.get() is UnknownFailure));
      });
    });
  });
}

class VacationRepositoryMock extends Mock implements VacationRepository {}
