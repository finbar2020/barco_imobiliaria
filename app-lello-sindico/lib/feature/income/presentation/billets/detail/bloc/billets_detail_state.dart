import 'package:essentials/essentials.dart';
import 'package:lello/feature/income/domain/entity/billet.dart';

abstract class BilletsDetailState extends Equatable {
  const BilletsDetailState();

  @override
  List<Object?> get props => [];
}

class BilletsDetailEmptyState extends BilletsDetailState {
  const BilletsDetailEmptyState();
}

class BilletsDetailLoadingState extends BilletsDetailState {
  const BilletsDetailLoadingState();
}

class BilletsDetailFailureState extends BilletsDetailState {
  final Failure error;

  const BilletsDetailFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}

class BilletsDetailSuccessState extends BilletsDetailState {
  final Billet? billet;

  const BilletsDetailSuccessState({this.billet});

  @override
  List<Object?> get props => [billet];
}
