import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/space/registration/domain/entity/space_registration_request.dart';
import 'package:lello/feature/space/registration/presentation/bloc/lello/space_registration_lello_event.dart';
import 'package:lello/feature/space/registration/presentation/bloc/lello/space_registration_lello_state.dart';

abstract class SpaceRegistrationLelloBloc
    extends Bloc<SpaceRegistrationLelloEvent, SpaceRegistrationLelloState> {
  SpaceRegistrationLelloBloc(SpaceRegistrationLelloState initialState)
      : super(initialState);

  void beginRegister(SpaceRegistrationRequest space);
}
