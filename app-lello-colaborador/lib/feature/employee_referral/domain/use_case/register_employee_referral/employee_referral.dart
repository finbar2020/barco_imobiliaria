import 'package:colaborador/feature/employee_referral/domain/entity/employee_referral.dart';
import 'package:essentials/essentials.dart';

abstract class RegisterEmployeeReferralUsecase
    extends UseCase<EmployeeReferralEntity, RegisterEmployeeReferralParam> {}

class RegisterEmployeeReferralParam {
  final String condoId;
  final String employeeId;
  final EmployeeReferralEntity employeeReferralEntity;

  RegisterEmployeeReferralParam(
      {required this.condoId,
      required this.employeeReferralEntity,
      required this.employeeId});
}
