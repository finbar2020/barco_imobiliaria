import 'package:lello/feature/unit/domain/entity/unit.dart';
import 'package:lello/feature/unit/domain/repository/unit_repository.dart';

import 'package:essentials/essentials.dart';

class ListUnitsUsecase extends UseCase<List<Unit>, ListUnitsParam> {
  final UnitRepository repository;

  ListUnitsUsecase({required this.repository});

  @override
  Future<Try<List<Unit>>> call(ListUnitsParam params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    final result = await repository.list(
      params.origin,
      params.condominiumId,
      lastUnitId: params.lastUnitId,
      query: params.query,
      loadAll: params.loadAll,
      blockName: params.blockName,
      unitName: params.unitName,
      showOnlyUnitsWithBiometrics: params.showOnlyUnitsWithBiometrics,
      filterOnlyWithTenant: params.filterOnlyWithTenant,
      hasAppInstalled: params.hasAppInstalled,
      vehicleIdentification: params.vehicleIdentification,
      vehicleTypeSelected: params.vehicleTypeSelected,
    );
    return result;
  }

  Failure? validate(ListUnitsParam? params) {
    if (params == null) return InvalidParamFailure();
    if (params.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}

class ListUnitsParam {
  final String condominiumId;
  final String? lastUnitId;
  final String? query;
  final DataOrigin origin;
  final bool? loadAll;
  final String? blockName;
  final String? unitName;
  final bool? hasAppInstalled;

  final bool? showOnlyUnitsWithBiometrics;
  final String? vehicleIdentification;
  final String? vehicleTypeSelected;
  final bool? filterOnlyWithTenant;

  ListUnitsParam({
    required this.condominiumId,
    this.lastUnitId,
    this.query,
    required this.origin,
    this.loadAll,
    this.blockName,
    this.unitName,
    this.hasAppInstalled,
    this.showOnlyUnitsWithBiometrics,
    this.vehicleIdentification,
    this.vehicleTypeSelected,
    this.filterOnlyWithTenant,
  });
}
