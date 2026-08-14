// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comfort_coupon_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComfortCouponRequestModel _$ComfortCouponRequestModelFromJson(
        Map<String, dynamic> json) =>
    ComfortCouponRequestModel(
      idRequest: json['id_request'] as String? ?? "",
      params: (json['params'] as List<dynamic>?)
              ?.map((e) => e == null
                  ? null
                  : ComfortCouponRequestParamModel.fromJson(
                      e as Map<String, dynamic>))
              .toList() ??
          const [],
      linkRedirectPartner: json['link_redirect_partner'] as String? ?? "",
      redirectExternal: json['redirect_external'] as bool? ?? false,
      cta: json['cta'] as String? ?? "cupom",
    );

Map<String, dynamic> _$ComfortCouponRequestModelToJson(
        ComfortCouponRequestModel instance) =>
    <String, dynamic>{
      'id_request': instance.idRequest,
      'params': instance.params,
      'link_redirect_partner': instance.linkRedirectPartner,
      'redirect_external': instance.redirectExternal,
      'cta': instance.cta,
    };
