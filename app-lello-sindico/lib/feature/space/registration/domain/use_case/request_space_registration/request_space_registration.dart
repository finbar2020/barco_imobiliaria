import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/registration/domain/entity/space_registration_request.dart';

abstract class RequestSpaceRegistration
    extends UseCase<SpaceRegistrationRequest, RequestSpaceRegistrationParam> {}

class RequestSpaceRegistrationParam {
  final String condominiumId;
  final SpaceRegistrationRequest data;

  RequestSpaceRegistrationParam(
      {required this.condominiumId, required this.data});
}
