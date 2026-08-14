import 'package:essentials/base/use_case.dart';
import 'package:essentials/functional/try.dart';

import '../entity/event_details_entity.dart';
import '../repository/maintenance_management_repository.dart';

class GetEventDetailsRequest {
  final String eventId;

  GetEventDetailsRequest({required this.eventId});
}

abstract class GetEventDetailsUseCase
    extends UseCase<EventDetailsEntity, GetEventDetailsRequest> {}

class GetEventDetailsUseCaseImpl implements GetEventDetailsUseCase {
  final MaintenanceManagementRepository repository;

  GetEventDetailsUseCaseImpl(this.repository);

  @override
  Future<Try<EventDetailsEntity>> call(GetEventDetailsRequest request) {
    return repository.getEventDetails(request.eventId);
  }
}
