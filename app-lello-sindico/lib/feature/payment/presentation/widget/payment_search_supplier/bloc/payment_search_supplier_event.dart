import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/supplier_data_entity.dart';

abstract class PaymentSearchSupplierEvent {}

class PaymentSearchSupplierEmptyEvent extends PaymentSearchSupplierEvent {}

class PaymentSearchSupplierLoadingEvent extends PaymentSearchSupplierEvent {}

class PaymentSearchSupplierSuccessEvent extends PaymentSearchSupplierEvent {
  SupplierDataEntity supplier;
  PaymentSearchSupplierSuccessEvent({required this.supplier});
}

class PaymentSearchSupplierFailureEvent extends PaymentSearchSupplierEvent {
  final Failure? error;
  PaymentSearchSupplierFailureEvent({this.error});
}
