import 'package:morar/feature/digital_meeting/data/model/digital_meeting_model.dart';

abstract class DigitalMeetingRemoteDataSource {
  Future<List<DigitalMeetingModel>> getMeetings(
      {bool showAll = false, required String unitId});
  Future<DigitalMeetingModel> getMeetingData(String tokenHash);
}
