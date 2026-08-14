import 'package:essentials/essentials.dart';
import 'package:morar/feature/my_preferences/data/data_source/my_preferences_data_source.dart';
import 'package:morar/feature/my_preferences/domain/entities/street_type_entity.dart';

import '../../domain/entities/access_data_entity.dart';
import '../../domain/repositories/my_preferences_repository.dart';

class MyPreferencesRepositoryImpl extends MyPreferencesRepository {
  final MyPreferencesDataSource _dataSource;

  MyPreferencesRepositoryImpl(this._dataSource);

  @override
  Future<Try<AccessData>> getUnitPersonalData(int unitId) async {
    try {
      final response = await _dataSource.getUnitPersonalData(unitId);
      return Success(response);
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<AccessData>> updateUnitPersonalData(AccessData accessData) async {
    try {
      final response = await _dataSource.updateUnitPersonalData(accessData);
      return Success(response);
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<List<StreetTypeEntity>>> getStreetTypesList() async  {
    try {
      final response = await _dataSource.getStreetTypesList();
      return Success(response);
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }
}
