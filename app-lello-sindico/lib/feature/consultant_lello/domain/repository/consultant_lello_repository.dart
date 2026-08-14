import 'package:essentials/essentials.dart';
import 'package:lello/feature/consultant_lello/domain/entity/consultant_lello.dart';

abstract class ConsultantRepository {
  Future<Try<ConsultantEntity>> consultant(String condominiumId);
}
