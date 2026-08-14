import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/documents/domain/entity/documents_type.dart';
import 'package:shared_features/feature/documents/domain/repository/documents_repository.dart';
import 'package:shared_features/feature/documents/domain/use_case/download_document/download_document.dart';

class DownloadDocumentImpl extends DownloadDocument {
  final DocumentsRepository repository;

  DownloadDocumentImpl({required this.repository});

  @override
  Future<Try<File>> call(DownloadDocumentParam params) async {
    if (params.documentId.isEmpty || params.documentType.isEmpty) {
      return Rejection(InvalidParamFailure());
    }

    return await repository.downloadFile(
      params.documentId,
      documentTypeToApiNumber(params.documentType),
    );
  }
}
