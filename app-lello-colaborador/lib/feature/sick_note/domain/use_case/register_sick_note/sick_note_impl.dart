import 'package:colaborador/feature/sick_note/domain/entity/sick_note.dart';
import 'package:colaborador/feature/sick_note/domain/repository/sick_note_repository.dart';
import 'package:colaborador/feature/sick_note/domain/use_case/register_sick_note/sick_note.dart';
import 'package:essentials/essentials.dart';
import 'package:shared_features/shared_features.dart';

class RegisterSickNoteUsecaseImpl extends RegisterSickNoteUsecase {
  final SickNoteRepository repository;
  final AwsUploadFileUsecase awsUploadFileUsecase;

  RegisterSickNoteUsecaseImpl({
    required this.repository,
    required this.awsUploadFileUsecase,
  });

  @override
  Future<Try<SickNoteEntity>> call(RegisterSickNoteParam params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    Try<UrlUploadS3> uploadResponse = await awsUploadFileUsecase.call(
      AwsUploadFileParam(
        getUrlUploadS3: () async {
          return getUrlUploadS3(params.condoId);
        },
        uploadFileToS3: repository.uploadImageToAws,
        file: params.sickNoteEntity.file!,
      ),
    );

    UrlUploadS3? urlUploadS3 =
        uploadResponse.fold((error) => null, (res) => res);

    if (urlUploadS3 == null) {
      return Rejection<SickNoteEntity>(
        KnownFailure("500", "upload_file_error"),
      );
    }
    params.sickNoteEntity.fileTempHash = urlUploadS3.fileName;
    return await registerSickNote(params);
  }

  Failure? validate(RegisterSickNoteParam? params) {
    if (params == null) return InvalidParamFailure();
    if (params.sickNoteEntity.file == null) return InvalidParamFailure();
    if (params.sickNoteEntity.date == null) return InvalidParamFailure();

    return null;
  }

  Future<Try<SickNoteEntity>> registerSickNote(
      RegisterSickNoteParam params) async {
    return await repository.registerSickNote(
        params.sickNoteEntity, params.condoId, params.meId);
  }

  Future<Try<UrlUploadS3>> getUrlUploadS3(String condoId) async {
    return await repository.getUrlAws(condoId);
  }
}
