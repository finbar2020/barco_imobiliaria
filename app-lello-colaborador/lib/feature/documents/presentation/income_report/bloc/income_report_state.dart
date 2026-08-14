import 'package:colaborador/feature/documents/domain/entity/document_info.dart';
import 'package:essentials/essentials.dart';

abstract class IncomeReportState extends Equatable {
  const IncomeReportState();

  @override
  List<Object?> get props => [];
}

class IncomeReportInitialState extends IncomeReportState {
  const IncomeReportInitialState();
}

class IncomeReportLoadingState extends IncomeReportState {
  const IncomeReportLoadingState();
}

class IncomeReportLoadedState extends IncomeReportState {
  final List<DocumentInfo> documentsInfo;
  const IncomeReportLoadedState(this.documentsInfo);

  @override
  List<Object?> get props => [documentsInfo];
}

class IncomeReportFailedState extends IncomeReportState {
  final String errorDescription;
  final String errorCode;

  const IncomeReportFailedState(
      {required this.errorDescription, required this.errorCode});

  @override
  List<Object?> get props => [errorDescription, errorCode];
}
