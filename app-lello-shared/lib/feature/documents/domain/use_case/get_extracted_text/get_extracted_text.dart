import 'package:essentials/essentials.dart';

abstract class GetExtractedText
    extends UseCase<String, GetExtractedTextParam> {}

class GetExtractedTextParam {
  final String documentId;
  final String documentType;

  GetExtractedTextParam({
    required this.documentId,
    required this.documentType,
  });
}
