import 'package:flutter_test/flutter_test.dart';

import 'package:lello/feature/me/domain/entity/me.dart';
import 'package:lello/feature/me/domain/repository/me_repository.dart';
import 'package:lello/feature/me/domain/use_case/get_me/get_me.dart';
import 'package:lello/feature/me/domain/use_case/get_me/get_me_impl.dart';
import 'package:mockito/mockito.dart';
import 'package:essentials/essentials.dart';
import '../../../../../matcher/is_and_matcher.dart';

void main() {
  GetMe getMe;
  MeRepository repository;

  final _me = Me();

  setUp(() {
    repository = MeRepositoryMock();
    getMe = GetMeImpl(repository: repository);
  });

  group('call', () {
    test('Should return invalid data origin failure when origin is null',
        () async {
      final result = await getMe.call(null);
      expect(result,
          IsAnd<Rejection>((it) => it.get() is InvalidDataOriginFailure));
    });

    group('With remote data origin', () {
      test('should call repository select method', () async {
        when(repository.select()).thenAnswer((_) async => Success(_me));
        await getMe.call(DataOrigin.remote);
        verify(repository.select());
      });

      test('should return rejection when repository fails', () async {
        when(repository.select())
            .thenAnswer((_) async => Rejection(UnknownFailure(null)));
        final result = await getMe.call(DataOrigin.remote);
        expect(result, IsAnd<Rejection>((it) => it.get() is UnknownFailure));
      });

      test('should return success when repository suceeds', () async {
        when(repository.select()).thenAnswer((_) async => Success(_me));
        final result = await getMe.call(DataOrigin.remote);
        expect(result, IsAnd<Success>((it) => it.get() == _me));
      });
    });

    group('With local data origin', () {
      test('should call repository selectFromCache method', () async {
        when(repository.selectFromCache())
            .thenAnswer((_) async => Success(_me));
        await getMe.call(DataOrigin.local);
        verify(repository.selectFromCache());
      });

      test('should return rejection when repository fails', () async {
        when(repository.selectFromCache())
            .thenAnswer((_) async => Rejection(UnknownFailure(null)));
        final result = await getMe.call(DataOrigin.local);
        expect(result, IsAnd<Rejection>((it) => it.get() is UnknownFailure));
      });

      test('should return success when repository suceeds', () async {
        when(repository.selectFromCache())
            .thenAnswer((_) async => Success(_me));
        final result = await getMe.call(DataOrigin.local);
        expect(result, IsAnd<Success>((it) => it.get() == _me));
      });
    });
  });
}

class MeRepositoryMock extends Mock implements MeRepository {}
