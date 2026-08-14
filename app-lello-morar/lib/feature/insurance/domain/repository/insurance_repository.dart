import 'package:essentials/essentials.dart';
import 'package:morar/feature/insurance/domain/entity/insurance.dart';

abstract class InsuranceRepository {
  Future<Try<Insurance>> getInsurance(String unitId);
  Future<Try<String>> postInsurance(String unitId);
}
