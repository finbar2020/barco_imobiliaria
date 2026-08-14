import 'package:lello/feature/dashboard/data/model/pendency_model.dart';

abstract class PendencyRemoteDataSource {
  Future<List<PendencyModel>> list(
      String condominiumId, String? lastPendencyId);
  Future<List<PendencyModel>> listPagination(
      String condominiumId, int? currentSize);
  Future<List<PendencyModel>> update(String condominiumId, String pendencyId);
}
