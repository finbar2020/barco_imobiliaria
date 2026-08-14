part of shared_features;

class AwsUploadFileUsecaseImpl extends AwsUploadFileUsecase {
  AwsUploadFileUsecaseImpl();

  @override
  Future<Try<UrlUploadS3>> call(AwsUploadFileParam params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    UrlUploadS3? s3;

    Try<UrlUploadS3> getUrl = await params.getUrlUploadS3();

    Try<UrlUploadS3> resultUrl = getUrl.fold(
      (error) => Rejection(error),
      (success) {
        s3 = success;
        return Success(success);
      },
    );

    if (s3 == null) {
      return resultUrl;
    }

    Try<String> uploadImage = await uploadImageToAws(params, s3!);

    return uploadImage.fold(
      (err) => Rejection<UrlUploadS3>(KnownFailure("500", "upload_error")),
      (res) => Success<UrlUploadS3>(s3!),
    );
  }

  Failure? validate(AwsUploadFileParam? params) {
    if (params == null) return InvalidParamFailure();

    return null;
  }

  Future<Try<String>> uploadImageToAws(
      AwsUploadFileParam params, UrlUploadS3 s3) async {
    return await params.uploadFileToS3(params.file, s3.url);
  }
}
