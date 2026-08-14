import 'package:essentials/essentials.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' show MediaType;
import 'package:lello/feature/vox/data/data_source/remote/vox_api.dart';
import 'package:lello/feature/vox/data/data_source/remote/vox_remote_data_source.dart';
import 'package:lello/feature/vox/data/model/announcement_create_model.dart';
import 'package:lello/feature/vox/data/model/announcement_detail_model.dart';
import 'package:lello/feature/vox/data/model/announcement_model.dart';
import 'package:lello/feature/vox/data/model/announcement_request_model.dart';
import 'package:lello/feature/vox/data/model/document_reason_model.dart';
import 'package:lello/feature/vox/data/model/document_template_model.dart';
import 'package:lello/feature/vox/data/model/fine_model.dart';
import 'package:lello/feature/vox/data/model/fine_request_model.dart';
import 'package:lello/feature/vox/data/model/image_upload_response_model.dart';
import 'package:lello/feature/vox/data/model/warning_create_model.dart';
import 'package:lello/feature/vox/data/model/warning_model.dart';
import 'package:lello/feature/vox/data/model/warning_request_model.dart';

class VoxRemoteDataSourceImpl extends VoxRemoteDataSource {
  final VoxApi api;

  VoxRemoteDataSourceImpl({required this.api});

  @override
  Future<String> requestWarning(WarningRequestModel model) async {
    final response = await api.postWarningRequest(model);
    if (response.isSuccessful == false) {
      throw response.error!;
    }
    return "";
  }

  @override
  Future<String> requestFine(FineRequestModel model) async {
    final response = await api.postFineRequest(model);
    if (response.isSuccessful == false) {
      throw response.error!;
    }
    return "";
  }

  @override
  Future<String> requestAnnouncement(AnnouncementRequestModel model) async {
    final response = await api.postAnnouncementRequest(model);
    if (response.isSuccessful == false) {
      throw response.error!;
    }
    return "";
  }

  @override
  Future<String> createWarning(
      String condominiumId, WarningCreateModel model) async {
    final response = await api.postWarning(condominiumId, model);
    if (response.isSuccessful == false) {
      throw response.error!;
    }
    return "";
  }

  @override
  Future<String> createAnnouncement(
      String condominiumId, AnnouncementCreateModel model) async {
    final response = await api.postAnnouncement(condominiumId, model);
    if (response.isSuccessful == false) {
      throw response.error!;
    }
    return "";
  }

  @override
  Future<List<DocumentReasonModel>> getWarningReasons(
      String condominiumId) async {
    final response = await api.getWarningReasons(condominiumId);
    return ApiMapper.mapList(
        response, (json) => DocumentReasonModel.fromJson(json));
  }

  @override
  Future<List<DocumentReasonModel>> getFineReasons(String condominiumId) async {
    final response = await api.getFineReasons(condominiumId);
    return ApiMapper.mapList(
        response, (json) => DocumentReasonModel.fromJson(json));
  }

  @override
  Future<List<DocumentTemplateModel>> getWarningTemplates(
      String condominiumId) async {
    final response = await api.getWarningTemplates(condominiumId);
    return ApiMapper.mapList(
        response, (json) => DocumentTemplateModel.fromJson(json));
  }

  @override
  Future<List<DocumentTemplateModel>> getFineTemplates(
      String condominiumId) async {
    final response = await api.getFineTemplates(condominiumId);
    return ApiMapper.mapList(
        response, (json) => DocumentTemplateModel.fromJson(json));
  }

  @override
  Future<List<DocumentTemplateModel>> getAnnouncementModels(
      String condominiumId) async {
    final response = await api.getAnnouncementModels(condominiumId);
    return ApiMapper.mapList(
        response, (json) => DocumentTemplateModel.fromJson(json));
  }

  @override
  Future<List<WarningModel>> listWarnings(String condominiumId) async {
    final response = await api.getWarnings(condominiumId);
    return ApiMapper.mapList(response, (json) => WarningModel.fromJson(json));
  }

  @override
  Future<List<FineModel>> listFines(String condominiumId) async {
    final response = await api.getFines(condominiumId);
    return ApiMapper.mapList(response, (json) => FineModel.fromJson(json));
  }

  @override
  Future<List<AnnouncementModel>> listAnnouncements(
      String condominiumId) async {
    final response = await api.getAnnouncements(condominiumId);
    return ApiMapper.mapList(
        response, (json) => AnnouncementModel.fromJson(json));
  }

  @override
  Future<WarningModel> getWarningById(String id) async {
    final response = await api.getWarningById(id);
    return ApiMapper.map(response, (json) => WarningModel.fromJson(json));
  }

  @override
  Future<FineModel> getFineById(String id) async {
    final response = await api.getFineById(id);
    return ApiMapper.map(response, (json) => FineModel.fromJson(json));
  }

  @override
  Future<AnnouncementDetailModel> getAnnouncementById(String id) async {
    final response = await api.getAnnouncementById(id);
    return ApiMapper.map(
        response, (json) => AnnouncementDetailModel.fromJson(json));
  }

  @override
  Future<String> uploadImage(List<int> bytes, String fileName) async {
    final mime = lookupMimeType(fileName) ?? 'image/jpeg';
    final file = http.MultipartFile.fromBytes(
      'file',
      bytes,
      filename: fileName,
      contentType: MediaType.parse(mime),
    );
    final response = await api.uploadImage(file);
    return ApiMapper.map(
        response, (json) => ImageUploadResponseModel.fromJson(json)).url;
  }
}
