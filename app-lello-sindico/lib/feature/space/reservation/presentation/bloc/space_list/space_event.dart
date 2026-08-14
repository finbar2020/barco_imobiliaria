import 'package:essentials/essentials.dart';

abstract class SpaceEvent extends Equatable {
  const SpaceEvent();

  @override
  List<Object?> get props => [];
}

class SpaceLoadEvent extends SpaceEvent {
  final String condominiumId;

  const SpaceLoadEvent({required this.condominiumId});

  @override
  List<Object?> get props => [condominiumId];
}
