import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/comfort/data/model/comfort_partner_coupon_model.dart';
import 'package:shared_features/feature/comfort/data/model/comfort_partner_details_model.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_cta_enum.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_category.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_intro.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_type.dart';

part 'comfort_partner_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ComfortPartnerModel {
  String id;
  String targetPublic;
  String title;
  String imageHash;
  String clobContent;
  String email;
  String instagram;
  String instagramLink;
  String site;
  String comfortType;
  String category;
  int biggestDiscountPercentage;
  String redirect;
  String cta;
  List<ComfortPartnerCouponModel?> partnerCoupons;
  ComfortPartnerDetailsModel? partnerDetails;
  double rating;
  int ratingsNumber;
  bool favorite;
  double categoryOrder;
  double partnerOrder;
  String notificationParameter;

  ComfortPartnerModel({
    this.id = "",
    this.targetPublic = "",
    this.title = "",
    this.imageHash = "",
    this.clobContent = "",
    this.comfortType = "",
    this.category = "",
    this.email = "",
    this.instagram = "",
    this.instagramLink = "",
    this.site = "",
    this.cta = "",
    this.biggestDiscountPercentage = 0,
    this.redirect = "",
    this.partnerCoupons = const [],
    this.rating = 0.0,
    this.ratingsNumber = 0,
    this.favorite = false,
    this.categoryOrder = 0.0,
    this.partnerOrder = 0.0,
    this.notificationParameter = "",
  });

  factory ComfortPartnerModel.fromJson(Map<String, dynamic> json) =>
      _$ComfortPartnerModelFromJson(json);

  Map<String, dynamic> toJson() => _$ComfortPartnerModelToJson(this);

  static ComfortPartnerModel? fromEntity(ComfortPartner? entity) =>
      entity == null
          ? null
          : (ComfortPartnerModel()
            ..id = entity.id
            ..targetPublic = entity.targetPublic
            ..email = entity.email
            ..instagram = entity.instagram
            ..instagramLink = entity.instagramLink
            ..site = entity.site
            ..cta = enumToString(entity.cta) ?? ""
            ..title = entity.partnerIntro.title
            ..imageHash = entity.imageHash
            ..clobContent = entity.clobContent
            ..comfortType = enumToString(entity.partnerIntro.comfortType) ?? ""
            ..category = enumToString(entity.category) ?? ""
            ..biggestDiscountPercentage = entity.biggestDiscountPercentage
            ..redirect = entity.redirect
            ..partnerDetails = ComfortPartnerDetailsModel.fromEntity(
                entity.partnerIntro.partnerDetails)
            ..rating = entity.rating
            ..ratingsNumber = entity.ratingsNumber
            ..favorite = entity.partnerIntro.favorite
            ..categoryOrder = entity.categoryOrder
            ..partnerOrder = entity.partnerOrder
            ..notificationParameter = entity.notificationParameter);

  ComfortPartner toEntity() => ComfortPartner(
      id: this.id,
      targetPublic: this.targetPublic,
      email: this.email,
      instagram: this.instagram,
      instagramLink: this.instagramLink,
      site: this.site,
      cta: stringToEnum(ComfortCTA.values, this.cta) ?? ComfortCTA.cupom,
      partnerIntro: ComfortPartnerIntro(
        id: this.id,
        title: this.title,
        partnerDetails: this.partnerDetails?.toEntity(),
        comfortType: stringToEnum(ComfortType.values, this.comfortType) ??
            ComfortType.others,
        favorite: this.favorite,
      ),
      imageHash: this.imageHash,
      clobContent: this.clobContent,
      category: stringToEnum(ComfortPartnerCategory.values, this.category) ??
          ComfortPartnerCategory.others,
      biggestDiscountPercentage: this.biggestDiscountPercentage,
      redirect: this.redirect,
      rating: this.rating,
      ratingsNumber: this.ratingsNumber,
      categoryOrder: this.categoryOrder,
      partnerOrder: this.partnerOrder,
      notificationParameter: this.notificationParameter);
}
