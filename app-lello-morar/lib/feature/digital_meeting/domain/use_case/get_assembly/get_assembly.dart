import 'package:morar/feature/digital_meeting/domain/entity/digital_meeting.dart';
import 'package:essentials/essentials.dart';

abstract class GetMeetingDataUseCase
    extends UseCase<DigitalMeeting, GetMeetingDataParams> {}

class GetMeetingDataParams {
  final String tokenHash;

  GetMeetingDataParams(this.tokenHash);
}
