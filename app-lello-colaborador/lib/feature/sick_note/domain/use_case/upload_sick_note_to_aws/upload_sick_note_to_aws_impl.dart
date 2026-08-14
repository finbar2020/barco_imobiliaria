import 'dart:io';

import 'package:colaborador/feature/sick_note/domain/entity/sick_note.dart';
import 'package:colaborador/feature/sick_note/domain/repository/sick_note_repository.dart';
import 'package:colaborador/feature/sick_note/domain/use_case/upload_sick_note_to_aws/upload_sick_note_to_aws.dart';
import 'package:essentials/essentials.dart';
import 'package:shared_features/shared_features.dart';

class UploadSickNoteToAwsUsecaseImpl extends UploadSickNoteToAwsUsecase {
  final SickNoteRepository repository;
  final AwsUploadFileUsecase awsUploadFileUsecase;

  UploadSickNoteToAwsUsecaseImpl({
    required this.repository,
    required this.awsUploadFileUsecase,
  });

  @override
  Future<Try<SickNoteEntity>> call(UploadSickNoteToAwsParam params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    Try<UrlUploadS3> uploadResponse = await awsUploadFileUsecase.call(
      AwsUploadFileParam(
        getUrlUploadS3: () async {
          return await repository.getUrlAws(params.condoId);
        },
        uploadFileToS3: repository.uploadImageToAws,
        file: File(params.sickNoteEntity.filePath!),
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
    return Success(params.sickNoteEntity);
  }

  Failure? validate(UploadSickNoteToAwsParam? params) {
    if (params == null) return InvalidParamFailure();
    return null;
  }
}
