import 'package:colaborador/feature/digital_point/domain/entity/digital_point.dart';
import 'package:essentials/essentials.dart';

abstract class SyncDigitalPointsState extends Equatable {
  const SyncDigitalPointsState();

  @override
  List<Object?> get props => [];
}

class SyncDigitalPointsLoadingState extends SyncDigitalPointsState {
  const SyncDigitalPointsLoadingState();
}

class SyncDigitalPointsLoadedState extends SyncDigitalPointsState {
  const SyncDigitalPointsLoadedState();
}

class SyncDigitalPointsFailedState extends SyncDigitalPointsState {
  final List<DigitalPointEntity> failedDigitalPoints;
  final String? code;
  final String? message;

  const SyncDigitalPointsFailedState({
    required this.failedDigitalPoints,
    this.code,
    this.message,
  });

  @override
  List<Object?> get props => [failedDigitalPoints, code, message];
}

class SyncDigitalPointsBlockedState extends SyncDigitalPointsState {
  final bool onlyTablet;
  final bool onlyPhone;

  const SyncDigitalPointsBlockedState({
    this.onlyTablet = false,
    this.onlyPhone = false,
  });

  @override
  List<Object?> get props => [onlyTablet, onlyPhone];
}

class SyncDigitalPointsSuccessState extends SyncDigitalPointsState {
  const SyncDigitalPointsSuccessState();
}
