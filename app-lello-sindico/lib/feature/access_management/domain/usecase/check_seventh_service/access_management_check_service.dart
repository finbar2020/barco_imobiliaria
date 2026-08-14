import 'package:essentials/essentials.dart';
import 'package:lello/feature/access_management/domain/entity/access_management_service_seventh.dart';

abstract class AccessManagementCheckServiceCase extends UseCase<
    AccessManagementServiceSeventh, AccessManagementCheckServiceParams> {}

class AccessManagementCheckServiceParams {
  final String reference;

  AccessManagementCheckServiceParams({required this.reference});
}
