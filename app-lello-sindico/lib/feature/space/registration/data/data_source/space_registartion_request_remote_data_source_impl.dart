import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/registration/data/data_source/space_registartion_request_remote_data_source.dart';
import 'package:lello/feature/space/registration/data/data_source/space_registration_request_api.dart';
import 'package:lello/feature/space/registration/data/model/space_registration_request_model.dart';

class SpaceRegistrationRequestRemoteDataSourceImpl
    extends SpaceRegistrationRequestRemoteDataSource {
  final SpaceRegistrationRequestApi api;

  SpaceRegistrationRequestRemoteDataSourceImpl({required this.api});
  @override
  Future<SpaceRegistrationRequestModel> insert(
      String condominiumId, SpaceRegistrationRequestModel data) async {
    final response = await api.post(condominiumId, data);
    return ApiMapper.map(
        response, (json) => SpaceRegistrationRequestModel.fromJson(json));
  }
}
