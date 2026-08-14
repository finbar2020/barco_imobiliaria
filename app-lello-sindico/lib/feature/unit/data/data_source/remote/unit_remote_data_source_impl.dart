import 'package:essentials/essentials.dart';
import 'package:lello/feature/condominium/data/model/condominium_simple_model.dart';
import 'package:lello/feature/unit/data/data_source/remote/unit_api.dart';
import 'package:lello/feature/unit/data/data_source/remote/unit_remote_data_source.dart';
import 'package:lello/feature/unit/data/model/unit_model.dart';
import 'package:lello/feature/unit/data/model/unit_simple_model.dart';

class UnitRemoteDataSourceImpl extends UnitRemoteDataSource {
  final UnitApi api;
  UnitRemoteDataSourceImpl({required this.api});

  @override
  Future<List<UnitModel>> list(
    String condominiumId, {
    String? query,
    String? lastUnitId,
    bool? loadAll,
    String? blockName,
    String? unitName,
    bool? hasAppInstalled,
    bool? showOnlyUnitsWithBiometrics,
    String? vehicleIdentification,
    String? vehicleTypeSelected,
    bool? filterOnlyWithTenant,
  }) async {
    try {
      final response = await api.list(
        condominiumId,
        query: query,
        lastUnitId: lastUnitId,
        loadAll: loadAll == true,
        blockName: blockName,
        unitName: unitName,
        hasAppInstalled: hasAppInstalled,
        showOnlyUnitsWithBiometrics: showOnlyUnitsWithBiometrics,
        vehicleIdentification: vehicleIdentification,
        vehicleTypeSelected: vehicleTypeSelected,
        filterOnlyWithTenant: filterOnlyWithTenant,
      );
      final result =
          ApiMapper.mapList(response, (json) => UnitModel.fromJson(json));

      return result
          .map((e) => e.copyWith(condominiumId: condominiumId))
          .toList();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<UnitSimpleModel>> listSimple(String condominiumId) async {
    try {
      final response = await api.listSimple(
        condominiumId,
      );
      final result = ApiMapper.map(
          response, (json) => CondominiumSimpleModel.fromJson(json));
      final List<UnitSimpleModel> units = [];
      for (final block in result.blocks) {
        units.addAll(block.units);
      }
      return units;
    } catch (e) {
      throw Exception();
    }
  }
}
