import 'package:colaborador/feature/digital_point/domain/repository/digital_point_repository.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/check_digital_point/check_digital_point.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/check_digital_point/check_digital_point_impl.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakePointRepo extends Fake implements DigitalPointRepository {
  Object? last;

  @override
  Future<Try<bool>> checkDigitalPoint(String condoId, DateTime date) async {
    last = condoId;
    return Success(true);
  }
}

void main() {
  group('CheckDigitalPointUsecaseImpl', () {
    test('rejeita condomínio vazio', () async {
      final result = await CheckDigitalPointUsecaseImpl(
        repository: _FakePointRepo(),
      )(CheckDigitalPointParam(condoId: '', date: DateTime(2026, 1, 10)));
      expect(result, isA<Rejection<bool>>());
    });

    test('consulta o ponto do dia', () async {
      final repo = _FakePointRepo();
      final result = await CheckDigitalPointUsecaseImpl(repository: repo)(
        CheckDigitalPointParam(condoId: 'c1', date: DateTime(2026, 1, 10)),
      );
      expect(result, isA<Success<bool>>());
      expect(repo.last, 'c1');
    });
  });
}
