import 'dart:io';

import 'package:colaborador/feature/sick_note/domain/entity/sick_note.dart';
import 'package:essentials/essentials.dart';
import 'package:shared_features/shared_features.dart';

abstract class UploadSickNoteToAwsUsecase
    extends UseCase<SickNoteEntity, UploadSickNoteToAwsParam> {}

class UploadSickNoteToAwsParam {
  final Future<Try<UrlUploadS3>> Function(String condoId) getUrlUploadS3;
  final Future<Try<String>> Function(File file, String url) uploadFileToS3;
  final SickNoteEntity sickNoteEntity;
  final String condoId;

  UploadSickNoteToAwsParam({
    required this.getUrlUploadS3,
    required this.uploadFileToS3,
    required this.sickNoteEntity,
    required this.condoId,
  });
}
