// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:essentials/api/api_mapper.dart';
import 'package:morar/feature/easy_fix/data/data_source/easy_fix_api.dart';
import 'package:morar/feature/easy_fix/data/data_source/easy_fix_remote_data_source.dart';
import 'package:morar/feature/easy_fix/data/model/city_model.dart';
import 'package:morar/feature/easy_fix/data/model/easy_fix_unit_model.dart';
import 'package:morar/feature/easy_fix/domain/entity/city_entity.dart';

class EasyFixRemoteDataSourceImpl implements EasyFixRemoteDataSource {
  final EasyFixApi api;

  EasyFixRemoteDataSourceImpl({
    required this.api,
  });
  @override
  Future<EasyFixUnitModel> selectEasyFixUnit(
      {required String condominiumId}) async {
    final response = await api.getEasyFixUnit(condominiumId);
    final easyFixUnit =
        ApiMapper.map(response, (json) => EasyFixUnitModel.fromJson(json));

    return easyFixUnit;
  }

  @override
  Future<void> updateAddress({
    required String condominiumId,
    required EasyFixUnitModel model,
  }) async {
    final response = await api.updateAddress(condominiumId, model);

    return ApiMapper.map(response, (json) => null);
  }

  @override
  Future<List<City>> selectCities({
    required String condominiumId,
    required String uf,
  }) async {
    final response = await api.getCities(condominiumId, uf);

    return ApiMapper.mapList(
        response, (json) => CityModel.fromJson(json).toEntity());
  }
}
