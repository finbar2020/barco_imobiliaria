
import 'package:shared_features/feature/gdp/payslip/data/model/payslip_file_model.dart';
import 'package:shared_features/feature/gdp/payslip/data/model/payslip_model.dart';

abstract class PayslipRemoteDataSource {
  Future<List<PayslipModel>> find(String registrationNumber);
  Future<PayslipFileModel> getFile(String nameFile, String registrationNumber);
}