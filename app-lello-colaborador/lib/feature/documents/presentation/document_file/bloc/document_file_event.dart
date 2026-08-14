import 'package:essentials/essentials.dart';

abstract class DocumentFileEvent extends Equatable {
  const DocumentFileEvent();

  @override
  List<Object?> get props => [];
}

class GetDocumentFileEvent extends DocumentFileEvent {
  final String documentName;

  const GetDocumentFileEvent({
    required this.documentName,
  });

  @override
  List<Object?> get props => [documentName];
}
