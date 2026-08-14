import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:lello/feature/vox/data/data_source/remote/vox_remote_data_source.dart';
import 'package:lello/feature/vox/data/model/announcement_create_model.dart';
import 'package:lello/feature/vox/data/model/announcement_request_model.dart';
import 'package:lello/feature/vox/data/model/fine_request_model.dart';
import 'package:lello/feature/vox/data/model/warning_create_model.dart';
import 'package:lello/feature/vox/data/model/warning_request_model.dart';
import 'package:lello/feature/vox/domain/entity/document.dart';
import 'package:lello/feature/vox/domain/entity/document_detail.dart';
import 'package:lello/feature/vox/domain/entity/document_reason.dart';
import 'package:lello/feature/vox/domain/entity/document_request.dart';
import 'package:lello/feature/vox/domain/entity/document_template.dart';
import 'package:lello/feature/vox/domain/entity/document_type.dart';
import 'package:lello/feature/vox/domain/repository/vox_repository.dart';

class VoxRepositoryImpl extends VoxRepository {
  final VoxRemoteDataSource remoteDataSource;

  VoxRepositoryImpl({required this.remoteDataSource});

  /// Estratégia de submit do eixo REQUEST: cada tipo monta seu model e bate em
  /// POST /requests/service. A serialização preserva o fio antigo (ver golden).
  @override
  Future<Try<String>> requestDocument(
      DocumentType type, DocumentRequest request) async {
    try {
      final String result;
      switch (type) {
        case DocumentType.warning:
          result = await remoteDataSource
              .requestWarning(WarningRequestModel.fromEntity(request));
          break;
        case DocumentType.fine:
          result = await remoteDataSource
              .requestFine(FineRequestModel.fromEntity(request));
          break;
        case DocumentType.announcement:
          result = await remoteDataSource.requestAnnouncement(
              AnnouncementRequestModel.fromEntity(request));
          break;
      }
      return Success(result);
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  /// Estratégia de submit do eixo CREATE (Q3): dispatch por tipo para o endpoint
  /// próprio de criação. Multa não suporta criação direta.
  @override
  Future<Try<String>> createDocument(
      DocumentType type, DocumentRequest request) async {
    try {
      final condominiumId = request.condominiumId ?? "";
      switch (type) {
        case DocumentType.warning:
          final result = await remoteDataSource.createWarning(
              condominiumId, WarningCreateModel.fromEntity(request));
          return Success(result);
        case DocumentType.fine:
          return Rejection(InvalidParamFailure());
        case DocumentType.announcement:
          final result = await remoteDataSource.createAnnouncement(
              condominiumId, AnnouncementCreateModel.fromEntity(request));
          return Success(result);
      }
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<List<DocumentReason>>> listReasons(
      DocumentType type, String condominiumId) async {
    try {
      switch (type) {
        case DocumentType.warning:
          final result =
              await remoteDataSource.getWarningReasons(condominiumId);
          return Success(result.map((m) => m.toEntity()).toList());
        case DocumentType.fine:
          final result = await remoteDataSource.getFineReasons(condominiumId);
          return Success(result.map((m) => m.toEntity()).toList());
        case DocumentType.announcement:
          // Comunicado não tem motivos.
          return Success(const <DocumentReason>[]);
      }
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<List<DocumentTemplate>>> listTemplates(
      DocumentType type, String condominiumId) async {
    try {
      switch (type) {
        case DocumentType.warning:
          final result =
              await remoteDataSource.getWarningTemplates(condominiumId);
          return Success(result.map((m) => m.toEntity()).toList());
        case DocumentType.fine:
          final result = await remoteDataSource.getFineTemplates(condominiumId);
          return Success(result.map((m) => m.toEntity()).toList());
        case DocumentType.announcement:
          final result =
              await remoteDataSource.getAnnouncementModels(condominiumId);
          return Success(result.map((m) => m.toEntity()).toList());
      }
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<List<Document>>> listDocuments(
      DocumentType type, String condominiumId) async {
    try {
      switch (type) {
        case DocumentType.warning:
          final result = await remoteDataSource.listWarnings(condominiumId);
          return Success(result.map((m) => m.toDocument()).toList());
        case DocumentType.fine:
          final result = await remoteDataSource.listFines(condominiumId);
          return Success(result.map((m) => m.toDocument()).toList());
        case DocumentType.announcement:
          final result =
              await remoteDataSource.listAnnouncements(condominiumId);
          return Success(result.map((m) => m.toDocument()).toList());
      }
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<DocumentDetail>> getDocument(DocumentType type, String id) async {
    try {
      switch (type) {
        case DocumentType.warning:
          final result = await remoteDataSource.getWarningById(id);
          return Success(result.toDetail());
        case DocumentType.fine:
          final result = await remoteDataSource.getFineById(id);
          return Success(result.toDetail());
        case DocumentType.announcement:
          final result = await remoteDataSource.getAnnouncementById(id);
          return Success(result.toDetail());
      }
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<String>> uploadImage(Uint8List bytes, String fileName) async {
    try {
      final compressed = await _compressImage(bytes, fileName);
      // A compressão sempre gera JPEG; o nome reflete isso (content-type).
      final url = await remoteDataSource.uploadImage(compressed, _jpgName(fileName));
      return Success(url);
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  String _jpgName(String fileName) {
    final dot = fileName.lastIndexOf('.');
    final base = dot > 0 ? fileName.substring(0, dot) : fileName;
    return '$base.jpg';
  }

  /// Comprime para no máximo 1920px (JPEG q85) antes do upload; em caso de erro,
  /// usa os bytes originais.
  Future<List<int>> _compressImage(Uint8List bytes, String fileName) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/$fileName');
      await tempFile.writeAsBytes(bytes);

      final compressed = await FlutterImageCompress.compressWithFile(
        tempFile.path,
        minWidth: 1920,
        minHeight: 1920,
        quality: 85,
        format: CompressFormat.jpeg,
      );

      await tempFile.delete();
      return compressed ?? bytes;
    } catch (_) {
      return bytes;
    }
  }
}
