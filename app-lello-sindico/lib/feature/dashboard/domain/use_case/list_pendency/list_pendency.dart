import 'package:essentials/essentials.dart';
import 'package:lello/feature/dashboard/domain/entity/pendency.dart';

abstract class ListPendency extends UseCase<List<Pendency>, ListPendencyParam> {
}

class ListPendencyParam {
  final String reference;
  final String? lastPendencyId;
  final int? currentSize;
  final DataOrigin dataOrigin;

  ListPendencyParam(
    this.reference, {
    this.lastPendencyId,
    this.currentSize,
    this.dataOrigin = DataOrigin.remote,
  });
}
