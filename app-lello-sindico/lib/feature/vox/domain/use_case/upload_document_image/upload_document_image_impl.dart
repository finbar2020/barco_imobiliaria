import 'package:essentials/essentials.dart';
import 'package:lello/feature/vox/domain/repository/vox_repository.dart';
import 'package:lello/feature/vox/domain/use_case/upload_document_image/upload_document_image.dart';

class UploadDocumentImageImpl extends UploadDocumentImage {
  final VoxRepository repository;

  UploadDocumentImageImpl({required this.repository});

  @override
  Future<Try<String>> call(UploadDocumentImageParam? params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    return repository.uploadImage(params!.bytes, params.fileName);
  }

  Failure? validate(UploadDocumentImageParam? params) {
    if (params == null) return InvalidParamFailure();
    if (params.bytes.isEmpty) return InvalidParamFailure();
    if (params.fileName.isEmpty) return InvalidParamFailure();
    return null;
  }
}
