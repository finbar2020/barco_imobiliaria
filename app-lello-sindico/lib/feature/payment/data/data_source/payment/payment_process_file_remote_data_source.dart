import 'package:lello/feature/access_management/data/model/url_upload_s3_model.dart';
import 'package:lello/feature/payment/data/model/process_files_response_model.dart';

abstract class PaymentProcessFileRemoteDataSource {
  Future<UrlUploadS3Model> getAwsPayload(String condoId);
  Future<ProcessFilesResponseModel> processFiles(
      String condoId, List<String> fileUrls);
}
