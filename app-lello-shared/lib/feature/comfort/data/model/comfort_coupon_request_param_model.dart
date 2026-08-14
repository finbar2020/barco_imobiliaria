import 'package:json_annotation/json_annotation.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_coupon_request_param.dart';

part 'comfort_coupon_request_param_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ComfortCouponRequestParamModel {
  String type;
  String nameParam;
  String param;

  ComfortCouponRequestParamModel({
    this.type = "",
    this.nameParam = "",
    this.param = "",
  });

  factory ComfortCouponRequestParamModel.fromJson(Map<String, dynamic> json) =>
      _$ComfortCouponRequestParamModelFromJson(json);

  Map<String, dynamic> toJson() => _$ComfortCouponRequestParamModelToJson(this);

  static ComfortCouponRequestParamModel? fromEntity(
          ComfortCouponRequestParam? entity) =>
      entity == null
          ? null
          : (ComfortCouponRequestParamModel()
            ..type = entity.type
            ..nameParam = entity.nameParam
            ..param = entity.param);

  ComfortCouponRequestParam toEntity() => ComfortCouponRequestParam(
        type: this.type,
        nameParam: this.nameParam,
        param: this.param,
      );
}
