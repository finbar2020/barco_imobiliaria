import 'package:intl/intl.dart';

class ComfortPartnerReview {
  String? image;
  String? name;
  double review;
  String? comment;
  DateTime? reviewDate;
  String? redirectImage;

  ComfortPartnerReview({
    this.image,
    this.name,
    required this.review,
    this.comment,
    this.reviewDate,
    this.redirectImage,
  });

  String get reviewTitle {
    if (name?.isNotEmpty == true && formattedDate.isNotEmpty) {
      return "$name - $formattedDate";
    } else if (name?.isNotEmpty == true) {
      return name!;
    } else if (formattedDate.isNotEmpty) {
      return formattedDate;
    } else {
      return "";
    }
  }

  String get formattedDate {
    if (reviewDate != null) {
      DateFormat format = DateFormat("dd/MM/yyyy");
      return format.format(reviewDate!);
    }
    return "";
  }
}
