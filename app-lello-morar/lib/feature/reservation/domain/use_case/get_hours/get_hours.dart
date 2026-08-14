import 'package:essentials/essentials.dart';
import 'package:morar/feature/reservation/domain/entity/space_available_hours.dart';

abstract class GetHours
    extends UseCase<List<SpaceAvailableHours>, GetHoursParam> {}

class GetHoursParam {
  final String condominiumId;
  final String spaceId;
  final DateTime date;
  final String unitId;

  GetHoursParam({
    required this.condominiumId,
    required this.spaceId,
    required this.date,
    required this.unitId,
  });
}
