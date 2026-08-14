import 'package:essentials/essentials.dart';
import 'package:lello/feature/resident/domain/entity/resident.dart';

abstract class ListResidents
    extends UseCase<List<Resident>, ListResidentsParam> {}

class ListResidentsParam {
  final String condominiumId;
  final String? lastResidentId;
  final String? query;
  final DataOrigin origin;
  final bool? loadAll;

  ListResidentsParam(
      {required this.condominiumId,
      this.lastResidentId,
      this.query,
      required this.origin,
      this.loadAll = false});
}
