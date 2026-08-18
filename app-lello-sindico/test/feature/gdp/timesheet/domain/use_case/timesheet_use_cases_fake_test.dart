import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/gdp/quick_fix/domain/entity/employee_report.dart';
import 'package:lello/feature/gdp/quick_fix/domain/entity/employee_report_type.dart';
import 'package:lello/feature/gdp/quick_fix/domain/repository/employee_report_repository.dart';
import 'package:lello/feature/gdp/quick_fix/domain/use_case/get_report/get_employee_report.dart';
import 'package:lello/feature/gdp/quick_fix/domain/use_case/get_report/get_employee_report_impl.dart';
import 'package:lello/feature/gdp/timesheet/data/model/timesheet_signature_model.dart';
import 'package:lello/feature/gdp/timesheet/data/model/timesheet_signature_request_model.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_action_enum.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_add_manual_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_add_manual_enum.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_collaborator_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_condo_location_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_day_appointments_check_in_data_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_day_appointments_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_employee.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_employee_detail_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_month_resume_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_occurrence_certificate_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_occurrence_request_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_occurrence_vacation_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_ocurrence_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_periods.dart';
import 'package:lello/feature/gdp/timesheet/domain/repository/timesheet_repository.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_check_in_data/get_check_in_data.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_check_in_data/get_check_in_data_impl.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_day_appointments/get_day_appointments.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_day_appointments/get_day_appointments_impl.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_employee_detail/get_employee_detail.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_employee_detail/get_employee_detail_impl.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_groupped_occurrence/get_grouped_occurrence.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_groupped_occurrence/get_grouped_occurrence_impl.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_list_employee/get_list_employee.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_list_employee/get_list_employee_impl.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_manual_appointments/get_manual_appointments.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_manual_appointments/get_manual_appointments_impl.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_month_resume/get_month_resume.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_month_resume/get_month_resume_impl.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_occurrence_certificate/get_occurrence_certificate.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_occurrence_certificate/get_occurrence_certificate_impl.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_occurrence_detail/get_occurrence_detail.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_occurrence_detail/get_occurrence_detail_impl.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_occurrence_vacation/get_occurrence_vacation.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_occurrence_vacation/get_occurrence_vacation_impl.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_point_mirror/get_point_mirror.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_point_mirror/get_point_mirror_impl.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_timesheet_periods/get_timesheet_periods.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_timesheet_periods/get_timesheet_periods_impl.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_vacation_receipt/get_vacation_receipt.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/get_vacation_receipt/get_vacation_receipt_impl.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/post_control_occurrence/post_control_occurrence.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/post_control_occurrence/post_control_occurrence_impl.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/post_manual_appointment/post_manual_appointment.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/post_manual_appointment/post_manual_appointment_impl.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/put_signature_notify/post_signature_notify.dart';
import 'package:lello/feature/gdp/timesheet/domain/use_case/put_signature_notify/post_signature_notify_impl.dart';

TimesheetOccurrenceEntity _occurrence() => TimesheetOccurrenceEntity(
      photo: '',
      name: 'joao silva',
      jobPosition: 'Zelador',
      numCra: '1',
      receivedMark: '08:00;12:00',
      hourRange: '08:00;17:00',
      referenceDate: '2026-01-10',
      occurenceDuration: 90,
      occurrenceName: 'Atraso',
      canTreat: true,
      occurrenceType: 'delay',
    );

class _FakeTimesheetRepo extends Fake implements TimesheetRepository {
  int periodsCalls = 0;
  Object? last;

  @override
  Future<Try<TimesheetMonthResumeEntity>> getMonthResume(String date) async =>
      Success(TimesheetMonthResumeEntity(extraHours: 2, extraHoursHundred: 1));

  @override
  Future<Try<List<TimesheetEmployee>>> getListEmployees(String id) async =>
      Success([TimesheetEmployee()..id = id..name = 'João']);

  @override
  Future<Try<List<TimesheetPeriods>>> getTimesheetPeriods(
      String condominiumId) async {
    periodsCalls++;
    return Success([
      TimesheetPeriods(
        periodMonth: DateTime(2026, 1),
        startDate: DateTime(2026, 1, 1),
        endDate: DateTime(2026, 1, 31),
      ),
    ]);
  }

