import 'package:json_annotation/json_annotation.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_review.dart';

part 'comfort_partner_review_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ComfortPartnerReviewModel {
  String? image;
  String? name;
  double review;
  String? comment;
  DateTime? reviewDate;
  String? redirectImage;

  ComfortPartnerReviewModel({
    this.image,
    this.name,
    required this.review,
    this.comment,
    this.reviewDate,
    this.redirectImage,
  });

  factory ComfortPartnerReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ComfortPartnerReviewModelFromJson(json);

  Map<String, dynamic> toJson() => _$ComfortPartnerReviewModelToJson(this);

  static ComfortPartnerReviewModel fromEntity(ComfortPartnerReview entity) =>
      ComfortPartnerReviewModel(
        image: entity.image,
        name: entity.name,
        review: entity.review,
        comment: entity.comment,
        reviewDate: entity.reviewDate,
        redirectImage: entity.redirectImage,
      );

  ComfortPartnerReview toEntity() => ComfortPartnerReview(
        image: this.image,
        name: this.name,
        review: this.review,
        comment: this.comment,
        reviewDate: this.reviewDate,
        redirectImage: this.redirectImage,
      );
}
