import 'package:essentials/essentials.dart';
import 'package:lello/feature/condominium/domain/entity/condominium.dart';
import 'package:lello/feature/space/domain/entity/space.dart';
import 'package:lello/feature/space/registration/domain/entity/space_registration_step.dart';

abstract class SpaceRegistrationEvent extends Equatable {
  const SpaceRegistrationEvent();

  @override
  List<Object?> get props => [];
}

class SpaceRegistrationChangeStepEvent extends SpaceRegistrationEvent {
  final SpaceRegistrationStep step;

  const SpaceRegistrationChangeStepEvent({required this.step});

  @override
  List<Object?> get props => [step];
}

class SpaceRegistrationSetupEvent extends SpaceRegistrationEvent {
  final Condominium condominium;
  final Space space;

  const SpaceRegistrationSetupEvent(
      {required this.condominium, required this.space});

  @override
  List<Object?> get props => [condominium, space];
}

class SpaceRegistrationRegisterEvent extends SpaceRegistrationEvent {
  final Condominium condominium;
  final Space space;

  const SpaceRegistrationRegisterEvent(
      {required this.condominium, required this.space});

  @override
  List<Object?> get props => [condominium, space];
}
