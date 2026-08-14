import 'package:essentials/essentials.dart';
import 'package:morar/feature/insurance/data/model/insurance_premium_model.dart';
import 'package:morar/feature/insurance/data/model/insurance_table_model.dart';
import 'package:morar/feature/insurance/domain/entity/insurance.dart';

abstract class InsuranceState extends Equatable {
  const InsuranceState();

  @override
  List<Object?> get props => [];
}

class LoadingInsuranceState extends InsuranceState {
  const LoadingInsuranceState();
}

class LoadedInsuranceState extends InsuranceState {
  final Insurance? model;
  final bool isCancel;
  final bool isPost;
  final InsurancePremiumModel selectedPremium;
  final InsuranceTableModel insuranceData;

  const LoadedInsuranceState({
    this.model,
    this.isCancel = false,
    this.isPost = false,
    required this.selectedPremium,
    required this.insuranceData,
  });

  @override
  List<Object?> get props =>
      [model, isCancel, isPost, selectedPremium, insuranceData];
}

class FailedInsuranceState extends InsuranceState {
  const FailedInsuranceState();
}
