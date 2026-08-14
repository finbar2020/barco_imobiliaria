import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/registration/domain/entity/space_registration_request.dart';
import 'package:lello/feature/space/registration/domain/repository/space_registrtion_request_repository.dart';
import 'package:lello/feature/space/registration/domain/use_case/request_space_registration/request_space_registration.dart';

class RequestSpaceRegistrationImpl extends RequestSpaceRegistration {
  final SpaceRegistrationRequestRepository repository;

  RequestSpaceRegistrationImpl({required this.repository});
  @override
  Future<Try<SpaceRegistrationRequest>> call(
      RequestSpaceRegistrationParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.insert(params.condominiumId, params.data);
  }

  Failure? _validate(RequestSpaceRegistrationParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
