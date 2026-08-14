import 'package:morar/feature/documents/data/model/document_file_response_model.dart';
import 'package:morar/feature/easy_fix/cnd/data/model/unit_profile_model.dart';

abstract class CndRemoteDataSource {
  Future<DocumentFileResponseModel> generateCertificateNoOutstandingDebt(
      {required String condominiumId, required UnitProfileModel model});
}
