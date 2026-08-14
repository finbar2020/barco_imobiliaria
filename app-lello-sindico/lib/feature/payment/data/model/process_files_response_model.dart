import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/payment/data/model/supplier_data_model.dart';
import 'package:lello/feature/payment/domain/entity/process_files_response.dart';
import 'payment_data_model.dart';

part 'process_files_response_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ProcessFilesResponseModel {
  final bool success;
  final String status;
  final String? message;
  final PaymentDataModel? paymentData;
  final SupplierDataModel? supplierData;
  final String? filePathLaunch;

  ProcessFilesResponseModel({
    required this.success,
    required this.status,
    this.message,
    this.paymentData,
    this.supplierData,
    this.filePathLaunch,
  });

  factory ProcessFilesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ProcessFilesResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProcessFilesResponseModelToJson(this);

  static ProcessFilesResponseModel? fromEntity(
      ProcessFilesResponseEntity? entity) {
    if (entity == null) return null;
    return ProcessFilesResponseModel(
      success: entity.success,
      status: entity.status,
      message: entity.message,
      paymentData: PaymentDataModel.fromEntity(entity.paymentData),
      supplierData: SupplierDataModel.fromEntity(entity.supplierData),
      filePathLaunch: entity.filePathLaunch,
    );
  }

  ProcessFilesResponseEntity toEntity() {
    return ProcessFilesResponseEntity(
      success: success,
      status: status,
      message: message,
      paymentData: paymentData?.toEntity(),
      supplierData: supplierData?.toEntity(),
      filePathLaunch: filePathLaunch,
    );
  }
}
