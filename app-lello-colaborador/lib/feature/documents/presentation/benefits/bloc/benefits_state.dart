import 'package:colaborador/feature/documents/domain/entity/document_info.dart';
import 'package:essentials/essentials.dart';

abstract class BenefitsState extends Equatable {
  const BenefitsState();

  @override
  List<Object?> get props => [];
}

class BenefitsInitialState extends BenefitsState {
  const BenefitsInitialState();
}

class BenefitsLoadingState extends BenefitsState {
  const BenefitsLoadingState();
}

class BenefitsLoadedState extends BenefitsState {
  final List<DocumentInfo> documentsInfo;
  const BenefitsLoadedState(this.documentsInfo);

  @override
  List<Object?> get props => [documentsInfo];
}

class BenefitsFailedState extends BenefitsState {
  final String errorDescription;
  final String errorCode;

  const BenefitsFailedState(
      {required this.errorDescription, required this.errorCode});

  @override
  List<Object?> get props => [errorDescription, errorCode];
}
