import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/payslip/data/data_source/payslip_api.dart';
import 'package:shared_features/feature/gdp/payslip/data/data_source/payslip_remote_data_source.dart';
import 'package:shared_features/feature/gdp/payslip/data/model/payslip_file_model.dart';
import 'package:shared_features/feature/gdp/payslip/data/model/payslip_model.dart';

class PayslipRemoteDataSourceImpl implements PayslipRemoteDataSource {
  PayslipApi api;

  PayslipRemoteDataSourceImpl({required this.api});

  @override
  Future<List<PayslipModel>> find(String registrationNumber) async {
    final response = await api.get(registrationNumber);
    final model =
        ApiMapper.mapList(response, (json) => PayslipModel.fromJson(json));
    return model;
  }

  @override
  Future<PayslipFileModel> getFile(
      String nameFile, String registrationNumber) async {
    final response = await api.getFile(nameFile, registrationNumber);
    final model =
        ApiMapper.map(response, (json) => PayslipFileModel.fromJson(json));
    return model;
  }
}
