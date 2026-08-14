import 'package:essentials/functional/try.dart';
import '../entity/formulary_by_month_response_entity.dart';
import '../repository/maintenance_management_repository.dart';

class GetFormularyByMonthParams {
  final String dtStart;
  final String untilDate;
  final String? dayCurrent;
  final List<String>? responsibleIds;
  final List<String>? assetIds;
  final List<String>? localIds;
  final List<String>? typeTask;
  final List<String>? status;

  const GetFormularyByMonthParams({
    required this.dtStart,
    required this.untilDate,
    this.dayCurrent,
    this.responsibleIds,
    this.assetIds,
    this.localIds,
    this.typeTask,
    this.status,
  });
}

abstract class GetFormularyByMonthUseCase {
  Future<Try<FormularyByMonthResponseEntity>> call(
      GetFormularyByMonthParams params);
}

class GetFormularyByMonthUseCaseImpl implements GetFormularyByMonthUseCase {
  final MaintenanceManagementRepository repository;

  GetFormularyByMonthUseCaseImpl(this.repository);

  @override
  Future<Try<FormularyByMonthResponseEntity>> call(
      GetFormularyByMonthParams params) {
    return repository.getFormularyByMonth(
      dtStart: params.dtStart,
      untilDate: params.untilDate,
      dayCurrent: params.dayCurrent,
      responsibleIds: params.responsibleIds,
      assetIds: params.assetIds,
      localIds: params.localIds,
      typeTask: params.typeTask,
      status: params.status,
    );
  }
}
