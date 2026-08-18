import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/maintenance_management/domain/entity/filter_options_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/legal_obligation_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/procedure_options_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/reset_schedule_event_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/task_by_month_response_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/task_files_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/task_formularies_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/task_report_entity.dart';
import 'package:lello/feature/maintenance_management/domain/enum/legal_obligation_type.dart';
import 'package:lello/feature/maintenance_management/domain/repository/maintenance_management_repository.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/get_legal_obligations_use_case.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/get_maintenance_tasks_filter_options_use_case.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/get_procedure_options_use_case.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/get_task_by_month_use_case.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/get_task_files_use_case.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/get_task_formularies_use_case.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/get_task_report_use_case.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/request_legal_obligation_renewal_use_case.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/reset_schedule_event_use_case.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/send_technical_inspection_email_use_case.dart';
import 'package:lello/feature/maintenance_management/presentation/home/widgets/task_card/task_card_enum.dart';
import 'package:lello/feature/maintenance_management/presentation/home/widgets/task_summary/task_summary_model.dart';

class _FakeRepo extends Fake implements MaintenanceManagementRepository {
  Object? last;

  @override
  Future<Try<TaskFilesResponseEntity>> getTaskFiles(String taskId) async {
    last = taskId;
    return Success(TaskFilesResponseEntity(files: const []));
  }

  @override
  Future<Try<TaskFormulariesResponseEntity>> getTaskFormularies(
      String taskId) async {
    last = taskId;
    return Success(TaskFormulariesResponseEntity(formularies: const []));
  }

  @override
  Future<Try<TaskReportEntity>> getTaskReport(String eventId) async {
    last = eventId;
    return Success(TaskReportEntity(
      id: 'r1',
      taskId: 't1',
      stepName: 'step',
      responsibleName: 'João',
      status: 'DONE',
      formularName: 'form',
      questions: const [],
    ));
  }

  @override
  Future<Try<ResetScheduleEventEntity>> resetScheduleEvent(
      String scheduleEventId) async {
    last = scheduleEventId;
    return Success(const ResetScheduleEventEntity(success: true));
  }

  @override
  Future<Try<FilterOptionsEntity>> getMaintenanceTasksFilterOptions() async {
    last = 'filters';
    return Success(FilterOptionsEntity(
      locals: const [],
      assets: const [],
      responsibles: const [],
      employeeGroup: const [],
      taskType: const [TaskType.routine],
      taskStatus: const [TaskStatusType.pending],
    ));
  }

  @override
  Future<Try<LegalObligationEntity>> getLegalObligations(
      LegalObligationType type) async {
    last = type;
    return Success(const LegalObligationEntity.empty());
  }

  @override
  Future<Try<ProcedureOptionsEntity>> getProcedureOptions(
      String typeTask) async {
    last = typeTask;
    return Success(ProcedureOptionsEntity(procedureOptions: const []));
  }

  @override
  Future<Try<TaskByMonthResponseEntity>> getTaskByMonth({
    required String dtStart,
    required String untilDate,
    List<String>? responsibleIds,
    List<String>? assetIds,
    List<String>? localIds,
    List<String>? typeTask,
    List<String>? status,
  }) async {
    last = '$dtStart|$untilDate';
    return Success(const TaskByMonthResponseEntity(
      formularyByMonthDto: [],
      totalConcluidos: 1,
      totalNaoConcluidos: 2,
      totalGeral: 3,
    ));
  }

  @override
  Future<Try<bool>> sendTechnicalInspectionEmail({
    required String type,
    required String id,
    required String email,
  }) async {
    last = email;
    return Success(true);
  }

  @override
  Future<Try<bool>> requestLegalObligationRenewal({
    required String type,
    required String id,
  }) async {
    last = id;
    return Success(true);
  }
}

void main() {
  late _FakeRepo repo;

  setUp(() => repo = _FakeRepo());

  test('GetTaskFiles e GetTaskFormularies encaminham taskId', () async {
    await GetTaskFilesUseCaseImpl(repo)(GetTaskFilesRequest(taskId: 't-files'));
    expect(repo.last, 't-files');
    await GetTaskFormulariesUseCaseImpl(repo)(
      GetTaskFormulariesRequest(taskId: 't-form'),
    );
    expect(repo.last, 't-form');
  });

  test('GetTaskReport rejeita eventId vazio e encaminha o válido', () async {
    final empty = await GetTaskReportUseCaseImpl(repository: repo)('');
    expect(empty, isA<Rejection<TaskReportEntity>>());
    final ok = await GetTaskReportUseCaseImpl(repository: repo)('ev-1');
    expect(ok, isA<Success<TaskReportEntity>>());
    expect(repo.last, 'ev-1');
  });

  test('ResetScheduleEvent encaminha o id', () async {
    final result = await ResetScheduleEventUseCaseImpl(repo)('ev-9');
    expect((result as Success<ResetScheduleEventEntity>).get().success, isTrue);
  });

  test('FilterOptions, ProcedureOptions e LegalObligations', () async {
    await GetMaintenanceTasksFilterOptionsUseCase(repo)();
    expect(repo.last, 'filters');
    await GetProcedureOptionsUseCase(repo)('ROTINA');
    expect(repo.last, 'ROTINA');
    await GetLegalObligationsUseCaseImpl(repo)(
      const GetLegalObligationsRequest(type: LegalObligationType.employee),
    );
    expect(repo.last, LegalObligationType.employee);
  });

  test('GetTaskByMonth encaminha o intervalo', () async {
    final result = await GetTaskByMonthUseCaseImpl(repo).execute(
      dtStart: '01/08/2026',
      untilDate: '31/08/2026',
    );
    expect(repo.last, '01/08/2026|31/08/2026');
    expect((result as Success<TaskByMonthResponseEntity>).get().totalGeral, 3);
  });

  test('e-mail de vistoria e renovação de obrigação', () async {
    await SendTechnicalInspectionEmailUseCaseImpl(repo)(
      const SendTechnicalInspectionEmailRequest(
        type: 'TT',
        id: '1',
        email: 'a@b.com',
      ),
    );
    expect(repo.last, 'a@b.com');
    await RequestLegalObligationRenewalUseCaseImpl(repo)(
      const RequestLegalObligationRenewalRequest(type: 'EMPLOYEE', id: 'ob-1'),
    );
    expect(repo.last, 'ob-1');
  });
}
