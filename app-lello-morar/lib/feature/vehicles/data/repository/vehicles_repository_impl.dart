import 'package:essentials/essentials.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:morar/feature/vehicles/data/data_source/vehicles_remote_data_source.dart';
import 'package:morar/feature/vehicles/data/models/vehicles_model.dart';
import 'package:morar/feature/vehicles/domain/entity/vehicles.dart';
import 'package:morar/feature/vehicles/domain/repository/vehicles_repository.dart';

class VehicleRepositoryImpl extends VehicleRepository {
  final VehicleRemoteDataSource remoteDataSource;

  VehicleRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Try<String>> delete(String vehicleId) async {
    try {
      final result = await remoteDataSource.delete(vehicleId);
      return Success(result);
    } catch (error) {
      return Rejection(UnknownFailure(error));
    }
  }

  @override
  Future<Try<List<Vehicle>>> post(Vehicle vehicle) async {
    try {
      final model = VehicleModel.fromEntity(vehicle);
      final result = await remoteDataSource.insertVehicle(model!);
      final entity =
          result?.map((vehicleModel) => vehicleModel.toEntity()).toList() ?? [];
      return Success(entity);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(e, stacktrace);
      if (e is ApiFailure) {
        switch (e.status) {
          case 400:
            return Rejection(
              KnownFailure(
                e.failure?.toString() ??
                    e.detail?.toString() ??
                    "request_insert_vehicle_failure",
                e,
                message: e.title,
              ),
            );
          default:
            return Rejection(UnknownFailure(e));
        }
      }
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<List<Vehicle>>> getVehicleList(String unitId) async {
    try {
      final remoteData = await remoteDataSource.getVehiclesList(unitId);
      final entity =
          remoteData?.map((vehicleModel) => vehicleModel.toEntity()).toList() ??
              [];
      return Success(entity);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'unitId: $unitId',
      );
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<List<Vehicle>>> put(Vehicle vehicle, String? vehicleId) async {
    try {
      final model = VehicleModel.fromEntity(vehicle);
      final data = await remoteDataSource.put(model!, model.id!);
      final entity =
          data?.map((vehicleModel) => vehicleModel.toEntity()).toList() ?? [];
      return Success(entity);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(e, stacktrace);
      if (e is ApiFailure) {
        switch (e.status) {
          case 400:
            return Rejection(
              KnownFailure(
                e.failure?.toString() ??
                    e.detail?.toString() ??
                    "request_insert_vehicle_failure",
                e,
                message: e.title,
              ),
            );
          default:
            return Rejection(UnknownFailure(e));
        }
      }
      return Rejection(UnknownFailure(e));
    }
  }
}
