import 'package:essentials/essentials.dart';
import 'package:morar/feature/digital_meeting/domain/entity/digital_meeting.dart';

abstract class GetMeetings
    extends UseCase<List<DigitalMeeting>, GetMeetingsParams> {}

class GetMeetingsParams {
  final bool showAll;
  final String unitId;

  GetMeetingsParams({this.showAll = false, required this.unitId});

  @override
  String toString() => 'GetMeetingsParams(showAll: $showAll)';
}
