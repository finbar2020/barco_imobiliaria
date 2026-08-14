import 'package:colaborador/feature/digital_point/data/model/url_upload_s3_model.dart';
import 'package:colaborador/feature/employee_referral/data/model/city_model.dart';
import 'package:colaborador/feature/employee_referral/data/model/employee_referral_model.dart';

abstract class EmployeeReferralRemoteDataSource {
  Future<EmployeeReferralModel> registerEmployeeReferral(
      EmployeeReferralModel model, String condoId, String employeeId);
  Future<UrlUploadS3Model> getUrlAws(String condoId, String employeeId);
  Future<List<CityModel>> getCities(String condoId, String employeeId);
}
