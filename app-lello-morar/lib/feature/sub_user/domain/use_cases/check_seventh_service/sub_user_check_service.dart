import 'package:essentials/essentials.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_service_seventh.dart';

abstract class SubUserCheckServiceCase
    extends UseCase<AccessControlServiceSeventh, GetSubUserCheckServiceParams> {
}

class GetSubUserCheckServiceParams {
  final String reference;

  GetSubUserCheckServiceParams({required this.reference});
}
