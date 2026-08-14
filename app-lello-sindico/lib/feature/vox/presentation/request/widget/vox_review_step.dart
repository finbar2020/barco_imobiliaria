import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/vox/domain/entity/document_request.dart';

/// Passo de revisão: destinatários + prévia do conteúdo antes do envio.
class VoxReviewStep extends StatelessWidget {
  final DocumentRequest request;

  /// Conteúdo é texto literal (solicitação) em vez de HTML (criação). No texto
  /// literal as quebras de linha (`\n`) precisam ser respeitadas, então a prévia
  /// usa um [Text] simples em vez do [HtmlWidget] (que colapsaria os `\n`).
  final bool plainText;

  const VoxReviewStep({
    Key? key,
    required this.request,
    this.plainText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(Dimens.spacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("Destinatários", style: LelloTextStyles.subtitleBold(theme)),
          SizedBox(height: Dimens.spacingSmall),
          Text(request.recipientsLabel(), style: LelloTextStyles.body(theme)),
          if ((request.value ?? "").isNotEmpty) ...[
            SizedBox(height: Dimens.spacing),
            Text("Valor", style: LelloTextStyles.subtitleBold(theme)),
            SizedBox(height: Dimens.spacingSmall),
            Text("R\$ ${request.value}", style: LelloTextStyles.body(theme)),
          ],
          Divider(height: Dimens.spacingLarge),
          Text("Conteúdo", style: LelloTextStyles.subtitleBold(theme)),
          SizedBox(height: Dimens.spacingSmall),
          plainText
              ? Text(request.content ?? "", style: LelloTextStyles.body(theme))
              : HtmlWidget(request.content ?? ""),
        ],
      ),
    );
  }
}
