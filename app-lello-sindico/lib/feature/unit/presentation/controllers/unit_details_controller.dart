import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/unit/presentation/bloc/vehicles/vehicles_bloc.dart';
import 'package:lello/feature/vehicles/domain/usecases/get_vehicles_usecase.dart';

import '../../domain/entity/unit.dart';

class UnitDetailsController {
  final GetVehiclesUsecase _getVehiclesUsecase;
  final VehiclesBloc vehiclesBloc;
  final SessionBloc _sessionBloc;

  UnitDetailsController({
    required SessionBloc sessionBloc,
    required GetVehiclesUsecase getVehiclesUsecase,
    required this.vehiclesBloc,
  })  : _getVehiclesUsecase = getVehiclesUsecase,
        _sessionBloc = sessionBloc;

  Future<void> pipeline(Unit unit) async {
    vehiclesBloc.add(VehiclesLoadingEvent());
    final result = await _getVehiclesUsecase.call(
      ParamsGetVehiclesUsecase(
        condominiumId: unit.condominiumId!,
        unitId: unit.id!,
      ),
    );

    result.fold(
      (failure) => vehiclesBloc.add(
        VehiclesFailureEvent(),
      ),
      (vehicles) {
        vehiclesBloc.add(
          VehiclesSuccessEvent(vehicles: vehicles),
        );
      },
    );
  }

  void dispose() {
    vehiclesBloc.add(VehiclesEmptyEvent());
  }

  bool get hasBiometrics =>
      _sessionBloc.state.session!.selectedCondominium?.useFacialBiometric ??
      false;
}
