import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/space/domain/entity/space.dart';
import 'package:lello/feature/space/registration/domain/entity/space_registration_step.dart';
import 'package:lello/feature/space/registration/presentation/bloc/registration/space_registration_event.dart';
import 'package:lello/feature/space/registration/presentation/bloc/registration/space_registration_state.dart';

abstract class SpaceRegistrationBloc
    extends Bloc<SpaceRegistrationEvent, SpaceRegistrationState> {
  SpaceRegistrationBloc(SpaceRegistrationState initialState)
      : super(initialState);

  void setup(Space space);
  void beginRegister(Space space);
  void goToStep(SpaceRegistrationStep step);
  void nextStep();
  bool previousStep();
}
