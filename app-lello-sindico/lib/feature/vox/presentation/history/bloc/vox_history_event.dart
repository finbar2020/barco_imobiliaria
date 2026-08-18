abstract class VoxHistoryEvent {}

/// Carga inicial do histórico.
class VoxHistoryStarted extends VoxHistoryEvent {}

/// Recarrega o histórico (pull-to-refresh / retry).
class VoxHistoryRefreshed extends VoxHistoryEvent {}
