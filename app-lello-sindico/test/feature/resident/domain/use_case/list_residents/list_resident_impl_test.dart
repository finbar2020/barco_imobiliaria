import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/feature/resident/domain/entity/resident.dart';
import 'package:lello/feature/resident/domain/repository/resident_repository.dart';
import 'package:lello/feature/resident/domain/use_case/list_residents.dart';
import 'package:lello/feature/resident/domain/use_case/list_residents_impl.dart';
import 'package:mockito/mockito.dart';

import '../../../../../matcher/is_and_matcher.dart';

void main() {
  ResidentRepository repository;
  ListResidents listResidents;

  final query = "1";
  final lastResidentId = "2";
  final condominiumId = "3";
  final resident = Resident();
  final origin = DataOrigin.local;
  final params = ListResidentsParam(
      condominiumId: condominiumId,
      lastResidentId: lastResidentId,
      query: query,
      origin: origin);

  setUp(() {
    repository = ResidentRepositoryMock();
    listResidents = ListResidentsImpl(repository: repository);
  });

  group('call', () {
    group('With invalid params', () {
      test('Should invalid params when param is null', () async {
        final result = await listResidents.call(null);
        expect(
            result,
            IsAnd<Rejection<List<Resident>>>(
                (it) => it.get() is InvalidParamFailure));
      });

      test('Should invalid params when condominium is null', () async {
        final invalid = ListResidentsParam(
            condominiumId: null,
            lastResidentId: lastResidentId,
            query: query,
            origin: origin);
        final result = await listResidents.call(invalid);
        expect(
            result,
            IsAnd<Rejection<List<Resident>>>(
                (it) => it.get() is InvalidParamFailure));
      });

      test('Should invalid params when condominium is empty', () async {
        final invalid = ListResidentsParam(
            condominiumId: "",
            lastResidentId: lastResidentId,
            query: query,
            origin: origin);
        final result = await listResidents.call(invalid);
        expect(
            result,
            IsAnd<Rejection<List<Resident>>>(
                (it) => it.get() is InvalidParamFailure));
      });

      test('Should invalid params when origin is null', () async {
        final invalid =
            ListResidentsParam(condominiumId: condominiumId, origin: null);
        final result = await listResidents.call(invalid);
        expect(
            result,
            IsAnd<Rejection<List<Resident>>>(
                (it) => it.get() is InvalidParamFailure));
      });
    });

    test('Should call repository list', () async {
      when(repository.list(any, any,
              lastResidentId: anyNamed("lastResidentId"),
              query: anyNamed("query")))
          .thenAnswer((_) async => Success([resident]));
      await listResidents.call(params);
      verify(repository.list(origin, condominiumId,
          lastResidentId: lastResidentId, query: query));
    });

    test('Should return success when repository succeeeds', () async {
      when(repository.list(any, any,
              lastResidentId: anyNamed("lastResidentId"),
              query: anyNamed("query")))
          .thenAnswer((_) async => Success([resident]));
      final result = await listResidents.call(params);
      expect(
          result, IsAnd<Success<List<Resident>>>((it) => it.get().length > 0));
    });

    test('Should return rejection when repository succeeeds', () async {
      when(repository.list(any, any,
              lastResidentId: anyNamed("lastResidentId"),
              query: anyNamed("query")))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      final result = await listResidents.call(params);
      expect(result,
          IsAnd<Rejection<List<Resident>>>((it) => it.get() is UnknownFailure));
    });
  });
}

class ResidentRepositoryMock extends Mock implements ResidentRepository {}
