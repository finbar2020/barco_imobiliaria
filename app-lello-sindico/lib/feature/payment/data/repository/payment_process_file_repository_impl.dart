import 'dart:async';
import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:lello/core/aws_uploader/aws_uploader.dart';
import 'package:lello/feature/access_management/data/model/url_upload_s3_model.dart';
import 'package:lello/feature/payment/data/data_source/payment/payment_process_file_remote_data_source.dart';
import 'package:lello/feature/payment/domain/entity/process_files_response.dart';
import 'package:lello/feature/payment/domain/repository/payment_process_file_repository.dart';

class PaymentProcessFileRepositoryImpl extends PaymentProcessFileRepository {
  final PaymentProcessFileRemoteDataSource dataSource;
  final AwsUploader awsUploader;

  PaymentProcessFileRepositoryImpl(
      {required this.dataSource, required this.awsUploader});

  @override
  Future<Try<UrlUploadS3Model>> getAwsUploadUrl(String condoId) async {
    try {
      final data = await dataSource.getAwsPayload(condoId);
      return Success(data);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance
          .recordError(e, stacktrace, reason: 'condoId: $condoId');
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<String>> uploadFileToAws(File file, String url) async {
    try {
      final completer = Completer<Try<String>>();
      await awsUploader.uploadS3(
        url,
        file,
        onComplete: (url) {
          completer.complete(Success(url));
        },
        onError: (error) {
          completer.complete(Rejection(UnknownFailure(error)));
        },
      );
      return completer.future;
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(e, stacktrace);
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<ProcessFilesResponseEntity>> processFiles(
      String condoId, List<String> fileUrls) async {
    try {
      final data = await dataSource.processFiles(condoId, fileUrls);
      return Success(data.toEntity());
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance
          .recordError(e, stacktrace, reason: 'condoId: $condoId');
      return Rejection(UnknownFailure(e));
    }
  }
}
