import 'package:essentials/essentials.dart';
import 'package:morar/feature/change_ownership/domain/repository/change_ownership_repository.dart';
import 'package:morar/feature/change_ownership/domain/use_case/post_change/post_change.dart';
import 'package:shared_features/shared_features.dart';

class PostChangeUseCaseImpl extends PostChangeUseCase {
  final ChangeOwnershipRepository repository;
  final AwsUploadFileUsecase awsUploadFileUsecase;

  PostChangeUseCaseImpl(
      {required this.repository, required this.awsUploadFileUsecase});
  @override
  Future<Try<String>> call(PostChangeParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    Try<UrlUploadS3> uploadResponse = await awsUploadFileUsecase.call(
      AwsUploadFileParam(
        getUrlUploadS3: () async {
          return getUrlUploadS3(params);
        },
        uploadFileToS3: repository.uploadImageToAws,
        file: params.entity.attachment!,
      ),
    );

    UrlUploadS3? urlUploadS3 =
        uploadResponse.fold((error) => null, (res) => res);

    if (urlUploadS3 == null) {
      return Rejection<String>(
        KnownFailure("500", "upload_file_error"),
      );
    }

    return await repository.postChange(params.condoId, params.entity);
  }

  Future<Try<UrlUploadS3>> getUrlUploadS3(PostChangeParams params) async {
    return await repository.getAws(params.condoId, params.entity);
  }

  Failure? _validate(PostChangeParams params) {
    if (params.condoId.isEmpty) return InvalidParamFailure();
    if (params.entity.personType?.isEmpty == true) return InvalidParamFailure();
    if (params.entity.registration?.isEmpty == true)
      return InvalidParamFailure();
    if (params.entity.name?.isEmpty == true) return InvalidParamFailure();
    if (params.entity.email?.isEmpty == true) return InvalidParamFailure();
    if (params.entity.phone?.isEmpty == true) return InvalidParamFailure();
    if (params.entity.cellphone?.isEmpty == true) return InvalidParamFailure();
    if (params.entity.attachment == null) return InvalidParamFailure();
    return null;
  }
}
