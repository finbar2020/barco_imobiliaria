import 'package:lello/feature/condominium/domain/entity/condominium.dart';
import 'package:lello/feature/space/domain/entity/space.dart';
import 'package:lello/feature/space/registration/domain/entity/space_registration_step.dart';

abstract class SpaceRegistrationEvent {}

class SpaceRegistrationChangeStepEvent extends SpaceRegistrationEvent {
  final SpaceRegistrationStep step;

  SpaceRegistrationChangeStepEvent({required this.step});
}

class SpaceRegistrationSetupEvent extends SpaceRegistrationEvent {
  final Condominium condominium;
  final Space space;
  SpaceRegistrationSetupEvent({required this.condominium, required this.space});
}

class SpaceRegistrationRegisterEvent extends SpaceRegistrationEvent {
  final Condominium condominium;
  final Space space;
  SpaceRegistrationRegisterEvent(
      {required this.condominium, required this.space});
}
