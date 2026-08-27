import 'package:essentials/base/use_case.dart';
import 'package:essentials/functional/failure.dart';
import 'package:essentials/functional/try.dart';
import 'package:flutter_test/flutter_test.dart';

class _Dobra implements UseCase<int, int> {
  @override
  Future<Try<int>> call(int params) async => Success(params * 2);
}

class _Unit implements UnitUseCase<String> {
  @override
  Future<Try<String>> call() async => Rejection(UnknownFailure('x'));
}

class _Obs implements ObservableUseCase<int, int> {
  @override
  Stream<Try<int>> call(int params) =>
      Stream.fromIterable([Success(params), Success(params + 1)]);
}

void main() {
  test('UseCase recebe parâmetros e devolve Try', () async {
    expect(await _Dobra().call(2), Success<int>(4));
  });

  test('UnitUseCase não recebe parâmetros', () async {
    expect(await _Unit().call(), isA<Rejection<String>>());
  });

  test('ObservableUseCase devolve um stream de Try', () async {
    expect(await _Obs().call(1).toList(), [Success<int>(1), Success<int>(2)]);
  });
}
