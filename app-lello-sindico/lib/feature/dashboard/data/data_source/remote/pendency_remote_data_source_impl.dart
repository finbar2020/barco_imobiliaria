import 'package:essentials/essentials.dart';
import 'package:lello/feature/dashboard/data/data_source/remote/pendency_api.dart';
import 'package:lello/feature/dashboard/data/data_source/remote/pendency_remote_data_source.dart';
import 'package:lello/feature/dashboard/data/model/pendency_model.dart';
import 'package:lello/feature/dashboard/data/model/read_notification_model.dart';

class PendencyRemoteDataSourceImpl extends PendencyRemoteDataSource {
  final PendencyApi api;

  PendencyRemoteDataSourceImpl({required this.api});

  @override
  Future<List<PendencyModel>> list(
      String condominiumId, String? lastPendencyId) async {
    final response = await api.get(condominiumId, lastPendencyId);
    return ApiMapper.mapList(response, (json) => PendencyModel.fromJson(json));
  }

  @override
  Future<List<PendencyModel>> listPagination(
      String condominiumId, int? currentSize) async {
    final response = await api.getPagination(condominiumId, currentSize);
    return ApiMapper.mapList(response, (json) => PendencyModel.fromJson(json));
  }

  @override
  Future<List<PendencyModel>> update(
      String condominiumId, String pendencyId) async {
    final body = new ReadNotificationModel();

    body.lido = true;
    final response = await api.update(condominiumId, pendencyId, body);

    return ApiMapper.mapList(response, (json) => PendencyModel.fromJson(json));
  }
}
