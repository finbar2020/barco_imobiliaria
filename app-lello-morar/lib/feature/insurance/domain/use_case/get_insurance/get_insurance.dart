import 'package:essentials/essentials.dart';
import 'package:morar/feature/insurance/domain/entity/insurance.dart';

abstract class GetInsurance extends UseCase<Insurance, GetInsuranceParam> {}

class GetInsuranceParam {
  String unitId;
  GetInsuranceParam({required this.unitId});
}
