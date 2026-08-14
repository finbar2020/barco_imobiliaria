import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/cupertino.dart';
import 'package:lello/core/analytics/analytics_log_events.dart';
import 'package:lello/feature/condominium/domain/entity/block_simple.dart';
import 'package:lello/feature/condominium/domain/use_case/get_simple_condominium/get_simple_condominium.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';
import 'package:lello/feature/unit/presentation/bloc/units/units_bloc.dart';
import 'package:lello/feature/unit/presentation/bloc/units/units_event.dart';
import 'package:lello/feature/vehicles/domain/enums/vehicle_type.dart';

import '../../../session/presentation/bloc/session_bloc.dart';
import '../../domain/entity/unit_simple.dart';
import '../../domain/use_case/list_units/list_simple_units_usecase.dart';
import '../../domain/use_case/list_units/list_units_usecase.dart';

class UnitsController {
  final SessionBloc _sessionBloc;
  final UnitsBloc unitsBloc;
  final ListUnitsUsecase _listUnitsUsecase;
  final ListUnitSimpleUsecase _listUnitSimpleUsecase;
  final GetSimpleCondominiumUsecase _getSimpleCondominiumUsecase;

  final TextEditingController vehicleIdentificationController =
      TextEditingController();

  final TextEditingController queryController = TextEditingController();

  List<BlockSimple> blocks = [];
  List<UnitSimple> unitsFilter = [];
  List<Unit> units = [];
  List<VehicleType> vehicleType = VehicleType.values;

  BlockSimple? blockSelected;
  UnitSimple? unitSelected;
  bool? hasAppInstalled;

  bool showOnlyUnitsWithBiometrics = false;
  bool filterOnlyWithTenant = false;
  String? vehicleIdentification;
  String? vehicleTypeSelected;

  UnitsController({
    required this.unitsBloc,
    required SessionBloc sessionBloc,
    required ListUnitsUsecase listUnitsUsecase,
    required ListUnitSimpleUsecase listUnitSimpleUsecase,
    required GetSimpleCondominiumUsecase getSimpleCondominiumUsecase,
  })  : _sessionBloc = sessionBloc,
        _listUnitsUsecase = listUnitsUsecase,
        _listUnitSimpleUsecase = listUnitSimpleUsecase,
        _getSimpleCondominiumUsecase = getSimpleCondominiumUsecase;

  bool isDeboucingUnits = false;

  Future<void> pipeline() async {
    await getUnits(clearUnits: true);
    await getUnitsForFilter();
    await getBlocks();
  }

  Future<void> getBlocks() async {
    final condominiumId = _sessionBloc.state.session!.selectedCondominium!.id;
    final result = await _getSimpleCondominiumUsecase(
      GetSimpleCondominiumParams(id: condominiumId),
    );
    result.fold(
      (failure) => unitsBloc.add(UnitsFailureEvent(error: failure)),
      (blocks) => this.blocks = blocks?.blocks ?? [],
    );
  }

  Future<void> getUnitsForFilter() async {
    final condominiumId = _sessionBloc.state.session!.selectedCondominium!.id;
    final result = await _listUnitSimpleUsecase(
      ListUnitSimpleParam(condominiumId: condominiumId),
    );
    result.fold(
      (failure) => unitsBloc.add(UnitsFailureEvent(error: failure)),
      (unitsFilter) => this.unitsFilter = unitsFilter,
    );
  }

