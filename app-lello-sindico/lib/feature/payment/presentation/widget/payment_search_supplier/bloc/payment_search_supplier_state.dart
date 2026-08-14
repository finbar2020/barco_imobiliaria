import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/supplier_data_entity.dart';

abstract class PaymentSearchSupplierState extends Equatable {
  const PaymentSearchSupplierState();

  @override
  List<Object?> get props => [];
}

class PaymentSearchSupplierEmptyState extends PaymentSearchSupplierState {
  const PaymentSearchSupplierEmptyState();
}

class PaymentSearchSupplierLoadingState extends PaymentSearchSupplierState {
  const PaymentSearchSupplierLoadingState();
}

class PaymentSearchSupplierSuccessState extends PaymentSearchSupplierState {
  final SupplierDataEntity value;

  const PaymentSearchSupplierSuccessState({required this.value});

  @override
  List<Object?> get props => [value];
}

class PaymentSearchSupplierFailureState extends PaymentSearchSupplierState {
  final Failure? error;

  const PaymentSearchSupplierFailureState({this.error});

  @override
  List<Object?> get props => [error];
}
