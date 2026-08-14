import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/supplier_data_entity.dart';

abstract class PaymentSearchSupplierEvent extends Equatable {
  const PaymentSearchSupplierEvent();

  @override
  List<Object?> get props => [];
}

class PaymentSearchSupplierEmptyEvent extends PaymentSearchSupplierEvent {
  const PaymentSearchSupplierEmptyEvent();
}

class PaymentSearchSupplierLoadingEvent extends PaymentSearchSupplierEvent {
  const PaymentSearchSupplierLoadingEvent();
}

class PaymentSearchSupplierSuccessEvent extends PaymentSearchSupplierEvent {
  final SupplierDataEntity supplier;

  const PaymentSearchSupplierSuccessEvent({required this.supplier});

  @override
  List<Object?> get props => [supplier];
}

class PaymentSearchSupplierFailureEvent extends PaymentSearchSupplierEvent {
  final Failure? error;

  const PaymentSearchSupplierFailureEvent({this.error});

  @override
  List<Object?> get props => [error];
}
