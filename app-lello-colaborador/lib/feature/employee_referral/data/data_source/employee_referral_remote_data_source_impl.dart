import 'package:colaborador/feature/digital_point/data/model/url_upload_s3_model.dart';
import 'package:colaborador/feature/employee_referral/data/data_source/employee_referral_api.dart';
import 'package:colaborador/feature/employee_referral/data/model/city_model.dart';
import 'package:colaborador/feature/employee_referral/data/model/employee_referral_model.dart';
import 'package:essentials/essentials.dart';

import 'employee_referral_remote_data_source.dart';

class EmployeeReferralRemoteDataSourceImpl
    extends EmployeeReferralRemoteDataSource {
  final EmployeeReferralApi api;
  EmployeeReferralRemoteDataSourceImpl({required this.api});

  @override
  Future<UrlUploadS3Model> getUrlAws(String condoId, String employeeId) async {
    final response = await api.getAwsUrl(condoId, employeeId);
    final aws =
        ApiMapper.map(response, (json) => UrlUploadS3Model.fromJson(json));
    return aws;
  }

  @override
  Future<EmployeeReferralModel> registerEmployeeReferral(
      EmployeeReferralModel model, String condoId, String employeeId) async {
    final response =
        await api.registerEmployeeReferral(model, condoId, employeeId);
    if (response.isSuccessful == false) {
      throw response.error!;
    } else {
      return model;
    }
  }

  @override
  Future<List<CityModel>> getCities(String condoId, String employeeId) async {
    Response response = await api.getCities(condoId, employeeId);
    return ApiMapper.mapList(response, (json) => CityModel.fromJson(json));
  }
}
