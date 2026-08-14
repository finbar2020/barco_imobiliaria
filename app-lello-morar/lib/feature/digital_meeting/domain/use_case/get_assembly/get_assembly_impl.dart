import 'package:essentials/essentials.dart';
import 'package:morar/feature/digital_meeting/domain/entity/digital_meeting.dart';
import 'package:morar/feature/digital_meeting/domain/repository/digital_meeting_repository.dart';
import 'package:morar/feature/digital_meeting/domain/use_case/get_assembly/get_assembly.dart';

class GetMeetingDataImpl extends GetMeetingDataUseCase {
  final DigitalMeetingRepository repository;

  GetMeetingDataImpl({required this.repository});

  @override
  Future<Try<DigitalMeeting>> call(GetMeetingDataParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return repository.getMeetingData(params.tokenHash);
  }

  Failure? _validate(GetMeetingDataParams params) {
    if (params.tokenHash.isEmpty) return InvalidParamFailure();

    return null;
  }
}
