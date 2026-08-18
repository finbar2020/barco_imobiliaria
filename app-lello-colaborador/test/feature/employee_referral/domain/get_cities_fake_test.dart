import 'package:colaborador/feature/employee_referral/domain/entity/city.dart';
import 'package:colaborador/feature/employee_referral/domain/repository/employee_referral_repository.dart';
import 'package:colaborador/feature/employee_referral/domain/use_case/get_cities/get_cities_impl.dart';
import 'package:colaborador/feature/employee_referral/domain/use_case/get_cities/get_cities_units.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeReferralRepo extends Fake implements EmployeeReferralRepository {
  Object? last;

  @override
  Future<Try<List<CityEntity>>> getCities(
      String condoId, String employeeId) async {
    last = '$condoId|$employeeId';
    return Success([CityEntity(name: 'São Paulo', regions: const ['Zona Sul'])]);
  }
}

void main() {
  group('GetCitiesUsecaseImpl', () {
    test('rejeita ids vazios', () async {
      final usecase = GetCitiesUsecaseImpl(repository: _FakeReferralRepo());
      expect(
        await usecase(GetCitiesParam(condoId: '', employeeId: 'e1')),
        isA<Rejection<List<CityEntity>>>(),
      );
      expect(
        await usecase(GetCitiesParam(condoId: 'c1', employeeId: '')),
        isA<Rejection<List<CityEntity>>>(),
      );
    });

    test('lista cidades', () async {
      final repo = _FakeReferralRepo();
      final result = await GetCitiesUsecaseImpl(repository: repo)(
        GetCitiesParam(condoId: 'c1', employeeId: 'e1'),
      );
      expect(result, isA<Success<List<CityEntity>>>());
      expect(repo.last, 'c1|e1');
      expect((result as Success<List<CityEntity>>).get().first.name, 'São Paulo');
    });
  });
}
