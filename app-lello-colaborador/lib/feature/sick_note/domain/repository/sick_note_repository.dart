import 'dart:io';

import 'package:colaborador/feature/sick_note/domain/entity/sick_note.dart';
import 'package:essentials/essentials.dart';
import 'package:shared_features/shared_features.dart';

abstract class SickNoteRepository {
  Future<Try<SickNoteEntity>> registerSickNote(
      SickNoteEntity entity, String condoId, String meId);
  
  Future<Try<UrlUploadS3>> getUrlAws(String condoId);
  Future<Try<String>> uploadImageToAws(File file, String url);
}
