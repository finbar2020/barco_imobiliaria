import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/documents/domain/entity/documents_list_result.dart';

abstract class DocumentsRepository {
  /// Stream stale-while-revalidate. Emite cache imediato se houver e dispara
  /// revalidação em background quando o TTL estourou. `forceRefresh` ignora o
  /// TTL (pull-to-refresh). `unitId` vazio lista os documentos do condomínio
  /// (síndico); preenchido lista os da unidade (morador).
  Stream<DocsListResult> watch(
    String condominiumId,
    String documentType,
    String unitId, {
    bool forceRefresh = false,
  });

  /// Baixa o PDF binário do documento e devolve o arquivo já gravado em disco
  /// (cache LRU em `DocumentsCacheManager`).
  Future<Try<File>> downloadFile(String documentId, String documentType);

  /// Texto extraído do documento (acessibilidade). Lazy, cacheado em disco
  /// junto ao binário.
  Future<Try<String>> getExtractedText(
      String documentId, String documentType);
}