  @override
  Future<Try<List<DayAppointmentsEntity>>> getDayAppointments(
      String date) async {
    last = date;
    return Success([
      DayAppointmentsEntity(
        collaborator: CollaboratorEntity(name: 'João'),
        appointments: const [],
        condoLocation: CondoLocationEntity(
          reference: 'c1',
          latitude: 0,
          longitude: 0,
        ),
      ),
    ]);
  }

  @override
  Future<Try<List<TimesheetOccurrenceEntity>>> getOccurrenceDetail(
      String date, String type) async {
    last = type;
    return Success([_occurrence()]);
  }

  @override
  Future<Try<List<TimesheetOccurrenceEntity>>> getGrouppedOccurrence(
      String date, String type) async {
    last = '$date-$type';
    return Success([_occurrence()]);
  }

  @override
  Future<Try<List<TimesheetEntity>>> getPointMirrorList(DateTime date) async {
    last = date;
    return Success([
      TimesheetEntity(name: 'João', action: TimesheetActionEnum.sign),
    ]);
  }

  @override
  Future<Try<TimesheetEmployeeDetailEntity>> getEmployeeDetail(
      String numCra, DateTime date) async {
    last = numCra;
    return Success(TimesheetEmployeeDetailEntity(
      startDateOfAssessment: DateTime(2026, 1, 1),
      endDateOfAssessment: DateTime(2026, 1, 31),
      signatureId: 1,
      employeeSigned: true,
      syndicateSigned: false,
      action: TimesheetActionEnum.notify,
      markings: const [],
    ));
  }

  @override
  Future<Try<List<String>>> getManualAppointments(
      String numCra, DateTime date) async {
    last = numCra;
    return Success(['08:00']);
  }

  @override
  Future<Try<List<TimesheetDayAppointmentsCheckInData>>> getCheckInData(
      String numCra, DateTime date) async {
    last = numCra;
    return Success([
      TimesheetDayAppointmentsCheckInData(
        name: 'João',
        craNumber: numCra,
        checkInDays: const [],
      ),
    ]);
  }

  @override
  Future<Try<List<TimesheetOccurrenceCertificateEntity>>>
      getOccurrenceCertificate(String date) async {
    return Success([TimesheetOccurrenceCertificateEntity(name: 'João')]);
  }

  @override
  Future<Try<List<TimesheetOccurrenceVacationEntity>>> getOccurrenceVacation(
      String date) async {
    return Success([TimesheetOccurrenceVacationEntity(name: 'João')]);
  }

  @override
  Future<Try<File>> getVacationReceipt(String archiveName) async {
    last = archiveName;
    return Success(File(archiveName));
  }

  @override
  Future<Try<String>> postControlOccurrence(
      List<TimesheetOccurrenceRequestEntity> actions) async {
    last = actions.length;
    return Success('ok');
  }

  @override
  Future<Try<String>> postAddManualAppointments(
      List<TimesheetAddManualEntity> models) async {
    last = models.first.numCra;
    return Success('ok');
  }

  @override
  Future<Try<String>> putSignatureOrNotify(
      TimesheetSignatureRequestModel model) async {
    last = model.signaturesRequest.length;
    return Success('ok');
  }
}

class _FakeReportRepo extends Fake implements EmployeeReportRepository {
  @override
  Future<Try<EmployeeReport>> get(String condominiumId, String employeeId,
          EmployeeReportType reportType) async =>
      Success(EmployeeReport(type: reportType));
}

