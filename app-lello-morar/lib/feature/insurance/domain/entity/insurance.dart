import 'package:morar/feature/insurance/domain/entity/insurance_data.dart';
import 'package:morar/feature/insurance/domain/entity/insurance_info.dart';

class Insurance {
  InsuranceData? insuranceData;
  String? insuranceStatus;
  InsuranceInfo? insuranceInfo;

  bool get contratado => insuranceStatus == "hired";
  bool get contratar => insuranceStatus == "proposal";
  bool get cancelamentoPendente => insuranceStatus == "cancellation_pending";
  bool get contratacaoPendente => insuranceStatus == "membership_pending";
  bool get indisponivel => insuranceStatus == "unavailable";
}
