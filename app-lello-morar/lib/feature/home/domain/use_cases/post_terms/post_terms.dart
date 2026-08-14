import 'package:essentials/essentials.dart';

abstract class PostTerms extends UseCase<String, PostTermsParams> {}

class PostTermsParams {
  final String unitId;

  PostTermsParams({required this.unitId});
}
