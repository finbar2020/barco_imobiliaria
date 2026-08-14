import 'package:colaborador/feature/digital_point/domain/entity/digital_point.dart';
import 'package:essentials/essentials.dart';

abstract class SyncDigitalPointsEvent extends Equatable {
  const SyncDigitalPointsEvent();

  @override
  List<Object?> get props => [];
}

class SyncPointsEvent extends SyncDigitalPointsEvent {
  final List<DigitalPointEntity> digitalPoints;

  const SyncPointsEvent({required this.digitalPoints});

  @override
  List<Object?> get props => [digitalPoints];
}
