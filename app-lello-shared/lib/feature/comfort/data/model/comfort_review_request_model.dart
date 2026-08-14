import 'package:json_annotation/json_annotation.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_review_request.dart';

part 'comfort_review_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ComfortReviewRequestModel {
  String requestId;
  double? rating;
  String? comment;

  ComfortReviewRequestModel({
    this.requestId = "",
    this.rating,
    this.comment,
  });

  factory ComfortReviewRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ComfortReviewRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$ComfortReviewRequestModelToJson(this);

  static ComfortReviewRequestModel fromEntity(ComfortReviewRequest entity) =>
      (ComfortReviewRequestModel()
        ..requestId = entity.requestId
        ..comment = entity.comment
        ..rating = entity.rating);

  ComfortReviewRequest toEntity() => ComfortReviewRequest(
        requestId: this.requestId,
        comment: this.comment,
        rating: this.rating ?? 0.0,
      );
}
