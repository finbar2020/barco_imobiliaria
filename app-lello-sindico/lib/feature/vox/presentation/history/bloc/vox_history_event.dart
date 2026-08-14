import 'package:essentials/essentials.dart';

abstract class VoxHistoryEvent extends Equatable {
  const VoxHistoryEvent();

  @override
  List<Object?> get props => [];
}

/// Carga inicial do histórico.
class VoxHistoryStartedEvent extends VoxHistoryEvent {
  const VoxHistoryStartedEvent();
}

/// Recarrega o histórico (pull-to-refresh / retry).
class VoxHistoryRefreshedEvent extends VoxHistoryEvent {
  const VoxHistoryRefreshedEvent();
}
