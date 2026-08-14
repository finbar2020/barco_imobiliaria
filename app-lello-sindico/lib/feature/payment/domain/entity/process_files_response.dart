import 'package:lello/feature/payment/domain/entity/payment_data.dart';
import 'package:lello/feature/payment/domain/entity/supplier_data_entity.dart';

class ProcessFilesResponseEntity {
  final bool success;
  final String status;
  final String? message;
  final PaymentDataEntity? paymentData;
  final SupplierDataEntity? supplierData;
  final String? filePathLaunch;

  ProcessFilesResponseEntity({
    required this.success,
    required this.status,
    this.message,
    this.paymentData,
    this.supplierData,
    this.filePathLaunch,
  });

  ProcessFilesResponseEntity copyWith({
    bool? success,
    String? status,
    String? message,
    PaymentDataEntity? paymentData,
    SupplierDataEntity? supplierData,
    String? filePathLaunch,
  }) {
    return ProcessFilesResponseEntity(
      success: success ?? this.success,
      status: status ?? this.status,
      message: message ?? this.message,
      paymentData: paymentData ?? this.paymentData,
      supplierData: supplierData ?? this.supplierData,
      filePathLaunch: filePathLaunch ?? this.filePathLaunch,
    );
  }
}
