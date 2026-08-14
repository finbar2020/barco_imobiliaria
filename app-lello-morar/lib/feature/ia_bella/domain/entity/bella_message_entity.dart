import 'package:morar/feature/ia_bella/domain/entity/ia_bella_documents_entity.dart';

class BellaMessageEntity {
  String? responseId;
  String text;
  String? displayText;
  bool? isUser;
  List<IaBellaDocumentsEntity?>? documents;

  BellaMessageEntity({
    this.responseId,
    this.isUser = false,
    this.documents = const [],
    this.displayText,
    required this.text,
  });
}
