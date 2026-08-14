import 'dart:convert';

import 'package:essentials/network/api_failure.dart';
import 'package:morar/feature/documents/data/model/document_file_response_model.dart';
import 'package:morar/feature/easy_fix/cnd/data/data_source/cnd_api.dart';
import 'package:morar/feature/easy_fix/cnd/data/data_source/cnd_remote_data_source.dart';
import 'package:morar/feature/easy_fix/cnd/data/model/unit_profile_model.dart';

class CndRemoteDataSourceImpl implements CndRemoteDataSource {
  final CndApi api;

  CndRemoteDataSourceImpl({required this.api});

  @override
  Future<DocumentFileResponseModel> generateCertificateNoOutstandingDebt(
      {required String condominiumId, required UnitProfileModel model}) async {
    final response =
        await api.generateCertificateNoOutstandingDebt(condominiumId, model);

    if (response.isSuccessful) {
      final pdfBytes = response.bodyBytes;
      final base64EncodedPdf = base64Encode(pdfBytes);
      return DocumentFileResponseModel()..data = base64EncodedPdf;
    } else {
      var errorResponse = jsonDecode(response.bodyString);
      print(errorResponse);
      if (errorResponse['status'] == 409) {
        return throw ApiFailure.fromJson(errorResponse);
      } else {
        return throw Exception('Error different from 409 encountered.');
      }
    }
  }
}
