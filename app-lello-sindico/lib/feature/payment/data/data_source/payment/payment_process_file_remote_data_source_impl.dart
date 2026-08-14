import 'package:essentials/essentials.dart';
import 'package:lello/feature/access_management/data/model/url_upload_s3_model.dart';
import 'package:lello/feature/payment/data/data_source/payment/payment_api.dart';
import 'package:lello/feature/payment/data/data_source/payment/payment_process_file_remote_data_source.dart';
import 'package:lello/feature/payment/data/model/process_files_response_model.dart';

class PaymentProcessFileRemoteDataSourceImpl
    implements PaymentProcessFileRemoteDataSource {
  final PaymentApi api;

  PaymentProcessFileRemoteDataSourceImpl({required this.api});

  @override
  Future<UrlUploadS3Model> getAwsPayload(String condoId) async {
    final response = await api.getAwsPayload(condoId);
    return ApiMapper.map(
      response,
      (json) => UrlUploadS3Model.fromJson(json),
    );
  }

  @override
  Future<ProcessFilesResponseModel> processFiles(
      String condoId, List<String> fileUrls) async {
    final response = await api.processFiles(
      condoId,
      fileUrls,
    );
    final data = ApiMapper.map(
      response,
      (json) => ProcessFilesResponseModel.fromJson(json),
    );
    return data;
  }
}
