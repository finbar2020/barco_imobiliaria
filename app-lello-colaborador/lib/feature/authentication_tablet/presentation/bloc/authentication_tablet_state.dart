import 'package:colaborador/feature/authentication_tablet/domain/entity/condominium_code_info.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point.dart';
import 'package:essentials/essentials.dart';

abstract class AuthenticationTabletState extends Equatable {
  const AuthenticationTabletState();

  @override
  List<Object?> get props => [];
}

class AuthenticationTabletInitialState extends AuthenticationTabletState {
  const AuthenticationTabletInitialState();
}

class AuthenticationTabletLoadingState extends AuthenticationTabletState {
  const AuthenticationTabletLoadingState();
}

class AuthenticationTabletFailedState extends AuthenticationTabletState {
  const AuthenticationTabletFailedState();
}

class AuthenticationTabletLoadedState extends AuthenticationTabletState {
  final CondominiumCodeInfo condominiumCodeInfo;
  final bool isUpdating;
  final List<DigitalPointEntity>? points;

  const AuthenticationTabletLoadedState(
    this.condominiumCodeInfo, {
    this.isUpdating = false,
    this.points,
  });

  @override
  List<Object?> get props => [condominiumCodeInfo, isUpdating, points];
}

class AuthenticationNoAuthPointsLoadedState extends AuthenticationTabletState {
  final List<DigitalPointEntity> points;

  const AuthenticationNoAuthPointsLoadedState({
    required this.points,
  });

  @override
  List<Object?> get props => [points];
}
