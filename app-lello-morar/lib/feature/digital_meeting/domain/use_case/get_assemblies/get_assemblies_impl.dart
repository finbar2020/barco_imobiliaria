import 'package:essentials/essentials.dart';
import 'package:morar/feature/digital_meeting/domain/entity/digital_meeting.dart';
import 'package:morar/feature/digital_meeting/domain/repository/digital_meeting_repository.dart';
import 'package:morar/feature/digital_meeting/domain/use_case/get_assemblies/get_assemblies.dart';

class GetMeetingsImpl extends GetMeetings {
  final DigitalMeetingRepository repository;

  GetMeetingsImpl({required this.repository});

  @override
  Future<Try<List<DigitalMeeting>>> call(GetMeetingsParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return repository.getMeelings(
        showAll: params.showAll, unitId: params.unitId);
  }

  Failure? _validate(GetMeetingsParams params) {
    if (params.unitId.isEmpty) return InvalidParamFailure();

    return null;
  }
}
