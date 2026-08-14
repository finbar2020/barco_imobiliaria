import 'package:lello/feature/vox/data/model/announcement_create_model.dart';
import 'package:lello/feature/vox/data/model/announcement_detail_model.dart';
import 'package:lello/feature/vox/data/model/announcement_model.dart';
import 'package:lello/feature/vox/data/model/announcement_request_model.dart';
import 'package:lello/feature/vox/data/model/document_reason_model.dart';
import 'package:lello/feature/vox/data/model/document_template_model.dart';
import 'package:lello/feature/vox/data/model/fine_model.dart';
import 'package:lello/feature/vox/data/model/fine_request_model.dart';
import 'package:lello/feature/vox/data/model/warning_create_model.dart';
import 'package:lello/feature/vox/data/model/warning_model.dart';
import 'package:lello/feature/vox/data/model/warning_request_model.dart';

/// Fonte de dados remota unificada (envolve [VoxApi]).
abstract class VoxRemoteDataSource {
  Future<String> requestWarning(WarningRequestModel model);
  Future<String> requestFine(FineRequestModel model);
  Future<String> requestAnnouncement(AnnouncementRequestModel model);

  // Criação direta (CREATE)
  Future<String> createWarning(String condominiumId, WarningCreateModel model);
  Future<String> createAnnouncement(
      String condominiumId, AnnouncementCreateModel model);

  Future<List<DocumentReasonModel>> getWarningReasons(String condominiumId);
  Future<List<DocumentReasonModel>> getFineReasons(String condominiumId);

  Future<List<DocumentTemplateModel>> getWarningTemplates(String condominiumId);
  Future<List<DocumentTemplateModel>> getFineTemplates(String condominiumId);
  Future<List<DocumentTemplateModel>> getAnnouncementModels(
      String condominiumId);

  // Listagem (histórico)
  Future<List<WarningModel>> listWarnings(String condominiumId);
  Future<List<FineModel>> listFines(String condominiumId);
  Future<List<AnnouncementModel>> listAnnouncements(String condominiumId);

  // Detalhe por id (Q7: o detalhe sempre re-busca)
  Future<WarningModel> getWarningById(String id);
  Future<FineModel> getFineById(String id);
  Future<AnnouncementDetailModel> getAnnouncementById(String id);

  /// Sobe uma imagem (multipart, com filename e content-type) e retorna a URL.
  Future<String> uploadImage(List<int> bytes, String fileName);
}
