import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_completed_request.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_subcategories.dart';

abstract class ComfortMyRequestsState extends Equatable {
  const ComfortMyRequestsState();

  @override
  List<Object?> get props => [];
}

class LoadingComfortMyRequestsState extends ComfortMyRequestsState {
  const LoadingComfortMyRequestsState();
}

class EmptyComfortMyRequestsState extends ComfortMyRequestsState {
  const EmptyComfortMyRequestsState();
}

class SuccessComfortMyRequestsState extends ComfortMyRequestsState {
  const SuccessComfortMyRequestsState();
}

class ErrorComfortMyRequestsState extends ComfortMyRequestsState {
  final String errorMessageKey;
  final String? errorDescription;
  final String? errorCode;

  const ErrorComfortMyRequestsState(
      {required this.errorMessageKey, this.errorCode, this.errorDescription});

  @override
  List<Object?> get props => [errorMessageKey, errorDescription, errorCode];
}

class LoadedMyRequestsState extends ComfortMyRequestsState {
  final List<ComfortCompletedRequest?> myRequests;
  final String? flushbarMessage;
  final ComfortCompletedRequest? selectedRequest;

  const LoadedMyRequestsState({
    required this.myRequests,
    this.flushbarMessage,
    this.selectedRequest,
  });

  @override
  List<Object?> get props => [myRequests, flushbarMessage, selectedRequest];
}

class LoadedRateRequestState extends ComfortMyRequestsState {
  final ComfortCompletedRequest selectedRequest;
  final String? flushbarMessage;

  const LoadedRateRequestState({
    required this.selectedRequest,
    this.flushbarMessage,
  });

  @override
  List<Object?> get props => [selectedRequest, flushbarMessage];
}

class LoadedSubcategoriesMyRequestState extends ComfortMyRequestsState {
  final List<ComfortSubcategories> subcategories;
  final String? flushbarMessage;

  const LoadedSubcategoriesMyRequestState({
    required this.subcategories,
    this.flushbarMessage,
  });

  @override
  List<Object?> get props => [subcategories, flushbarMessage];
}
