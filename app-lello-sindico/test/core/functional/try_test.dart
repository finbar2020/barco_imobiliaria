import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Try', () {
    group('success', () {
      test('Should be an instance of Success', () async {
        Try<int> data = Try.success(1);
        expect(data, isA<Success<int>>());
      });
    });

    group('reject', () {
      test('Should be an instance of Rejection', () async {
        Try<int> data = Try.reject(UnknownFailure(null));
        expect(data, isA<Rejection<int>>());
      });
    });
  });

  group('Success', () {
    group('Factories', () {
      test('Should be an instance of Try', () {
        var data = Success(1);
        expect(data, isA<Try<int>>());
      });
    });

    group('Equal operator', () {
      test('Should return true when comparing same instance', () async {
        var data = Success(1);
        expect(data == data, true);
      });

      test(
          'Should return true when comparing different instances with the same value',
          () async {
        var data = Success(1);
        var data2 = Success(1);
        expect(data == data2, true);
      });

      test('Should return false when comparing different values', () async {
        var data = Success(1);
        var data2 = Success(2);
        expect(data == data2, false);
      });

      test('Should return false when comparing different dynamic values',
          () async {
        var data = Success(1);
        var data2 = Success("teste");
        expect(data == data2, false);
      });
    });

    group('Fold', () {
      test('Should return right value', () async {
        var data = Success(1);
        var expected = 2;
        var folded = data.fold((l) => null, (r) => expected);
        expect(folded, expected);
      });
    });
  });

  group('Rejection', () {
    group('Factories', () {
      test('Should be an instance of Try', () {
        Rejection<int> data = Rejection(UnknownFailure(null));
        expect(data, isA<Try<int>>());
      });
    });

    group('Equal operator', () {
      test('Should return true when comparing same instance', () async {
        var data = Rejection(UnknownFailure(null));
        expect(data == data, true);
      });

      test(
          'Should return true when comparing different instances with the same value',
          () async {
        var data = Rejection(UnknownFailure(null));
        var data2 = Rejection(UnknownFailure(null));
        expect(data == data2, true);
      });

      test('Should return false when comparing different values', () async {
        Rejection<int> data = Rejection(UnknownFailure(null));
        Rejection<int> data2 = Rejection(UnknownFailure(Exception()));
        expect(data == data2, false);
      });

      test(
          'Should return true when comparing different dynamic values and equal exceptions',
          () async {
        Rejection<int> data = Rejection(UnknownFailure(null));
        Rejection<String> data2 = Rejection(UnknownFailure(null));
        expect(data == data2, true);
      });

      group('Fold', () {
        test('Should return right value', () async {
          var data = Rejection(UnknownFailure(null));
          var expected = 2;
          var folded = data.fold((l) => expected, (r) => null);
          expect(folded, expected);
        });
      });
    });
  });
}
