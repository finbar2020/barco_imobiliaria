import 'package:chopper/chopper.dart';
import 'package:http/http.dart' show MultipartFile;
import 'package:lello/feature/vox/data/model/announcement_create_model.dart';
import 'package:lello/feature/vox/data/model/announcement_request_model.dart';
import 'package:lello/feature/vox/data/model/fine_request_model.dart';
import 'package:lello/feature/vox/data/model/warning_create_model.dart';
import 'package:lello/feature/vox/data/model/warning_request_model.dart';

part 'vox_api.chopper.dart';

/// API Chopper unificada dos documentos do síndico (advertência, multa,
/// comunicado). Substitui `WarningFinesApi` + `AnnouncementApi` (item B / Q8a).
///
/// Os três `postXRequest` batem em POST /requests/service com models distintos
/// que carregam o `serviceId` correto — a serialização preserva o fio antigo
/// byte-a-byte (ver golden em test/feature/vox/data/model).
///
/// CREATE (POST direto): advertência em /warnings/condominium/{id}/models e
/// comunicado em /announcements/{id}/templates (multa não tem create).
@ChopperApi()
abstract class VoxApi extends ChopperService {
  // ----- Advertências -----
  @GET(path: "/warnings/condominium/{id}")
  Future<Response> getWarnings(@Path() String id);

  @GET(path: "/warnings/{id}")
  Future<Response> getWarningById(@Path() String id);

  @POST(path: "/requests/service")
  Future<Response> postWarningRequest(@Body() WarningRequestModel body);

  @POST(path: "/warnings/condominium/{id}/models")
  Future<Response> postWarning(
      @Path() String id, @Body() WarningCreateModel body);

  @GET(path: "/warnings/{id}/models")
  Future<Response> getWarningTemplates(@Path() String id);

  @GET(path: "/warnings/{id}/reasons")
  Future<Response> getWarningReasons(@Path() String id);

  // ----- Multas -----
  @GET(path: "/fines/condominium/{id}")
  Future<Response> getFines(@Path() String id);

  @GET(path: "/fines/{id}")
  Future<Response> getFineById(@Path() String id);

  @POST(path: "/requests/service")
  Future<Response> postFineRequest(@Body() FineRequestModel body);

  @GET(path: "/fines/{id}/models")
  Future<Response> getFineTemplates(@Path() String id);

  @GET(path: "/fines/{id}/reasons")
  Future<Response> getFineReasons(@Path() String id);

  // ----- Comunicados -----
  @GET(path: "/announcements/condominium/{id}")
  Future<Response> getAnnouncements(@Path() String id);

  @GET(path: "/announcements/{id}")
  Future<Response> getAnnouncementById(@Path() String id);

  @POST(path: "/requests/service")
  Future<Response> postAnnouncementRequest(
      @Body() AnnouncementRequestModel body);

  @POST(path: "/announcements/{id}/templates")
  Future<Response> postAnnouncement(
      @Path() String id, @Body() AnnouncementCreateModel body);

  @GET(path: "/announcements/{id}/models")
  Future<Response> getAnnouncementModels(@Path() String id);

  // ----- Compartilhado -----
  // MultipartFile (e não List<int>) para preservar filename e content-type.
  @POST(path: "/documents/image/upload")
  @Multipart()
  Future<Response> uploadImage(@PartFile() MultipartFile file);

  static VoxApi create(ChopperClient client) => _$VoxApi(client);
}
