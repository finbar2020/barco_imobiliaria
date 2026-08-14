import 'package:essentials/essentials.dart';
import 'package:lello/feature/access_management/data/model/url_upload_s3_model.dart';

abstract class AwsGetUrl extends UseCase<UrlUploadS3Model, AwsGetUrlParams> {}

class AwsGetUrlParams {
  final String condoId;

  AwsGetUrlParams({required this.condoId});
}
