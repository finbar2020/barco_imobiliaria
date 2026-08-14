import 'package:essentials/essentials.dart';
import 'package:essentials/paginator/paginator_model.dart';
import 'package:morar/feature/billets/data/data_source/billets_api.dart';
import 'package:morar/feature/billets/data/data_source/billets_remote_data_source.dart';
import 'package:morar/feature/documents/data/model/document_file_response_model.dart';

class BilletsRemoteDataSourceImpl implements BilletsRemoteDataSource {
  final BilletsApi api;

  BilletsRemoteDataSourceImpl({required this.api});
  @override
  Future<PaginatorModel> getBillets(String reference, String unitId,
      {bool showAll = false}) async {
    final response = await api.fetchBillets(reference, unitId, showAll);
    return ApiMapper.map(response, (json) => PaginatorModel.fromJson(json));
  }

  @override
  Future<DocumentFileResponseModel> getBilletPdf(String nrBillet) async {
    final response = await api.getBilletPdf(nrBillet);
    return ApiMapper.map(
        response, (json) => DocumentFileResponseModel.fromJson(json));
  }
}
