import 'package:essentials/essentials.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:morar/feature/digital_meeting/data/data_source/digital_meeting_remote_data_source.dart';
import 'package:morar/feature/digital_meeting/domain/entity/digital_meeting.dart';
import 'package:morar/feature/digital_meeting/domain/repository/digital_meeting_repository.dart';

class DigitalMeetingRepositoryImpl extends DigitalMeetingRepository {
  final DigitalMeetingRemoteDataSource dataSource;

  DigitalMeetingRepositoryImpl({required this.dataSource});

  @override
  Future<Try<List<DigitalMeeting>>> getMeelings(
      {bool showAll = false, required String unitId}) async {
    try {
      final data =
          await dataSource.getMeetings(showAll: showAll, unitId: unitId);
      return Success(data.map((e) => e.toEntity()).toList());
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'showAll: $showAll - unitId: $unitId',
      );
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<DigitalMeeting>> getMeetingData(String tokenHash) async {
    try {
      final data = await dataSource.getMeetingData(tokenHash);
      return Success(data.toEntity());
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'tokenHash: $tokenHash',
      );
      return Rejection(UnknownFailure(e));
    }
  }
}
