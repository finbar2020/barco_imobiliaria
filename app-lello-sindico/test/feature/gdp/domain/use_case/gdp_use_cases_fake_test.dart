import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/gdp/domain/entity/employee.dart';
import 'package:lello/feature/gdp/domain/repository/employee_repository.dart';
import 'package:lello/feature/gdp/domain/use_case/get_employee/get_employee.dart';
import 'package:lello/feature/gdp/domain/use_case/get_employee/get_employee_impl.dart';
import 'package:lello/feature/gdp/domain/use_case/list_employee/list_employee.dart';
import 'package:lello/feature/gdp/domain/use_case/list_employee/list_employee_impl.dart';
import 'package:lello/feature/gdp/payslip/domain/entity/payslip.dart';
import 'package:lello/feature/gdp/payslip/domain/entity/payslipFile.dart';
import 'package:lello/feature/gdp/payslip/domain/repository/payslip_repository.dart';
import 'package:lello/feature/gdp/payslip/domain/use_case/get_payslips/get_payslip.dart';
import 'package:lello/feature/gdp/payslip/domain/use_case/get_payslips/get_payslip_impl.dart';
import 'package:lello/feature/gdp/payslip/domain/use_case/get_payslips_file/get_payslip_file.dart';
import 'package:lello/feature/gdp/payslip/domain/use_case/get_payslips_file/get_payslip_file_impl.dart';
import 'package:lello/feature/gdp/vacation/domain/entity/vacation.dart';
import 'package:lello/feature/gdp/vacation/domain/entity/vacation_created.dart';
import 'package:lello/feature/gdp/vacation/domain/entity/vacation_locked_days.dart';
import 'package:lello/feature/gdp/vacation/domain/entity/vacation_params.dart';
import 'package:lello/feature/gdp/vacation/domain/repository/vacation_repository.dart';
import 'package:lello/feature/gdp/vacation/domain/use_case/get_vacation/get_vacation.dart';
import 'package:lello/feature/gdp/vacation/domain/use_case/get_vacation/get_vacation_impl.dart';
import 'package:lello/feature/gdp/vacation/domain/use_case/get_vacation_locked_days/get_vacation_locked_days.dart';
import 'package:lello/feature/gdp/vacation/domain/use_case/get_vacation_locked_days/get_vacation_locked_days_impl.dart';
import 'package:lello/feature/gdp/vacation/domain/use_case/get_vacation_period/get_vacation_period.dart';
import 'package:lello/feature/gdp/vacation/domain/use_case/get_vacation_period/get_vacation_period_impl.dart';
import 'package:lello/feature/gdp/vacation/domain/use_case/schedule_vacation/schedule_vacation.dart';
import 'package:lello/feature/gdp/vacation/domain/use_case/schedule_vacation/schedule_vacation_impl.dart';

class _FakeEmployeeRepo extends Fake implements EmployeeRepository {
  Object? last;

  @override
  Future<Try<Employee>> get(String condominiumId, String employeeId) async {
    last = employeeId;
    return Success(Employee()..id = employeeId..name = 'João');
  }

  @override
  Future<Try<List<Employee>>> list(String condominiumId, DataOrigin origin,
      {String? lastEmployeeId, filter}) async {
    last = condominiumId;
    return Success([Employee()..id = 'e1']);
  }
}

class _FakePayslipRepo extends Fake implements PayslipRepository {
  @override
  Future<Try<List<Payslip>>> getPayslip(String registrationNumber) async {
    return Success([Payslip(name: registrationNumber)]);
  }

  @override
  Future<Try<PayslipFile>> getPayslipFile(
      String nameFile, String registrationNumber) async {
    return Success(PayslipFile(name: nameFile, data: 'pdf'));
  }
}

class _FakeVacationRepo extends Fake implements VacationRepository {
  Object? last;

  @override
  Future<Try<Vacation>> getVacation(
      String condominiumId, String employeeId) async {
    return Success(Vacation(employeeId: employeeId));
  }

  @override
  Future<Try<VacationParams>> getVacationPeriod(
      String condominiumId, String employeeId) async {
    last = employeeId;
    return Success(VacationParams(periods: const [], qtdInitDays: 30));
  }

  @override
  Future<Try<VacationCreated>> createVacation({
    required String condominiumId,
    required String employeeId,
    required VacationCreated vacationCreated,
  }) async {
    last = employeeId;
    return Success(vacationCreated);
  }

  @override
  Future<Try<VacationLockedDays>> getLockedDays(
    String condominiumId,
    String employeeId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    last = startDate;
    return Success(VacationLockedDays()..add('2026-01-01'));
  }
}

