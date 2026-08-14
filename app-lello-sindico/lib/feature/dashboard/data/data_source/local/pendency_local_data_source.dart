import 'package:lello/feature/dashboard/data/model/pendency_model.dart';

abstract class PendencyLocalDataSource {
  Future<List<PendencyModel>> list(String condominiumId);
  Future<List<PendencyModel>> save(
      String condominiumId, List<PendencyModel> pendencies);
  Future<void> clear(String? condominiumId);
}
