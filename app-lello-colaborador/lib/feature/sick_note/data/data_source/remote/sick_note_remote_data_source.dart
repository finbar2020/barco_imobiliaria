import 'package:colaborador/feature/digital_point/data/model/url_upload_s3_model.dart';
import 'package:colaborador/feature/sick_note/data/model/sick_note_model.dart';

abstract class SickNoteRemoteDataSource {
  Future<SickNoteModel> registerSickNote(SickNoteModel model, String condoId);
  Future<UrlUploadS3Model> getUrlAws(String condoId);
}
