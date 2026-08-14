import 'package:essentials/essentials.dart';
import 'package:lib_facedetection/lib_facedetection.dart';
import 'package:morar/feature/easy_fix/data/data_source/easy_fix_remote_data_source.dart';
import 'package:morar/feature/easy_fix/data/model/easy_fix_unit_model.dart';
import 'package:morar/feature/easy_fix/domain/entity/city_entity.dart';
import 'package:morar/feature/easy_fix/domain/entity/easy_fix_unit_entity.dart';
import 'package:morar/feature/easy_fix/domain/repository/easy_fix_repository.dart';

class EasyFixRepositoryImpl implements EasyFixRepository {
  final EasyFixRemoteDataSource datasource;
  EasyFixRepositoryImpl({
    required this.datasource,
  });
  @override
  Future<Try<EasyFixUnit>> getEasyFixUnit(
      {required String condominiumId}) async {
    try {
      final result =
          await datasource.selectEasyFixUnit(condominiumId: condominiumId);
      return Success(result.toEntity());
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'condominiumId: $condominiumId ',
      );
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<void>> updateAddress({
    required String condominiumId,
    required EasyFixUnit unit,
  }) async {
    try {
      await datasource.updateAddress(
        condominiumId: condominiumId,
        model: EasyFixUnitModel.fromEntity(unit),
      );
      return Success(voidRight);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason:
            'condominiumId: $condominiumId - easyfixunit: ${unit.toString()}',
      );
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<List<City>>> getCities({
    required String condominiumId,
    required String uf,
  }) async {
    try {
      final cities = await datasource.selectCities(
        condominiumId: condominiumId,
        uf: uf,
      );
      return Success(cities);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason:
            'condominiumId: $condominiumId - easyfixunit: ${unit.toString()}',
      );
      return Rejection(UnknownFailure(e));
    }
  }
}
