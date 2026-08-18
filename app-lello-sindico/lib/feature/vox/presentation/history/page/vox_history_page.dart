import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/vox/domain/entity/document.dart';
import 'package:lello/feature/vox/domain/entity/document_type.dart';
import 'package:lello/feature/vox/presentation/history/bloc/vox_history_bloc.dart';
import 'package:lello/feature/vox/presentation/history/bloc/vox_history_event.dart';
import 'package:lello/feature/vox/presentation/history/bloc/vox_history_state.dart';
import 'package:lello/feature/vox/presentation/widget/vox_error_widget.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

/// Histórico unificado de documentos. O [VoxHistoryBloc] é provido pelo chamador;
/// o tap em um item dispara [onOpenDocument] (a navegação para o detalhe é
/// montada no wiring de rotas/DI).
///
/// A lista é agrupada por período (mês/ano da data de referência) e filtrável
/// por título via campo de busca local sobre os dados já carregados.
class VoxHistoryPage extends StatefulWidget {
  final void Function(BuildContext context, Document document) onOpenDocument;

  const VoxHistoryPage({Key? key, required this.onOpenDocument})
      : super(key: key);

  @override
  State<VoxHistoryPage> createState() => _VoxHistoryPageState();
}

class _VoxHistoryPageState extends State<VoxHistoryPage> {
  String _query = "";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<VoxHistoryBloc, VoxHistoryState>(
      builder: (context, state) {
        return Scaffold(
          appBar: PrimaryAppBar(
            title: _title(state.type),
            theme: theme,
            iconColor: theme.primaryColor,
          ),
          body: _body(context, state),
        );
      },
    );
  }

  Widget _body(BuildContext context, VoxHistoryState state) {
    switch (state.status) {
      case VoxHistoryStatus.loading:
        return const Center(child: LoadingWidget());
      case VoxHistoryStatus.failure:
        return VoxErrorWidget(
          error: state.error,
          onRetry: () =>
              context.read<VoxHistoryBloc>().add(VoxHistoryStarted()),
          onBack: () => Navigator.of(context).pop(),
        );
      case VoxHistoryStatus.empty:
        return _empty(context, "Nenhum documento por aqui ainda.");
      case VoxHistoryStatus.loaded:
        return _loaded(context, state);
    }
  }

  Widget _loaded(BuildContext context, VoxHistoryState state) {
    final theme = Theme.of(context);
    final rows = _buildRows(state.documents);
    return Column(
      children: [
        _search(theme),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async =>
                context.read<VoxHistoryBloc>().add(VoxHistoryRefreshed()),
            child: rows.isEmpty
                ? _empty(context, "Nada encontrado para \"$_query\".")
                : ListView.builder(
                    itemCount: rows.length,
                    itemBuilder: (context, index) {
                      final row = rows[index];
                      return row.isHeader
                          ? _periodHeader(theme, row.header!)
                          : _item(context, state.type, row.document!);
                    },
                  ),
          ),
        ),
      ],
    );
  }

  Widget _search(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.all(Dimens.spacing),
      child: TextField(
        textInputAction: TextInputAction.search,
        decoration: const InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.search),
          hintText: "Buscar por título",
        ),
        onChanged: (value) => setState(() => _query = value.trim()),
      ),
    );
  }

  Widget _periodHeader(ThemeData theme, String label) {
    return Container(
      width: double.infinity,
      color: LelloTheme.palleteOf(theme).separator(),
      padding: EdgeInsets.symmetric(
          horizontal: Dimens.spacing, vertical: Dimens.spacingSmall),
      child: Text(
        label,
        style: LelloTextStyles.bodyBold(theme)?.copyWith(
          color: LelloTheme.palleteOf(theme).hubText(),
        ),
      ),
    );
  }

  Widget _item(BuildContext context, DocumentType type, Document document) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          title: Text(_itemTitle(type, document),
              style: LelloTextStyles.subtitleBold(theme)),
          subtitle: Padding(
            padding: EdgeInsets.only(top: Dimens.spacingXSmall),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_itemSubtitle(type, document).isNotEmpty) ...[
                  Text(
                    _itemSubtitle(type, document),
                    style: LelloTextStyles.body(theme),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: Dimens.spacingSmall),
                ],
                _details(theme, document),
              ],
            ),
          ),
          trailing: Icon(Icons.chevron_right, color: theme.primaryColor),
          onTap: () => widget.onOpenDocument(context, document),
        ),
        Divider(color: theme.dividerColor),
      ],
    );
  }

  Widget _details(ThemeData theme, Document document) {
    final captionStyle = LelloTextStyles.caption(theme)?.copyWith(
      color: LelloTheme.palleteOf(theme).grey(),
    );
    final sent = _sentDate(document);
    return Wrap(
      spacing: Dimens.spacing,
      runSpacing: Dimens.spacingXSmall,
      children: [
        if (sent != null) _detailChip(Icons.event_outlined, sent, captionStyle),
        if ((document.status ?? "").isNotEmpty)
          _detailChip(Icons.info_outline, document.status!, captionStyle),
        if (document.pagesQuantity != null)
          _detailChip(Icons.description_outlined,
              "${document.pagesQuantity} pág.", captionStyle),
      ],
    );
  }

  Widget _detailChip(IconData icon, String text, TextStyle? style) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: style?.color),
        SizedBox(width: Dimens.spacingXSmall),
        Text(text, style: style),
      ],
    );
  }

  Widget _empty(BuildContext context, String message) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.all(Dimens.spacing),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.info_outline, size: 96, color: Colors.grey),
            SizedBox(height: Dimens.spacing),
            Text(
              message,
              textAlign: TextAlign.center,
              style: LelloTextStyles.subtitle(theme)?.copyWith(
                color: LelloTheme.palleteOf(theme).grey(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Filtra por título e agrupa por período (mês/ano), inserindo um cabeçalho a
  /// cada troca de período. Ordena por data de referência decrescente.
  List<_Row> _buildRows(List<Document> documents) {
    final filtered = documents.where(_matchesQuery).toList()
      ..sort((a, b) {
        final da = a.periodDate;
        final db = b.periodDate;
        if (da == null && db == null) return 0;
        if (da == null) return 1;
        if (db == null) return -1;
        return db.compareTo(da);
      });

    final rows = <_Row>[];
    String? currentPeriod;
    for (final document in filtered) {
      final period = _periodLabel(document.periodDate);
      if (period != currentPeriod) {
        currentPeriod = period;
        rows.add(_Row.header(period));
      }
      rows.add(_Row.item(document));
    }
    return rows;
  }

  bool _matchesQuery(Document document) {
    if (_query.isEmpty) return true;
    final query = _query.toLowerCase();
    final name = (document.name ?? "").toLowerCase();
    final reason = (document.reason ?? "").toLowerCase();
    final description = (document.description ?? "").toLowerCase();
    return name.contains(query) ||
        reason.contains(query) ||
        description.contains(query);
  }

  /// Título do item: advertência/multa usam o motivo; comunicado usa o nome.
  String _itemTitle(DocumentType type, Document document) {
    switch (type) {
      case DocumentType.warning:
      case DocumentType.fine:
        final reason = document.reason;
        if (reason != null && reason.isNotEmpty) return reason;
        return document.name ?? _fallbackTitle(type);
      case DocumentType.announcement:
        return document.name ?? _fallbackTitle(type);
    }
  }

  /// Subtítulo do item. Dirty fix: a `description` de advertência/multa vem como
  /// "Advertência para a unidade XXXX" — extrai só a unidade e exibe
  /// "Unidade XXXX". Comunicado mantém a descrição original.
  String _itemSubtitle(DocumentType type, Document document) {
    final description = document.description ?? "";
    switch (type) {
      case DocumentType.warning:
      case DocumentType.fine:
        final match = RegExp(r'unidade\s+(.+)$', caseSensitive: false)
            .firstMatch(description);
        if (match != null) return "Unidade ${match.group(1)!.trim()}";
        return description;
      case DocumentType.announcement:
        return description;
    }
  }

  String _periodLabel(DateTime? date) {
    if (date == null) return "Sem data";
    final label = DateFormat("MMMM 'de' yyyy", "pt_BR").format(date);
    return label.isEmpty
        ? label
        : "${label[0].toUpperCase()}${label.substring(1)}";
  }

  String? _sentDate(Document document) {
    final parsed = DateTime.tryParse(document.createdAt ?? "");
    if (parsed != null) return DateFormat("dd/MM/yyyy").format(parsed);
    final raw = document.createdAt;
    return (raw == null || raw.isEmpty) ? null : raw;
  }

  String _title(DocumentType type) {
    switch (type) {
      case DocumentType.warning:
        return "Advertências";
      case DocumentType.fine:
        return "Multas";
      case DocumentType.announcement:
        return "Comunicados";
    }
  }

  String _fallbackTitle(DocumentType type) {
    switch (type) {
      case DocumentType.warning:
        return "Advertência";
      case DocumentType.fine:
        return "Multa";
      case DocumentType.announcement:
        return "Comunicado";
    }
  }
}

/// Linha da lista: um cabeçalho de período ou um documento.
class _Row {
  final String? header;
  final Document? document;

  _Row.header(this.header) : document = null;
  _Row.item(this.document) : header = null;

  bool get isHeader => header != null;
}
