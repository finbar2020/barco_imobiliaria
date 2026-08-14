import 'dart:convert';
import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/vox/domain/entity/document_request.dart';
import 'package:lello/feature/vox/domain/use_case/upload_document_image/upload_document_image.dart';
import 'package:lello/feature/vox/presentation/request/widget/vox_attachments_widget.dart';

/// Passo de edição do conteúdo do documento. Escreve direto em
/// [DocumentRequest.content].
///
/// Criação usa o editor HTML rico (o Base64 é aplicado na camada data);
/// solicitação usa um campo de texto simples multilinha — texto literal, sem
/// HTML nem Base64 (igual ao fluxo antigo) — e exibe o componente de anexos.
class VoxTextStep extends StatefulWidget {
  final DocumentRequest request;
  final VoidCallback onChanged;

  /// Texto simples multilinha (solicitação) em vez do editor HTML (criação).
  final bool plainText;

  /// Exibe o componente de anexos (apenas no modo solicitação).
  final bool showAttachments;

  const VoxTextStep({
    Key? key,
    required this.request,
    required this.onChanged,
    this.plainText = false,
    this.showAttachments = false,
  }) : super(key: key);

  @override
  State<VoxTextStep> createState() => _VoxTextStepState();
}

class _VoxTextStepState extends State<VoxTextStep> {
  final HtmlEditorController _controller = HtmlEditorController();
  final UploadDocumentImage _uploadImage =
      ApplicationContainer.instance().resolve<UploadDocumentImage>();

  /// Evita reprocessar enquanto um lote de imagens coladas é enviado.
  bool _processingPaste = false;

  /// Imagens coladas em voo (deduplica pelo início do Base64).
  final Set<String> _pasteInFlight = {};

  /// Instância estável da toolbar: recriá-la a cada build (por conter a closure
  /// do interceptor) faz o pacote reconstruir a toolbar nos rebuilds do teclado
  /// e o editor fica comprimido ao recolher o teclado.
  late final HtmlToolbarOptions _toolbarOptions = HtmlToolbarOptions(
    // Toolbar padrão (rolável, no topo) sem o seletor de fonte (fontName).
    // Ao inserir imagem, faz upload e insere uma tag <img> com a URL retornada
    // (em vez do Base64 inline padrão).
    mediaUploadInterceptor: _onMediaUpload,
    defaultToolbarButtons: const [
      StyleButtons(),
      FontSettingButtons(fontName: false, fontSizeUnit: false),
      FontButtons(clearAll: false),
      ColorButtons(),
      ListButtons(listStyles: false),
      ParagraphButtons(
          textDirection: false, lineHeight: false, caseConverter: false),
      InsertButtons(
          video: false,
          audio: false,
          table: false,
          hr: false,
          otherFile: false),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Dimens.spacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child:
                widget.plainText ? _plainField(context) : _htmlEditor(context),
          ),
          if (widget.showAttachments) ...[
            SizedBox(height: Dimens.spacing),
            const VoxAttachmentsWidget(),
          ],
        ],
      ),
    );
  }

  Widget _plainField(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      initialValue: widget.request.content,
      expands: true,
      maxLines: null,
      minLines: null,
      keyboardType: TextInputType.multiline,
      textAlignVertical: TextAlignVertical.top,
      textCapitalization: TextCapitalization.sentences,
      style: LelloTextStyles.body(theme),
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: getString(context, "announcements_create_name_hint",
            defaultText: "Escreva o conteúdo..."),
      ),
      onChanged: (value) {
        widget.request.content = value;
        widget.onChanged();
      },
    );
  }

  Widget _htmlEditor(BuildContext context) {
    // O HtmlEditor (webview) exige altura concreta; mede o espaço disponível.
    return LayoutBuilder(
      builder: (context, constraints) => HtmlEditor(
        controller: _controller,
        htmlEditorOptions: HtmlEditorOptions(
          initialText: widget.request.content ?? "",
          hint: getString(context, "announcements_create_name_hint",
              defaultText: "Escreva o conteúdo..."),
          // Não deixar o pacote redimensionar a área editável com o teclado: é
          // o que prendia a altura "no meio" ao recolher o teclado. A altura é
          // fixa (espaço do Expanded) e o webview rola para manter o cursor.
          adjustHeightForKeyboard: false,
        ),
        htmlToolbarOptions: _toolbarOptions,
        otherOptions: OtherOptions(height: constraints.maxHeight),
        callbacks: Callbacks(
          onChangeContent: (String? content) {
            widget.request.content = content;
            widget.onChanged();
          },
          onPaste: () async {
            // Dá tempo do editor processar o conteúdo colado antes de varrer.
            await Future.delayed(const Duration(milliseconds: 150));
            await _detectAndUploadPastedImages();
          },
        ),
      ),
    );
  }

  /// Intercepta a inserção de mídia: faz upload da imagem e insere uma tag
  /// `<img>` com a URL retornada. Retorna `false` para impedir o handler padrão
  /// (que embutiria a imagem como Base64 inline).
  Future<bool> _onMediaUpload(PlatformFile file, InsertFileType type) async {
    if (type != InsertFileType.image) return true;
    final bytes = file.bytes ??
        (file.path != null ? await File(file.path!).readAsBytes() : null);
    if (bytes == null) return false;

    final result = await _uploadImage(
        UploadDocumentImageParam(bytes: bytes, fileName: file.name));
    result.fold((_) {}, (url) => _controller.insertNetworkImage(url));
    return false;
  }

  /// Captura imagens coladas (inseridas como Base64 inline pelo editor): faz
  /// upload de cada uma e substitui a tag por `<img>` com a URL retornada.
  Future<void> _detectAndUploadPastedImages() async {
    if (_processingPaste) return;

    final currentHtml = await _controller.getText();
    final regex = RegExp(
      r'<img[^>]*src="data:image\/([^;]+);base64,([^"]+)"[^>]*>',
      caseSensitive: false,
    );
    final matches = regex.allMatches(currentHtml).toList();
    if (matches.isEmpty) return;

    _processingPaste = true;
    var updatedHtml = currentHtml;
    try {
      for (final match in matches) {
        final fullTag = match.group(0)!;
        final format = match.group(1)!;
        final base64Data = match.group(2)!;
        final key =
            base64Data.length > 50 ? base64Data.substring(0, 50) : base64Data;
        if (_pasteInFlight.contains(key)) continue;
        _pasteInFlight.add(key);

        try {
          final bytes = base64Decode(base64Data);
          final fileName =
              'paste_${DateTime.now().millisecondsSinceEpoch}.$format';
          final result = await _uploadImage(
              UploadDocumentImageParam(bytes: bytes, fileName: fileName));
          result.fold((_) {}, (url) {
            updatedHtml = updatedHtml.replaceFirst(
                fullTag, '<img src="$url" style="max-width: 100%;" />');
          });
        } catch (_) {
          // Mantém o Base64 nesta imagem se o upload falhar.
        } finally {
          _pasteInFlight.remove(key);
        }
      }

      if (updatedHtml != currentHtml) {
        _controller.setText(updatedHtml);
        widget.request.content = updatedHtml;
        widget.onChanged();
      }
    } finally {
      _processingPaste = false;
    }
  }
}
