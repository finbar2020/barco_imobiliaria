import 'dart:io';

import 'package:colaborador/feature/employee_referral/domain/entity/city.dart';
import 'package:colaborador/feature/employee_referral/domain/entity/employee_referral.dart';
import 'package:essentials/essentials.dart';
import 'package:shared_features/shared_features.dart';

abstract class EmployeeReferralRepository {
  Future<Try<EmployeeReferralEntity>> registerEmployeeReferral(
      EmployeeReferralEntity entity, String condoId, String employeeId);

  Future<Try<UrlUploadS3>> getUrlAws(String condoId, String employeeId);
  Future<Try<String>> uploadImageToAws(File file, String url);
  Future<Try<List<CityEntity>>> getCities(String condoId, String employeeId);
}
