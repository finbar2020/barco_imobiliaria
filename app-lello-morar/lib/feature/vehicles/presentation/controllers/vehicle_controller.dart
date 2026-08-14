import 'package:essentials/analytics/events/analytics_events_owner.dart';
import 'package:essentials/functional/failure.dart';
import 'package:morar/core/analytics/analytics_log_events.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:morar/feature/vehicles/domain/entity/vehicles.dart';
import 'package:morar/feature/vehicles/domain/use_cases/delete_vehicles/delete_vehicle.dart';
import 'package:morar/feature/vehicles/domain/use_cases/get_vehicles/get_vehicles.dart';
import 'package:morar/feature/vehicles/domain/use_cases/save_vehicles/save_vehicles.dart';
import 'package:morar/feature/vehicles/domain/use_cases/update_vehicles/update_vehicles.dart';
import 'package:morar/feature/vehicles/presentation/bloc/vehicle_bloc.dart';
import 'package:morar/feature/vehicles/presentation/bloc/vehicle_event.dart';

class VehicleController {
  final VehiclesBloc vehicleBloc;
  final SessionBloc sessionBloc;
  final SaveVehicle saveVehicle;
  final GetVehicle getVehiacle;
  final UpDateVehicle upDateVehicle;
  final DeleteVehicle deleteVehicle;

  VehicleController({
    required this.vehicleBloc,
    required this.sessionBloc,
    required this.saveVehicle,
    required this.getVehiacle,
    required this.deleteVehicle,
    required this.upDateVehicle,
  });

  Future<void> postVehicle(Vehicle postVehicle) async {
    vehicleBloc.add(LoadingInProgressEvent());
    Vehicle vehicle = Vehicle(
        type: postVehicle.type,
        identificationNumber: postVehicle.identificationNumber,
        color: postVehicle.color,
        model: postVehicle.model,
        rentedSpace: postVehicle.rentedSpace,
        unitId: sessionBloc.state.session!.unity!.id!,
        additionalInfo: postVehicle.additionalInfo);
    final response = await saveVehicle.call(SaveVehicleParam(vehicle));
    response.fold(
      (failed) {
        //know faliures
        if (failed is KnownFailure) {
          vehicleBloc.add(VehicleAddingFailedEvent(
              error: failed.code ?? "request_insert_vehicle_failure",
              message: failed.code ?? "request_insert_vehicle_failure"));
          return;
        }

        return vehicleBloc
            .add(VehicleAddingFailedEvent(error: 'impossible to add'));
      },
      (vehicles) {
        vehicleBloc.add(VehicleAddSuccessEvent(vehicles: vehicles));
        OwnerAnalyticsLogEvents.logEvent(
          event:
              AnalyticsEventsOwner.veiculoAcessarAdicionarNovoVeiculoSucesso(),
          userId: sessionBloc.state.session?.me?.id ?? "",
          unitValue: sessionBloc.state.session!.unity?.title.toString() ?? "",
          referenceValue:
              sessionBloc.state.session!.condominium?.reference?.toString() ??
                  "",
        );
      },
    );
  }

  Future<void> getVehicle() async {
    vehicleBloc.add(LoadingInProgressDataEvent());
    if (sessionBloc.state.session?.unity?.id == null) {
      vehicleBloc
          .add(VehicleLoadingFailedEvent(error: 'not possible to load list'));
      return;
    }
    final response = await getVehiacle
        .call(GetVehicleParam(unityId: sessionBloc.state.session!.unity!.id!));
    response.fold(
        (error) => vehicleBloc.add(
            VehicleLoadingFailedEvent(error: ' not possible to load list')),
        (list) {
      list.forEach((element) {
        element =
            element.copyWith(unitId: sessionBloc.state.session!.unity!.id);
      });
      vehicleBloc.add(
        VehicleLoadedDataEvent(
            vehicles: list, session: sessionBloc.state.session!),
      );
    });
  }

  Future<void> updateVehicle(Vehicle updateVehicle) async {
    vehicleBloc.add(VehicleLoadingUpdateInProgressEvent());

    Vehicle vehicle = Vehicle(
        id: updateVehicle.id,
        type: updateVehicle.type,
        color: updateVehicle.color,
        identificationNumber: updateVehicle.identificationNumber,
        model: updateVehicle.model,
        rentedSpace: updateVehicle.rentedSpace,
        unitId: sessionBloc.state.session!.unity!.id,
        additionalInfo: updateVehicle.additionalInfo);

    final response =
        await upDateVehicle.call(UpDateVehicleParam(vehicle: vehicle));
    response.fold((failed) {
      //know faliures
      if (failed is KnownFailure) {
        vehicleBloc.add(VehicleAddingFailedEvent(
            error: failed.code ?? "request_insert_vehicle_failure",
            message: failed.code ?? "request_insert_vehicle_failure"));
        return;
      }
      return vehicleBloc
          .add(VehicleAddingFailedEvent(error: 'impossible to update'));
    }, (list) => vehicleBloc.add(UpdateVehicleEvent()));
  }

  Future<void> excludedVehicle(String vehicleId) async {
    vehicleBloc.add(VehicleDeleteLoadingEvent());
    final response = await deleteVehicle.call(DeleteVehicleParam(vehicleId));
    print("PASSEI AQUI RESPONSE => $response");
    response.fold(
        (l) => vehicleBloc.add(
            VehicleDeleteErrorEvent(error: 'not possible to delete')), (r) {
      vehicleBloc.add(VehicleDeleteSuccessEvent());
      OwnerAnalyticsLogEvents.logEvent(
        event: AnalyticsEventsOwner.veiculoAcessarExcluirVeiculo(),
        userId: sessionBloc.state.session?.me?.id ?? "",
        unitValue: sessionBloc.state.session!.unity?.title.toString() ?? "",
        referenceValue:
            sessionBloc.state.session!.condominium?.reference?.toString() ?? "",
      );
    });
  }

  void restartState() {
    vehicleBloc.add(VehicleIsEmptyEvent());
  }
}
