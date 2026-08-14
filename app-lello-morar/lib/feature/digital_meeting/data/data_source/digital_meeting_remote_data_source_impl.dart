import 'package:essentials/essentials.dart';
import 'package:morar/feature/digital_meeting/data/data_source/digital_meeting_api.dart';
import 'package:morar/feature/digital_meeting/data/data_source/digital_meeting_remote_data_source.dart';
import 'package:morar/feature/digital_meeting/data/model/digital_meeting_model.dart';

class DigitalMeetingRemoteDataSourceImpl
    extends DigitalMeetingRemoteDataSource {
  final DigitalMeetingApi api;

  DigitalMeetingRemoteDataSourceImpl({required this.api});

  @override
  Future<List<DigitalMeetingModel>> getMeetings(
      {bool showAll = false, required String unitId}) async {
    final response = await api.getMeetings(showAll, unitId);
    return ApiMapper.mapList(
        response, (json) => DigitalMeetingModel.fromJson(json));
  }

  @override
  Future<DigitalMeetingModel> getMeetingData(String tokenHash) async {
    final response = await api.getMeetingData(tokenHash);
    return ApiMapper.map(
        response, (json) => DigitalMeetingModel.fromJson(json));
  }
}
