import 'package:essentials/essentials.dart';
import 'package:lello/feature/income/domain/entity/billet.dart';

abstract class BilletsDetailEvent extends Equatable {
  const BilletsDetailEvent();

  @override
  List<Object?> get props => [];
}

class BilletsDetailLoadingEvent extends BilletsDetailEvent {
  const BilletsDetailLoadingEvent();
}

class BilletsDetailEmptyEvent extends BilletsDetailEvent {
  const BilletsDetailEmptyEvent();
}

class BilletsDetailSuccessEvent extends BilletsDetailEvent {
  final Billet? billet;

  const BilletsDetailSuccessEvent({this.billet});

  @override
  List<Object?> get props => [billet];
}

class BilletsDetailFailureEvent extends BilletsDetailEvent {
  final Failure failure;

  const BilletsDetailFailureEvent({required this.failure});

  @override
  List<Object?> get props => [failure];
}
