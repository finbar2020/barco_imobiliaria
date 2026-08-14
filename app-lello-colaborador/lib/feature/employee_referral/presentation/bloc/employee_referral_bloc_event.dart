import 'package:colaborador/feature/employee_referral/domain/entity/employee_referral.dart';
import 'package:essentials/essentials.dart';

abstract class EmployeeReferralEvent extends Equatable {
  const EmployeeReferralEvent();

  @override
  List<Object?> get props => [];
}

class GetCitiesEvent extends EmployeeReferralEvent {
  const GetCitiesEvent();
}

class RegisterEmployeeReferralEvent extends EmployeeReferralEvent {
  final EmployeeReferralEntity employeeReferralEntity;
  const RegisterEmployeeReferralEvent({
    required this.employeeReferralEntity,
  });

  @override
  List<Object?> get props => [employeeReferralEntity];
}
