import 'package:essentials/essentials.dart';

abstract class PayrollEvent extends Equatable {
  const PayrollEvent();

  @override
  List<Object?> get props => [];
}

class PayrollLoadEvent extends PayrollEvent {
  final String condominiumId;
  final DateTime period;

  const PayrollLoadEvent({required this.condominiumId, required this.period});

  @override
  List<Object?> get props => [condominiumId, period];
}

class PayrollLoadListEvent extends PayrollEvent {
  final String condominiumId;

  const PayrollLoadListEvent({required this.condominiumId});

  @override
  List<Object?> get props => [condominiumId];
}
