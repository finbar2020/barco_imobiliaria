import 'dart:convert';
import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:shared_features/core/database/documents/cached_documents_store.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';
import 'package:shared_features/feature/documents/data/data_source/documents_api.dart';
import 'package:shared_features/feature/documents/data/data_source/documents_cache_manager.dart';
import 'package:shared_features/feature/documents/data/data_source/documents_remote_data_source.dart';
import 'package:shared_features/feature/documents/data/model/documents_response_model.dart';
import 'package:shared_features/feature/documents/domain/entity/documents.dart';
import 'package:shared_features/feature/documents/domain/entity/documents_list_result.dart';
import 'package:shared_features/feature/documents/domain/repository/documents_repository.dart';

class DocumentsRepositoryImpl extends DocumentsRepository {
  final DocumentsRemoteDataSource remoteDataSource;
  final CachedDocumentsStore cacheStore;
  final Environment environment;
  final AuthenticationStore authenticationStore;

  DocumentsRepositoryImpl({
    required this.remoteDataSource,
    required this.cacheStore,
    required this.environment,
    required this.authenticationStore,
  });

  @override
  Stream<DocsListResult> watch(
    String condominiumId,
    String documentType,
    String unitId, {
    bool forceRefresh = false,
  }) async* {
    final cached = await cacheStore.read(condominiumId, unitId, documentType);
    final now = DateTime.now();

    List<Documents>? cachedDocs;
    DateTime? cachedAt;
    var isFresh = false;

    if (cached != null) {
      cachedDocs = _deserialize(cached.documentsJson);
      cachedAt = DateTime.fromMillisecondsSinceEpoch(cached.lastFetchedAt);
      isFresh =
          !forceRefresh && now.difference(cachedAt) < CachedDocumentsStore.ttl;
    }

    if (isFresh && cachedDocs != null && cachedAt != null) {
      yield DocsListResult.fresh(docs: cachedDocs, lastFetchedAt: cachedAt);
      return;
    }

    if (cachedDocs != null && cachedAt != null) {
      yield DocsListResult.staleRevalidating(
          docs: cachedDocs, lastFetchedAt: cachedAt);
    } else {
      yield DocsListResult.coldLoading();
    }

    try {
      final response = await remoteDataSource.listDocuments(
          condominiumId, documentType, unitId);
      final docs = response.map((model) => model.toEntity()).toList();
      final json = jsonEncode(response.map((m) => m.toJson()).toList());
      await cacheStore.upsert(
          condominiumId, unitId, documentType, json, now);
      yield DocsListResult.fresh(docs: docs, lastFetchedAt: now);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'condominiumId: $condominiumId - documentType: $documentType',
      );
      if (cachedDocs != null && cachedAt != null) {
        await cacheStore.markFailed(condominiumId, unitId, documentType, now);
        yield DocsListResult.staleFailed(
            docs: cachedDocs, lastFetchedAt: cachedAt, error: e);
      } else {
        yield DocsListResult.error(e);
      }
    }
  }

  @override
  Future<Try<File>> downloadFile(
      String documentId, String documentType) async {
    try {
      final url = '${environment.apiUrl}'
          '${DocumentsBinaryPaths.download(documentType, documentId)}';
      final headers = authenticationStore.getCustomHeader();
      final file = await DocumentsCacheManager()
          .getSingleFile(url, headers: headers);
      return Success(file);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'documentId: $documentId - documentType: $documentType',
      );
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<String>> getExtractedText(
      String documentId, String documentType) async {
    try {
      final url = '${environment.apiUrl}'
          '${DocumentsBinaryPaths.text(documentType, documentId)}';
      final headers = authenticationStore.getCustomHeader();
      final file = await DocumentsCacheManager()
          .getSingleFile(url, headers: headers);
      final text = await file.readAsString();
      return Success(text);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'documentId: $documentId - documentType: $documentType',
      );
      return Rejection(UnknownFailure(e));
    }
  }

  List<Documents> _deserialize(String json) {
    final decoded = jsonDecode(json) as List<dynamic>;
    return decoded
        .map((e) => DocumentsResponseModel.fromJson(e as Map<String, dynamic>)
            .toEntity())
        .toList();
  }
}
