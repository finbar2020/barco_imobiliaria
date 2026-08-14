import 'package:essentials/essentials.dart';
import 'package:morar/feature/billets/domain/entity/billet.dart';

abstract class BilletsEvent extends Equatable {
  const BilletsEvent();

  @override
  List<Object?> get props => [];
}

class BilletsLoadingEvent extends BilletsEvent {
  final Billet? billet;

  const BilletsLoadingEvent({this.billet});

  @override
  List<Object?> get props => [billet];
}

class BilletsLoadedEvent extends BilletsEvent {
  final List<Billet> billets;
  final int allBillets;

  const BilletsLoadedEvent({required this.billets, required this.allBillets});

  @override
  List<Object?> get props => [billets, allBillets];
}

class BilletsFailureEvent extends BilletsEvent {
  final String error;
  final Billet? billet;

  const BilletsFailureEvent({required this.error, this.billet});

  @override
  List<Object?> get props => [error, billet];
}

class BilletsEmptyEvent extends BilletsEvent {
  final Billet? billet;

  const BilletsEmptyEvent({this.billet});

  @override
  List<Object?> get props => [billet];
}

class BilletsShowInfoEvent extends BilletsEvent {
  final Billet billet;
  final String? pdf;
  final String? fileName;

  const BilletsShowInfoEvent({
    required this.billet,
    this.pdf,
    this.fileName,
  });

  @override
  List<Object?> get props => [billet, pdf, fileName];
}