void main() {
  test('GetEmployeeImpl rejeita ids vazios e encaminha o válido', () async {
    final repo = _FakeEmployeeRepo();
    expect(
      await GetEmployeeImpl(repository: repo)(
        GetEmployeeParam(condominiumId: 'c1', employeeId: ''),
      ),
      isA<Rejection<Employee>>(),
    );
    final result = await GetEmployeeImpl(repository: repo)(
      GetEmployeeParam(condominiumId: 'c1', employeeId: 'e1'),
    );
    expect(result, isA<Success<Employee>>());
    expect(repo.last, 'e1');
  });

  test('ListEmployeeImpl lista colaboradores', () async {
    final repo = _FakeEmployeeRepo();
    expect(
      await ListEmployeeImpl(repository: repo)(
        ListEmployeeParam(condominiumId: '', origin: DataOrigin.remote),
      ),
      isA<Rejection<List<Employee>>>(),
    );
    final result = await ListEmployeeImpl(repository: repo)(
      ListEmployeeParam(condominiumId: 'c1', origin: DataOrigin.remote),
    );
    expect(result, isA<Success<List<Employee>>>());
  });

  test('GetPayslipImpl rejeita matrícula vazia', () async {
    final repo = _FakePayslipRepo();
    expect(
      await GetPayslipImpl(repository: repo)(
        GetPayslipParam(registrationNumber: ''),
      ),
      isA<Rejection<List<Payslip>>>(),
    );
    expect(
      await GetPayslipImpl(repository: repo)(
        GetPayslipParam(registrationNumber: '123'),
      ),
      isA<Success<List<Payslip>>>(),
    );
  });

  test('GetVacationImpl encaminha o colaborador', () async {
    final repo = _FakeVacationRepo();
    expect(
      await GetVacationImpl(repository: repo)(
        GetVacationParam(condominiumId: '', employeeId: 'e1'),
      ),
      isA<Rejection<Vacation>>(),
    );
    expect(
      await GetVacationImpl(repository: repo)(
        GetVacationParam(condominiumId: 'c1', employeeId: 'e1'),
      ),
      isA<Success<Vacation>>(),
    );
  });

  test('GetPayslipFileImpl rejeita nome ou matrícula vazios', () async {
    final repo = _FakePayslipRepo();
    expect(
      await GetPayslipFileImpl(repository: repo)(
        GetPayslipFileParam(nameFile: '', registrationNumber: '123'),
      ),
      isA<Rejection<PayslipFile>>(),
    );
    expect(
      await GetPayslipFileImpl(repository: repo)(
        GetPayslipFileParam(nameFile: 'holerite.pdf', registrationNumber: '123'),
      ),
      isA<Success<PayslipFile>>(),
    );
  });

  test('Período, dias bloqueados e agendamento de férias', () async {
    final repo = _FakeVacationRepo();
    expect(
      await GetVacationPeriodImpl(repository: repo)(
        GetVacationPeriodParam(condominiumId: 'c1', employeeId: ''),
      ),
      isA<Rejection<VacationParams>>(),
    );
    expect(
      await GetVacationPeriodImpl(repository: repo)(
        GetVacationPeriodParam(condominiumId: 'c1', employeeId: 'e1'),
      ),
      isA<Success<VacationParams>>(),
    );

    expect(
      await GetLockedDaysImpl(repository: repo)(
        GetLockedDaysParam(
          condominiumId: 'c1',
          employeeId: 'e1',
          startDate: null,
          endDate: DateTime(2026, 1, 31),
        ),
      ),
      isA<Rejection<VacationLockedDays>>(),
    );
    expect(
      await GetLockedDaysImpl(repository: repo)(
        GetLockedDaysParam(
          condominiumId: 'c1',
          employeeId: 'e1',
          startDate: DateTime(2026, 1, 1),
          endDate: DateTime(2026, 1, 31),
        ),
      ),
      isA<Success<VacationLockedDays>>(),
    );

    expect(
      await ScheduleVacationImpl(repository: repo)(
        ScheduleVacationParam(
          condominiumId: '',
          employeeId: 'e1',
          vacationCreated: VacationCreated(),
        ),
      ),
      isA<Rejection<VacationCreated>>(),
    );
    expect(
      await ScheduleVacationImpl(repository: repo)(
        ScheduleVacationParam(
          condominiumId: 'c1',
          employeeId: 'e1',
          vacationCreated: VacationCreated(employeeId: 'e1'),
        ),
      ),
      isA<Success<VacationCreated>>(),
    );
  });
}
