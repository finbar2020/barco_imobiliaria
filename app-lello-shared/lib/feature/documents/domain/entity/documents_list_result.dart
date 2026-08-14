import 'package:shared_features/feature/documents/domain/entity/documents.dart';

enum DocsFreshness {
  /// Cache hit, dentro do TTL. Nada disparado.
  fresh,

  /// Cache hit fora do TTL. Revalidação em background em andamento.
  staleRevalidating,

  /// Cache hit fora do TTL. Revalidação falhou — usuário vê dados antigos.
  staleFailed,

  /// Sem cache. Busca inicial em andamento.
  coldLoading,

  /// Sem cache e a busca falhou.
  error,
}

class DocsListResult {
  final DocsFreshness freshness;
  final List<Documents> docs;
  final DateTime? lastFetchedAt;
  final Object? error;

  const DocsListResult._({
    required this.freshness,
    required this.docs,
    this.lastFetchedAt,
    this.error,
  });

  factory DocsListResult.fresh({
    required List<Documents> docs,
    required DateTime lastFetchedAt,
  }) =>
      DocsListResult._(
        freshness: DocsFreshness.fresh,
        docs: docs,
        lastFetchedAt: lastFetchedAt,
      );

  factory DocsListResult.staleRevalidating({
    required List<Documents> docs,
    required DateTime lastFetchedAt,
  }) =>
      DocsListResult._(
        freshness: DocsFreshness.staleRevalidating,
        docs: docs,
        lastFetchedAt: lastFetchedAt,
      );

  factory DocsListResult.staleFailed({
    required List<Documents> docs,
    required DateTime lastFetchedAt,
    Object? error,
  }) =>
      DocsListResult._(
        freshness: DocsFreshness.staleFailed,
        docs: docs,
        lastFetchedAt: lastFetchedAt,
        error: error,
      );

  factory DocsListResult.coldLoading() => const DocsListResult._(
        freshness: DocsFreshness.coldLoading,
        docs: [],
      );

  factory DocsListResult.error(Object error) => DocsListResult._(
        freshness: DocsFreshness.error,
        docs: const [],
        error: error,
      );
}
