abstract class SpaceEvent {}

class SpaceLoadEvent extends SpaceEvent {
  final String condominiumId;
  SpaceLoadEvent({required this.condominiumId});
}
