import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_completed_request_paginated.dart';
import 'package:shared_features/feature/comfort/domain/repository/comfort_repository.dart';
import 'package:shared_features/feature/comfort/domain/use_case/get_my_requests/get_my_requests.dart';

class GetMyRequestsUseCaseImpl extends GetMyRequestsUseCase {
  final ComfortRepository repository;

  GetMyRequestsUseCaseImpl({required this.repository});

  @override
Future<Try<ComfortCompletedRequestPaginated>> call(GetMyRequestsUseCaseParam params) async {
  final error = validate(params);

  if (error != null) {
    return Rejection(error);
  }

  final result = await repository.getMyRequests(
    params.condominiumId,
    params.page,
    params.pageSize,
    params.startDate,
    params.endDate,
    params.status,
    params.requestType,
  );

  return result;
}


  Failure? validate(GetMyRequestsUseCaseParam params) {
    if (params.condominiumId.isEmpty) return InvalidParamFailure();
    if (params.page == 0) return InvalidParamFailure();
    if (params.pageSize == 0) return InvalidParamFailure();
    return null;
  }
}
