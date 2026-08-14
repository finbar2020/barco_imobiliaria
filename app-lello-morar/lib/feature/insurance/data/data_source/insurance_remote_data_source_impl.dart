import 'package:essentials/essentials.dart';
import 'package:morar/feature/insurance/data/data_source/insurance_api.dart';
import 'package:morar/feature/insurance/data/data_source/insurance_remote_data_source.dart';
import 'package:morar/feature/insurance/data/model/insurance_model.dart';

class InsuranceRemoteDataSourceImpl extends InsuranceRemoteDataSource {
  final InsuranceApi api;
  InsuranceRemoteDataSourceImpl({required this.api});

  @override
  Future<InsuranceModel> getInsurance(String unitId) async {
    final response = await api.getInsurance(unitId);
    final result =
        ApiMapper.map(response, (json) => InsuranceModel.fromJson(json));
    return result;
  }

  @override
  Future<String> postInsurance(String unitId) async {
    final response = await api.postInsurance(unitId);
    if (response.isSuccessful == false) {
      print(response.error);
      throw response.error!;
    } else {
      return "";
    }
  }
}
