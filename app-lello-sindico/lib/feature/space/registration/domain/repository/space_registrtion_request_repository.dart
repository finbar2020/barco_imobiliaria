import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/registration/domain/entity/space_registration_request.dart';

abstract class SpaceRegistrationRequestRepository {
  Future<Try<SpaceRegistrationRequest>> insert(
      String condominiumId, SpaceRegistrationRequest data);
}
