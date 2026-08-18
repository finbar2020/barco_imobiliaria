import 'dart:async';
import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:lello/feature/account/domain/entity/account.dart';
import 'package:lello/feature/condominium/domain/entity/condominium.dart';
import 'package:lello/feature/space/domain/entity/space.dart';
import 'package:lello/feature/space/domain/entity/space_type.dart';
import 'package:lello/feature/space/registration/domain/entity/space_registration_step.dart';

abstract class SpaceRegistrationState {
  final Space data;
  final Condominium? condominium;
  final List<Account> accounts;
  final List<Space> spaces;
  final List<SpaceType> spaceTypes;
  final SpaceRegistrationStep? step;

  SpaceRegistrationState(this.data, this.condominium, this.step, this.accounts,
      this.spaces, this.spaceTypes);
}

class SpaceRegistrationIdleState extends SpaceRegistrationState {
  SpaceRegistrationIdleState(
      Space data,
      Condominium? condominium,
      List<Account> accounts,
      SpaceRegistrationStep step,
      List<Space> spaces,
      List<SpaceType> spaceTypes)
      : super(data, condominium, step, accounts, spaces, spaceTypes);
}

class SpaceRegistrationLoadingState extends SpaceRegistrationState {
  SpaceRegistrationLoadingState(
      Space data,
      Condominium condominium,
      List<Account> accounts,
      SpaceRegistrationStep step,
      List<Space> spaces,
      List<SpaceType> spaceTypes)
      : super(data, condominium, step, accounts, spaces, spaceTypes);
}

class SpaceRegistrationLoadedState extends SpaceRegistrationState {
  SpaceRegistrationLoadedState(
      Space data,
      Condominium condominium,
      List<Account> accounts,
      SpaceRegistrationStep step,
      List<Space> spaces,
      List<SpaceType> spaceTypes)
      : super(data, condominium, step, accounts, spaces, spaceTypes);
}

class SpaceRegistrationLoadFailedState extends SpaceRegistrationState {
  final Failure? error;
  SpaceRegistrationLoadFailedState(
      Space data,
      Condominium condominium,
      List<Account> accounts,
      SpaceRegistrationStep step,
      List<Space> spaces,
      List<SpaceType> spaceTypes,
      this.error)
      : super(data, condominium, step, accounts, spaces, spaceTypes);
}

class SpaceRegistrationUploadingState extends SpaceRegistrationState {
  Stream<double> progress;
  File file;
  SpaceRegistrationUploadingState(
      Space data,
      Condominium condominium,
      List<Account> accounts,
      SpaceRegistrationStep step,
      List<Space> spaces,
      List<SpaceType> spaceTypes,
      this.progress,
      this.file)
      : super(data, condominium, step, accounts, spaces, spaceTypes);
}

class SpaceRegistrationUploadedState extends SpaceRegistrationState {
  final String path;
  SpaceRegistrationUploadedState(
      Space data,
      Condominium condominium,
      List<Account> accounts,
      SpaceRegistrationStep step,
      List<Space> spaces,
      List<SpaceType> spaceTypes,
      this.path)
      : super(data, condominium, step, accounts, spaces, spaceTypes);
}

class SpaceRegistrationUploadFailedState extends SpaceRegistrationState {
  final Failure error;
  SpaceRegistrationUploadFailedState(
      Space data,
      Condominium condominium,
      List<Account> accounts,
      SpaceRegistrationStep step,
      List<Space> spaces,
      List<SpaceType> spaceTypes,
      this.error)
      : super(data, condominium, step, accounts, spaces, spaceTypes);
}

class SpaceRegistrationRegisteringState extends SpaceRegistrationState {
  SpaceRegistrationRegisteringState(
      Space data,
      Condominium condominium,
      List<Account> accounts,
      SpaceRegistrationStep step,
      List<Space> spaces,
      List<SpaceType> spaceTypes)
      : super(data, condominium, step, accounts, spaces, spaceTypes);
}

class SpaceRegistrationRegisterFailedState extends SpaceRegistrationState {
  final Failure error;
  SpaceRegistrationRegisterFailedState(
      Space data,
      Condominium condominium,
      List<Account> accounts,
      SpaceRegistrationStep step,
      List<Space> spaces,
      List<SpaceType> spaceTypes,
      this.error)
      : super(data, condominium, step, accounts, spaces, spaceTypes);
}

class SpaceRegistrationRegisteredState extends SpaceRegistrationState {
  SpaceRegistrationRegisteredState(
      Space data,
      Condominium condominium,
      List<Account> accounts,
      SpaceRegistrationStep step,
      List<Space> spaces,
      List<SpaceType> spaceTypes)
      : super(data, condominium, step, accounts, spaces, spaceTypes);
}
