import 'package:essentials/essentials.dart';
import 'package:morar/feature/digital_meeting/domain/entity/digital_meeting.dart';

abstract class DigitalMeetingRepository {
  Future<Try<List<DigitalMeeting>>> getMeelings(
      {bool showAll = false, required String unitId});
  Future<Try<DigitalMeeting>> getMeetingData(String tokenHash);
}
