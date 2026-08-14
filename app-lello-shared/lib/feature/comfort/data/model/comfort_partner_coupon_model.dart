import 'package:json_annotation/json_annotation.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_coupon.dart';

part 'comfort_partner_coupon_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ComfortPartnerCouponModel {
  String id;
  String code;
  String title;
  int discountPercentage;
  bool highlight;
  String description;
  String saleType;
  DateTime? dateInsertion;
  DateTime? dateRemoval;
  String imageHash;
  bool reusable;
  int useLimit;
  String notificationParameter;

  ComfortPartnerCouponModel({
    this.id = "",
    this.code = "",
    this.title = "",
    this.discountPercentage = 0,
    this.highlight = false,
    this.description = "",
    this.saleType = "",
    this.dateInsertion,
    this.dateRemoval,
    this.imageHash = "",
    this.reusable = true,
    this.useLimit = 999,
    this.notificationParameter = "",
  });

  factory ComfortPartnerCouponModel.fromJson(Map<String, dynamic> json) =>
      _$ComfortPartnerCouponModelFromJson(json);

  Map<String, dynamic> toJson() => _$ComfortPartnerCouponModelToJson(this);

  static ComfortPartnerCouponModel? fromEntity(ComfortPartnerCoupon? entity) =>
      entity == null
          ? null
          : (ComfortPartnerCouponModel()
            ..id = entity.id
            ..code = entity.code
            ..title = entity.title
            ..discountPercentage = entity.discountPercentage
            ..highlight = entity.highlight
            ..description = entity.description
            ..saleType = entity.saleType
            ..dateInsertion = entity.dateInsertion
            ..dateRemoval = entity.dateRemoval
            ..imageHash = entity.imageHash
            ..reusable = entity.reusable
            ..useLimit = entity.useLimit
            ..notificationParameter = entity.notificationParameter
            );

  ComfortPartnerCoupon toEntity() => ComfortPartnerCoupon(
        id: this.id,
        code: this.code,
        title: this.title,
        discountPercentage: this.discountPercentage,
        highlight: this.highlight,
        description: this.description,
        saleType: this.saleType,
        dateInsertion: this.dateInsertion,
        dateRemoval: this.dateRemoval,
        imageHash: this.imageHash,
        reusable: this.reusable,
        useLimit: this.useLimit,
        notificationParameter: this.notificationParameter,
      );
}
