import 'package:essentials/essentials.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitialState extends HomeState {
  const HomeInitialState();
}

class HomeLoadingState extends HomeState {
  const HomeLoadingState();
}

class HomeLoadedState extends HomeState {
  final List<DigitalPointEntity> digitalPoints;

  const HomeLoadedState({
    required this.digitalPoints,
  });

  @override
  List<Object?> get props => [digitalPoints];
}

class HomeFailedState extends HomeState {
  const HomeFailedState();
}
