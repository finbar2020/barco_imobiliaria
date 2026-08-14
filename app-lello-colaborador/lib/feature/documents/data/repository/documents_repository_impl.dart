import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:colaborador/feature/documents/data/data_source/documents_remote_data_source.dart';
import 'package:colaborador/feature/documents/domain/entity/document_file.dart';
import 'package:colaborador/feature/documents/domain/entity/document_info.dart';
import 'package:colaborador/feature/documents/domain/entity/document_type_enum.dart';
import 'package:colaborador/feature/documents/domain/repository/documents_repository.dart';
import 'package:essentials/essentials.dart';

class DocumentsRepositoryImpl extends DocumentsRepository {
  final DocumentsRemoteDataSource remoteDataSource;

  DocumentsRepositoryImpl({
    required this.remoteDataSource,
  });
  @override
  Future<Try<List<DocumentInfo>>> getDocumentsInfoList(
      String condoId,
      DocumentTypeEnum documentType,
      DateTime? dateFrom,
      DateTime? dateTo) async {
    try {
      String type = enumToString(documentType) ?? "";
      final data = await remoteDataSource.getDocumentsInfoList(
          condoId, type, dateFrom, dateTo);
      List<DocumentInfo> response =
          data.map((e) => e.toEntity()).cast<DocumentInfo>().toList();
      response.sort(((a, b) =>
          b.documentProcessingDate.compareTo(a.documentProcessingDate)));
      return Success(response);
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<DocumentFile>> getDocumentFile(String documentName) async {
    try {
      final data = await remoteDataSource.getDocumentFile(documentName);
      DocumentFile documentFile = data.toEntity();
      if (documentFile.data.isNotEmpty) {
        File file = await _getFile(documentFile);
        documentFile.file = file;
      }
      return Success(documentFile);
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }

  Future<File> _getFile(DocumentFile documentFile) async {
    Uint8List bytes = base64.decode(documentFile.data);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File("$dir/${documentFile.name}");
    await file.writeAsBytes(bytes);
    return file;
  }
}
