import 'package:colaborador/feature/digital_point/data/model/url_upload_s3_model.dart';
import 'package:colaborador/feature/sick_note/data/data_source/remote/sick_note_api.dart';
import 'package:colaborador/feature/sick_note/data/data_source/remote/sick_note_remote_data_source.dart';
import 'package:colaborador/feature/sick_note/data/model/sick_note_model.dart';
import 'package:essentials/essentials.dart';

class SickNoteRemoteDataSourceImpl extends SickNoteRemoteDataSource {
  final SickNoteApi api;

  SickNoteRemoteDataSourceImpl({required this.api});

  @override
  Future<UrlUploadS3Model> getUrlAws(String condoId) async {
    final response = await api.getAwsUrl(condoId);
    final aws =
        ApiMapper.map(response, (json) => UrlUploadS3Model.fromJson(json));
    return aws;
  }

  @override
  Future<SickNoteModel> registerSickNote(
      SickNoteModel model, String condoId) async {
    final response = await api.registerSickNote(model, condoId);
    if (response.isSuccessful == false) {
      throw response.error!;
    } else {
      return model;
    }
  }
}
