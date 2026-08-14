import 'package:dartz/dartz.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('toTry', () {
    group('With left', () {
      group('With valid error', () {
        test('Should create and instance of Rejection', () async {
          Either<Failure, int> either = Left(UnknownFailure(null));
          Try<int> data = either.toTry();
          expect(data, isA<Rejection<int>>());
        });
      });

      group('With invalid left type', () {
        test('Should create and instance of Rejection', () async {
          Either<String, int> either = Left("Teste");
          Try<int> data = either.toTry();
          expect(data, isA<Rejection<int>>());
        });
      });
    });

    group('With right', () {
      test('Should create and instance of Success', () async {
        Either<Failure, int> either = Right(1);
        Try<int> data = either.toTry();
        expect(data, isA<Success<int>>());
      });
    });
  });
}
