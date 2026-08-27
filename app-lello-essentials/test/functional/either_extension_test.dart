import 'package:dartz/dartz.dart';
import 'package:essentials/functional/extension/either_extension.dart';
import 'package:essentials/functional/failure.dart';
import 'package:essentials/functional/try.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Right vira Success', () {
    final Either<Failure, int> e = Right(3);
    final t = e.toTry<int>();
    expect(t, isA<Success<int>>());
    expect((t as Success<int>).get(), 3);
  });

  test('Left vira Rejection com a mesma falha', () {
    final falha = UnknownFailure('x');
    final Either<Failure, int> e = Left(falha);
    final t = e.toTry<int>();
    expect(t, isA<Rejection<int>>());
    expect((t as Rejection<int>).get(), falha);
  });
}
