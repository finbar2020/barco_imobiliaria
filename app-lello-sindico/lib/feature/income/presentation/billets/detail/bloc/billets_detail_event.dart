import 'package:essentials/essentials.dart';
import 'package:lello/feature/income/domain/entity/billet.dart';

abstract class BilletsDetailEvent {}

class BilletsDetailLoadingEvent extends BilletsDetailEvent {}

class BilletsDetailEmptyEvent extends BilletsDetailEvent {}

class BilletsDetailSuccessEvent extends BilletsDetailEvent {
  final Billet? billet;
  BilletsDetailSuccessEvent({
    this.billet,
  });
}

class BilletsDetailFailureEvent extends BilletsDetailEvent {
  final Failure failure;
  BilletsDetailFailureEvent({
    required this.failure,
  });
}
