import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/registration/domain/entity/space_registration_request.dart';

abstract class SpaceRegistrationLelloState extends Equatable {
  final SpaceRegistrationRequest data;
  final String? condominiumId;

  const SpaceRegistrationLelloState(this.data, this.condominiumId);

  @override
  List<Object?> get props => [data, condominiumId];
}

class SpaceRegistrationLelloInitialState extends SpaceRegistrationLelloState {
  const SpaceRegistrationLelloInitialState(SpaceRegistrationRequest data)
      : super(data, null);
}

class SpaceRegistrationLelloRegisteringState
    extends SpaceRegistrationLelloState {
  const SpaceRegistrationLelloRegisteringState(
      SpaceRegistrationRequest data, String condominiumId)
      : super(data, condominiumId);
}

class SpaceRegistrationLelloRegisterFailedState
    extends SpaceRegistrationLelloState {
  final Failure error;

  const SpaceRegistrationLelloRegisterFailedState(
      SpaceRegistrationRequest data, String condominiumId, this.error)
      : super(data, condominiumId);

  @override
  List<Object?> get props => [data, condominiumId, error];
}

class SpaceRegistrationLelloRegisteredState
    extends SpaceRegistrationLelloState {
  const SpaceRegistrationLelloRegisteredState(
      SpaceRegistrationRequest data, String condominiumId)
      : super(data, condominiumId);
}
