import 'package:flutter/material.dart';
import 'package:shared_features/feature/documents/presentation/page/documents_menu_item.dart';

/// Estratégia injetada pelo app para o menu de documentos. Encapsula o que é
/// app-específico: gating de RBAC/circuit-breaker em torno de cada item e
/// resolução de deep-link. O default não gata nada (Síndico); o Morar injeta
/// uma subclasse que envolve cada item no `CircuitBreakerWidget`.
abstract class DocumentsMenuStrategy {
  /// Itens do menu, na ordem de exibição.
  List<DocumentsMenuItem> get items;

  /// Envolve o card de um item (ex.: RBAC + circuit breaker). Default: devolve
  /// o card direto, sem gating.
  Widget wrapItem(BuildContext context, DocumentsMenuItem item, Widget card) =>
      card;
}

/// Estratégia padrão sem gating (Síndico). Usa os itens padrão por default.
class DefaultDocumentsMenuStrategy extends DocumentsMenuStrategy {
  @override
  final List<DocumentsMenuItem> items;

  DefaultDocumentsMenuStrategy({this.items = kDefaultDocumentsMenuItems});
}
