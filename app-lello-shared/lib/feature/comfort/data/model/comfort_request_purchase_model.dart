import 'package:json_annotation/json_annotation.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_request_purchase.dart';

part 'comfort_request_purchase_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ComfortRequestPurchaseModel {
  String requestId;
  String userId;
  String unitId;
  bool purchaseDone;
  int? usedCoupon;
  double? rating;
  String? comment;
  DateTime? purchaseDate;
  DateTime? dateResend;
  String? typeCTA;
  bool? canCancel;
  bool? canResend;
  String? status;
  String? typeSubject;

  ComfortRequestPurchaseModel(
      {this.requestId = "",
      this.userId = "",
      this.unitId = "",
      this.purchaseDone = false,
      this.usedCoupon,
      this.rating,
      this.comment,
      this.purchaseDate,
      this.dateResend,
      this.typeCTA,
      this.status,
      this.canCancel = false,
      this.canResend = false,
      this.typeSubject});

  factory ComfortRequestPurchaseModel.fromJson(Map<String, dynamic> json) =>
      _$ComfortRequestPurchaseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ComfortRequestPurchaseModelToJson(this);

  static ComfortRequestPurchaseModel? fromEntity(
          ComfortRequestPurchase? entity) =>
      entity == null
          ? null
          : (ComfortRequestPurchaseModel()
            ..requestId = entity.requestId
            ..userId = entity.userId
            ..unitId = entity.unitId
            ..usedCoupon = entity.usedCoupon
            ..rating = entity.rating
            ..comment = entity.comment
            ..purchaseDone = entity.purchaseDone
            ..purchaseDate = entity.purchaseDate
            ..dateResend = entity.dateResend
            ..typeCTA = entity.typeCTA
            ..canCancel = entity.canCancel
            ..canResend = entity.canResend
            ..status = entity.status
            ..typeSubject = entity.typeSubject);

  ComfortRequestPurchase toEntity() => ComfortRequestPurchase(
      requestId: this.requestId,
      userId: this.userId,
      unitId: this.unitId,
      usedCoupon: this.usedCoupon,
      rating: this.rating,
      comment: this.comment,
      purchaseDone: this.purchaseDone,
      purchaseDate: this.purchaseDate,
      dateResend: this.dateResend,
      typeCTA: this.typeCTA,
      canCancel: this.canCancel,
      canResend: this.canResend,
      status: this.status,
      typeSubject: this.typeSubject);
}
