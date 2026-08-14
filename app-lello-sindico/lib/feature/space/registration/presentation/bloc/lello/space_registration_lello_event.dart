import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/registration/domain/entity/space_registration_request.dart';

abstract class SpaceRegistrationLelloEvent extends Equatable {
  const SpaceRegistrationLelloEvent();

  @override
  List<Object?> get props => [];
}

class SpaceRegistrationLelloSendEvent extends SpaceRegistrationLelloEvent {
  final String condominiumId;
  final SpaceRegistrationRequest request;

  const SpaceRegistrationLelloSendEvent(
      {required this.condominiumId, required this.request});

  @override
  List<Object?> get props => [condominiumId, request];
}
