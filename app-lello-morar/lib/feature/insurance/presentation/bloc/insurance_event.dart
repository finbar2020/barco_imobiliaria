import 'package:essentials/essentials.dart';
import 'package:morar/feature/insurance/data/model/insurance_premium_model.dart';
import 'package:morar/feature/insurance/data/model/insurance_table_model.dart';
import 'package:morar/feature/insurance/domain/entity/insurance.dart';

abstract class InsuranceEvent extends Equatable {
  const InsuranceEvent();

  @override
  List<Object?> get props => [];
}

class InsuranceLoadingEvent extends InsuranceEvent {
  const InsuranceLoadingEvent();
}

class InsuranceLoadedEvent extends InsuranceEvent {
  final Insurance? model;
  final InsurancePremiumModel selectedPremium;
  final InsuranceTableModel insuranceData;
  final bool isCancel;
  final bool isPost;

  const InsuranceLoadedEvent({
    this.model,
    this.isCancel = false,
    this.isPost = false,
    required this.selectedPremium,
    required this.insuranceData,
  });

  @override
  List<Object?> get props =>
      [model, selectedPremium, insuranceData, isCancel, isPost];
}

class InsuranceFailedEvent extends InsuranceEvent {
  const InsuranceFailedEvent();
}
