import 'package:essentials/essentials.dart';
import 'package:essentials/paginator/paginator.dart';

abstract class BilletsUseCase extends UseCase<Paginator, BilletsParams> {}

class BilletsParams {
  final String reference;
  final String unitId;
  final bool showAll;

  BilletsParams(
      {required this.reference, required this.unitId, this.showAll = false});
}
