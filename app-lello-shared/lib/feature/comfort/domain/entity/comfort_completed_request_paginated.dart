import 'package:essentials/paginator/meta.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_completed_request.dart';

class ComfortCompletedRequestPaginated {
  Meta meta;
  List<ComfortCompletedRequest> data;

  ComfortCompletedRequestPaginated({
    required this.meta,
    required this.data,
  });
}
