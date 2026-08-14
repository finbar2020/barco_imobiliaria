import 'package:essentials/essentials.dart';

abstract class VoxDetailEvent extends Equatable {
  const VoxDetailEvent();

  @override
  List<Object?> get props => [];
}

/// Carrega o detalhe por id (Q7: o detalhe sempre re-busca).
class VoxDetailStartedEvent extends VoxDetailEvent {
  const VoxDetailStartedEvent();
}
