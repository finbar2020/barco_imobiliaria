import 'package:essentials/essentials.dart';
import 'package:lello/feature/dashboard/domain/entity/pendency.dart';

abstract class PendencyRepository {
  Future<Try<List<Pendency>>> select(String condominiumId,
      {String? lastPendencyId});
  Future<Try<List<Pendency>>> selectPagination(String condominiumId,
      {int? currentSize});
  Future<Try<List<Pendency>>> selectCache(String condominiumId);
  Future<Try<List<Pendency>>> updateNotification(
      String condominiumId, String pendencyId);
  Future<Try<List<Pendency>>> save(
      String condominiumId, List<Pendency> pendencies);
  Future<Try<Nothing>> clear();
}
