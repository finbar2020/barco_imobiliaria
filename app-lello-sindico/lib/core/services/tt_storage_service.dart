import 'dart:io';
import 'package:essentials/essentials.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'tt_firebase_app.dart';

/// Serviço para upload de arquivos no Firebase Storage
class TTStorageService {
  /// Usa Firebase secundário se disponível, senão usa o padrão
  static FirebaseStorage _getStorageInstance({
    String bucket = 'gs://lello-98641.appspot.com',
    String? appName,
  }) {
    try {
      // Se especificou um app secundário, tenta usar
      if (appName != null && TTFirebaseApp.isAppInitialized(appName)) {
        return FirebaseStorage.instanceFor(
          app: TTFirebaseApp.getApp(appName),
          bucket: bucket,
        );
      }
    } catch (e) {
      debugPrint(
          '⚠️ [TTStorageService] App "$appName" não disponível, usando padrão');
    }

    // Fallback para instância padrão
    return FirebaseStorage.instanceFor(bucket: bucket);
  }

  final FirebaseStorage _storage;

  /// Construtor padrão
  ///
  /// [bucket] - Bucket do Firebase Storage (ex: 'gs://lello-98641.appspot.com' ou 'we-service')
  /// [appName] - Nome do Firebase App secundário (opcional)
  TTStorageService({
    String bucket = 'gs://lello-98641.appspot.com',
    String? appName,
  }) : _storage = _getStorageInstance(bucket: bucket, appName: appName);

  /// Faz upload de um arquivo para o Firebase Storage
  ///
  /// [file] - Arquivo a ser enviado
  /// [folderPath] - Caminho da pasta no Storage (ex: 'maintenance/forms')
  /// [fileName] - Nome opcional do arquivo (se null, usa o nome original)
  ///
  /// Retorna a URL de download do arquivo
  Future<String> uploadFile({
    required File file,
    required String folderPath,
    String? fileName,
  }) async {
    try {
      // Gera nome do arquivo se não fornecido
      final String fileNameToUse = fileName ??
          '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';

      // Caminho completo no Storage
      final String fullPath = '$folderPath/$fileNameToUse';
      // Referência do arquivo no Storage
      final Reference ref = _storage.ref().child(fullPath);

      // Detecta o tipo MIME do arquivo
      final String? mimeType = _getMimeType(file.path);

      // Configura metadata
      final SettableMetadata metadata = SettableMetadata(
        contentType: mimeType,
        customMetadata: {
          'uploadedAt': DateTime.now().toIso8601String(),
        },
      );

      // Faz o upload
      final UploadTask uploadTask = ref.putFile(file, metadata);

      // Aguarda conclusão
      final TaskSnapshot snapshot = await uploadTask;

      // Retorna URL de download
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e, stackTrace) {
      debugPrint('🔴 [TTStorageService] ERRO: $e');
      debugPrint('🔴 [TTStorageService] StackTrace: $stackTrace');
      throw Exception('Erro ao fazer upload do arquivo: $e');
    }
  }

  /// Faz upload de múltiplos arquivos
  ///
  /// Retorna lista de URLs de download
  Future<List<String>> uploadMultipleFiles({
    required List<File> files,
    required String folderPath,
    Function(int current, int total)? onProgress,
  }) async {
    final List<String> downloadUrls = [];

    for (int i = 0; i < files.length; i++) {
      try {
        final url = await uploadFile(
          file: files[i],
          folderPath: folderPath,
        );
        downloadUrls.add(url);

        // Notifica progresso
        if (onProgress != null) {
          onProgress(i + 1, files.length);
        }
      } catch (e) {
        // Se um arquivo falhar, continua com os próximos
        print('Erro ao fazer upload do arquivo ${files[i].path}: $e');
      }
    }

    return downloadUrls;
  }

  /// Deleta um arquivo do Firebase Storage pela URL
  Future<void> deleteFileByUrl(String downloadUrl) async {
    try {
      final Reference ref = _storage.refFromURL(downloadUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('Erro ao deletar arquivo: $e');
    }
  }

  /// Deleta um arquivo do Firebase Storage pelo caminho
  Future<void> deleteFileByPath(String fullPath) async {
    try {
      final Reference ref = _storage.ref().child(fullPath);
      await ref.delete();
    } catch (e) {
      throw Exception('Erro ao deletar arquivo: $e');
    }
  }

  /// Detecta o tipo MIME baseado na extensão do arquivo
  String? _getMimeType(String filePath) {
    final extension = path.extension(filePath).toLowerCase();

    switch (extension) {
      // Imagens
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.gif':
        return 'image/gif';
      case '.webp':
        return 'image/webp';
      case '.svg':
        return 'image/svg+xml';

      // PDFs
      case '.pdf':
        return 'application/pdf';

      // Documentos
      case '.doc':
        return 'application/msword';
      case '.docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case '.xls':
        return 'application/vnd.ms-excel';
      case '.xlsx':
        return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';

      // Vídeos
      case '.mp4':
        return 'video/mp4';
      case '.mov':
        return 'video/quicktime';
      case '.avi':
        return 'video/x-msvideo';

      default:
        return null;
    }
  }
}
