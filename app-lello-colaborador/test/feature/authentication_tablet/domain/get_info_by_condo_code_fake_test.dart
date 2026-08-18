import 'package:colaborador/feature/authentication_tablet/domain/entity/condo_info.dart';
import 'package:colaborador/feature/authentication_tablet/domain/entity/condominium_code_info.dart';
import 'package:colaborador/feature/authentication_tablet/domain/entity/employee_info.dart';
import 'package:colaborador/feature/authentication_tablet/domain/repository/authentication_tablet_repository.dart';
import 'package:colaborador/feature/authentication_tablet/domain/use_case/get_info_by_condo_code/get_info_by_condo_code.dart';
import 'package:colaborador/feature/authentication_tablet/domain/use_case/get_info_by_condo_code/get_info_by_condo_code_impl.dart';
import 'package:colaborador/feature/me/domain/entity/digital_timesheet_status_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';

CondominiumCodeInfo _info() => CondominiumCodeInfo(
      condoCode: 'ABC',
      condominium: CondoInfo(
        reference: 'R1',
        name: 'Torre',
        picturehash: 'p',
        status: 'ok',
        ref: 'r',
      ),
      employees: [
        EmployeeInfo(
          numCra: '1',
          numCad: '2',
          cpf: '12345678901',
          name: 'ana silva',
          jobPosition: 'porteiro noturno',
          idLogin: 'l1',
          pictureHash: 'pic',
          registered: true,
          statusEnum: DigitalTimesheetStatusEnum.approved,
        ),
      ],
    );

class _FakeRepo extends Fake implements AuthenticationTabletRepository {
  Object? last;

  @override
  Future<Try<CondominiumCodeInfo>> getInfoByCondoCode(String condoCode) async {
    last = condoCode;
    return Success(_info());
  }

  @override
  Future<Try<CondominiumCodeInfo>> getInfoByCondoCodeFromCache() async {
    last = 'cache';
    return Success(_info());
  }
}

void main() {
  group('GetInfoByCondoCodeUseCaseImpl', () {
    test('rejeita param nulo', () {
      expect(
        GetInfoByCondoCodeUseCaseImpl(repository: _FakeRepo()).validate(null),
        isA<InvalidParamFailure>(),
      );
    });

    test('rejeita remoto sem condoCode', () {
      expect(
        GetInfoByCondoCodeUseCaseImpl(repository: _FakeRepo()).validate(
          GetInfoByCondoCodeParams(origin: DataOrigin.remote),
        ),
        isA<InvalidParamFailure>(),
      );
    });

    test('busca remoto', () async {
      final repo = _FakeRepo();
      final result = await GetInfoByCondoCodeUseCaseImpl(repository: repo)(
        GetInfoByCondoCodeParams(condoCode: 'ABC', origin: DataOrigin.remote),
      );
      expect(result, isA<Success<CondominiumCodeInfo>>());
      expect(repo.last, 'ABC');
    });

    test('busca cache', () async {
      final repo = _FakeRepo();
      final result = await GetInfoByCondoCodeUseCaseImpl(repository: repo)(
        GetInfoByCondoCodeParams(origin: DataOrigin.local),
      );
      expect(result, isA<Success<CondominiumCodeInfo>>());
      expect(repo.last, 'cache');
    });
  });

  group('EmployeeInfo', () {
    test('formata nome, cargo e foto', () {
      final employee = _info().employees.first;
      expect(employee.nameFormatted, 'Ana Silva');
      expect(employee.jobPositionFormatted, 'Porteiro Noturno');
      expect(
        employee.pictureLink,
        '/registration/employee/picture/file/pic',
      );
    });
  });
}
