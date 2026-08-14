import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/vox/domain/entity/document_mode.dart';
import 'package:lello/feature/vox/domain/entity/document_reason.dart';
import 'package:lello/feature/vox/domain/entity/document_request.dart';
import 'package:lello/feature/vox/domain/entity/document_template.dart';
import 'package:lello/feature/vox/domain/entity/document_type.dart';
import 'package:lello/feature/vox/domain/entity/recipient_type.dart';
import 'package:lello/feature/maintenance_management/presentation/task/pages/file_preview_page.dart';
import 'package:lello/feature/vox/presentation/request/widget/vox_recipients_page.dart';
import 'package:lello/feature/vox/presentation/request/widget/vox_selected_recipients.dart';

/// Passo de dados do wizard, renderizado conforme as capacidades do
/// [DocumentType]. Escreve direto no [DocumentRequest] (mutável) e dispara
/// [onChanged] a cada alteração para reavaliar a habilitação do "Avançar".
class VoxDataStep extends StatefulWidget {
  final DocumentType type;
  final DocumentMode mode;
  final DocumentRequest request;
  final List<DocumentReason> reasons;
  final List<DocumentTemplate> templates;
  final VoidCallback onChanged;

  const VoxDataStep({
    Key? key,
    required this.type,
    required this.mode,
    required this.request,
    required this.reasons,
    required this.templates,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<VoxDataStep> createState() => _VoxDataStepState();
}

class _VoxDataStepState extends State<VoxDataStep> {
  @override
  void initState() {
    super.initState();
    // Advertência/multa selecionam unidades diretamente.
    if (!widget.type.hasRecipientTypeSelector) {
      widget.request.recipientType ??= RecipientType.units;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(Dimens.spacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.type.hasTitle) _title(theme),
          if (widget.type.hasReasons) _reasons(theme),
          if (widget.type.usesTemplates(widget.mode)) _signature(theme),
          if (widget.type.hasValue) _value(theme),
          if (widget.type.hasOccurrenceDate) _occurrenceDate(theme),
          _recipients(theme),
          if (widget.type.hasCopies) _copies(theme),
          if (widget.mode == DocumentMode.request) _distribution(theme),
        ],
      ),
    );
  }

