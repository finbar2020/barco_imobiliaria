import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/domain/repository/space_file_repository.dart';
import 'package:lello/feature/space/registration/domain/use_case/upload_space_file/upload_space_file.dart';

class UploadSpaceFileImpl extends UploadSpaceFile {
  final SpaceFileRepository repository;

  UploadSpaceFileImpl({required this.repository});

  @override
  Future<Try<String>> call(UploadSpaceFileParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.upload(
        params.condominiumId, params.spaceId, params.file, params.progress);
  }

  Failure? _validate(UploadSpaceFileParam? params) {
    if (params == null) return InvalidParamFailure();
    if (params.condominiumId.isEmpty) return InvalidParamFailure();

    return null;
  }
}
