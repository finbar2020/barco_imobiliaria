import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_completed_request_paginated.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_filter_requests_status.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_type.dart';

abstract class GetMyRequestsUseCase extends UseCase<
    ComfortCompletedRequestPaginated, GetMyRequestsUseCaseParam> {}

class GetMyRequestsUseCaseParam {
  String condominiumId;
  int page;
  int pageSize;
  DateTime? startDate;
  DateTime? endDate;
  ComfortFilterRequestStatus? status;
  ComfortType? requestType;
  GetMyRequestsUseCaseParam({
    required this.condominiumId,
    required this.page,
    required this.pageSize,
    this.startDate,
    this.endDate,
    this.status,
    this.requestType
  });
}
