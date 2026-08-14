import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_features/core/widgets/custom_app_bar.dart';
import 'package:shared_features/feature/documents/presentation/controllers/documents_controller.dart';
import 'package:shared_features/feature/documents/presentation/page/documents_menu_item.dart';
import 'package:shared_features/feature/documents/presentation/page/documents_menu_strategy.dart';
import 'package:shared_features/feature/documents/presentation/page/documents_selected_page.dart';
import 'package:shared_features/feature/documents/presentation/widget/documents_card_widget.dart';

/// Página-menu de documentos (data-driven). Itera os itens da estratégia
/// injetada pelo app; cada item é envolvido por `strategy.wrapItem` (RBAC +
/// circuit breaker no Morar, nada no Síndico) e navega para a lista
/// compartilhada via `MaterialPageRoute`.
class DocumentsPage extends StatefulWidget {
  final DocumentsController controller;
  final DocumentsMenuStrategy strategy;

  /// Subtítulo opcional (ex.: "Condomínio - Unidade" no Morar). Síndico passa
  /// só o nome do condomínio ou `null`.
  final String? subtitle;

  /// Deep-link: tipo a abrir automaticamente ao entrar (resolvido pelo app).
  final String? initialType;

  /// Deep-link: identificador/parâmetro do documento a abrir na lista.
  final String? notificationContext;

  const DocumentsPage({
    Key? key,
    required this.controller,
    required this.strategy,
    this.subtitle,
    this.initialType,
    this.notificationContext,
  }) : super(key: key);

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  @override
  void initState() {
    super.initState();
    final type = widget.initialType;
    if (type != null && type.isNotEmpty) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) _openType(type);
      });
    }
  }

  void _openType(String documentType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DocumentsSelectedPage(
          controller: widget.controller,
          title: documentType,
          notificationContext: widget.notificationContext,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: CustomAppBar(title: "documents"),
      body: Column(
        children: [
          if (widget.subtitle != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              color: LelloTheme.palleteOf(theme).backgroundDark(),
              width: double.infinity,
              height: Dimens.spacingLarge,
              child: Center(
                child: Text(
                  widget.subtitle!,
                  overflow: TextOverflow.ellipsis,
                  style: LelloTextStyles.body(theme),
                ),
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.strategy.items.length,
              itemBuilder: (BuildContext context, int index) {
                final DocumentsMenuItem item = widget.strategy.items[index];
                final card = DocumentsCardWidget(
                  title: item.documentType,
                  onTap: () => _openType(item.documentType),
                );
                return widget.strategy.wrapItem(context, item, card);
              },
            ),
          ),
        ],
      ),
    );
  }
}
