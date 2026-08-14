import 'package:essentials/essentials.dart';
import 'package:lello/feature/consultant_lello/data/data_source/remote/consultant_lello_api.dart';
import 'package:lello/feature/consultant_lello/data/model/consultant_lello_model.dart';

import 'consultant_lello_remote_data_source.dart';



class ConsultantRemoteDataSourceImpl extends ConsultantRemoteDataSource {
  final ConsultantApi api;

  ConsultantRemoteDataSourceImpl({required this.api});

  @override
  Future<ConsultantModel> consultant(String condominiumId) async {
    final response = await api.get(condominiumId);
    return ApiMapper.map(response, (json) => ConsultantModel.fromJson(json));
  }
}