void main() {
  test('GetMonthResumeImpl rejeita data vazia e devolve o resumo', () async {
    final repo = _FakeTimesheetRepo();
    expect(
      await GetMonthResumeImpl(repository: repo)(GetMonthResumeParam(date: '')),
      isA<Rejection<TimesheetMonthResumeEntity>>(),
    );
    final result = await GetMonthResumeImpl(repository: repo)(
      GetMonthResumeParam(date: '01/2026'),
    );
    expect(result, isA<Success<TimesheetMonthResumeEntity>>());
    expect(
      (result as Success<TimesheetMonthResumeEntity>).get().showExtraHours,
      isFalse,
    );
  });

  test('GetListEmployeesImpl encaminha o id', () async {
    final repo = _FakeTimesheetRepo();
    expect(
      await GetListEmployeesImpl(repository: repo)(
        GetListEmployeesParam(id: ''),
      ),
      isA<Rejection<List<TimesheetEmployee>>>(),
    );
    expect(
      await GetListEmployeesImpl(repository: repo)(
        GetListEmployeesParam(id: 'e1'),
      ),
      isA<Success<List<TimesheetEmployee>>>(),
    );
  });

  test('GetTimesheetPeriodsUsecaseImpl valida e cacheia', () async {
    final repo = _FakeTimesheetRepo();
    final useCase = GetTimesheetPeriodsUsecaseImpl(repository: repo);
    expect(
      await useCase(GetTimesheetPeriodsParam(condoId: '')),
      isA<Rejection<List<TimesheetPeriods>>>(),
    );
    expect(
      await useCase(GetTimesheetPeriodsParam(condoId: 'c1')),
      isA<Success<List<TimesheetPeriods>>>(),
    );
    expect(
      await useCase(GetTimesheetPeriodsParam(condoId: 'c1')),
      isA<Success<List<TimesheetPeriods>>>(),
    );
    expect(repo.periodsCalls, 1);
  });

  test('GetEmployeeReportImpl e helper de tipo', () async {
    final repo = _FakeReportRepo();
    expect(
      await GetEmployeeReportImpl(repository: repo)(
        GetEmployeeReportParam(
          condominiumId: '',
          employeeId: 'e1',
          reportType: EmployeeReportType.vacation,
        ),
      ),
      isA<Rejection<EmployeeReport>>(),
    );
    expect(
      await GetEmployeeReportImpl(repository: repo)(
        GetEmployeeReportParam(
          condominiumId: 'c1',
          employeeId: 'e1',
          reportType: EmployeeReportType.termination,
        ),
      ),
      isA<Success<EmployeeReport>>(),
    );
    expect(EmployeeReportType.vacation.value, 'vacation');
    expect(EmployeeReportTypeHelper.parse('termination'),
        EmployeeReportType.termination);
    expect(EmployeeReportTypeHelper.parseString(EmployeeReportType.vacation),
        'Férias');
  });

  test('Marcações, ocorrências e espelho de ponto', () async {
    final repo = _FakeTimesheetRepo();
    expect(
      await GetDayAppointmentsImpl(repository: repo)(
        GetDayAppointmentsParam(date: ''),
      ),
      isA<Rejection<List<DayAppointmentsEntity>>>(),
    );
    final day = await GetDayAppointmentsImpl(repository: repo)(
      GetDayAppointmentsParam(date: '2026-01-10'),
    );
    expect(day, isA<Success<List<DayAppointmentsEntity>>>());
    expect(
      (day as Success<List<DayAppointmentsEntity>>).get().first.marks,
      'Sem marcação',
    );

    expect(
      await GetOccurrenceDetailImpl(repository: repo)(
        GetOccurrenceDetailParam(date: '2026-01-10', type: ''),
      ),
      isA<Rejection<List<TimesheetOccurrenceEntity>>>(),
    );
    final occurrence = await GetOccurrenceDetailImpl(repository: repo)(
      GetOccurrenceDetailParam(date: '2026-01-10', type: 'delay'),
    );
    expect(occurrence, isA<Success<List<TimesheetOccurrenceEntity>>>());
    expect(
      (occurrence as Success<List<TimesheetOccurrenceEntity>>)
          .get()
          .first
          .convertExtraHours(),
      '1h30min',
    );

    expect(
      await GetGroupedOccurrenceImpl(repository: repo)(
        GetGroupedOccurrenceParam(date: '', type: 'delay'),
      ),
      isA<Rejection<List<TimesheetOccurrenceEntity>>>(),
    );
    expect(
      await GetGroupedOccurrenceImpl(repository: repo)(
        GetGroupedOccurrenceParam(date: '2026-01-10', type: 'delay'),
      ),
      isA<Success<List<TimesheetOccurrenceEntity>>>(),
    );

    expect(
      await GetPointMirrorImpl(repository: repo)(
        GetPointMirrorParam(date: DateTime(2026, 1, 10)),
      ),
      isA<Success<List<TimesheetEntity>>>(),
    );
  });

  test('Detalhe, check-in e apontamentos manuais', () async {
    final repo = _FakeTimesheetRepo();
    expect(
      await GetEmployeeDetailImpl(repository: repo)(
        GetEmployeeDetailParam(date: DateTime(2026, 1, 10), numCra: ''),
      ),
      isA<Rejection<TimesheetEmployeeDetailEntity>>(),
    );
    final detail = await GetEmployeeDetailImpl(repository: repo)(
      GetEmployeeDetailParam(date: DateTime(2026, 1, 10), numCra: '1'),
    );
    expect(detail, isA<Success<TimesheetEmployeeDetailEntity>>());
    expect(
      (detail as Success<TimesheetEmployeeDetailEntity>).get().signatureStatus,
      'ASSINADO',
    );

    expect(
      await GetManualAppointmentsImpl(repository: repo)(
        GetManualAppointmentsParam(numCra: '', date: DateTime(2026, 1, 10)),
      ),
      isA<Rejection<List<String>>>(),
    );
    expect(
      await GetManualAppointmentsImpl(repository: repo)(
        GetManualAppointmentsParam(numCra: '1', date: DateTime(2026, 1, 10)),
      ),
      isA<Success<List<String>>>(),
    );

    expect(
      await GetCheckInDataImpl(repository: repo)(
        GetCheckInDataParam(numCra: '', date: DateTime(2026, 1, 10)),
      ),
      isA<Rejection<List<TimesheetDayAppointmentsCheckInData>>>(),
    );
    expect(
      await GetCheckInDataImpl(repository: repo)(
        GetCheckInDataParam(numCra: '1', date: DateTime(2026, 1, 10)),
      ),
      isA<Success<List<TimesheetDayAppointmentsCheckInData>>>(),
    );
  });

  test('Certificados, férias, controle e assinatura', () async {
    final repo = _FakeTimesheetRepo();
    expect(
      await GetOccurrenceCertificateImpl(repository: repo)(
        GetOccurrenceCertificateParam(date: ''),
      ),
      isA<Rejection<List<TimesheetOccurrenceCertificateEntity>>>(),
    );
    expect(
      await GetOccurrenceCertificateImpl(repository: repo)(
        GetOccurrenceCertificateParam(date: '2026-01-10'),
      ),
      isA<Success<List<TimesheetOccurrenceCertificateEntity>>>(),
    );

    expect(
      await GetOccurrenceVacationImpl(repository: repo)(
        GetOccurrenceVacationParam(date: ''),
      ),
      isA<Rejection<List<TimesheetOccurrenceVacationEntity>>>(),
    );
    expect(
      await GetOccurrenceVacationImpl(repository: repo)(
        GetOccurrenceVacationParam(date: '2026-01-10'),
      ),
      isA<Success<List<TimesheetOccurrenceVacationEntity>>>(),
    );

    expect(
      await GetVacationReceiptImpl(repository: repo)(
        GetVacationReceiptParam(archiveName: ''),
      ),
      isA<Rejection<File>>(),
    );
    expect(
      await GetVacationReceiptImpl(repository: repo)(
        GetVacationReceiptParam(archiveName: 'recibo.pdf'),
      ),
      isA<Success<File>>(),
    );

    expect(
      await PostControlOccurrenceImpl(repository: repo)(
        PostControlOccurrenceParam(actions: const []),
      ),
      isA<Rejection<String>>(),
    );
    expect(
      await PostControlOccurrenceImpl(repository: repo)(
        PostControlOccurrenceParam(actions: [TimesheetOccurrenceRequestEntity()]),
      ),
      isA<Success<String>>(),
    );

    expect(
      await PostManualAppointmentImpl(repository: repo)(
        PostManualAppointmentParam(entitys: const []),
      ),
      isA<Rejection<String>>(),
    );
    expect(
      await PostManualAppointmentImpl(repository: repo)(
        PostManualAppointmentParam(entitys: [
          TimesheetAddManualEntity(
            numCra: '1',
            date: DateTime(2026, 1, 10),
            type: TimesheetAddManualEnum.standard_schedule,
            justification: 'esquecimento',
            marks: const ['08:00'],
            single: true,
          ),
        ]),
      ),
      isA<Success<String>>(),
    );

    expect(
      await PutSignatureNotifyImpl(repository: repo)(
        PutSignatureNotifyParam(
          model: TimesheetSignatureRequestModel(signaturesRequest: const []),
        ),
      ),
      isA<Rejection<String>>(),
    );
    expect(
      await PutSignatureNotifyImpl(repository: repo)(
        PutSignatureNotifyParam(
          model: TimesheetSignatureRequestModel(
            signaturesRequest: [TimesheetSignatureModel(numCra: '1')],
          ),
        ),
      ),
      isA<Success<String>>(),
    );
  });
}