  Widget _field(String label, Widget field) => Padding(
        padding: EdgeInsets.only(bottom: Dimens.spacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(label, style: LelloTextStyles.bodyBold(Theme.of(context))),
            SizedBox(height: Dimens.spacingSmall),
            field,
          ],
        ),
      );

  Widget _title(ThemeData theme) => _field(
        "Título",
        PrimaryTextFormField(
          initialValue: widget.request.title,
          hint: "Título do comunicado",
          onChanged: (value) {
            widget.request.title = value;
            widget.onChanged();
          },
        ),
      );

  Widget _reasons(ThemeData theme) {
    // Casa o motivo já selecionado pelo id (mesma instância da lista, para a
    // igualdade do dropdown funcionar); null = nada selecionado ainda.
    DocumentReason? selected;
    for (final r in widget.reasons) {
      if (r.id == widget.request.reasonId) {
        selected = r;
        break;
      }
    }
    return _field(
      "Motivo",
      DropdownButtonFormField<DocumentReason>(
        value: selected,
        isExpanded: true,
        decoration: const InputDecoration(border: OutlineInputBorder()),
        hint: const Text("Selecione..."),
        items: widget.reasons
            .map((r) => DropdownMenuItem<DocumentReason>(
                value: r, child: Text(r.description ?? "")))
            .toList(),
        onChanged: (reason) {
          // Guarda descrição (reason) e id (reasonId → reason_id no fio).
          setState(() {
            widget.request.reason = reason?.description;
            widget.request.reasonId = reason?.id;
          });
          widget.onChanged();
        },
      ),
    );
  }

  Widget _signature(ThemeData theme) {
    final String label;
    switch (widget.type) {
      case DocumentType.announcement:
        label = "Modelo do comunicado";
        break;
      case DocumentType.fine:
        label = "Quem assina a multa";
        break;
      case DocumentType.warning:
        label = "Quem assina a advertência";
        break;
    }
    final ids = widget.templates.map((t) => t.id).toSet();
    final value =
        ids.contains(widget.request.model) ? widget.request.model : null;
    DocumentTemplate? selected;
    for (final t in widget.templates) {
      if (t.id == value) {
        selected = t;
        break;
      }
    }
    final thumbnail = selected?.thumbnail;
    return _field(
      label,
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<String>(
            value: value,
            isExpanded: true,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            hint: const Text("Selecione..."),
            selectedItemBuilder: (context) => widget.templates
                .map((t) => Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        t.name ?? t.description ?? "",
                        overflow: TextOverflow.ellipsis,
                      ),
                    ))
                .toList(),
            items: widget.templates
                .map((t) => DropdownMenuItem<String>(
                      value: t.id,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t.name ?? t.description ?? "",
                            style: theme.textTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (t.description != null &&
                              t.description!.isNotEmpty &&
                              t.name != null &&
                              t.name!.isNotEmpty)
                            Text(
                              t.description!,
                              style: theme.textTheme.bodySmall
                                  ?.copyWith(color: theme.hintColor),
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() => widget.request.model = value);
              widget.onChanged();
            },
          ),
          if (thumbnail != null && thumbnail.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: Dimens.spacingSmall),
              child: OutlinedButton.icon(
                icon: const Icon(Icons.visibility),
                label: const Text("Visualizar modelo"),
                onPressed: () => _openModelPreview(thumbnail, selected?.name),
              ),
            ),
        ],
      ),
    );
  }

  void _openModelPreview(String url, String? name) {
    final filename = (name != null && name.isNotEmpty) ? name : "Modelo";
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FilePreviewPage(
          url: url,
          filename: filename,
          // O thumbnail do modelo é sempre uma imagem (a URL não traz extensão).
          extension: "jpg",
        ),
      ),
    );
  }

  Widget _value(ThemeData theme) => _field(
        "Valor da multa",
        PrimaryTextFormField(
          initialValue: widget.request.value,
          hint: "0,00",
          textInputType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (value) {
            widget.request.value = value;
            widget.onChanged();
          },
        ),
      );

  Widget _occurrenceDate(ThemeData theme) {
    final date = widget.request.occurrenceDate;
    return _field(
      "Data de ocorrência",
      OutlinedButton.icon(
        icon: const Icon(Icons.calendar_today),
        label: Text(date == null
            ? "Selecionar data"
            : "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}"),
        onPressed: () async {
          final now = DateTime.now();
          final picked = await showDatePicker(
            context: context,
            initialDate: date ?? now,
            firstDate: DateTime(now.year - 5),
            lastDate: now,
          );
          if (picked != null) {
            setState(() => widget.request.occurrenceDate = picked);
            widget.onChanged();
          }
        },
      ),
    );
  }

  Widget _copies(ThemeData theme) => _field(
        "Cópias para elevador",
        PrimaryTextFormField(
          initialValue: widget.request.singleCopiesQuantity?.toString() ?? "0",
          hint: "Quantidade",
          textInputType: TextInputType.number,
          onChanged: (value) {
            widget.request.singleCopiesQuantity = int.tryParse(value);
            widget.onChanged();
          },
        ),
      );

  /// Formas de distribuição (apenas solicitação): e-mail e/ou impresso.
  Widget _distribution(ThemeData theme) => _field(
        "Formas de distribuição",
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text("Distribuir por e-mail",
                  style: LelloTextStyles.body(theme)),
              value: widget.request.flagEmailDistribution ?? false,
              onChanged: (value) {
                setState(() => widget.request.flagEmailDistribution = value);
                widget.onChanged();
              },
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text("Distribuir impresso",
                  style: LelloTextStyles.body(theme)),
              value: widget.request.flagPrintDistribution ?? false,
              onChanged: (value) {
                setState(() => widget.request.flagPrintDistribution = value);
                widget.onChanged();
              },
            ),
          ],
        ),
      );

  Widget _recipients(ThemeData theme) {
    if (widget.type.hasRecipientTypeSelector) {
      final type = widget.request.recipientType;
      return _field(
        "Enviar para",
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<RecipientType>(
              value: type,
              isExpanded: true,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              hint: const Text("Selecione..."),
              items: const [
                DropdownMenuItem(
                    value: RecipientType.all, child: Text("Todos")),
                DropdownMenuItem(
                    value: RecipientType.block, child: Text("Bloco")),
                DropdownMenuItem(
                    value: RecipientType.units, child: Text("Unidade")),
              ],
              onChanged: (value) {
                setState(() {
                  widget.request.recipientType = value;
                  widget.request.recipientListMap.clear();
                });
                widget.onChanged();
              },
            ),
            if (type == RecipientType.block || type == RecipientType.units) ...[
              SizedBox(height: Dimens.spacing),
              _recipientsSection(theme, type!, single: false),
            ],
          ],
        ),
      );
    }
    // Advertência/multa: seleção direta de uma única unidade.
    return _field(
      "Destinatário (unidade)",
      _recipientsSection(theme, RecipientType.units, single: true),
    );
  }

  Widget _recipientsSection(ThemeData theme, RecipientType mode,
      {required bool single}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _recipientsButton(theme, mode, single: single),
        VoxSelectedRecipients(
          mode: mode,
          recipientListMap: widget.request.recipientListMap,
          single: single,
        ),
      ],
    );
  }

  Widget _recipientsButton(ThemeData theme, RecipientType mode,
      {required bool single}) {
    final map = widget.request.recipientListMap;
    final hasSelection = map.isNotEmpty;
    final String label;
    if (!hasSelection) {
      label = single ? "Selecionar destinatário" : "Selecionar destinatários";
    } else {
      label = single ? "Trocar destinatário" : "Editar destinatários";
    }
    return OutlinedButton.icon(
      icon: const Icon(Icons.people_outline),
      label: Text(label),
      onPressed: () async {
        await Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => VoxRecipientsPage(
            mode: mode,
            recipientListMap: map,
            singleSelection: single,
            useUnitId: widget.mode == DocumentMode.create,
          ),
        ));
        setState(() {});
        widget.onChanged();
      },
    );
  }
}
