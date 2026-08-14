part of shared_features;

abstract class AwsUploadFileUsecase
    extends UseCase<UrlUploadS3, AwsUploadFileParam> {}

class AwsUploadFileParam {
  final Future<Try<UrlUploadS3>> Function() getUrlUploadS3;
  final Future<Try<String>> Function(File file, String url) uploadFileToS3;
  final File file;

  AwsUploadFileParam({
    required this.getUrlUploadS3,
    required this.uploadFileToS3,
    required this.file,
  });
}
