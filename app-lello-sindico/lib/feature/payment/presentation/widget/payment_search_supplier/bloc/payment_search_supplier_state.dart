import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/supplier_data_entity.dart';

abstract class PaymentSearchSupplierState {}

class PaymentSearchSupplierEmptyState extends PaymentSearchSupplierState {}

class PaymentSearchSupplierLoadingState extends PaymentSearchSupplierState {}

class PaymentSearchSupplierSuccessState extends PaymentSearchSupplierState {
  SupplierDataEntity value;
  PaymentSearchSupplierSuccessState({required this.value});
}

class PaymentSearchSupplierFailureState extends PaymentSearchSupplierState {
  final Failure? error;
  PaymentSearchSupplierFailureState({this.error});
}
