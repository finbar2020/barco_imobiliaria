import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/registration/data/data_source/space_registartion_request_remote_data_source.dart';
import 'package:lello/feature/space/registration/data/model/space_registration_request_model.dart';
import 'package:lello/feature/space/registration/domain/entity/space_registration_request.dart';
import 'package:lello/feature/space/registration/domain/repository/space_registrtion_request_repository.dart';

class SpaceRegistrationRequestRepositoryImpl
    extends SpaceRegistrationRequestRepository {
  final SpaceRegistrationRequestRemoteDataSource dataSource;

  SpaceRegistrationRequestRepositoryImpl({required this.dataSource});

  @override
  Future<Try<SpaceRegistrationRequest>> insert(
      String condominiumId, SpaceRegistrationRequest data) async {
    try {
      final model = SpaceRegistrationRequestModel.fromEntity(data);
      final result = await dataSource.insert(condominiumId, model!);
      return Success(result.toEntity());
    } catch (ex) {
      return Rejection(UnknownFailure(ex));
    }
  }
}
