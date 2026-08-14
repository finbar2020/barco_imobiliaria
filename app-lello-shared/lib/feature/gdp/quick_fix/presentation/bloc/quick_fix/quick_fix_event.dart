import 'package:essentials/essentials.dart';

abstract class QuickFixEvent extends Equatable {
  const QuickFixEvent();

  @override
  List<Object?> get props => [];
}

class QuickFixLoadEvent extends QuickFixEvent {
  final String condominiumId;

  const QuickFixLoadEvent({required this.condominiumId});

  @override
  List<Object?> get props => [condominiumId];
}
