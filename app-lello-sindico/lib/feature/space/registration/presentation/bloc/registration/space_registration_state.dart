import 'dart:async';
import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:lello/feature/account/domain/entity/account.dart';
import 'package:lello/feature/condominium/domain/entity/condominium.dart';
import 'package:lello/feature/space/domain/entity/space.dart';
import 'package:lello/feature/space/domain/entity/space_type.dart';
import 'package:lello/feature/space/registration/domain/entity/space_registration_step.dart';

abstract class SpaceRegistrationState extends Equatable {
  final Space data;
  final Condominium? condominium;
  final List<Account> accounts;
  final List<Space> spaces;
  final List<SpaceType> spaceTypes;
  final SpaceRegistrationStep? step;

  const SpaceRegistrationState(this.data, this.condominium, this.step,
      this.accounts, this.spaces, this.spaceTypes);

  @override
  List<Object?> get props =>
      [data, condominium, step, accounts, spaces, spaceTypes];
}

class SpaceRegistrationInitialState extends SpaceRegistrationState {
  const SpaceRegistrationInitialState(
      Space data,
      Condominium? condominium,
      List<Account> accounts,
      SpaceRegistrationStep step,
      List<Space> spaces,
      List<SpaceType> spaceTypes)
      : super(data, condominium, step, accounts, spaces, spaceTypes);
}

class SpaceRegistrationLoadingState extends SpaceRegistrationState {
  const SpaceRegistrationLoadingState(
      Space data,
      Condominium condominium,
      List<Account> accounts,
      SpaceRegistrationStep step,
      List<Space> spaces,
      List<SpaceType> spaceTypes)
      : super(data, condominium, step, accounts, spaces, spaceTypes);
}

class SpaceRegistrationLoadedState extends SpaceRegistrationState {
  const SpaceRegistrationLoadedState(
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

  const SpaceRegistrationLoadFailedState(
      Space data,
      Condominium condominium,
      List<Account> accounts,
      SpaceRegistrationStep step,
      List<Space> spaces,
      List<SpaceType> spaceTypes,
      this.error)
      : super(data, condominium, step, accounts, spaces, spaceTypes);

  @override
  List<Object?> get props =>
      [data, condominium, step, accounts, spaces, spaceTypes, error];
}

class SpaceRegistrationUploadingState extends SpaceRegistrationState {
  final Stream<double> progress;
  final File file;

  const SpaceRegistrationUploadingState(
      Space data,
      Condominium condominium,
      List<Account> accounts,
      SpaceRegistrationStep step,
      List<Space> spaces,
      List<SpaceType> spaceTypes,
      this.progress,
      this.file)
      : super(data, condominium, step, accounts, spaces, spaceTypes);

  @override
  List<Object?> get props =>
      [data, condominium, step, accounts, spaces, spaceTypes, progress, file];
}

class SpaceRegistrationUploadedState extends SpaceRegistrationState {
  final String path;

  const SpaceRegistrationUploadedState(
      Space data,
      Condominium condominium,
      List<Account> accounts,
      SpaceRegistrationStep step,
      List<Space> spaces,
      List<SpaceType> spaceTypes,
      this.path)
      : super(data, condominium, step, accounts, spaces, spaceTypes);

  @override
  List<Object?> get props =>
      [data, condominium, step, accounts, spaces, spaceTypes, path];
}

class SpaceRegistrationUploadFailedState extends SpaceRegistrationState {
  final Failure error;

  const SpaceRegistrationUploadFailedState(
      Space data,
      Condominium condominium,
      List<Account> accounts,
      SpaceRegistrationStep step,
      List<Space> spaces,
      List<SpaceType> spaceTypes,
      this.error)
      : super(data, condominium, step, accounts, spaces, spaceTypes);

  @override
  List<Object?> get props =>
      [data, condominium, step, accounts, spaces, spaceTypes, error];
}

class SpaceRegistrationRegisteringState extends SpaceRegistrationState {
  const SpaceRegistrationRegisteringState(
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

  const SpaceRegistrationRegisterFailedState(
      Space data,
      Condominium condominium,
      List<Account> accounts,
      SpaceRegistrationStep step,
      List<Space> spaces,
      List<SpaceType> spaceTypes,
      this.error)
      : super(data, condominium, step, accounts, spaces, spaceTypes);

  @override
  List<Object?> get props =>
      [data, condominium, step, accounts, spaces, spaceTypes, error];
}

class SpaceRegistrationRegisteredState extends SpaceRegistrationState {
  const SpaceRegistrationRegisteredState(
      Space data,
      Condominium condominium,
      List<Account> accounts,
      SpaceRegistrationStep step,
      List<Space> spaces,
      List<SpaceType> spaceTypes)
      : super(data, condominium, step, accounts, spaces, spaceTypes);
}
