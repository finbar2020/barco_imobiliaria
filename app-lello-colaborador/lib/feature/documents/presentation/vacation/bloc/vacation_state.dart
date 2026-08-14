import 'package:colaborador/feature/documents/domain/entity/document_info.dart';
import 'package:essentials/essentials.dart';

abstract class VacationState extends Equatable {
  const VacationState();

  @override
  List<Object?> get props => [];
}

class VacationInitialState extends VacationState {
  const VacationInitialState();
}

class VacationLoadingState extends VacationState {
  const VacationLoadingState();
}

class VacationLoadedState extends VacationState {
  final List<DocumentInfo> documentsInfo;
  const VacationLoadedState(this.documentsInfo);

  @override
  List<Object?> get props => [documentsInfo];
}

class VacationFailedState extends VacationState {
  final String errorDescription;
  final String errorCode;

  const VacationFailedState(
      {required this.errorDescription, required this.errorCode});

  @override
  List<Object?> get props => [errorDescription, errorCode];
}
