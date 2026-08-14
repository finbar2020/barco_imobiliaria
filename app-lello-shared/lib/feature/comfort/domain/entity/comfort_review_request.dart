class ComfortReviewRequest {
  String requestId;
  double rating;
  String? comment;

  ComfortReviewRequest({
    required this.requestId,
    required this.rating,
    required this.comment,
  });
}
