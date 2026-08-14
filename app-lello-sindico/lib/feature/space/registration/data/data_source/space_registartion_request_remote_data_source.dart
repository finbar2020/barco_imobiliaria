import 'package:lello/feature/space/registration/data/model/space_registration_request_model.dart';

abstract class SpaceRegistrationRequestRemoteDataSource {
	Future<SpaceRegistrationRequestModel> insert(String condominiumId, SpaceRegistrationRequestModel data);
}