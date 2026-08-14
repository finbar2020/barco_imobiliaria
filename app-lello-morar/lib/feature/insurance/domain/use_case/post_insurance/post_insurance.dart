import 'package:essentials/essentials.dart';

abstract class PostInsurance extends UseCase<String, PostInsuranceParam> {}

class PostInsuranceParam {
  String unitId;
  PostInsuranceParam({required this.unitId});
}
