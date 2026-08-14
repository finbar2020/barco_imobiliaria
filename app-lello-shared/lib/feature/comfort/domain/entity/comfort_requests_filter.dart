import 'package:shared_features/feature/comfort/domain/entity/comfort_filter_requests_status.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_type.dart';

class ComfortRequestsFilter {
  DateTime? startDate;
  DateTime? endDate;
  ComfortFilterRequestStatus? status;
  ComfortType? subcategories;

  ComfortRequestsFilter(
      {this.startDate, this.endDate, this.status, this.subcategories});


  bool isEqualTo(ComfortRequestsFilter other) {
    return status == other.status &&
        subcategories == other.subcategories &&
        startDate == other.startDate &&
        endDate == other.endDate;
  }
}

