import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/registration/domain/entity/space_registration_request.dart';

abstract class SpaceRegistrationLelloState {
  final SpaceRegistrationRequest data;
  final String? condominiumId;

  SpaceRegistrationLelloState(this.data, this.condominiumId);
}

class SpaceRegistrationLelloIdleState extends SpaceRegistrationLelloState {
  SpaceRegistrationLelloIdleState(SpaceRegistrationRequest data)
      : super(data, null);
}

class SpaceRegistrationLelloRegisteringState
    extends SpaceRegistrationLelloState {
  SpaceRegistrationLelloRegisteringState(
      SpaceRegistrationRequest data, String condominiumId)
      : super(data, condominiumId);
}

class SpaceRegistrationLelloRegisterFailedState
    extends SpaceRegistrationLelloState {
  final Failure error;
  SpaceRegistrationLelloRegisterFailedState(
      SpaceRegistrationRequest data, String condominiumId, this.error)
      : super(data, condominiumId);
}

class SpaceRegistrationLelloRegisteredState
    extends SpaceRegistrationLelloState {
  SpaceRegistrationLelloRegisteredState(
      SpaceRegistrationRequest data, String condominiumId)
      : super(data, condominiumId);
}
