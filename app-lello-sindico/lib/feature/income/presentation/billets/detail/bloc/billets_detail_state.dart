// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:lello/feature/income/domain/entity/billet.dart';

import 'package:essentials/essentials.dart';

abstract class BilletsDetailState {}

class BilletsDetailEmptyState extends BilletsDetailState {}

class BilletsDetailLoadingState extends BilletsDetailState {}

class BilletsDetailFailureState extends BilletsDetailState {
  final Failure error;
  BilletsDetailFailureState({
    required this.error,
  });
}

class BilletsDetailSuccessState extends BilletsDetailState {
  final Billet? billet;
  BilletsDetailSuccessState({
    this.billet,
  });
}
