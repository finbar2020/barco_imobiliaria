// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'process_files_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProcessFilesResponseModel _$ProcessFilesResponseModelFromJson(
        Map<String, dynamic> json) =>
    ProcessFilesResponseModel(
      success: json['success'] as bool,
      status: json['status'] as String,
      message: json['message'] as String?,
      paymentData: json['payment_data'] == null
          ? null
          : PaymentDataModel.fromJson(
              json['payment_data'] as Map<String, dynamic>),
      supplierData: json['supplier_data'] == null
          ? null
          : SupplierDataModel.fromJson(
              json['supplier_data'] as Map<String, dynamic>),
      filePathLaunch: json['file_path_launch'] as String?,
    );

Map<String, dynamic> _$ProcessFilesResponseModelToJson(
        ProcessFilesResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'status': instance.status,
      'message': instance.message,
      'payment_data': instance.paymentData,
      'supplier_data': instance.supplierData,
      'file_path_launch': instance.filePathLaunch,
    };
