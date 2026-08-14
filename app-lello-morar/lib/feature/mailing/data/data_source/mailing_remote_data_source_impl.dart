import 'package:essentials/essentials.dart';
import 'package:essentials/paginator/paginator_model.dart';
import 'package:morar/feature/mailing/data/data_source/mailing_api.dart';
import 'package:morar/feature/mailing/data/data_source/mailing_remote_data_source.dart';

class MailingRemoteDataSourceImpl implements MailingRemoteDataSource {
  final MailingApi api;

  MailingRemoteDataSourceImpl({required this.api});
  @override
  Future<PaginatorModel> getMailings(String unitId,
      {bool showAll = false}) async {
    final response = await api.fetchMailings(unitId, showAll);
    return ApiMapper.map(response, (json) => PaginatorModel.fromJson(json));
  }

  @override
  Future<Uint8List?> getPicture(String hash) async {
    final response = await api.getPicture(hash);
    return response.bodyBytes;
  }
}
