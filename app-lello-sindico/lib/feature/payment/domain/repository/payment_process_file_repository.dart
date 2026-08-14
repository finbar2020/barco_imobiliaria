import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:lello/feature/access_management/data/model/url_upload_s3_model.dart';
import 'package:lello/feature/payment/domain/entity/process_files_response.dart';

abstract class PaymentProcessFileRepository {
  Future<Try<UrlUploadS3Model>> getAwsUploadUrl(String condoId);
  Future<Try<String>> uploadFileToAws(File file, String url);
  Future<Try<ProcessFilesResponseEntity>> processFiles(
      String condoId, List<String> fileUrls);
}
