// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comfort_coupon_request_param_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComfortCouponRequestParamModel _$ComfortCouponRequestParamModelFromJson(
        Map<String, dynamic> json) =>
    ComfortCouponRequestParamModel(
      type: json['type'] as String? ?? "",
      nameParam: json['name_param'] as String? ?? "",
      param: json['param'] as String? ?? "",
    );

Map<String, dynamic> _$ComfortCouponRequestParamModelToJson(
        ComfortCouponRequestParamModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'name_param': instance.nameParam,
      'param': instance.param,
    };
