import 'package:chopper/chopper.dart';
import 'package:colaborador/feature/sick_note/data/model/sick_note_model.dart';

part 'sick_note_api.chopper.dart';

@ChopperApi()
abstract class SickNoteApi extends ChopperService {
  @Post(path: "digitalRepository/sick_note/register")
  Future<Response> registerSickNote(
    @Body() SickNoteModel model,
    @Path("id") String id,
  );

  @Get(path: "digitalRepository/urlUploadImage")
  Future<Response> getAwsUrl(
    @Path("id") String id,
  );

  static SickNoteApi create(ChopperClient client) {
    return _$SickNoteApi(client);
  }
}
