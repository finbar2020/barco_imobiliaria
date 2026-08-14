import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Cache em disco para arquivos de documentos (PDFs binários e textos
/// extraídos). TTL longo porque documentos finalizados não mudam — o ETag
/// do servidor invalida pontualmente quando precisar. LRU built-in remove os
/// menos recentes primeiro ao bater no limite.
class DocumentsCacheManager extends CacheManager {
  static const key = 'documents_file_cache';

  static final DocumentsCacheManager _instance = DocumentsCacheManager._();
  factory DocumentsCacheManager() => _instance;

  DocumentsCacheManager._()
      : super(Config(
          key,
          stalePeriod: const Duration(days: 365 * 10),
          maxNrOfCacheObjects: 200,
        ));
}