  Future<void> getUnits({bool clearUnits = false}) async {
    if (isDeboucingUnits) {
      return;
    }
    isDeboucingUnits = true;
    if (clearUnits) {
      units = [];
    }
    final condominiumId = _sessionBloc.state.session!.selectedCondominium!.id;

    if (units.isNotEmpty) {
      unitsBloc.add(UnitsNewLoadingEvent());
    } else {
      unitsBloc.add(UnitsLoadingEvent());
    }

    final remoteResult = await _listUnitsUsecase.call(
      ListUnitsParam(
        condominiumId: condominiumId,
        lastUnitId: units.isNotEmpty ? units.last.id : null,
        query: queryController.text.isEmpty ? null : queryController.text,
        origin: DataOrigin.remote,
        blockName: blockSelected?.name,
        unitName: unitSelected?.title,
        hasAppInstalled: hasAppInstalled,
        showOnlyUnitsWithBiometrics: showOnlyUnitsWithBiometrics,
        vehicleIdentification: vehicleIdentification,
        vehicleTypeSelected: vehicleTypeSelected,
        filterOnlyWithTenant: filterOnlyWithTenant,
      ),
    );

    remoteResult.fold(
      (failure) async {
        final localResult = await _listUnitsUsecase.call(
          ListUnitsParam(
            condominiumId: condominiumId,
            lastUnitId: null,
            query: queryController.text,
            origin: DataOrigin.local,
          ),
        );

        localResult.fold(
          (failure) => unitsBloc.add(UnitsFailureEvent(error: failure)),
          (units) {
            this.units = units;
            unitsBloc.add(UnitsSuccessEvent(units: units));
          },
        );
      },
      (units) {
        String reference = _sessionBloc
                .state.session!.selectedCondominium?.reference
                .toString() ??
            "";
        ManagerAnalyticsLogEvents.logEvent(
          event: AnalyticsEventsManager.unidadesAcessar(),
          referenceValue: reference,
        );
        if (units.isEmpty && this.units.isEmpty) {
          return unitsBloc.add(UnitsEmptyEvent());
        }
        this.units.addAll(units);
        unitsBloc.add(UnitsSuccessEvent(units: this.units));
      },
    );
    isDeboucingUnits = false;
  }

  void setBlock(BlockSimple? block) {
    blockSelected = block;
  }

  void setUnitsFilter(List<UnitSimple>? units) => unitsFilter = units ?? [];

  void setUnit(UnitSimple? unit) => unitSelected = unit;

  void setHasAppInstalled(bool? hasApp) => hasAppInstalled = hasApp;

  void setShowBiometrics(bool? showBiometrics) =>
      showOnlyUnitsWithBiometrics = showBiometrics ?? false;

  void setFilterOnlyWithTenant(bool? onlyTenant) =>
      filterOnlyWithTenant = onlyTenant ?? false;

  void setVehicleType(String? type) => vehicleTypeSelected = type;

  void setVehicleIdentification(String? identification) =>
      vehicleIdentification = identification;

  void clearVehicleIdentification() {
    vehicleIdentification = null;
    vehicleIdentificationController.clear();
  }

  void clearFilters() {
    blockSelected = null;
    unitSelected = null;
    hasAppInstalled = null;
    filterOnlyWithTenant = false;
    showOnlyUnitsWithBiometrics = false;
    vehicleTypeSelected = null;
    vehicleIdentification = null;
    vehicleIdentificationController.clear();
  }

  void dispose() {
    unitsBloc.add(UnitsEmptyEvent());
    unitsFilter = [];
    units = [];
    blocks = [];
    queryController.clear();
    clearFilters();
  }

  Map<String, Map<String?, Function>> get filters {
    Map<String, Map<String?, Function>> filtersToShow = {};
    if (blockSelected != null) {
      filtersToShow.addAll({
        "units_group": {
          blockSelected!.name: () async {
            setBlock(null);
            await getUnits(clearUnits: true);
          }
        }
      });
    }
    if (unitSelected != null) {
      filtersToShow.addAll({
        "units_unit": {
          unitSelected!.title: () async {
            setUnit(null);
            await getUnits(clearUnits: true);
          }
        }
      });
    }
    if (hasAppInstalled != null) {
      filtersToShow.addAll({
        "is_app_installed": {
          hasAppInstalled! ? "yes" : "no": () async {
            setHasAppInstalled(null);
            await getUnits(clearUnits: true);
          }
        }
      });
    }
    if (filterOnlyWithTenant) {
      filtersToShow.addAll({
        "show_unit_with_occupant": {
          null: () async {
            setFilterOnlyWithTenant(null);
            await getUnits(clearUnits: true);
          }
        }
      });
    }
    if (showOnlyUnitsWithBiometrics) {
      filtersToShow.addAll(
        {
          "show_unit_with_biometrics": {
            null: () async {
              setShowBiometrics(null);
              await getUnits(clearUnits: true);
            }
          }
        },
      );
    }
    if (vehicleTypeSelected != null) {
      filtersToShow.addAll({
        "filter_by_vehicle": {
          vehicleTypeSelected!: () async {
            setVehicleType(null);
            await getUnits(clearUnits: true);
          }
        }
      });
    }
    if (vehicleIdentification != null) {
      filtersToShow.addAll({
        "vehicle_identification": {
          vehicleIdentification!: () async {
            clearVehicleIdentification();
            await getUnits(clearUnits: true);
          }
        }
      });
    }
    return filtersToShow;
  }

  bool get hasBiometrics =>
      _sessionBloc.state.session!.selectedCondominium?.useFacialBiometric ??
      false;
}
