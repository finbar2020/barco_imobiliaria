import 'package:shared_features/feature/documents/domain/entity/documents_type.dart';

class Documents {
  String? id;
  String? name;
  String? content;
  String? createdAt;
  bool? flagEmailDistribution;
  bool? flagPrintDistribution;
  String? status;
  String? description;
  String? occurrenceDate;
  int? pagesQuantity;
  DocumentsType? documentsType;
  String? notificationParameter;

  @override
  String toString() {
    return 'Documents(id: $id, name: $name, content: $content, createdAt: $createdAt, flagEmailDistribution: $flagEmailDistribution, flagPrintDistribution: $flagPrintDistribution, status: $status, description: $description, occurrenceDate: $occurrenceDate, pagesQuantity: $pagesQuantity)';
  }
}
