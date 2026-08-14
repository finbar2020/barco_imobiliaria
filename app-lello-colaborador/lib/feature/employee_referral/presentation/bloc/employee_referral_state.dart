import 'package:essentials/essentials.dart';

abstract class EmployeeReferralState extends Equatable {
  const EmployeeReferralState();

  @override
  List<Object?> get props => [];
}

class EmployeeReferralInitialState extends EmployeeReferralState {
  const EmployeeReferralInitialState();
}

class GetCitiesLoadingState extends EmployeeReferralState {
  const GetCitiesLoadingState();
}

class GetCitiesFailedState extends EmployeeReferralState {
  final String errorDescription;
  final String errorCode;

  const GetCitiesFailedState(
      {required this.errorDescription, required this.errorCode});

  @override
  List<Object?> get props => [errorDescription, errorCode];
}

class GetCitiesLoadedState extends EmployeeReferralState {
  const GetCitiesLoadedState();
}

class EmployeeReferralRegisterLoadingState extends EmployeeReferralState {
  const EmployeeReferralRegisterLoadingState();
}

class EmployeeReferralRegisterLoadedState extends EmployeeReferralState {
  const EmployeeReferralRegisterLoadedState();
}

class EmployeeReferralRegisterFailedState extends EmployeeReferralState {
  const EmployeeReferralRegisterFailedState();
}
