import 'package:lello/feature/space/registration/domain/entity/space_registration_request.dart';

abstract class SpaceRegistrationLelloEvent {}

class SpaceRegistrationLelloSendEvent extends SpaceRegistrationLelloEvent {
  final String condominiumId;
  final SpaceRegistrationRequest request;
  SpaceRegistrationLelloSendEvent(
      {required this.condominiumId, required this.request});
}
