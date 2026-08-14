import 'package:essentials/essentials.dart';
import 'package:lello/feature/access_management/data/model/url_upload_s3_model.dart';
import 'package:lello/feature/payment/domain/repository/payment_process_file_repository.dart';
import 'package:lello/feature/payment/domain/use_case/aws_get_url/aws_get_url_impl.dart';

class AwsGetUrlImpl extends AwsGetUrl {
  final PaymentProcessFileRepository repository;

  AwsGetUrlImpl({required this.repository});

  @override
  Future<Try<UrlUploadS3Model>> call(AwsGetUrlParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.getAwsUploadUrl(params.condoId);
  }

  Failure? _validate(AwsGetUrlParams? params) {
    if (params == null) return InvalidParamFailure();
    if (params.condoId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
