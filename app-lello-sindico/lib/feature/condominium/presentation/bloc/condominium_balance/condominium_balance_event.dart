import 'package:essentials/essentials.dart';

abstract class CondominiumBalanceEvent extends Equatable {
  const CondominiumBalanceEvent();

  @override
  List<Object?> get props => [];
}

class CondominiumBalanceLoadEvent extends CondominiumBalanceEvent {
  const CondominiumBalanceLoadEvent();
}
