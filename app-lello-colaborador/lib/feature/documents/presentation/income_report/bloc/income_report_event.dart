import 'package:colaborador/feature/documents/domain/entity/document_type_enum.dart';
import 'package:essentials/essentials.dart';

abstract class IncomeReportEvent extends Equatable {
  const IncomeReportEvent();

  @override
  List<Object?> get props => [];
}

class GetDocumentsInfoListEvent extends IncomeReportEvent {
  final DocumentTypeEnum documentType;
  final DateTime? dateFrom;
  final DateTime? dateTo;

  const GetDocumentsInfoListEvent({
    required this.documentType,
    this.dateFrom,
    this.dateTo,
  });

  @override
  List<Object?> get props => [documentType, dateFrom, dateTo];
}
