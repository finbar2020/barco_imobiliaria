import 'package:colaborador/feature/documents/domain/entity/document_info.dart';
import 'package:essentials/essentials.dart';

abstract class PayStubState extends Equatable {
  const PayStubState();

  @override
  List<Object?> get props => [];
}

class PayStubInitialState extends PayStubState {
  const PayStubInitialState();
}

class PayStubLoadingState extends PayStubState {
  const PayStubLoadingState();
}

class PayStubLoadedState extends PayStubState {
  final List<DocumentInfo> documentsInfo;
  const PayStubLoadedState(this.documentsInfo);

  @override
  List<Object?> get props => [documentsInfo];
}

class PayStubFailedState extends PayStubState {
  final String errorDescription;
  final String errorCode;

  const PayStubFailedState(
      {required this.errorDescription, required this.errorCode});

  @override
  List<Object?> get props => [errorDescription, errorCode];
}
