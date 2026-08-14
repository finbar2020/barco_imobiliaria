import 'package:morar/feature/insurance/data/model/insurance_model.dart';

abstract class InsuranceRemoteDataSource {
  Future<InsuranceModel> getInsurance(String unitId);
  Future<String> postInsurance(String unitId);
}
