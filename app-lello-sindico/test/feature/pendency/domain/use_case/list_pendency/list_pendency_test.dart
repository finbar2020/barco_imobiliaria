import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/feature/pendency/domain/entity/pendency.dart';
import 'package:lello/feature/pendency/domain/repository/pendency_repository.dart';
import 'package:lello/feature/pendency/domain/use_case/list_pendency/list_pendency.dart';
import 'package:lello/feature/pendency/domain/use_case/list_pendency/list_pendency_impl.dart';
import 'package:mockito/mockito.dart';

import '../../../../../matcher/is_and_matcher.dart';

void main() {
  ListPendency listPendency;
  PendencyRepository repository;

  final List<Pendency> _data = [Pendency(id: "1")];
  setUp(() {
    repository = PendencyRepositoryMock();
    listPendency = ListPendencyImpl(repository: repository);
  });

  group('call', () {
    group('With local data origin', () {
      test('Should call repository select cache', () async {
        final condominium = "1744";
        await listPendency
            .call(ListPendencyParam(condominium, dataOrigin: DataOrigin.local));
        verify(repository.selectCache(condominium));
      });

      test('Should return success when repository succeeds', () async {
        final condominium = "1744";
        when(repository.selectCache(condominium))
            .thenAnswer((_) async => Success(_data));
        final result = await listPendency
            .call(ListPendencyParam(condominium, dataOrigin: DataOrigin.local));
        expect(
            result, IsAnd<Success<List<Pendency>>>((it) => it.get() == _data));
      });

      test('Should return rejection when repository fails', () async {
        final failure = UnknownFailure(null);
        final condominium = "1744";
        when(repository.selectCache(condominium))
            .thenAnswer((_) async => Rejection(failure));
        final result = await listPendency
            .call(ListPendencyParam(condominium, dataOrigin: DataOrigin.local));
        expect(result,
            IsAnd<Rejection<List<Pendency>>>((it) => it.get() == failure));
      });
    });

    group('With remote data origin ', () {
      test('Should call repository select', () async {
        final condominium = "1744";
        await listPendency.call(
            ListPendencyParam(condominium, dataOrigin: DataOrigin.remote));
        verify(repository.select(condominium));
      });

      test('Should call repository select with expected lastPendencyId',
          () async {
        final condominium = "1744";
        final lastPendencyId = "1";
        await listPendency.call(ListPendencyParam(condominium,
            dataOrigin: DataOrigin.remote, lastPendencyId: lastPendencyId));
        verify(repository.select(condominium, lastPendencyId: lastPendencyId));
      });

      test('Should return success when repository succeeds', () async {
        final condominium = "1744";
        when(repository.select(condominium))
            .thenAnswer((_) async => Success(_data));
        final result = await listPendency.call(
            ListPendencyParam(condominium, dataOrigin: DataOrigin.remote));
        expect(
            result, IsAnd<Success<List<Pendency>>>((it) => it.get() == _data));
      });

      test('Should return success when padging and repository succeeds',
          () async {
        final condominium = "1744";
        final lastPendencyId = "1";
        when(repository.select(condominium, lastPendencyId: lastPendencyId))
            .thenAnswer((_) async => Success(_data));
        final result = await listPendency.call(ListPendencyParam(condominium,
            dataOrigin: DataOrigin.remote, lastPendencyId: lastPendencyId));
        expect(
            result, IsAnd<Success<List<Pendency>>>((it) => it.get() == _data));
      });

      test('Should return rejection when repository fails', () async {
        final failure = UnknownFailure(null);
        final condominium = "1744";
        when(repository.select(condominium))
            .thenAnswer((_) async => Rejection(failure));
        final result = await listPendency.call(
            ListPendencyParam(condominium, dataOrigin: DataOrigin.remote));
        expect(result,
            IsAnd<Rejection<List<Pendency>>>((it) => it.get() == failure));
      });

      test('Should return rejection when paging and repository fails',
          () async {
        final failure = UnknownFailure(null);
        final condominium = "1744";
        final lastPendencyId = "1";
        when(repository.select(condominium, lastPendencyId: lastPendencyId))
            .thenAnswer((_) async => Rejection(failure));
        final result = await listPendency.call(ListPendencyParam(condominium,
            dataOrigin: DataOrigin.remote, lastPendencyId: lastPendencyId));
        expect(result,
            IsAnd<Rejection<List<Pendency>>>((it) => it.get() == failure));
      });
    });
  });
}

class PendencyRepositoryMock extends Mock implements PendencyRepository {}
