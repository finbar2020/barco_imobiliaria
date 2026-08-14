import 'package:chopper/chopper.dart';
part 'digital_meeting_api.chopper.dart';

@ChopperApi()
abstract class DigitalMeetingApi extends ChopperService {
  @Get(path: "/meeting/unit/{unitId}")
  Future<Response> getMeetings(
    @Query("showAll") bool showAll,
    @Path("unitId") String unitId,
  );

  @Get(path: "/meeting/hash/{tokenHash}")
  Future<Response> getMeetingData(
    @Path("tokenHash") String tokenHash,
  );

  static DigitalMeetingApi create(ChopperClient client) {
    return _$DigitalMeetingApi(client);
  }
}
