abstract class QuickFixEvent {}

class QuickFixLoadEvent extends QuickFixEvent {
  final String condominiumId;

  QuickFixLoadEvent({required this.condominiumId});
}
