import 'package:essentials/essentials.dart';
import '../../../digital_point/domain/entity/digital_point.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeLoadEvent extends HomeEvent {
  final List<DigitalPointEntity> digitalPoints;

  const HomeLoadEvent({
    required this.digitalPoints,
  });

  @override
  List<Object?> get props => [digitalPoints];
}
