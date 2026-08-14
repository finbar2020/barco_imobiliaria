import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_completed_request.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_subcategories.dart';

abstract class ComfortMyRequestsEvent extends Equatable {
  const ComfortMyRequestsEvent();

  @override
  List<Object?> get props => [];
}

class EmptyComfortMyRequestsEvent extends ComfortMyRequestsEvent {
  const EmptyComfortMyRequestsEvent();
}

class LoadingComfortMyRequestsEvent extends ComfortMyRequestsEvent {
  const LoadingComfortMyRequestsEvent();
}

class SuccessComfortMyRequestsEvent extends ComfortMyRequestsEvent {
  const SuccessComfortMyRequestsEvent();
}

class ErrorComfortMyRequestsEvent extends ComfortMyRequestsEvent {
  final String errorMessageKey;
  final String? errorDescription;
  final String? errorCode;

  const ErrorComfortMyRequestsEvent(
      {required this.errorMessageKey,
      required this.errorCode,
      required this.errorDescription});

  @override
  List<Object?> get props => [errorMessageKey, errorDescription, errorCode];
}

class LoadedMyRequestsEvent extends ComfortMyRequestsEvent {
  final List<ComfortCompletedRequest?> myRequests;
  final String? flushbarMessage;
  final ComfortCompletedRequest? selectedRequest;

  const LoadedMyRequestsEvent({
    required this.myRequests,
    this.flushbarMessage,
    this.selectedRequest,
  });

  @override
  List<Object?> get props => [myRequests, flushbarMessage, selectedRequest];
}

class LoadedRateRequestEvent extends ComfortMyRequestsEvent {
  final ComfortCompletedRequest selectedRequest;
  final String? flushbarMessage;

  const LoadedRateRequestEvent({
    required this.selectedRequest,
    this.flushbarMessage,
  });

  @override
  List<Object?> get props => [selectedRequest, flushbarMessage];
}

class LoadedSubcategoriesMyRequestEvent extends ComfortMyRequestsEvent {
  final List<ComfortSubcategories> subcategories;
  final String? flushbarMessage;

  const LoadedSubcategoriesMyRequestEvent({
    required this.subcategories,
    this.flushbarMessage,
  });

  @override
  List<Object?> get props => [subcategories, flushbarMessage];
}
