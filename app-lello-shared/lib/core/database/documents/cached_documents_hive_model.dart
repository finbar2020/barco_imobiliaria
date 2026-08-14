import 'package:hive/hive.dart';

part 'cached_documents_hive_model.g.dart';

/// Entrada de cache da lista de documentos. Uma linha por
/// (condomínio, unidade, tipo). `unitId` vazio = escopo condomínio (síndico).
@HiveType(typeId: 2)
class CachedDocumentsHive extends HiveObject {
  /// Chave composta `"$condominiumId|$unitId|$documentType"`.
  @HiveField(0)
  late String key;

  /// Lista de documentos serializada (JSON dos `DocumentsResponseModel`).
  @HiveField(1)
  late String documentsJson;

  /// Epoch ms da última busca remota bem-sucedida.
  @HiveField(2)
  late int lastFetchedAt;

  /// Epoch ms da última revalidação que falhou (null se a última deu certo).
  @HiveField(3)
  int? lastErrorAt;
}
